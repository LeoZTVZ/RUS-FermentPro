# FermentPro

Ovaj projekt je osmišljen kako bi pomogao malim vinarima lakše pratiti proces fermentacije vina, ali može se koristiti i za praćenje fermentacije ostalih pića. Mi dolazimo iz kraja gdje postoje mnogi mali vinogradari pa smo s njima na umu došli do ideje za ovaj projekt.

## Opis projekta
Za ostvarenje projekta planirano je korištenje mikroupravljača Arduino MKR1010 WiFi zbog mogućnosti korištenja WiFi-a kako bi se podaci mogli slati na Firebase bazu podataka s koje se preuzimaju podaci za prikazivanje na našoj aplikaciji. (Za mjerenje vanjske temperature koristit će se DHT22 senzor za temperaturu, iako može mjeriti i vlagu, za ovaj projekt to nije potrebno.) Za mjerenje temperature tekućine koristi se DS18B20 vodotporni senzor za temperaturu. Mjerenje dinamike fermentacije računat će se tako da photo interrupt senzorom brojimo mjehuriće CO2 koji se ispuštaju van i oni se mjere u određenom vremenskom periodu i tako se može zaključiti dinamika fermentacije. Na kraju tu je LCD ekran za pregled podataka na mjestu.

  ### Korištene komponente i njihove cijene

  |Komponenta | Opis | Cijena (EUR) |
  |------------|-------|---------------|
  |Arduino MKR WiFi 1010 | Mikrokontroler s Wi-Fi i Bluetooth podrškom, idealan za IoT projekte | ~35–40 € |
  DHT22 modul| Digitalni senzor temperature i vlažnosti | 4,23–7,50 € | 
  Foto-interruptor senzor | Optički senzor za detekciju prekida svjetlosnog snopa | ~2–5 € |
  16x2 LCD display | Ekran za prikaz podataka, koristi I2C sabirnicu | ~5 € |
  10k potenciometar | Koristi se kao 10k otpotnik za spajanje LHT301-07 foto senzora |
  1k OHM otpornik | Za spajanje LHT301-07 |


## Pregled komponenata
  **Arduino MKR 1010 WiFi**  
  **DHT 22**  
  **DS18B20**  
  **Photo interrupt senzor**  
  **16x2 LCD display**  

## Način korištenja
 Senzor za mjerenje temperature tekućine i foto interrupt umoče se u tekućinu, photo interrupt senzor je zaštičen, on ima dvije cjevčice, jedna je IR odašiljač, a druga senzor za primanje IR zraka. Između te dvije cjevčice je stavljena jedna prozirna kroz koju ide tekućina i kroz nju se promatraju mjehurići koji izlaze van.
 Nakon određenog vremena na LCD ekranu pojavit će se temperatura tekućine i broj mjehurića u 10 sekundi, također će sve to detaljnije biti vidljivo i na mobilnoj aplikaciji gdje će biti prikazan graf i bit će točno vidljiva dinamika odnsono brzina fermentacije.
## Funkcijski zahtjevi

FRID | Funkcionalnost | Opis
-----|-----------------|---------
FR1 | Mjerenje temperature | Očitanje temperature mošta svaku minutu radi uštede energije (korištenjem sleep moda) ili vanjski interrupt
FR2 | Detekcija fermentacijskih mjehurića | Broji kada photo-interrupt senzor detektira prekid svjetlosti (prolazak mjehurića), aktivira se svaku minutu i broji 10 sekundi
FR3 | Izračun dinamike fermentacije | Računanje dinamike fermentacije u CO2 mjehurići u 10 sekundi
FR4 | Zbog očuvanja energije uređaj ide u LightSleep u trajanju od 1 min |
FR4 | Slanje podataka na Firebase | Slanje izmjerenih podataka u stvarnom vremenu putem WiFi veze
FR5 | Prikaz podataka u aplikaciji | Vizualizacija temperature i dinamike vrenja kroz mobilnu aplikaciju
FR6 | Prikaz podataka na LCD ekranu | Prikaz zadnje izmjerene temperature i dinamike vrenja

![image](https://github.com/user-attachments/assets/d3195908-f1e8-4f34-90b0-979bad2a9d7b)

![image](https://www.plantuml.com/plantuml/png/XLF1ZjD03BtFLmovK0ILO8yze5rKHJqWiQAHEAxSZ7VhDXbN7a-GYZXpui0_zSEOMLIQqLPA3f6TUU_PVkFS1WNHs7VcbMwnHxk5TezYp6kxn4Vo9B2p-mu2cZQzWxqJ5ydp6ZKUx0zZq_Csv6Jsvb_IilVOwZUgwSwxcWGtYPrEVvfIuZFpVuKknMF86drW-OhWKCuOITcdkDbq66gM3-_Nc4gvSAxxXDfWVq01ZLBKE_Um0k-wYruyK7Y83niunbc_m-t2ajTtLfF8mZvs33hIQAZ76hNTPlwbOFugtA-Qvduq_u2Y3TSiFQYYowYP0qLDmSAkLSW_9UtIPC4EMjgXfMEFfp_nsNKmOxFcZh_x-SVIdOMjzYmKbAfhu7BwQVneqX9RNFnq9oLwkfMICD5BOHm7puD7omEbA9sRegjvqgcMg-RcnWRqHvOgItqv_IQ50NmoN2zhKrtXrgmyfYvHSPzk2cpUcYXq-WMbbPcMzp-Zxtd08pqNUWaw6_82Q6xHk_nN_WK0)



## Članovi tima
  __Leo Žižek__  
  __Antonio Miser__  
