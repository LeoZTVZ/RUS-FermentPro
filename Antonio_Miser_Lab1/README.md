# 🔁 Sustav za upravljanje LED-icama i buzzerom pomoću prekida

Arduino Uno projekt koji demonstrira upravljanje LED-icama i piezo buzzerom koristeći prekide s prioritetima i timerom.

[Poveznica na wokwi projekt](https://wokwi.com/projects/427038709644762113)
---

## 📖 Sadržaj

- [Opis zadatka](#1-opis-zadatka)  
- [Hardverske komponente](#2-hardverske-komponente)  
- [Slika spojeva](#3-slika-spojeva)  
- [Opis rješenja](#4-opis-rješenja)  
    - [Timer Prekid](#41-timer-prekid)
    - [Tablica funkcionalnosti](#42-tablica-funkcionalnosti)
- [Zaključak](#5-zaključak)  

---

## 1. Opis zadatka

Cilj projekta je upravljanje LED-icama i buzzerom koristeći dva tipkala i timer, s fokusom na upotrebu prekida. Projekt koristi:

- 2 tipkala za generiranje prekida (INT0, INT1)
- 3 LED-ice (LED1, LED2, LED3)
- Piezo buzzer s promjenjivom frekvencijom
- Timer1 koji stvara prekid svakih 500 ms
- Arduino Uno mikrokontroler

### Ključna svojstva:

- Tipkala generiraju prekide i mijenjaju stanje LED-ica i buzzera
- Timer1 kontrolira treptanje LED-ice i modulaciju frekvencije buzzera
- Buzzer mijenja frekvenciju u rasponu od 500 Hz do 1500 Hz
- Prekidi se debouncaju i ispisuju poruke putem serijskog monitora

---

## 2. Hardverske komponente

| Komponenta       | Količina | Pin na Arduino Uno         |
|------------------|----------|-----------------------------|
| Arduino Uno      | 1        | -                           |
| Tipkalo 1        | 1        | 2 (INT0)                    |
| Tipkalo 2        | 1        | 3 (INT1)                    |
| LED1 (plava)     | 1        | 10                          |
| LED2 (žuta)      | 1        | 9                           |
| LED3 (zelena)    | 1        | 8                           |
| Piezo buzzer     | 1        | 11                          |
| Otpornici 200Ω   | 3        | -                           |


---

## 3. Slika spojeva

![Image](https://github.com/user-attachments/assets/da3097e8-c63c-4077-b859-45b4b2a5f634)
---

## 4. Opis rješenja

Projekt koristi dvije vanjske tipke povezane na prekide (INT0 i INT1) i Timer1 za automatske radnje svake 0.5 sekunde.

### Funkcionalnost:

- **Tipkalo 1 (INT0)**:
  - Pali LED2 da cijelo vrijeme svijetli
  - Aktivira buzzer s frekvencijom od 500 Hz koja raste do 1500 Hz, pa zatim pada do 500Hz
  - Sve dok je tipkalo pritisnuto, buzzer svira i LED2 ostaje upaljena

- **Tipkalo 2 (INT1)**:
  - Ako tipkalo 1 nije aktivno, pali LED3

- **Timer1 (svakih 500ms)**:
  - Trepće LED1
  - Ako tipkalo 1 nije aktivno, LED2 također trepće
  - Ako je tipkalo 1 aktivno, LED1 i dalje trepće

---

## 4.1. Timer prekid

Timer1 je konfiguriran za CTC mod, prescaler 1024. U OCR1A se postavlja vrijednost 7812 za generiranje prekida svakih 500 ms.

---

## 4.2. Tablica funkcionalnosti

| ID   | Opis funkcionalnosti |
|------|----------------------|
| FR-1 | Upravljanje LED-icama: LED2 (tipkalo 1), LED1 (timer), LED3 (tipkalo 2) |
| FR-2 | Upravljanje buzzerom s promjenjivom frekvencijom |
| FR-3 | Detekcija pritiska na tipkala (INT0, INT1) i promjena stanja |
| FR-4 | Debounce mehanizam za tipkala |
| FR-5 | Timer1 generira prekid svake 0.5 sekunde |
| FR-6 | Serijska komunikacija prikazuje stanja prekida |
| FR-7 | LED1 uvijek trepće kao signal rada sustava |
| FR-8 | Promjena frekvencije buzzera između 500 Hz i 1500 Hz u koracima od 100 Hz |

---

## 5. Zaključak

Ovaj projekt prikazuje kako se mogu koristiti vanjski prekidi i interni tajmeri za upravljanje kompleksnijim sustavima u stvarnom vremenu. Na ovaj način se postiže:

- Neovisno upravljanje komponentama
- Pravovremeni odgovor na korisničke akcije
- Modularnost i skalabilnost sustava
- Praktična primjena teorije upravljanja prekidima

Projekt se može proširiti dodavanjem senzora, LCD ekrana, ili povezivanjem s mobilnom aplikacijom za daljinsko upravljanje.



