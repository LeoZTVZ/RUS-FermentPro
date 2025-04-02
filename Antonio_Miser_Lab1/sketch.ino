#include <Arduino.h>

// Definicija pinova za LED diode, buzzer i tipkala
const int led1 = 9;
const int led2 = 10;
const int led3 = 8;
const int buzzer = 11;
const int button1Pin = 2;
const int button2Pin = 3;
const int debounceTime = 200; // Vrijeme debounce-a za tipkala

// Varijable za praćenje statusa tipkala i buzzera
volatile bool button1Pressed = false;
volatile bool button2Pressed = false;
volatile int buzzerFrequency = 500; // Početna frekvencija buzzera
volatile bool buzzerLimitReached = false; // Oznaka je li dostignuta maksimalna frekvencija

void setup() {
    // Postavljanje pinova za LED diode kao izlaze
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
    pinMode(led3, OUTPUT);
    pinMode(buzzer, OUTPUT); // Postavljanje pina za buzzer kao izlaz
    pinMode(button1Pin, INPUT_PULLUP); // Postavljanje tipkala 1 kao ulaz s pull-up otpornikom
    pinMode(button2Pin, INPUT_PULLUP); // Postavljanje tipkala 2 kao ulaz s pull-up otpornikom
    
    // Postavljanje prekida za tipkala
    attachInterrupt(digitalPinToInterrupt(button1Pin), button1ISR, FALLING);
    attachInterrupt(digitalPinToInterrupt(button2Pin), button2ISR, FALLING);
    
    // Inicijalizacija Timer1 za periodične prekide
    Timer1Setup();
    Serial.begin(9600); // Pokretanje serijske komunikacije za ispis podataka
}

void loop() {

        // Upravljanje LED1 i buzzerom ako je tipkalo 1 pritisnuto
        if (button1Pressed) {
            digitalWrite(led1, HIGH);
            digitalWrite(led2, HIGH);
            tone(buzzer, buzzerFrequency); // Postavljanje frekvencije buzzera
        } else {
            digitalWrite(led1, LOW);
            noTone(buzzer);
        }

        // Upravljanje LED3 ako je tipkalo 2 pritisnuto, ali tipkalo 1 nije
        if (button2Pressed && !button1Pressed) {
            digitalWrite(led3, HIGH);
        } else {
            digitalWrite(led3, LOW);
        }
    
}

// ISR prekidna rutina za tipkalo s višim prioritetom
void button1ISR() {
    static unsigned long lastInterruptTime = 0;
    unsigned long interruptTime = millis();
    if (interruptTime - lastInterruptTime > debounceTime) {
        button1Pressed = !button1Pressed;
        Serial.print("Button visi prioritet: ");
        Serial.println(button1Pressed ? "true" : "false");
    }
    lastInterruptTime = interruptTime;
}

// ISR prekidna rutina za tipkalo s nižim prioritetom
void button2ISR() {
    static unsigned long lastInterruptTime = 0;
    unsigned long interruptTime = millis();
    if (interruptTime - lastInterruptTime > debounceTime) {
        button2Pressed = !button2Pressed;
        Serial.print("Button nizi prioritet: ");
        Serial.println(button2Pressed ? "true" : "false");
    }
    lastInterruptTime = interruptTime;
}

// Postavljanje Timer1 koji generira prekid svake 500 ms
void Timer1Setup() {
    noInterrupts(); // Onemogućavanje prekida tijekom postavljanja timera
    TCCR1A = 0; //Postavlja registar kontrolera timera 1 na nulu
    TCCR1B = (1 << WGM12) | (1 << CS12) | (1 << CS10); 
       /*
    Postavlja bit za CTC (Clear Timer on Compare Match) način rada, 
    koji omogućuje timeru da generira prekid kada se 
    brojčanik (counter) podudari s određenom vrijednošću.
    
    Postavlja prescaler timeru na 1024, što znači da će timer brojači biti 
    povećani za svakih 1024 takta procesora.  
    Time se usporava brojanje timera, što daje točno vrijeme za generiranje prekida.
    */
    OCR1A = 7812; // Vrijednost za 500 ms 
    TIMSK1 |= (1 << OCIE1A); // 
    /*Omogućuje prekid na usporedbi (compare interrupt) za Timer1. 
    Kada brojčanik dosegne vrijednost u OCR1A, 
    generirat će se prekid i pozvat će se odgovarajući prekidni rukovatelj.
    */
    interrupts(); // Ponovno uključivanje prekida
}

// ISR prekidna rutina za Timer1
ISR(TIMER1_COMPA_vect) {
    static int step = 100;
    if (!button1Pressed) {
        toggleLED(led2); // Treptanje LED2 ako tipkalo 1 nije pritisnuto
    } else {
        buzzerFrequency += step; // Mijenjanje frekvencije buzzera
        if (buzzerFrequency >= 1500 || buzzerFrequency <= 500) {
            step = -step;
        }
        if (buzzerFrequency >= 1500) {
            buzzerLimitReached = true; // Postavljanje oznake da je buzzer dostigao 1500 Hz
            Serial.print("Buzzer: ");
            Serial.println(buzzerLimitReached ? "true" : "false");
        } else {
            buzzerLimitReached = false;
        }
    }
}

// Funkcija za promjenu stanja određene LED diode
void toggleLED(int ledPin) {
    digitalWrite(ledPin, !digitalRead(ledPin));
}

