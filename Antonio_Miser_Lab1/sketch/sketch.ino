/**
 * @file GlavniProgram.ino
 * @brief Upravljanje LED diodama, buzzerom i tipkalima koristeći prekide i timer.
 */

#include <Arduino.h>

// === DEFINICIJE PINOVA ===

/** @brief Pin za LED1. */
const int led1 = 9;

/** @brief Pin za LED2. */
const int led2 = 10;

/** @brief Pin za LED3. */
const int led3 = 8;

/** @brief Pin za buzzer. */
const int buzzer = 11;

/** @brief Pin za tipkalo 1 (viši prioritet). */
const int button1Pin = 2;

/** @brief Pin za tipkalo 2 (niži prioritet). */
const int button2Pin = 3;

/** @brief Vrijeme za debounce prekida (ms). */
const int debounceTime = 200;

// === VARIJABLE STATUSA ===

/** @brief Status je li tipkalo 1 pritisnuto. */
volatile bool button1Pressed = false;

/** @brief Status je li tipkalo 2 pritisnuto. */
volatile bool button2Pressed = false;

/** @brief Trenutna frekvencija buzzera. */
volatile int buzzerFrequency = 500;

/** @brief Označava je li buzzer dosegao maksimalnu frekvenciju. */
volatile bool buzzerLimitReached = false;

/**
 * @brief Postavljanje početnog stanja komponenti.
 */
void setup() {
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
    pinMode(led3, OUTPUT);
    pinMode(buzzer, OUTPUT);
    pinMode(button1Pin, INPUT_PULLUP);
    pinMode(button2Pin, INPUT_PULLUP);

    attachInterrupt(digitalPinToInterrupt(button1Pin), button1ISR, FALLING);
    attachInterrupt(digitalPinToInterrupt(button2Pin), button2ISR, FALLING);

    Timer1Setup();
    Serial.begin(9600);
}

/**
 * @brief Glavna petlja programa.
 */
void loop() {
    if (button1Pressed) {
        digitalWrite(led1, HIGH);
        tone(buzzer, buzzerFrequency);
    } else {
        noTone(buzzer);
    }

    if (button2Pressed && !button1Pressed) {
        digitalWrite(led3, HIGH);
    } else {
        digitalWrite(led3, LOW);
    }
}

/**
 * @brief ISR za tipkalo 1 (viši prioritet).
 */
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

/**
 * @brief ISR za tipkalo 2 (niži prioritet).
 */
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

/**
 * @brief Postavljanje Timer1 za generiranje prekida svakih 500 ms.
 */
void Timer1Setup() {
    noInterrupts();
    TCCR1A = 0;
    TCCR1B = (1 << WGM12) | (1 << CS12) | (1 << CS10);
    OCR1A = 7812;
    TIMSK1 |= (1 << OCIE1A);
    interrupts();
}

/**
 * @brief ISR koji se poziva svakih 500 ms putem Timer1.
 */
ISR(TIMER1_COMPA_vect) {
    static int step = 100;
    toggleLED(led2);
    
    if (!button1Pressed) {
        toggleLED(led1);
    } else {
        buzzerFrequency += step;
        if (buzzerFrequency >= 1500 || buzzerFrequency <= 500) {
            step = -step;
        }
        if (buzzerFrequency >= 1500) {
            buzzerLimitReached = true;
            Serial.print("Buzzer: ");
            Serial.println(buzzerLimitReached ? "true" : "false");
        } else {
            buzzerLimitReached = false;
        }
    }
}

/**
 * @brief Mijenja trenutno stanje LED diode.
 * 
 * @param ledPin Pin na kojem se nalazi LED dioda.
 */
void toggleLED(int ledPin) {
    digitalWrite(ledPin, !digitalRead(ledPin));
}
