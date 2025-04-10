#include <avr/sleep.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>

const int ledPin = 13;   ///< Pin na kojem je spojena LED dioda
const int buttonPin = 2; ///< Pin na kojem je spojeno tipkalo

volatile bool buttonWokeUp = false; ///< Zastavica koja označava da je buđenje bilo preko tipkala
volatile bool timerWokeUp = false;  ///< Zastavica koja označava da je buđenje bilo preko watchdog timera
volatile bool goSleep = true;       ///< Kontrolira stanje spavanja

unsigned long previousMillis = 0;   ///< Vrijeme zadnjeg paljenja/gašenja LED
const long interval = 500;          ///< Interval treptanja LED u milisekundama
int blinkCount = 0;                 ///< Brojač treptanja LED
int activePeriodCount = 0;          ///< Brojač aktivnih perioda (sekundi)
bool ledState = LOW;                ///< Trenutno stanje LED
bool inActivePeriod = true;         ///< Označava je li mikrokontroler u aktivnom periodu

/**
 * @brief Inicijalizacija ulazno/izlaznih pinova i serijske komunikacije.
 */
void setup()
{
    pinMode(ledPin, OUTPUT);
    pinMode(buttonPin, INPUT_PULLUP);

    // Konfiguracija vanjskog prekida na tipkalu (padajući brid zbog pull-up otpornika)
    attachInterrupt(digitalPinToInterrupt(buttonPin), buttonWakeUp, FALLING);
    set_sleep_mode(SLEEP_MODE_PWR_DOWN); // Najniža potrošnja

    Serial.begin(9600);
}

/**
 * @brief Glavna petlja programa.
 * 
 * LED dioda trepće 5 sekundi (u intervalu od 500 ms),
 * zatim mikrokontroler ulazi u sleep. Iz sleepa se budi
 * putem tipkala ili watchdog timera.
 */
void loop() {
    unsigned long currentMillis = millis();

    if (inActivePeriod) {
        if (blinkCount < 2) { // 2 treptaja po sekundi
            if (currentMillis - previousMillis >= interval) {
                previousMillis = currentMillis;

                ledState = !ledState;
                digitalWrite(ledPin, ledState);

                if (ledState == HIGH) {
                    Serial.print("Proslo sekundi: ");
                    Serial.println(activePeriodCount + 1);
                }

                blinkCount++;
            }
        } else {
            blinkCount = 0;
            activePeriodCount++;

            if (activePeriodCount >= 5) {
                inActivePeriod = false; // Gotovi svi aktivni periodi
            }
        }
    } else {
        // Ulazak u sleep nakon aktivnog perioda
        digitalWrite(ledPin, LOW);
        Serial.println("Sleep mode ON");

        buttonWokeUp = false;
        timerWokeUp = false;

        enterSleep();

        if (buttonWokeUp) {
            Serial.println("Probudio tipkalo prekid.");
        } else if (timerWokeUp) {
            Serial.println("Probudio WatchDog Timer nakon 4s.");
        }

        // Reset stanja nakon buđenja
        inActivePeriod = true;
        activePeriodCount = 0;
    }
}

/**
 * @brief Ulazi u način rada spavanja (SLEEP_MODE_PWR_DOWN).
 * 
 * Aktivira Watchdog timer i omogućuje buđenje putem vanjskog prekida.
 */
void enterSleep()
{
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);

    noInterrupts();      // Onemogući prekide tijekom pripreme za spavanje
    goSleep = true;

    setupWatchdog();     // Postavi Watchdog timer (~4 sekunde)

    sleep_enable();      // Omogući sleep
    interrupts();        // Ponovno omogući prekide

    while (goSleep) {
        sleep_cpu();     // Ulazak u sleep
    }

    sleep_disable();     // Isključi sleep nakon buđenja
}

/**
 * @brief Postavlja Watchdog timer za buđenje iz sleep moda.
 * 
 * Podešeno za otprilike 4 sekunde i samo generira prekid (ne reset).
 */
void setupWatchdog()
{
    cli();               // Onemogući prekide
    wdt_reset();         // Resetiraj WDT

    // Omogući izmjenu WDT konfiguracije
    WDTCSR = (1 << WDCE) | (1 << WDE);

    // Postavi na ~4 sekunde, samo prekid
    WDTCSR = (1 << WDIE) | (1 << WDP3);

    sei();               // Omogući prekide
}

/**
 * @brief ISR za Watchdog prekid.
 * 
 * Postavlja zastavicu za buđenje iz sleepa putem WDT.
 */
ISR(WDT_vect)
{
    goSleep = false;
    timerWokeUp = true;
}

/**
 * @brief ISR za vanjski prekid (tipkalo).
 * 
 * Postavlja zastavicu za buđenje iz sleepa putem tipkala.
 */
void buttonWakeUp()
{
    goSleep = false;
    buttonWokeUp = true;
}
