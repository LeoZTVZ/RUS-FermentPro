// Arduino Uno - Višestruki interrupti s LED-icama i buzzerom (Wokwi)

const int led1 = 9;  // LED dioda za tipkalo
const int led2 = 10; // LED dioda za timer
const int buzzer = 11; // Buzzer povezan na digitalni pin 11
const int buttonPin = 2; // Tipkalo povezano na digitalni pin 2
volatile bool buttonPressed = false; // Varijabla za praćenje statusa tipkala
volatile int buzzerFrequency = 500; // Početna frekvencija buzzera

void setup() {
    pinMode(led1, OUTPUT); // Postavljanje pina za LED1 kao izlaz
    pinMode(led2, OUTPUT); // Postavljanje pina za LED2 kao izlaz
    pinMode(buzzer, OUTPUT); // Postavljanje pina za buzzer kao izlaz
    pinMode(buttonPin, INPUT_PULLUP); // Omogućavanje pull-up otpornika za tipkalo
    
    attachInterrupt(digitalPinToInterrupt(buttonPin), buttonISR, FALLING); // Eksterni prekid na tipkalu
    
    Timer1Setup(); // Postavljanje timera
    Serial.begin(9600); // Pokretanje serijske komunikacije
}

void loop() {
    if (buttonPressed) {
        digitalWrite(led1, HIGH); // Uključuje LED1
        digitalWrite(led2, HIGH); // Uključuje LED2
        tone(buzzer, buzzerFrequency); // Postavlja buzzer na trenutnu frekvenciju
    } else {
        digitalWrite(led1, LOW); // Isključuje LED1
        noTone(buzzer); // Isključuje buzzer
    }
}

// ISR prekidna rutina za tipkalo
void buttonISR() {
    buttonPressed = !buttonPressed; // Mijenja stanje varijable buttonPressed
    Serial.print("Button pressed: ");
    Serial.println(buttonPressed ? "true" : "false");
}

// Funkcija za postavljanje Timer1 koji generira prekid svake 500 ms
void Timer1Setup() {
    noInterrupts(); // Onemogućavanje prekida tijekom postavljanja timera
    TCCR1A = 0; // Normalni način rada
    TCCR1B = (1 << WGM12) | (1 << CS12) | (1 << CS10); // CTC način rada, prescaler 1024
    OCR1A = 7812; // Vrijednost za 500 ms (16 MHz / 1024 prescaler / 2 Hz)
    TIMSK1 |= (1 << OCIE1A); // Omogućavanje Timer1 compare interrupta
    interrupts(); // Ponovno uključivanje prekida
}

// ISR prekidna rutina za Timer1
ISR(TIMER1_COMPA_vect) {
    if (!buttonPressed) { // Ako tipka NIJE pritisnuta, LED2 mijenja stanje svake sekunde
        digitalWrite(led2, !digitalRead(led2));
    } else { 
        static int step = 10;
        buzzerFrequency += step; // Mijenja frekvenciju svake sekunde
        if (buzzerFrequency >= 1500 || buzzerFrequency <= 500) {
            step = -step;
        }
    }
}