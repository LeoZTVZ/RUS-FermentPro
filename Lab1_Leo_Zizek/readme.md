# Zadatak 1 Upravljanje prekidima

## 1. Opis sustava

Ovaj projekt implementira sustav upravljanja LED diodama i očitavanja senzorskih podataka koristeći Arduino mikrokontroler. Sustav koristi različite prekide (interrupts) kako bi omogućio brze reakcije na vanjske događaje, uključujući pritisak tipkala, detekciju svjetla, vremenske intervale i završetak ADC konverzije. Sve je izvršeno na Wokwi simulacijskoj platformi.

### Funkcionalnosti
    1. Upravljanje LED diodama pomoću tipkala – Kada korisnik pritisne tipkalo, stanje LED diode na pinu 11 se mijenja.
    2. Automatsko bljeskanje LED diode – LED na pinu 13 mijenja stanje svakih 1 ms pomoću Timer1 prekida.
    3. Detekcija svjetla pomoću fotosenzora – Kada fotosenzor detektira svjetlo, LED dioda na pinu 8 se aktivira.
    4. Gašenje LED diode nakon određenog vremena – Ako je LED na pinu 8 aktivirana, ona se automatski gasi nakon 2 sekunde.

## 2. Komponente 
| Komponenta | Količina | Pinovi |
|------------|---------|---------|
|Arduino UNO R3|1|-|
|LED dioda|3|11,13,8|
|Photoresistor(LDR) senzor|1|3|
|Pushbutton|1|2|
|Potenciometar|1|A0|
|Logički analizator|1| 13,2,3|

## 3. Izvršavanje prioriteta prekida
    # INT0 > INT1 >Timer1 > Potenciometar
    
## Funkcionalni zahtjevi 
| ID | Opis zahtjeva |
|---|-------------|
| FR1 | Sustav mora reagirati na pritisak tipkala i promijeniti stanje LED diode.|
| FR2 | Timer mora generirati prekid svakih 500 ms za bljeskanje LED diode.|
| FR3 | Sustav mora detektirati svjetlo putem fotosenzora i upaliti LED diodu.|
| FR4 | LED dioda povezana s fotosenzorom mora se automatski ugasiti nakon 2 sekunde. |
| FR5 | Sustav mora omogućiti očitavanje analognih senzora pomoću ADC prekida. |
