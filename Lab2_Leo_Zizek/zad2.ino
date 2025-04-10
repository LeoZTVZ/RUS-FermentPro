/**
 * @file sleep_mode_example.ino
 * @brief Demonstracija korištenja sleep moda i watchdog timera na AVR mikrokontroleru (npr. ATmega328P).
 *
 * Uređaj ulazi u najdublji način mirovanja (Power Down), a budi se pomoću vanjskog prekida (tipkalo)
 * ili watchdog timera nakon ~8 sekundi. Nakon buđenja, LED treperi 5 sekundi kao indikacija aktivnosti.
 */

#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

/// Pin na koji je spojena LED dioda.
const int ledPin = 8;

/// Pin na koji je spojeno tipkalo (koristi se za buđenje iz sleep moda).
const int buttonPin = 2;

/// Zastavica koja označava buđenje pomoću tipkala.
volatile bool wakeUpByButton = false;

/// Zastavica koja označava buđenje pomoću watchdog timera.
volatile bool wakeUpByWDT = false;

/// Interna zastavica za upravljanje sleep režimom.
volatile bool zastava = false;

/**
 * @brief ISR za vanjski prekid – poziva se kad se pritisne tipkalo.
 *
 * Postavlja zastavicu da je uređaj probuđen putem gumba.
 */
void wakeUp()
{
    wakeUpByButton = true;
    zastava = false;
}

/**
 * @brief ISR za watchdog timer – postavlja zastavicu za buđenje.
 */
ISR(WDT_vect)
{
    wakeUpByWDT = true;
    zastava = false;
}

/**
 * @brief Inicijalizacija sustava.
 *
 * Postavlja serijsku komunikaciju, modove pinova, vanjski prekid i sleep mode.
 */
void setup()
{
    Serial.begin(9600);
    pinMode(ledPin, OUTPUT);
    pinMode(buttonPin, INPUT_PULLUP);

    attachInterrupt(digitalPinToInterrupt(buttonPin), wakeUp, FALLING);
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
}

/**
 * @brief Treperi LED-icom 5 sekundi.
 *
 * LED trepće u intervalima od 0.5 sekunde.
 */
void blinkLed5Seconds()
{
    for (int i = 0; i < 5; i++)
    {
        digitalWrite(ledPin, HIGH);
        delay(500);
        digitalWrite(ledPin, LOW);
        delay(500);
    }
}

/**
 * @brief Postavlja watchdog timer da generira prekid svakih približno 8 sekundi.
 */
void setupWatchdog()
{
    cli(); // Onemogući prekide tijekom konfiguracije

    MCUSR &= ~(1 << WDRF);                            // Resetiraj watchdog status
    WDTCSR |= (1 << WDCE) | (1 << WDE);               // Omogući promjene WDTCSR registra
    WDTCSR = (1 << WDIE) | (1 << WDP3) | (1 << WDP0); // Postavi timeout na 8 sekundi i omogući interrupt

    sei(); // Ponovno omogući prekide
}

/**
 * @brief Ulazi u sleep (Power Down) mod.
 *
 * Omogućuje sleep, konfigurira watchdog i čeka dok se ne dogodi prekid koji resetira zastavicu.
 */
void sleepNow()
{
    cli();
    sleep_enable();
    zastava = true;
    setupWatchdog();
    sei();

    while (zastava)
    {
        sleep_cpu();
    }

    sleep_disable();
}

/**
 * @brief Glavna petlja programa.
 *
 * Treperi LED-icom, provjerava izvor buđenja, šalje poruke putem serijske veze, a zatim ulazi u sleep.
 */
void loop()
{
    blinkLed5Seconds();

    if (wakeUpByButton)
    {
        Serial.println("Probuio me gumb");
    }
    else if (wakeUpByWDT)
    {
        Serial.println("Probuio me tajmer");
    }

    Serial.println("Idem spavat");

    // Resetiraj zastavice buđenja
    wakeUpByButton = false;
    wakeUpByWDT = false;

    sleepNow();
}
