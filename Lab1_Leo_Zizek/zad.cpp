// interval za gašenje LED diode u trajanju od 2s
#define INTERVAL 2000
// Definicije prekidnih zastavica
volatile bool buttonPressed = false;  // zastavica gumba
volatile bool timerTriggered = false; // zastavica timera
volatile bool sensorReady = false;    // Stanje potenciometra
volatile bool ledState = false;       // Stanje LED-ice
volatile bool lightDetected = false;  // zastavica fotosenzora
unsigned long previousMillis = 0;
// ISR za vanjski prekid (tipkalo na INT0 - pin 2)
void ISR_Button()
{
    buttonPressed = true; // Postavi zastavicu
}

// ISR za Timer1 prekid (svakih 1s)
ISR(TIMER1_COMPA_vect)
{
    timerTriggered = true;
}

// ISR za ADC prekid (kada je očitanje završeno)
ISR(ADC_vect)
{
    sensorReady = true;
}
void photoCellISR()
{
    lightDetected = true;
}

void setup()
{
    // Pocetak serijske komunikacije
    Serial.begin(9600);
    // Konfiguracija fotosenzora
    pinMode(3, INPUT);
    // Konfiguracija LED-ice
    pinMode(13, OUTPUT);
    digitalWrite(13, LOW);
    pinMode(11, OUTPUT);
    digitalWrite(11, LOW);
    pinMode(8, OUTPUT);
    digitalWrite(8, LOW);

    // Konfiguracija vanjskog prekida na pin 2 i 3 (INT0,INT1)
    pinMode(2, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(2), ISR_Button, FALLING);   // Najviši
    attachInterrupt(digitalPinToInterrupt(3), photoCellISR, FALLING); // Srednji

    // Konfiguracija Timer1 za prekid svakih 1s
    cli(); // Isključeni globalni prekidi
    TCCR1A = 0;
    TCCR1B = (1 << WGM12) | (1 << CS12) | (1 << CS10); // CTC mod, prescaler 1024
    OCR1A = 15624;                                     // 1s pri 16MHz/256
    TIMSK1 |= (1 << OCIE1A);                           // Omogući Timer1 Compare prekid
    sei();                                             // Uključeni globalni prekidi

    // Konfiguracija ADC prekida
    ADMUX = (1 << REFS0);                              // Referentni napon na AVCC
    ADCSRA = (1 << ADEN) | (1 << ADIE) | (1 << ADPS2); // Omogući ADC i prekid
}

void loop()
{
    unsigned long currentMillis = millis();
    // Obrada tipkala - paljenje/gašenje LED-ice
    if (buttonPressed)
    {
        ledState = !ledState; // Promjena stanja LED-ice
        digitalWrite(11, ledState);
        Serial.println("Tipkalo pritisnuto! LED stanje promijenjeno.");
        buttonPressed = false; // Reset zastavice
    }

    // Obrada Timer1 prekida - bljeskanje LED-ice
    if (timerTriggered)
    {
        digitalWrite(13, !digitalRead(13)); // Promjena stanja LED-ice
        Serial.println("Timer prekid! LED biljeska.");
        timerTriggered = false;
    }

    // Pokreni ADC konverziju
    ADCSRA |= (1 << ADSC);
    // Obrada prekida fotosenzora
    if (lightDetected)
    {
        digitalWrite(8, HIGH); // Ukoliko je očitano svijetlo, LED dioda počinje svjetliti
        Serial.println("Svjetlo detektirano!");
        lightDetected = false; // Reset zastavice
    }
    if (digitalRead(8) == HIGH)
    {
        if (currentMillis - previousMillis >= INTERVAL)
        {                                   // Ako je prošlo 2 sekunde
            previousMillis = currentMillis; // Ažuriraj vrijeme
            digitalWrite(8, LOW);
        }
    }
    // Obrada ADC očitanja
    if (sensorReady)
    {
        int sensorValue = ADC; // Pročitaj ADC rezultat
        Serial.print("Senzor: ");
        Serial.println(sensorValue); // Ispis vrijednosti na serijski monitor
        sensorReady = false;
    }
}
