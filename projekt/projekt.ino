const int ledPin = 2;    // kontrola opto LED emitter
const int sensorPin = 7; // pin kolektora
int count = 0;           // brojač broja mjehurića
unsigned long lastResetTime = 0;
const unsigned long interval = 10000; // vremensko razdoblje za ispis broja mjehurića

bool lastState = HIGH;

void setup()
{
  pinMode(ledPin, OUTPUT);
  pinMode(sensorPin, INPUT);
  Serial.begin(9600);
  lastResetTime = millis();
  digitalWrite(ledPin, HIGH);
}

void loop()
{
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
