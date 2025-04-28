/**
 * @file projekt.ino
 * @brief Glavni Arduino kod za rad s Firebaseom, očitavanje podataka sa senzora i prikazivanje na LCD ekranu.
 *
 * Ovaj projekt koristi DHT22 senzor za očitavanje temperature, foto senzor za detekciju mjehurića i LCD ekran za prikaz podataka.
 * Također, podaci se šalju na Firebase i koristi se API za dohvat trenutnog vremena.
 */

/**
 * @brief Funkcija koja se izvodi na početku i inicijalizira WiFi, Firebase, DHT senzor i LCD ekran.
 *
 * Ova funkcija se izvodi samo jednom prilikom pokretanja i postavlja sve potrebne inicijalizacije, uključujući serijsku komunikaciju,
 * WiFi, Firebase, DHT senzor i LCD ekran.
 */
void setup()
{
  Serial.begin(115200);
  while (!Serial)
    ;

  pinMode(sensorPin, INPUT);

  connectWiFiAndFirebase();
  dht.begin();

  lcd.begin(16, 2);
  lcd.setBacklight(1); // Uključi pozadinsko osvjetljenje
  lcd.print("Inicijalizacija...");
}

/**
 * @brief Glavna petlja koja kontinuirano čita podatke sa senzora i prikazuje ih na LCD ekranu.
 *
 * Ova funkcija čita podatke temperature sa DHT22 senzora i broji mjehuriće putem foto senzora.
 * Zatim prikazuje te podatke na LCD ekranu, pohranjuje ih na Firebase i čeka jednu minutu prije nego što ponovi postupak.
 */
void loop()
{
  // Očitavanje podataka
  float temperature = dht.readTemperature();
  if (isnan(temperature))
  {
    Serial.println("Greška pri očitavanju temperature!");
    temperature = -99.0;
  }

  int count = readBubblesFor10Seconds();

  Serial.print("Broj mjehurića: ");
  Serial.println(count);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp: ");
  lcd.print(temperature);
  lcd.print(" C");

  lcd.setCursor(0, 1);
  lcd.print("Bubbles: ");
  lcd.print(count);
  upis_u_bazu(count, temperature);

  // Isključivanje WiFi-a radi uštede energije (opcionalno)
  WiFi.disconnect();
  WiFi.end();

  // Mirovanje 1 minut
  Serial.println("Čekanje 1 min...");
  unsigned long sleepStart = millis();
  while (millis() - sleepStart < 60000UL)
  {
    delay(100); // Mali odmor kako bi se spriječilo preopterećenje CPU-a
  }

  // Ponovno spajanje na WiFi nakon mirovanja
  connectWiFiAndFirebase();
}

/**
 * @brief Funkcija za povezivanje na WiFi mrežu i Firebase bazu podataka.
 *
 * Spaja se na WiFi mrežu koristeći SSID i lozinku, a zatim inicijalizira vezu s Firebase.
 */
void connectWiFiAndFirebase()
{
  Serial.print("Spajanje na WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(100);
    Serial.print(".");
  }
  Serial.println(" Spojeno!");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);
}

/**
 * @brief Funkcija koja očitava broj mjehurića sa foto senzora tijekom 10 sekundi.
 *
 * Funkcija mjeri promjene stanja foto senzora i broji koliko puta se stanje promijeni (detektira prolazak mjehurića).
 *
 * @return Broj detektiranih mjehurića u razdoblju od 10 sekundi.
 */
int readBubblesFor10Seconds()
{
  int bubbleCount = 0;
  bool currentState;
  lastState = HIGH;

  unsigned long startTime = millis();
  while (millis() - startTime < 10000)
  {
    currentState = digitalRead(sensorPin);

    if (lastState == HIGH && currentState == LOW)
    {
      bubbleCount++;
      delay(50); // Debouncing
    }
    lastState = currentState;
  }
  return bubbleCount;
}

/**
 * @brief Funkcija koja unosi podatke o mjehurićima i temperaturi u Firebase bazu podataka.
 *
 * Ova funkcija kreira jedinstveni ID za svaku pohranu podataka, dohvaća trenutno vrijeme putem HTTP API-ja,
 * te unosi podatke u Firebase u odgovarajuće polje.
 *
 * @param mjeh Broj mjehurića detektiranih tijekom mjerenja.
 * @param temp Temperatura očitana sa DHT senzora.
 */
void upis_u_bazu(int mjeh, float temp)
{
  long id = random(1000, 9999) + millis();
  Serial.println(id);
  String recordId = String(id);

  String path = "/fermentRecord/" + recordId;
  String datetime = getTimeFromHTTP();
  String formatted = convertToFormattedTime(datetime);

  if (Firebase.setString(firebaseData, path + "/dateTime", formatted))
    Serial.println("dateTime uspješno prenesen!");
  else
    Serial.print("Neuspješno slanje dateTime: "), Serial.println(firebaseData.errorReason());

  if (Firebase.setString(firebaseData, path + "/deviceId", "asw11"))
    Serial.println("deviceId uspješno prenesen!");
  else
    Serial.print("Neuspješno slanje deviceId: "), Serial.println(firebaseData.errorReason());

  if (Firebase.setInt(firebaseData, path + "/photoSensor", mjeh))
    Serial.println("photoSensor uspješno prenesen!");
  else
    Serial.print("Neuspješno slanje photoSensor: "), Serial.println(firebaseData.errorReason());

  if (Firebase.setFloat(firebaseData, path + "/temperature", temp))
    Serial.println("temperature uspješno prenesen!");
  else
    Serial.print("Neuspješno slanje temperature: "), Serial.println(firebaseData.errorReason());
}

/**
 * @brief Funkcija za dohvat trenutnog vremena sa HTTP API-ja.
 *
 * Povezuje se na API "timeapi.io" i dohvaća UTC vremensku oznaku u formatu ISO 8601.
 *
 * @return Trenutno vrijeme u formatu "yyyy-MM-ddTHH:mm:ss".
 */
String getTimeFromHTTP()
{
  Serial.println("Dohvaćanje vremena s timeapi.io...");
  String datetime = "0";
  client.get(path1);

  int statusCode = client.responseStatusCode();
  String response = client.responseBody();

  if (statusCode == 200)
  {
    Serial.println("Dohvaćeni podaci:");
    Serial.println(response);

    int index = response.indexOf("\"dateTime\":\"");
    if (index >= 0)
    {
      int start = index + 12;
      int end = response.indexOf("\"", start);
      datetime = response.substring(start, end);

      Serial.print("Trenutno UTC vrijeme: ");
      String formatted = convertToFormattedTime(datetime);
      Serial.println(formatted);
    }
  }
  else
  {
    Serial.print("Neuspješan zahtjev, status kod: ");
    Serial.println(statusCode);
  }
  return datetime;
}

/**
 * @brief Funkcija koja konvertira UTC vrijeme u formatirani string.
 *
 * Ova funkcija uzima UTC vrijeme u formatu "yyyy-MM-ddTHH:mm:ss" i konvertira ga u format "HH:mm:ss dd.MM.yyyy".
 *
 * @param datetime UTC vrijeme u formatu "yyyy-MM-ddTHH:mm:ss".
 * @return Formatirani string vremena.
 */
String convertToFormattedTime(String datetime)
{
  String year = datetime.substring(0, 4);
  String month = datetime.substring(5, 7);
  String day = datetime.substring(8, 10);
  String hour = datetime.substring(11, 13);
  String minute = datetime.substring(14, 16);
  String second = datetime.substring(17, 19);

  return hour + ":" + minute + ":" + second + " " + day + "." + month + "." + year;
}
