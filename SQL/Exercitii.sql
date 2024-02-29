-- 12

-- Afisati numele si prenumele utilizatorilor care detin cel putin doua jocuri publicate de editorul Electronic Arts sau cel putin trei jocuri publicate de dezvoltatorul Ubisoft Quebec
-- Pentru rezolvare, am folosit o subcerere sincronizata in WHERE care implica 3 tabele
SELECT u.nume, u.prenume
FROM UTILIZATOR u
WHERE 3 = ANY (
                    SELECT COUNT(*)
                    FROM UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp
                    JOIN JOC_VIDEO jv ON(ujvp.cod_joc = jv.cod_joc)
                    JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON(jv.cod_joc = dejv.cod_joc)
                    JOIN DEZVOLTATOR d ON(dejv.cod_editor = d.cod_dezvoltator)
                    WHERE ujvp.cod_utilizator = u.cod_utilizator AND INITCAP(d.nume) = 'Ubisoft Quebec'
              )
OR 2 = ANY (
                    SELECT COUNT(*)
                    FROM UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp
                    JOIN JOC_VIDEO jv ON(ujvp.cod_joc = jv.cod_joc)
                    JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON(jv.cod_joc = dejv.cod_joc)
                    JOIN EDITOR e ON(dejv.cod_editor = e.cod_editor)
                    WHERE ujvp.cod_utilizator = u.cod_utilizator AND INITCAP(e.nume) = 'Electronic Arts'
           );


-- Afisati numele si prenumele utilizatorilor si cat au cheltuit acestia in total pe toate platformele
-- Pentru rezolvare, am folosit o subcerere nesincronizata in clauza FROM
SELECT u.nume, u.prenume, a.total
FROM UTILIZATOR u, 
                    (
                        SELECT cod_utilizator, SUM(pret) total
                        FROM UTILIZATOR_JOC_VIDEO_PLATFORMA
                        GROUP BY cod_utilizator
                    ) a
WHERE u.cod_utilizator = a.cod_utilizator;

-- Afisati numele si prenumele utilizatorilor care detin jocuri de la cel putin 2 dezvoltatori
-- Pentru rezolvare, am folosit grupari de date cu subcereri nesincronizate in care intervin cel putin 3 tabele, functii grup si filtre la nivel de grupuri
SELECT u.nume, u.prenume
FROM (
        SELECT ujvp.cod_utilizator, COUNT(DISTINCT d.nume) nr_dezvoltatori
        FROM UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp
        JOIN JOC_VIDEO jv ON(ujvp.cod_joc = jv.cod_joc)
        JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON(jv.cod_joc = dejv.cod_joc)
        JOIN DEZVOLTATOR d ON(dejv.cod_dezvoltator = d.cod_dezvoltator)
        WHERE pret >= 20
        GROUP BY ujvp.cod_utilizator
     ) temp
JOIN UTILIZATOR u ON(u.cod_utilizator = temp.cod_utilizator)
GROUP BY u.nume, u.prenume, nr_dezvoltatori
HAVING nr_dezvoltatori >= 2;


-- Afisati site-urile dezvoltatorilor (daca nu exista, afisati 'Site in lucru') si al editorilor (daca nu exista, afisati 'Site in lucru') care au publicat jocuri pe platformele Steam si Origin. Se va afisa de asemenea un mesaj informativ daca nu exista ambele site-uri pentru un joc sau daca site-ul este comun. Rezultatul se va afisa in alfabetic, in ordine descrescatoare dupa numele jocului, apoi crescator dupa numele dezvoltatorului si descrescator dupa cel al editorului.
-- Pentru rezolvare, am folosit ordonari, functiile NVL si DECODE si o functie pe siruri de caractere
SELECT jv.nume, DECODE(d.site, NULL, 'Nu exista inca ambele site-uri', e.site, 'Exista un singur site comun', 'Exista ambele site-uri') "Exista site-uri",
       d.nume, NVL(d.site, 'Site in lucru') "Site Dezvoltator", 
       e.nume, NVL(e.site, 'Site in lucru') "Site Editor"
FROM DEZVOLTATOR_EDITOR_JOC_VIDEO dejv
JOIN DEZVOLTATOR d ON(dejv.cod_dezvoltator = d.cod_dezvoltator)
JOIN EDITOR e ON(dejv.cod_editor = e.cod_editor)
JOIN JOC_VIDEO jv ON(dejv.cod_joc = jv.cod_joc)
WHERE dejv.cod_joc IN (
                            SELECT cod_joc
                            FROM UTILIZATOR_JOC_VIDEO_PLATFORMA
                            WHERE cod_platforma IN (
                                                        SELECT cod_platforma
                                                        FROM PLATFORMA
                                                        WHERE INITCAP(nume) IN ('Steam', 'Origin')
                                                  )
                            GROUP BY cod_joc
                       )
ORDER BY 1 DESC, 3, 5 DESC;

-- Afisati urmatoarea zi de duminica pentru fiecare joc aparut inainte de 2020 si urmatoarea zi de miercuri pentru jocurile aparute in 2020 sau dupa. Afisati de asemenea urmatoarea luna si urmatorul an de la data de lansare pentru fiecare joc.
-- Pentru rezolvare, am folosit 1 bloc de cerere (clauza WITH), o functie pe siruri de caractere, 2 functii pe date calendaristice si o expresie CASE
WITH 
URMATOAREA_ZI AS
(
    SELECT nume, data_lansare,
           CONCAT('Urmatoarea duminica: ', TO_CHAR(NEXT_DAY(data_lansare, 'Sunday'), 'DD-MONTH-YYYY')) "Duminica", 
           CONCAT('Urmatoarea miercuri: ', TO_CHAR(NEXT_DAY(data_lansare, 'Wednesday'), 'DD-MONTH-YYYY')) "Miercuri"
    FROM JOC_VIDEO
)
SELECT nume, data_lansare, 
       CASE
            WHEN TO_CHAR(data_lansare, 'YYYY') < '2020' THEN "Duminica"
            ELSE "Miercuri"
       END "Urmatoarea zi",
       ADD_MONTHS(data_lansare, 1) "Urmatoarea luna",
       ADD_MONTHS(data_lansare, 12) "Urmatorul an"
FROM URMATOAREA_ZI;



-- 13
-- Implementarea a trei operatii de actualizare a datelor utilizand subcereri

-- Scumpiti pretul jocurilor cumparate de pe Origin cu 10%
UPDATE UTILIZATOR_JOC_VIDEO_PLATFORMA
SET pret = pret * 1.1
WHERE cod_platforma = (
                            SELECT cod_platforma
                            FROM PLATFORMA
                            WHERE INITCAP(nume) = 'Origin'
                      );

-- Adaugati X la finalul parolelor utilizatorilor care au lungimea parolei mai mica de 12 caractere pana aceastea se incadreaza in lungimea dorita. Aceasta transformare se va aplica utilizatorilor care au mai mult de 2 jocuri in cont pentru a asigura protectia datelor.
UPDATE UTILIZATOR_JOC_VIDEO_PLATFORMA
SET parola = RPAD(parola, 12, 'X')
WHERE LENGTH(parola) < 12 AND cod_utilizator IN (
                                                    SELECT cod_utilizator
                                                    FROM UTILIZATOR_JOC_VIDEO_PLATFORMA
                                                    GROUP BY cod_utilizator
                                                    HAVING COUNT(*) > 2
                                                );

-- Dezvoltatorii si editorii care publica jocuri pe platformele Epic Games si Steam au decis sa ofere o reducere de 25% la DLC-uri pentru utilizatorii care au lasat o recenzie de 3, 4 sau 5 jocului de baza. Actualizati pretul acestora.
UPDATE UTILIZATOR_JOC_VIDEO_PLATFORMA
SET pret = pret * 0.75
WHERE cod_utilizator IN (
                                        SELECT cod_utilizator
                                        FROM RECENZIE
                                        WHERE scor BETWEEN 3 AND 5
                        )
AND cod_platforma IN (
                            SELECT cod_platforma
                            FROM PLATFORMA
                            WHERE INITCAP(nume) IN ('Steam', 'Epic Games')
                     )
AND cod_joc IN (
                    SELECT cod_joc
                    FROM JOC_VIDEO
                    WHERE tip = 'dlc'
               );


-- Implementarea a trei operatii de actualizare a datelor utilizand subcereri

-- Stergeti demo-urile aparute inainte de 2019 de pe Steam si Battle.net.
DELETE FROM UTILIZATOR_JOC_VIDEO_PLATFORMA
WHERE cod_joc IN (
                    SELECT cod_joc
                    FROM JOC_VIDEO
                    WHERE tip = 'demo' AND TO_CHAR(data_lansare, 'YYYY') < '2019'
                 )
AND cod_platforma IN (
                            SELECT cod_platforma
                            FROM PLATFORMA
                            WHERE INITCAP(nume) IN ('Steam', 'Battle.Net')
                     );

-- Stergeti jocurile care nu au nicio categorie.
DELETE FROM DEZVOLTATOR_EDITOR_JOC_VIDEO
WHERE cod_joc NOT IN (
                            SELECT cod_joc
                            FROM JOC_VIDEO_CATEGORIE
                     );
                     
DELETE FROM UTILIZATOR_JOC_VIDEO_PLATFORMA
WHERE cod_joc NOT IN (
                            SELECT cod_joc
                            FROM JOC_VIDEO_CATEGORIE
                     );

DELETE FROM JOC_VIDEO
WHERE cod_joc NOT IN (
                            SELECT cod_joc
                            FROM JOC_VIDEO_CATEGORIE
                     );

-- Stergeti recenziile care nu au niciun comentariu.
DELETE FROM RECENZIE
WHERE (cod_utilizator, cod_joc) NOT IN (
                                            SELECT cod_utilizator_recenzie, cod_joc
                                            FROM COMENTARIU
                                       );


-- 15

-- Afisati numele fiecarui joc, tipul sau si categoriile din care face parte, precum si dezvoltatorul si editorul acestuia si site-urile lor.
-- Outer Join
SELECT jv.nume "Nume Joc", jv.tip "Tip Joc", 
       c.nume "Categorie", 
       d.nume "Nume Dezvoltator", d.site "Site Dezvoltator", 
       e.nume "Nume Editor", e.site "Site Editor"
FROM JOC_VIDEO jv
LEFT JOIN JOC_VIDEO_CATEGORIE jvc ON(jv.cod_joc = jvc.cod_joc)
LEFT JOIN CATEGORIE c ON(jvc.cod_categorie = c.cod_categorie)
FULL JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON(jv.cod_joc = dejv.cod_joc)
FULL JOIN DEZVOLTATOR d ON(dejv.cod_dezvoltator = d.cod_dezvoltator)
FULL JOIN EDITOR e ON(dejv.cod_editor = e.cod_editor)
ORDER BY jv.nume, c.nume;


-- Afisati utilizatorii care au cumparat doar jocuri cu pretul mai mare de 20 de euro. Fiind gratis, demo-urile nu se iau in considerare. Sa se sorteze rezultatul descrescator dupa numele de familie.
-- Division implementat cu MINUS
SELECT u.nume, u.prenume
FROM UTILIZATOR u
JOIN UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp ON(u.cod_utilizator = ujvp.cod_utilizator)
WHERE ujvp.pret >= 20
MINUS
SELECT u.nume, u.prenume
FROM UTILIZATOR u
JOIN UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp ON(u.cod_utilizator = ujvp.cod_utilizator)
JOIN JOC_VIDEO jv ON(ujvp.cod_joc = jv.cod_joc)
WHERE ujvp.pret < 20 AND jv.tip != 'demo'
ORDER BY 1 DESC;


-- Afisati top 3 utilizatori dupa numarul de jocuri detinute. DLC-urile se numara, insa demo-urile nu.
-- Analiza top-n
SELECT nume, prenume, "Nr. Jocuri", rownum
FROM
    (
        SELECT u.nume, u.prenume, COUNT(*) "Nr. Jocuri"
        FROM UTILIZATOR u
        JOIN UTILIZATOR_JOC_VIDEO_PLATFORMA ujvp ON(u.cod_utilizator = ujvp.cod_utilizator)
        JOIN JOC_VIDEO jv ON(ujvp.cod_joc = jv.cod_joc)
        WHERE jv.tip != 'Demo'
        GROUP BY u.nume, u.prenume
        ORDER BY 3 DESC
    )
WHERE rownum <= 3;