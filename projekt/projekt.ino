
#include "DHT.h"
#include <WiFiNINA.h>
#include "Firebase_Arduino_WiFiNINA.h"
#include <WiFiSSLClient.h>
#include <ArduinoHttpClient.h>
#include "arduino_secrets.h"

// WiFi credentials
#define WIFI_SSID SECRET_SSID
#define WIFI_PASSWORD SECRET_PASS

// Firebase credentials
#define FIREBASE_HOST SECRET_HOST
#define FIREBASE_AUTH SECRET_AUTH
#define DHTPIN 2       // Data pin
#define DHTPOW 11       // Power pin (controls VCC)
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);
FirebaseData firebaseData;

unsigned long previousMillis = 0;
const long interval2 = 10000UL;  // 5 minutes
const int sensorPin = 7; // pin kolektora
int count = 0;           // brojač broja mjehurića
unsigned long lastResetTime = 0;
const unsigned long interval = 10000; // vremensko razdoblje za ispis broja mjehurića
int temp=0;
bool lastState = HIGH;

char server[] = "www.timeapi.io";
int port = 443; // HTTPS

String path1 = "/api/Time/current/zone?timeZone=UTC";

WiFiSSLClient wifi; // <-- important to use SSL client
HttpClient client = HttpClient(wifi, server, port);


void setup()
{
  Serial.begin(115200);
  Serial.print("Connecting to WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }
  Serial.println("WiFi connected.");
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
pinMode(sensorPin, INPUT);
  // Only now: start UDP, Firebase, HTTP client
  // Connect to Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);

  lastResetTime = millis();
}


void loop()
{
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval2) {
    previousMillis = currentMillis;

    // Power up the sensor
    delay(2000);

    dht.begin(); 

    float temperature = dht.readTemperature();

    if (isnan(temperature)) {
      Serial.println("Pogreška čitanja sa senzora!");
    } else {
      Serial.print("Temperature: ");
      Serial.print(temperature);
      Serial.println(" °C");
      upis_u_bazu(count,temperature);
    }
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

void upis_u_bazu(int mjeh, float temp){
  long id = random(1000, 9999) + millis();
  Serial.println(id);
  String recordId = String(id); // You could generate random IDs or timestamps

  // Build the path
  String path = "/fermentRecord/" + recordId;
  String datetime=getTimeFromHTTP();
  String formatted = convertToFormattedTime(datetime);
  if (Firebase.setString(firebaseData, path + "/dateTime", formatted)) {
    Serial.println("dateTime uploaded successfully!");
  } else {
    Serial.print("Failed to upload dateTime: ");
    Serial.println(firebaseData.errorReason());
  }

  if (Firebase.setString(firebaseData, path + "/deviceId", "asw11")) {
    Serial.println("deviceId uploaded successfully!");
  } else {
    Serial.print("Failed to upload deviceId: ");
    Serial.println(firebaseData.errorReason());
  }

  if (Firebase.setInt(firebaseData, path + "/photoSensor", mjeh)) {
    Serial.println("photoSensor uploaded successfully!");
  } else {
    Serial.print("Failed to upload photoSensor: ");
    Serial.println(firebaseData.errorReason());
  }

  if (Firebase.setFloat(firebaseData, path + "/temperature", temp)) {
    Serial.println("temperature uploaded successfully!");
  } else {
    Serial.print("Failed to upload temperature: ");
    Serial.println(firebaseData.errorReason());
  }

}

String getTimeFromHTTP() {
  Serial.println("Requesting time from timeapi.io...");
  String datetime= "0";
  client.get(path1);

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

  if (statusCode == 200) {
    Serial.println("Got response:");
    Serial.println(response);

    // Simple parsing: find "dateTime" field
    int index = response.indexOf("\"dateTime\":\"");
    if (index >= 0) {
      int start = index + 12;
      int end = response.indexOf("\"", start);
      datetime = response.substring(start, end);

      Serial.print("Current UTC DateTime: ");
      String formatted = convertToFormattedTime(datetime);
      Serial.println(formatted);

    }
  } else {
    Serial.print("Failed to get time, status code: ");
    Serial.println(statusCode);
  }
  return datetime;
}
String convertToFormattedTime(String datetime) {
  String year = datetime.substring(0, 4);
  String month = datetime.substring(5, 7);
  String day = datetime.substring(8, 10);
  String hour = datetime.substring(11, 13);
  String minute = datetime.substring(14, 16);
  String second = datetime.substring(17, 19);

  return hour + ":" + minute + ":" + second + " " + day + "." + month + "." + year;
}
