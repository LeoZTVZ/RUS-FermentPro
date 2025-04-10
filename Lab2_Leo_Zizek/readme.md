# Zadatak 2: Upravljanje potrošnjom energije pomoću sleep moda

[Poveznica na Wokwi projekt](https://wokwi.com/projects/427037599729002497)

## 1. Opis sustava

Ovaj projekt demonstrira upravljanje potrošnjom energije mikrokontrolera korištenjem **Power Down sleep moda**, gdje se procesor uspavljuje dok ne dođe do događaja buđenja. Sustav se budi na dva načina: pritiskom na **tipkalo (vanjski prekid)** ili **istekom vremena watchdog timera**. Nakon buđenja, LED dioda treperi 5 sekundi kao indikator aktivnosti. Projekt je simuliran putem Wokwi platforme.

### Funkcionalnosti

1. Uspavljivanje mikrokontrolera korištenjem `SLEEP_MODE_PWR_DOWN`.
2. Buđenje putem:
   - Pritiska na tipkalo (eksterni prekid INT0)
   - Watchdog timera nakon ~8 sekundi
3. Treptanje LED diode (5 sekundi) kao indikator buđenja.
4. Serijska komunikacija za ispis statusnih poruka.

## 2. Komponente

| Komponenta               | Količina | Pinovi     |
|--------------------------|----------|------------|
| Arduino UNO R3           | 1        | -          |
| LED dioda                | 1        | 8          |
| Tipkalo (pushbutton)     | 1        | 2 (INT0)   |
| 220 otpornik (pull-up)   | 1        | -          |

## 3. Logika rada

1. Mikrokontroler se pokreće i LED treperi 5 sekundi.
2. Uređaj zatim ulazi u sleep mode.
3. Buđenje se događa:
   - kada korisnik pritisne tipkalo (prekid na pinu 2)
   - ili nakon isteka watchdog timera (~8 sekundi).
4. Nakon buđenja, serijski ispis informira korisnika o uzroku buđenja.
5. Ciklus se ponavlja.

## 4. Prioritet događaja buđenja

    # Tipkalo (INT0) > Watchdog Timer

## Funkcionalni zahtjevi

| ID   | Opis zahtjeva |
|------|----------------|
| FR1  | Sustav mora ući u Power Down sleep mod. |
| FR2  | Tipkalo mora probuditi uređaj putem eksternog prekida. |
| FR3  | Watchdog timer mora probuditi uređaj nakon približno 8 sekundi. |
| FR4  | LED dioda mora treperiti 5 sekundi nakon buđenja. |
| FR5  | Sustav mora ispisati informaciju o uzroku buđenja putem serijskog monitora. |

## 5. Pokretanje

1. Otvori projekt u Wokwi simulatoru ili Arduino IDE-u.
2. Uploadaj kod na Arduino UNO.
3. Otvori serijski monitor (baud: 9600).
4. Prati poruke i testiraj buđenje pomoću tipkala ili čekanjem WDT timeouta.

## 6. Licenca

MIT licenca. Projekt je slobodan za korištenje, izmjene i dijeljenje u edukativne svrhe.
