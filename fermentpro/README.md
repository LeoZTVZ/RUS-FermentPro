# FermentPro

**FermentPro** je Flutter aplikacija za prikaz i praćenje podataka o fermentaciji u stvarnom vremenu. Aplikacija dohvaća podatke s Firebase baze i vizualizira ih kroz jednostavno sučelje i atraktivne grafove.

## ✨ Značajke

- Prikaz najnovije temperature fermentacije i broja mjehurića (photoSensor).
- Interaktivni dijagrami temperature i broja mjehurića kroz vrijeme.
- Glatke animacije između stranica koristeći `PageTransitionSwitcher`.
- Sinkronizacija podataka s Firebase baze podataka.

## 🏗 Struktura Aplikacije

- **Home Page**

  - Prikaz najnovije temperature.
  - Prikaz trenutnog broja mjehurića.

- **Data Page**

  - Dijagram temperature kroz vrijeme.
  - Dijagram broja mjehurića kroz vrijeme.
  - Implementirano pomoću [FL Chart](https://pub.dev/packages/fl_chart) biblioteke.

Prebacivanje između stranica animirano je pomoću `PageTransitionSwitcher` iz [animations](https://pub.dev/packages/animations) paketa.

## 📦 Korištene Tehnologije

- **Flutter** — za razvoj aplikacije
- **Firebase** — za spremanje i dohvaćanje podataka
- **Riverpod** — za upravljanje stanjem
- **FL Chart** — za crtanje dijagrama
- **Shared Preferences** — za lokalno spremanje korisničkih postavki
- **Animations** — za glatke prijelaze stranica
- **Flutter SVG** — za prikaz SVG grafika
- **HTTP** — za dodatnu komunikaciju ako je potrebno
- **Flutter Launcher Icons** — za podešavanje ikone aplikacije

## 📋 Model Podataka

Podaci o fermentaciji se sastoje od sljedećih polja:

```dart
final String id;           // Jedinstveni ID zapisa
final String dateTime;     // Datum i vrijeme zapisa
final String deviceId;     // ID uređaja koji šalje podatke
final int photoSensor;     // Broj mjehurića (očitanje senzora)
final double temperature;  // Temperatura u °C
```

## 🚀 Pokretanje Projekta

1. Klonirajte repozitorij:

   ```bash
    https://github.com/LeoZTVZ/RUS-FermentPro.git
   cd fermentpro
   ```

2. Instalirajte potrebne pakete:

   ```bash
   flutter pub get
   ```

3. Postavite Firebase za svoj projekt:

   - Dodajte `google-services.json` (Android) i/ili `GoogleService-Info.plist` (iOS) u odgovarajuće mape.
   - Provjerite da je Firebase inicijaliziran u projektu (`firebase_core`).

4. Pokrenite aplikaciju:

   ```bash
   flutter run
   ```

## 📷 Slike aplikacije

| Home Page | Data Page (Grafovi) |
| --------- | ------------------- |
|           |                     |

*(Dodajte slike u **`screenshots/`** direktorij)*

## 🔧 Podešavanje ikone aplikacije

Ako želite promijeniti ikonu aplikacije:

```bash
flutter pub run flutter_launcher_icons:main
```

Konfiguracija ikone se nalazi u `pubspec.yaml`.

## 📜 Licenca

Ovaj projekt je licenciran pod [MIT licencom](LICENSE).

