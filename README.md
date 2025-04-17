# FermentPro

Ovaj projekt je osmišljen kako bi pomogao malim vinarima lakše pratiti proces fermentacije vina, ali može se koristiti i za praćenje fermentacije ostalih pića. Mi dolazimo iz kraja gdje postoje mnogi mali vinogradari pa smo s njima na umu došli do ideje za ovaj projekt.

## Opis projekta
Za ostvarenje projekta planirano je korištenje mikroupravljača Arduino MKR1010 WiFi zbog mogućnosti korištenja WiFi-a kako bi se podaci mogli slati na Firebase bazu podataka s koje se preuzimaju podaci za prikazivanje na našoj aplikaciji. (Za mjerenje vanjske temperature koristit će se DHT22 senzor za temperaturu, iako može mjeriti i vlagu, za ovaj projekt to nije potrebno.) Za mjerenje temperature tekućine koristi se DS18B20 vodotporni senzor za temperaturu. Mjerenje dinamike fermentacije računat će se tako da photo interrupt senzorom brojimo mjehuriće CO2 koji se ispuštaju van i oni se mjere u određenom vremenskom periodu i tako se može zaključiti dinamika fermentacije. Na kraju tu je LCD ekran za pregled podataka na mjestu.

  ### Korištene komponente i njihove cijene

  |Komponenta | Opis | Cijena (EUR) |
  |------------|-------|---------------|
  |Arduino MKR WiFi 1010 | Mikrokontroler s Wi-Fi i Bluetooth podrškom, idealan za IoT projekte | ~35–40 € |
  DHT22 senzor(opcionalno)| Digitalni senzor temperature i vlažnosti | 4,23–7,50 € | 
  DS18B20 senzor | Digitalni senzor temperature (voddotporan) | ~5 € |
  Foto-interruptor senzor | Optički senzor za detekciju prekida svjetlosnog snopa | ~2–5 € |
  16x2 LCD display | Ekran za prikaz podataka, koristi I2C sabirnicu | ~5 € |


## Pregled komponenata
  **Arduino MKR 1010 WiFi**  
  **DHT 22**  
  **DS18B20**  
  **Photo interrupt senzor**  
  **16x2 LCD display**  

## Način korištenja
 Senzor za mjerenje temperature tekućine i foto interrupt umoče se u tekućinu, photo interrupt senzor je zaštičen, on ima dvije cjevčice, jedna je IR odašiljač, a druga senzor za primanje IR zraka. Između te dvije cjevčice je stavljena jedna prozirna kroz koju ide tekućina i kroz nju se promatraju mjehurići koji izlaze van.
 Nakon određenog vremena na LCD ekranu pojavit će se temperatura tekućine i broj mjehurića u minuti, također će sve to detaljnije biti vidljivo i na mobilnoj aplikaciji gdje će biti prikazan graf i bit će točno vidljiva dinamika odnsono brzina fermentacije.
## Funkcijski zahtjevi

FRID | Funkcionalnost | Opis
-----|-----------------|---------
FR1 | Mjerenje temperature | Očitanje temperature mošta svakih 15 minuta radi uštede energije (korištenjem sleep moda) ili vanjski interrupt
FR2 | Detekcija fermentacijskih mjehurića | Aktivira se kada photo-interrupt senzor detektira prekid svjetlosti (prolazak mjehurića)
FR3 | Izračun dinamike fermentacije | Računanje dinamike fermentacije u CO2 mjehurići po minuti
FR4 | Slanje podataka na Firebase | Slanje izmjerenih podataka u stvarnom vremenu putem WiFi veze
FR5 | Prikaz podataka u aplikaciji | Vizualizacija temperature i dinamike vrenja kroz mobilnu aplikaciju
FR6 | Prikaz podataka na LCD ekranu | Prikaz zadnje izmjerene temperature i dinamike vrenja

## Članovi tima
  __Leo Žižek__  
  __Antonio Miser__  
