/**
 * @file led_control_interrupts.ino
 * @brief Upravljanje LED diodama pomoću prekida i senzora na Arduino UNO.
 *
 * Ovaj projekt koristi vanjske i interne prekide kako bi se upravljalo
 * LED diodama i očitavanjima s fotosenzora i potenciometra.
 *
 * @details
 * Funkcionalnosti uključuju:
 * - Promjenu stanja LED diode na pin 11 putem tipkala (INT0)
 * - Bljeskanje LED diode na pin 13 svake 1 sekunde (Timer1)
 * - Aktivaciju LED diode na pin 8 kada fotosenzor detektira svjetlost (INT1)
 * - Gašenje LED diode nakon 2 sekunde
 * - Očitavanje vrijednosti s potenciometra (ADC)
 *
 * @note Projekt je razvijen i testiran na Wokwi simulacijskoj platformi.
 * @see https://wokwi.com/projects/427037599729002497
 */

/// Interval za gašenje LED diode u trajanju od 2s
#define INTERVAL 2000

/// Zastavica koja označava da je pritisnuto tipkalo
volatile bool buttonPressed = false;
/// Zastavica koja označava Timer1 prekid
volatile bool timerTriggered = false;
/// Zastavica koja označava da je očitanje s potenciometra završeno
volatile bool sensorReady = false;
/// Trenutno stanje LED diode na pinu 11
volatile bool ledState = false;
/// Zastavica koja označava da je fotosenzor detektirao svjetlo
volatile bool lightDetected = false;

/// Pohranjuje vrijeme posljednje promjene stanja za automatsko gašenje LED diode
unsigned long previousMillis = 0;

/**
 * @brief ISR za vanjski prekid na INT0 (tipkalo na pinu 2)
 * Postavlja zastavicu buttonPressed.
 */
void ISR_Button()
{
    buttonPressed = true;
}

/**
 * @brief ISR za Timer1 Compare Match prekid
 * Postavlja zastavicu timerTriggered.
 */
ISR(TIMER1_COMPA_vect)
{
    timerTriggered = true;
}

/**
 * @brief ISR za ADC prekid (kada je završeno očitanje s potenciometra)
 * Postavlja zastavicu sensorReady.
 */
ISR(ADC_vect)
{
    sensorReady = true;
}

/**
 * @brief ISR za fotosenzor (vanjski prekid INT1 - pin 3)
 * Postavlja zastavicu lightDetected.
 */
void photoCellISR()
{
    lightDetected = true;
}

/**
 * @brief Inicijalizacija sustava, pinova, prekida i modula.
 */
void setup()
{
    Serial.begin(9600);

    // Konfiguracija pinova
    pinMode(3, INPUT); // fotosenzor
    pinMode(13, OUTPUT);
    digitalWrite(13, LOW);
    pinMode(11, OUTPUT);
    digitalWrite(11, LOW);
    pinMode(8, OUTPUT);
    digitalWrite(8, LOW);
    pinMode(2, INPUT_PULLUP); // tipkalo

    // Vanjski prekidi
    attachInterrupt(digitalPinToInterrupt(2), ISR_Button, FALLING);   // INT0
    attachInterrupt(digitalPinToInterrupt(3), photoCellISR, FALLING); // INT1

    // Timer1 konfiguracija (1s interval)
    cli();
    TCCR1A = 0;
    TCCR1B = (1 << WGM12) | (1 << CS12) | (1 << CS10); // CTC mod, prescaler 1024
    OCR1A = 15624;
    TIMSK1 |= (1 << OCIE1A); // Omogući Timer1 Compare Match prekid
    sei();

    // ADC konfiguracija
    ADMUX = (1 << REFS0);                              // Referentni napon na AVCC
    ADCSRA = (1 << ADEN) | (1 << ADIE) | (1 << ADPS2); // Omogući ADC i njegov prekid
}

/**
 * @brief Glavna petlja sustava, obrada zastavica i upravljanje LED diodama.
 */
void loop()
{
    unsigned long currentMillis = millis();

    // Obrada prekida tipkala
    if (buttonPressed)
    {
        ledState = !ledState;
        digitalWrite(11, ledState);
        Serial.println("Tipkalo pritisnuto! LED stanje promijenjeno.");
        buttonPressed = false;
    }

    // Timer1 prekid - bljeskanje LED diode
    if (timerTriggered)
    {
        digitalWrite(13, !digitalRead(13));
        Serial.println("Timer prekid! LED biljeska.");
        timerTriggered = false;
    }

    // Pokretanje ADC konverzije
    ADCSRA |= (1 << ADSC);

    // Fotosenzor prekid
    if (lightDetected)
    {
        digitalWrite(8, HIGH);
        Serial.println("Svjetlo detektirano!");
        lightDetected = false;
    }

    // Automatsko gašenje LED diode nakon INTERVAL ms
    if (digitalRead(8) == HIGH)
    {
        if (currentMillis - previousMillis >= INTERVAL)
        {
            previousMillis = currentMillis;
            digitalWrite(8, LOW);
        }
    }

    // Očitavanje ADC vrijednosti
    if (sensorReady)
    {
        int sensorValue = ADC;
        Serial.print("Senzor: ");
        Serial.println(sensorValue);
        sensorReady = false;
    }
}
