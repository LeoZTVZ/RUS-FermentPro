# 🔁 Prikaz upravljanja potrošnjom energije i sleep mode

Projekt koji demonstrira korištenje spavanja na **Arduino Uno** i buđenje pomoću vanjskog prekida (tipkalo) i **Watchdog Timera**. LED dioda blinka tijekom 5 sekundi, nakon čega Arduino prelazi u **sleep mode** kako bi se uštedjela energija. Mikrokontroler se može probuditi pomoću vanjskog prekida (tipkalo) ili pomoću **Watchdog timera**.

[Poveznica na wokwi projekt](https://wokwi.com/projects/427691329617498113)
---

## 📖 Sadržaj
- [Opis zadatka](#1-opis-zadatka)
- [Hardverske komponente](#2-hardverske-komponente)
- [Slika spojeva](#3-slika-spojeva)
- [Opis rješenja](#4-opis-rješenja)
  - [Aktivni period](#41-aktivni-period)
  - [Spavanje](#42-spavanje)
  - [Buđenje](#43-buđenje)
  - [Tablica funkcionalnosti](#44-tablica-funkcionalnosti)
- [Zaključak](#5-zaključak)

## 1. Opis zadatka
Cilj ovog projekta je pokazati kako se koristi **sleep mode** za uštedu energije na **Arduino Uno** mikrokontroleru, s mogućnošću buđenja putem **prekida (tipkalo)** ili pomoću **Watchdog timera**. Projekt uključuje:
- LED diodu koja trepće tijekom 5 sekundi
- Prekide za buđenje Arduino mikrokontrolera
- **Watchdog timer** koji buđenje generira svakih 4 sekunde
- Serijsku komunikaciju za praćenje vremena spavanja i buđenja

### Ključna svojstva:
- **LED dioda** trepće 5 sekundi, nakon čega Arduino prelazi u **sleep mode**.
- **Prekidi** omogućuju buđenje mikrokontrolera (tipkalo na pin 2).
- **Watchdog timer** buđenje nakon 4 sekunde.
- **Serijska komunikacija** prikazuje poruke vezane uz spavanje i buđenje.

## 2. Hardverske komponente

| Komponenta      | Količina | Pin na Arduino Uno |
|-----------------|----------|--------------------|
| Arduino Uno     | 1        | -                  |
| LED dioda       | 1        | 13                 |
| Tipkalo         | 1        | 2 (INT0)           |
| Otpornici 200Ω  | 1        | -                  |

## 3. Slika spojeva
![Image](https://github.com/user-attachments/assets/ccdb0726-b31c-4b04-bcad-2766b9d433c5)


## 4. Opis rješenja

Projekt koristi **Arduino Uno** s tri glavne funkcionalnosti:

### 4.1. Aktivni period
- LED dioda trepće 5 sekundi (2 puta po sekundi, svaki put trajanje 500 ms).
- Tijekom tih 5 sekundi, serijska komunikacija ispisuje koliko sekundi je prošlo.

### 4.2. Spavanje
- Nakon završetka treptanja, Arduino ide u **sleep mode** kako bi uštedio energiju.
- U **sleep mode**, sve funkcije mikrokontrolera su onemogućene osim onih vezanih uz prekide (tipkalo i watchdog timer).

### 4.3. Buđenje
- **Tipkalo**: Kada pritisnete tipkalo povezano na pin 2, Arduino se budi i ispisuje poruku na serijskom monitoru.
- **Watchdog Timer**: Nakon otprilike 4 sekunde, watchdog timer generira prekid i budi mikrokontroler.

### 4.4. Tablica funkcionalnosti

| ID   | Opis funkcionalnosti |
|------|----------------------|
| FR-1 | LED dioda trepće 5 sekundi (2 puta po sekundi, 500 ms ON, 500 ms OFF) |
| FR-2 | Prelazak u sleep mode nakon što LED dioda prestane treptati |
| FR-3 | Detekcija pritiska na tipkalo povezano na pin 2 (INT0) za buđenje iz sleep mode-a |
| FR-4 | Korištenje Watchdog timera za generiranje prekida svakih 4 sekunde i buđenje iz sleep mode-a |
| FR-5 | Serijska komunikacija ispisuje broj sekundi prošlih od početka treptanja LED diode |
| FR-6 | Serijska komunikacija ispisuje poruku kada Arduino pređe u sleep mode |
| FR-7 | Serijska komunikacija ispisuje poruke kada se Arduino budi putem tipkala ili Watchdog timera |
| FR-8 | Efikasna ušteda energije korištenjem sleep mode-a za smanjenje potrošnje kada uređaj nije aktivan |

## 5. Zaključak
Ovaj projekt demonstrira osnovne tehnike upravljanja potrošnjom energije pomoću **sleep mode** i prekida. Korištenjem vanjskih prekida (tipkalo) i Watchdog timera, omogućeno je efikasno upravljanje energijom dok se istovremeno održava funkcionalnost uređaja. 

Ovaj projekt može poslužiti kao temelj za daljnje istraživanje načina uštede energije u aplikacijama koje koriste **Arduino**. Daljnje proširenje projekta može uključivati dodavanje drugih senzora, daljinsko upravljanje ili integraciju s mobilnim uređajem.

---
