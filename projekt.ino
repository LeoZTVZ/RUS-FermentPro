const int ledPin = 2;     // kontrola opto LED
const int sensePin = 7;   // čitanje tranzistorske strane(čitanje signala)

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(sensePin, INPUT);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(ledPin, HIGH); // paljenje opto LED-ice
  delay(10);
  
  int sensorValue = digitalRead(sensePin);
  Serial.println(sensorValue); // ako prolazi svijetlo LED diode ispisuje se 0
  delay(1000);
}
