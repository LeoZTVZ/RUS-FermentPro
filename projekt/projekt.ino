#include "DHT.h"

#define DHTPIN 2       // Data pin
#define DHTPOW 11       // Power pin (controls VCC)
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

unsigned long previousMillis = 0;
const long interval2 = 5 * 60 * 1000UL;  // 5 minutes
const int sensorPin = 7; // pin kolektora
int count = 0;           // brojač broja mjehurića
unsigned long lastResetTime = 0;
const unsigned long interval = 10000; // vremensko razdoblje za ispis broja mjehurića

bool lastState = HIGH;

void setup()
{
  pinMode(sensorPin, INPUT);
  Serial.begin(9600);
  lastResetTime = millis();
  pinMode(DHTPOW, OUTPUT);
}

void loop()
{
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval2) {
    previousMillis = currentMillis;

    // Power up the sensor
    digitalWrite(DHTPOW, HIGH);
    delay(2000);

    dht.begin(); 

    float temperature = dht.readTemperature();

    if (isnan(temperature)) {
      Serial.println("Pogreška čitanja sa senzora!");
    } else {
      Serial.print("Temperature: ");
      Serial.print(temperature);
      Serial.println(" °C");
    }
    digitalWrite(DHTPOW, LOW);
  }
  // čitanje stanja kolektora
  bool currentState = digitalRead(sensorPin);

  // ako je stanje promijenjeno znači da je učitan prekid svijetlosti
  if (lastState == HIGH && currentState == LOW)
  {
    count++;
    delay(50); // debounce
  }

  lastState = currentState;

  // Provjera proteklog vremena
  if (millis() - lastResetTime >= interval)
  {
    print();
  }
}
// Funkcija za ispis izbrojanih prekida
void print()
{
  Serial.print("Broj mjehurica u zadnjih 10s: ");
  Serial.println(count);

  count = 0;
  lastResetTime = millis();
}
