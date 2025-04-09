/***************************************************************
 *  
 *  NAZIV DATOTEKE: buzzer_led_timer.ino
 *  
 *  OPIS:
 *  Arduino primjer koji demonstrira korištenje vanjskih prekida 
 *  i Timer1 za upravljanje LED-icama i zvučnikom (buzzerom).
 *  
 *  Program koristi dva gumba s prekidima za upravljanje LED-icama 
 *  i zvučnikom. Timer1 generira periodične prekide za bljeskanje LED-ice 
 *  i promjenu frekvencije zvuka na zvučniku.
 *  
 *  Gumb 1 (pin 2): Uključuje/isključuje led1 i počinje mijenjati 
 *  frekvenciju zvučnika na pinu 11.
 *  
 *  Gumb 2 (pin 3): Upravlja s led3, ali samo kada gumb 1 nije aktivan.
 *  
 *  led2 (pin 10): Bljeska svakih 500 ms preko Timer1.
 *  led1 (pin 9): Uključuje se na pritisak gumba 1, bljeska kada nije aktivan.
 *  Buzzer (pin 11): Reproducira tonove promjenjive frekvencije dok je gumb 1 aktivan.
 *  
 ***************************************************************/


/***************************************************************
 *  
 *  📊 PREGLED KOMPONENTI (TEKSTUALNA SHEMA)
 *  
 *  Komponenta     | Arduino pin | Smjer   | Opis
 *  -------------- | ------------|---------|------------------------------------------
 *  LED1           | 9           | Izlaz   | Kontrolira se gumbom 1 (bljeskanje / ON/OFF)
 *  LED2           | 10          | Izlaz   | Bljeska svakih 500 ms putem Timer1
 *  LED3           | 8           | Izlaz   | Kontrolira se gumbom 2
 *  Zvučnik        | 11          | Izlaz   | Reproducira ton promjenjive frekvencije
 *  Gumb 1         | 2 (INT0)    | Ulaz    | Prekid visoke prioritete
 *  Gumb 2         | 3 (INT1)    | Ulaz    | Prekid niskog prioriteta
 *  
 ***************************************************************/


/***************************************************************
 *  
 *  🔧 DOXYGEN DOKUMENTACIJA (UGRAĐENI KOMENTARI)
 *  
 ***************************************************************/

/**
 * @brief Postavlja načine rada pinova, prekide i Timer1.
 */
void setup();

/**
 * @brief Glavna petlja programa.
 * 
 * Upravljanje LED-icama i zvučnikom ovisno o stanju gumbi.
 */
void loop();

/**
 * @brief ISR za gumb 1 (prekid visokog prioriteta).
 * 
 * Prebacuje stanje varijable button1Pressed s debounce logikom.
 */
void button1ISR();

/**
 * @brief ISR za gumb 2 (prekid niskog prioriteta).
 * 
 * Prebacuje stanje varijable button2Pressed s debounce logikom.
 */
void button2ISR();

/**
 * @brief Postavlja Timer1 da generira prekid svakih 500 ms.
 * 
 * Timer se postavlja u CTC (Clear Timer on Compare Match) način.
 * Preskaler: 1024.
 * Prekid se aktivira na Compare Match A.
 */
void Timer1Setup();

/**
 * @brief ISR za Timer1 Compare Match A prekid.
 * 
 * Toggla led2 svakih 500 ms.
 * Ako je button1Pressed aktivan, mijenja frekvenciju zvučnika 
 * od 500 Hz do 1500 Hz.
 * Kada dosegne 1500 Hz, postavlja zastavicu buzzerLimitReached.
 */
ISR(TIMER1_COMPA_vect);

/**
 * @brief Prebacuje stanje LED-ice na danom pinu.
 * 
 * @param ledPin Broj pina na kojem se nalazi LED-ica.
 */
void toggleLED(int ledPin);
