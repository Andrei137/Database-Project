# Platforma digitala pentru jocuri video

### About

- Jocurile video fac parte din viata unui numar din ce in ce mai mare de oameni. Insa, de-a lungul anilor, odata cu evolutia jocurilor, dar si cu disputele financiare si competitiile dintre diverse mari companii, au aparut din ce in ce mai multe platforme digitale in aceasta industrie, fiecare detinand titlurile sale unice, ce nu pot fi gasite pe alte platforme. Din acest motiv, poate deveni incomod si chiar frustrant pentru utilizatori sa schimbe aplicatia de fiecare data cand doresc sa joace un anumit joc si chiar sa tina minte pe ce platforma se gaseste jocul pe care vor sa il deschida sau sa il cumpere. Aceste lucruri pot duce la o experienta destul de neplacuta ce nu ar trebui sa isi aiba locul in universul jocurilor video. Asadar, consider ca solutia este dezvoltarea unei noi platforme care sa le imbine pe toate celelalte la un loc. Utilizatorii se pot conecta cu fiecare cont in parte is isi pot importa toate librariile intr -un singur loc, pe care il pot configura dupa bunul plac. Astfel, jocurile pot fi accesate prin deschiderea unei singure aplicatii si pot fi gasite printr-o simpla cautare, ceea ce poate salva mult timp si multi nervi.

### Cerinte obligatorii

- [x] 1. Descrierea modelului real, a utilitatii acestuia si a regulilor de functionare.
- [x] 2. Prezentarea constrangerilor (restrictii, reguli) impuse asupra modelului.
- [x] 3. Descrierea entitatilor, incluzand precizarea cheii primare.
- [x] 4. Descrierea relatiilor, incluzand precizarea cardinalitatii acestora.
- [x] 5. Descrierea atributelor, incluzand tipul de date si eventualele constrangeri, valori implicite, valori posibile ale atributelor.
- [x] 6. Realizarea diagramei entitate-relatie corespunzatoare descrierii de la punctele 3-5.
- [x] 7. Realizarea diagramei conceptuale corespunzatoare diagramei entitate-relatie proiectata la punctul 6. Diagrama conceptuala obtinuta trebuie sa contina minimum 6 tabele (fara considerarea subentitatilor), dintre care cel putin un tabel asociativ.
- [x] 8. Enumerarea schemelor relationale corespunzatoare diagramei conceptuale proiectata la punctul 7.
- [x] 9. Realizarea normalizarii pana la forma normala 3 (FN1-FN3).
- [x] 10. Crearea unei secvente ce va fi utilizata in inserarea inregistrarilor in tabele.
- [x] 11. Crearea tabelelor in SQL si inserarea de date coerente in fiecare dintre acestea (minimum 5 inregistrari in fiecare tabel neasociativ; minimum 10 inregistrari in tabelele asociative).

### Cerinte de complexitate

- [x] 12. Formulati in limbaj natural si implementati 5 cereri SQL complexe ce vor utiliza, in ansamblul lor, urmatoarele elemente:
    - subcereri sincronizate in care intervin cel putin 3 tabele
    - subcereri nesincronizate in clauza FROM
    - grupari de date cu subcereri nesincronizate in care intervin cel putin 3 tabele, functii grup, filtrare la nivel de grupuri (in cadrul aceleiasi cereri)
    - ordonari si utilizarea functiilor NVL si DECODE (in cadrul aceleiasi cereri)
    - utilizarea a cel putin 2 functii pe siruri de caractere, 2 functii pe date calendaristice, a cel putin unei expresii CASE
    - utilizarea a cel putin 1 bloc de cerere (clauza WITH)
- [x] 13. Implementarea a 3 operatii de actualizare si 3 operatii de suprimare a datelor utilizand subcereri.
- [ ] 14. Removed
- [x] 15. Formulati in limbaj natural si implementati in SQL: o cerere ce utilizeaza operatia outer-join pe minimum 4 tabele, o cerere ce utilizează operatia division si o cerere care implementează analiza top-n
- [ ] 16. Optimizarea unei cereri, aplicand regulile de optimizare ce deriva din proprietatile operatorilor algebrei relationale. Cererea va fi exprimata prin expresie algebrica, arbore algebric si limbaj (SQL), atat anterior cat si ulterior optimizarii.
- [ ] 17. Realizarea normalizarii BCNF, FN4, FN5. Aplicarea denormalizarii, justificand necesitatea acesteia.