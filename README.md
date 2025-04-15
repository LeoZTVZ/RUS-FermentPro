# FermentPro

Ovaj projekt je osmišljen kako bi pomogao malim vinarima lakše pratiti proces fermentacije vina, ali može se koristiti i za praćenje fermentacije ostalih pića. Mi dolazimo iz kraja gdje postoje mnogi mali vinogradari pa smo s njima na umu došli do ideje za ovaj projekt.

## Opis projekta
Za ostvarenje projekta planirano je korištenje mikroupravljača Arduino MKR1010 WiFi zbog mogućnosti korištenja WiFi-a kako bi se podaci mogli slati na Firebase bazu podataka s koje se preuzimaju podaci za prikazivanje na našoj aplikaciji. Za mjerenje vanjske temperature koristit će se DHT11 senzor za temperaturu, iako može mjeriti i vlagu, za ovaj projekt to nije potrebno. Mjerenje dinamike fermentacije računat će se tako da photo interrupt senzorom brojimo mjehuriće CO2 koji se ispuštaju van i oni se mjere u određenom vremenskom periodu, i tako se može zaključiti dinamika fermentacije.

  ### Korištene komponente i njihove cijene

  |Komponenta | Opis | Cijena (EUR) | Napomena|
  |------------|-------|---------------|-----------|
  |Arduino MKR WiFi 1010 | Mikrokontroler s Wi-Fi i Bluetooth podrškom, idealan za IoT projekte | ~35–40 € | Dostupan na Arduino službenoj stranici|
  DHT11 senzor | Digitalni senzor temperature i vlažnosti | 4,23–7,50 € | Dostupan na Chipoteka.hr i Nabava.net|
  Foto-interruptor senzor | Optički senzor za detekciju prekida svjetlosnog snopa | ~2–5 € | Dostupan na Automation Robotics Arduino|


## Pregled komponenata
  **Arduino MKR 1010 WiFi**
  **DHT 11**
  **Photo interrupt senzor**
  

## Funkcijski zahtjevi

FRID | Funkcionalnost | Opis
-----|-----------------|---------
FR1 | Mjerenje temperature | Očitanje vanjske temperature pomoću senzora
FR2 | Detekcija fermentacijskih mjehurića | Brojanje mjehurića CO₂ kroz photo-interrupt senzor
FR3 | Izračun dinamike fermentacije | Računanje brzine fermentacije (mjehurića/min)
FR4 | Slanje podataka na Firebase | Slanje izmjerenih podataka u stvarnom vremenu
FR5 | Prikaz podataka u aplikaciji | Vizualizacija temperature i dinamike vrenja korisniku
