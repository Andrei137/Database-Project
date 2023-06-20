-- Ex 10
CREATE SEQUENCE secv_utilizator
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCYCLE;

CREATE SEQUENCE secv_platforma
INCREMENT BY 1
START WITH 1
MAXVALUE 999
NOCYCLE;

CREATE SEQUENCE secv_joc_video
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCYCLE;

CREATE SEQUENCE secv_comentariu
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCYCLE;

CREATE SEQUENCE secv_categorie
INCREMENT BY 1
START WITH 1
MAXVALUE 999
NOCYCLE;

CREATE SEQUENCE secv_dezvoltator
INCREMENT BY 1
START WITH 1
MAXVALUE 99999
NOCYCLE;

CREATE SEQUENCE secv_editor
INCREMENT BY 1
START WITH 1
MAXVALUE 99999
NOCYCLE;


-- Ex 11
-- CREATE
CREATE TABLE UTILIZATOR
(
    cod_utilizator NUMBER(7) constraint pkey_utilizator PRIMARY KEY,
    nume VARCHAR2(30) constraint nume_utilizator NOT NULL,
    prenume VARCHAR2(30) constraint prenume_utilizator NOT NULL,
    parola VARCHAR(30) constraint parola_utilizator NOT NULL,
    email VARCHAR2(30) constraint email_valid CHECK(email LIKE '%@%.%'),
    data_inregistrare DATE DEFAULT SYSDATE
);

CREATE TABLE PLATFORMA
(
    cod_platforma NUMBER(3) constraint pkey_platforma PRIMARY KEY,
    nume VARCHAR2(30) constraint nume_platforma NOT NULL,
    data_lansare DATE,
    site VARCHAR2(50)
);

CREATE TABLE JOC_VIDEO
(
    cod_joc NUMBER(7) constraint pkey_joc_video PRIMARY KEY,
    nume VARCHAR2(50) constraint nume_joc_video NOT NULL,
    data_lansare DATE,
    durata NUMBER(5, 1),
    tip VARCHAR2(4) constraint tip_joc_video CHECK (tip IN ('baza', 'dlc', 'demo'))
);

CREATE TABLE DLC
(
    cod_joc NUMBER(7) constraint pkey_dlc REFERENCES JOC_VIDEO(cod_joc),
    cod_joc_baza NUMBER(7) constraint fkey_joc_dlc REFERENCES JOC_VIDEO(cod_joc),
                           constraint dlc_valid CHECK (cod_joc != cod_joc_baza)
);

CREATE TABLE DEMO
(
    cod_joc NUMBER(7) constraint pkey_demo REFERENCES JOC_VIDEO(cod_joc),
    cod_joc_baza NUMBER(7) constraint fkey_joc_demo REFERENCES JOC_VIDEO(cod_joc),
                           constraint demo_valid CHECK (cod_joc != cod_joc_baza)
);

CREATE TABLE RECENZIE
(
    cod_utilizator NUMBER(7) constraint fkey_recenzie_cod_utilizator REFERENCES UTILIZATOR(cod_utilizator),
    cod_joc NUMBER(7) constraint fkey_recenzie_cod_joc REFERENCES JOC_VIDEO(cod_joc),
    continut VARCHAR2(2000),
    scor NUMBER(1) constraint scor_valid CHECK(scor BETWEEN 1 AND 5),
    data_postare DATE DEFAULT SYSDATE,
    constraint pkey_recenzie PRIMARY KEY(cod_utilizator, cod_joc)
);

CREATE TABLE COMENTARIU
(
    cod_comentariu NUMBER(9) constraint pkey_comentariu PRIMARY KEY,
    cod_utilizator_recenzie NUMBER(7),
    cod_joc NUMBER(7),
    cod_utilizator NUMBER(7) constraint fkey_comentariu_cod_utilizator REFERENCES UTILIZATOR(cod_utilizator),
    continut VARCHAR2(1000) constraint continut_comentariu NOT NULL,
    data_postare DATE DEFAULT SYSDATE,
    constraint fkey_comentariu_recenzie FOREIGN KEY(cod_utilizator_recenzie, cod_joc) REFERENCES RECENZIE(cod_utilizator, cod_joc)
);

CREATE TABLE CATEGORIE
(
    cod_categorie NUMBER(3) constraint pkey_categorie PRIMARY KEY,
    nume VARCHAR2(30) constraint nume_categorie NOT NULL
);

CREATE TABLE DEZVOLTATOR
(
    cod_dezvoltator NUMBER(5) constraint pkey_dezvoltator PRIMARY KEY,
    nume VARCHAR2(30) constraint nume_dezvoltator NOT NULL,
    site VARCHAR2(50),
    data_infiintare DATE
);

CREATE TABLE EDITOR
(
    cod_editor NUMBER(5) constraint pkey_editor PRIMARY KEY,
    nume VARCHAR2(30) constraint nume_editor NOT NULL,
    site VARCHAR2(50),
    data_infiintare DATE
);

CREATE TABLE UTILIZATOR_UTILIZATOR
(
    cod_utilizator NUMBER(7) constraint fkey_urmarire_utilizator1 REFERENCES UTILIZATOR(cod_utilizator),
    cod_utilizator_urmarit NUMBER(7) constraint fkey_urmarire_utilizator2 REFERENCES UTILIZATOR(cod_utilizator),
                                     constraint urmarire_valid CHECK(cod_utilizator != cod_utilizator_urmarit),
    constraint pkey_urmarire PRIMARY KEY(cod_utilizator, cod_utilizator_urmarit)
);

CREATE TABLE JOC_VIDEO_CATEGORIE
(
    cod_joc NUMBER(7) constraint fkey_continut_joc REFERENCES JOC_VIDEO(cod_joc),
    cod_categorie NUMBER(3) constraint fkey_continut_categorie REFERENCES CATEGORIE(cod_categorie),
    constraint pkey_continut PRIMARY KEY(cod_joc, cod_categorie)
);

CREATE TABLE UTILIZATOR_JOC_VIDEO_PLATFORMA
(
    cod_utilizator NUMBER(7) constraint fkey_detine_utilizator REFERENCES UTILIZATOR(cod_utilizator),
    cod_joc NUMBER(7) constraint fkey_detine_joc REFERENCES JOC_VIDEO(cod_joc),
    cod_platforma NUMBER(3) constraint fley_detine_platforma REFERENCES PLATFORMA(cod_platforma),
    cont VARCHAR2(30) constraint cont_platforma NOT NULL,
    parola VARCHAR2(30) constraint parola_platforma NOT NULL,
    pret NUMBER(5, 2) constraint pret_joc NOT NULL,
    constraint pkey_detine PRIMARY KEY(cod_utilizator, cod_joc, cod_platforma)
);

CREATE TABLE DEZVOLTATOR_EDITOR_JOC_VIDEO
(
    cod_joc NUMBER(7) constraint fkey_publica_joc REFERENCES JOC_VIDEO(cod_joc),
    cod_dezvoltator NUMBER(5) constraint fkey_publica_dezvoltator REFERENCES DEZVOLTATOR(cod_dezvoltator),
    cod_editor NUMBER(5) constraint fkey_publica_editor REFERENCES EDITOR(cod_editor),
    constraint pkey_publica PRIMARY KEY(cod_dezvoltator, cod_editor, cod_joc)
);


-- INSERT
-- UTILIZATOR
INSERT INTO UTILIZATOR(cod_utilizator, nume, prenume, parola, email, data_inregistrare)
VALUES (secv_utilizator.NEXTVAL, 'Neculae', 'Andrei', 'parola123', 'andrei.fabian188@gmail.com', '01-JAN-2020');

INSERT INTO UTILIZATOR(cod_utilizator, nume, prenume, parola, email)
VALUES (secv_utilizator.NEXTVAL, 'Buzatu', 'Giulian', '321alorap', 'buzatu.giulian@gmail.com');

INSERT INTO UTILIZATOR(cod_utilizator, nume, prenume, parola, email)
VALUES (secv_utilizator.NEXTVAL, 'Ilie', 'Dumitru', 'parola321', 'ilie.dumitru12@yahoo.com');

INSERT INTO UTILIZATOR(cod_utilizator, nume, prenume, parola, email, data_inregistrare)
VALUES (secv_utilizator.NEXTVAL, 'Popescu', 'Stefan', '123alorap', 'stefan-popescu@s.unibuc.ro', '05-OCT-2021');

INSERT INTO UTILIZATOR(cod_utilizator, nume, prenume, parola, email)
VALUES (secv_utilizator.NEXTVAL, 'Grigore', 'Vlad', '1234567', 'vlad.grigore7@yahoo.com');


-- PLATFORMA
INSERT INTO PLATFORMA
VALUES (secv_platforma.NEXTVAL, 'Steam', '12-SEP-2003', 'https://store.steampowered.com/');

INSERT INTO PLATFORMA
VALUES (secv_platforma.NEXTVAL, 'Epic Games', '04-DEC-2018', 'https://www.epicgames.com/store/en-US/');

INSERT INTO PLATFORMA
VALUES (secv_platforma.NEXTVAL, 'Xbox', '01-AUG-2019', 'https://www.xbox.com/en-US/');

INSERT INTO PLATFORMA
VALUES (secv_platforma.NEXTVAL, 'Battle.net', '31-DEC-1996', 'https://us.shop.battle.net/en-us');

INSERT INTO PLATFORMA
VALUES (secv_platforma.NEXTVAL, 'Origin', '03-JUN-2011', 'https://www.origin.com/');


-- JOC_VIDEO
INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Life is Strange 2', '27-SEP-2018', '16', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Life is Strange 2 Early Access', '16-AUG-2018', '0.5', 'demo');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Life is Strange 2 Episode 1', '27-SEP-2018', '3', 'demo');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Dead Space Remake', '27-JAN-2023', '11', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Dead Space Remake Demo', '27-JAN-2023', '1.5', 'demo');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Alan Wake', '14-MAY-2010', '11', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Alan Wake The Signal', '12-OCT-2010', '1.5', 'dlc');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Alan Wake The Writer', '12-NOV-2010', '1.5', 'dlc');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Assassin''s Creed Syndicate', '23-OCT-2015', '18.5', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Assassin''s Creed Syndicate Jack the Ripper', '15-DEC-2015', '3', 'dlc');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Assassin''s Creed Syndicate The Last Maharaja', '01-MAR-2016', '2.5', 'dlc');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Assassin''s Creed Syndicate The Dreadful Crimes', '11-APR-2016', '3.5', 'dlc');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Tell Me Why', '17-AUG-2020', '9.5', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Tell Me Why Chapter 1', '27-AUG-2020', '3', 'demo');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'World of Warcraft', '23-NOV-2004', '250', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'World of Warcraft Demo', '23-NOV-2004', '30', 'demo');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Need For Speed Unbound', '29-NOV-2022', '23.5', 'baza');

INSERT INTO JOC_VIDEO
VALUES (secv_joc_video.NEXTVAL, 'Pronty', '19-NOV-2021', '7.5', 'baza');


-- DLC
INSERT INTO DLC
VALUES (7, 6);

INSERT INTO DLC
VALUES (8, 6);

INSERT INTO DLC
VALUES (10, 9);

INSERT INTO DLC
VALUES (11, 9);

INSERT INTO DLC
VALUES (12, 9);


-- DEMO
INSERT INTO DEMO
VALUES (2, 1);

INSERT INTO DEMO
VALUES (3, 1);

INSERT INTO DEMO
VALUES (5, 4);

INSERT INTO DEMO
VALUES (14, 13);

INSERT INTO DEMO
VALUES (16, 15);


-- RECENZIE
INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor)
VALUES (1, 6, 'Bun jocul, dar nu e pentru mine.', 3);

INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor, data_postare)
VALUES (4, 4, 'Mi-a placut foarte mult, recomand!', 5, '09-JAN-2023');

INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor)
VALUES (3, 13, 'Acest joc este o dezamagire, nu va pierdeti timpul si banii pe el', 1);

INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor)
VALUES (2, 15, 'Am pierdut prea mult timp in acest joc, mi-am facut foarte multi nervi, 10/10 recomand', 5);

INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor, data_postare)
VALUES (1, 9, 'Jocul este foarte bun, dar este doar pentru persoanele mai rafinate', 4, '01-JUN-2023');

INSERT INTO RECENZIE(cod_utilizator, cod_joc, continut, scor, data_postare)
VALUES (5, 14, 'Un demo excelent, abia astept sa se lanseze jocul complet', 5, '17-AUG-2020');


-- COMENTARIU
INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 1, 6, 2, 'Si mie mi s-a parut bun jocul, 100% il recomand mai departe');

INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 1, 6, 3, 'Nu inteleg de ce nu ti-a placut, mie mi s-a parut un joc foarte bun');

INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 4, 4, 3, 'Personal nu am gasit ceva care sa ma atraga la acest joc, mi s-a parut prea plictisitor');

INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 3, 13, 1, 'Mie nu mi s-a parut o dezamagire, ba din contra, il consider un joc foarte bun, desi inteleg de ce ar putea dezamagi unele persoane'); 

INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 2, 15, 5, 'Si eu am pierdut foarte mult timp in acest joc, nu am simtit efectiv cum trec orele! Foarte buna treaba din partea developerilor!');

INSERT INTO COMENTARIU(cod_comentariu, cod_utilizator_recenzie, cod_joc, cod_utilizator, continut)
VALUES (secv_comentariu.NEXTVAL, 1, 9, 2, 'Nu ma consider o persoana ''rafinata'' si totusi nu mi s-a parut ca jocul ar fi prea slab, dar clar nu este de nota 10');


-- CATEGORIE
INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Actiune');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Aventura');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Science-fiction');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Horror');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Thriller');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Drama');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'MMORPG');

INSERT INTO CATEGORIE
VALUES (secv_categorie.NEXTVAL, 'Curse');


-- DEZVOLTATOR
INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'DONTNOD Entertainment', 'https://dont-nod.com/en/', '01-MAY-2008');

INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'Motive', 'https://www.ea.com/ea-studios/motive', '13-JULY-2015');

INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'Remedy Entertainment', 'https://www.remedygames.com/', '18-AUG-1995');

INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'Ubisoft Quebec', 'https://quebec.ubisoft.com/en/', '27-JUN-2005');

INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'Blizzard Entertainment', 'https://www.blizzard.com/en-us/', '08-FEB-1991');

INSERT INTO DEZVOLTATOR
VALUES (secv_dezvoltator.NEXTVAL, 'Criterion Games', 'https://www.ea.com/ea-studios/criterion-games', '01-JAN-1996');

INSERT INTO DEZVOLTATOR(cod_dezvoltator, nume, site)
VALUES (secv_dezvoltator.NEXTVAL, '18Light Game', 'https://18light.cc/en/');

INSERT INTO DEZVOLTATOR(cod_dezvoltator, nume)
VALUES (secv_dezvoltator.NEXTVAL, 'FunZone Games');


-- EDITOR
INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Square Enix', 'https://square-enix-games.com/en_US/home', '01-APR-2003');

INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Electronic Arts', 'https://www.ea.com/', '27-MAY-1982');

INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Remedy Entertainment', 'https://www.remedygames.com/', '18-AUG-1995');

INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Ubisoft', 'https://www.ubisoft.com/en-us/', '28-MAR-1986');

INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Xbox Game Studios', 'https://www.xbox.com/en-US/xbox-game-studios', '21-MAR-2000');

INSERT INTO EDITOR
VALUES (secv_editor.NEXTVAL, 'Blizzard Entertainment', 'https://www.blizzard.com/en-us/', '08-FEB-1991');

INSERT INTO EDITOR(cod_editor, nume, site)
VALUES (secv_editor.NEXTVAL, '18Light Game', 'https://18light.cc/en/');


-- UTILIZATOR_UTILIZATOR
INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (1, 2);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (1, 3);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (1, 5);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (2, 1);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (2, 3);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (2, 4);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (3, 1);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (3, 2);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (3, 5);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (4, 2);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (5, 1);

INSERT INTO UTILIZATOR_UTILIZATOR
VALUES (5, 4);


-- JOC_VIDEO_CATEGORIE
-- Adaugam categoriile manual la jocurile de baza
INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (1, 2);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (1, 6);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (4, 1);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (4, 2);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (4, 3);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (4, 4);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (6, 1);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (6, 2);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (6, 5);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (6, 6);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (9, 1);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (9, 2);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (13, 2);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (13, 6);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (15, 7);

INSERT INTO JOC_VIDEO_CATEGORIE
VALUES (17, 8);

-- Adaugam aceleasi categorii de la jocul de baza la dlc folosind o cerere
INSERT INTO JOC_VIDEO_CATEGORIE
(
    SELECT d.cod_joc, jvc.cod_categorie
    FROM JOC_VIDEO jv
    JOIN DLC d ON (d.cod_joc_baza = jv.cod_joc)
    JOIN JOC_VIDEO_CATEGORIE jvc ON (d.cod_joc_baza = jvc.cod_joc)
);

-- Adaugam aceleasi categorii de la jocul de baza la demo folosind o cerere
INSERT INTO JOC_VIDEO_CATEGORIE
(
    SELECT d.cod_joc, jvc.cod_categorie
    FROM JOC_VIDEO jv
    JOIN DEMO d ON (d.cod_joc_baza = jv.cod_joc)
    JOIN JOC_VIDEO_CATEGORIE jvc ON (d.cod_joc_baza = jvc.cod_joc)
);


-- UTILIZATOR_JOC_VIDEO_PLATFORMA
INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (2, 1, 1, 'b_giulian', 'buzatu7', '29.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (2, 2, 1, 'b_giulian', 'buzatu7', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (2, 3, 1, 'b_giulian', 'buzatu7', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (5, 3, 1, 'vlad_grigore', 'gri123', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (4, 4, 1, 'pop_stef', 'stefan97', '59.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (4, 5, 1, 'pop_stef', 'stefan97', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 6, 2, 'andrei13', 'Andrei_13', '24.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 7, 2, 'andrei13', 'Andrei_13', '5.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 8, 2, 'andrei13', 'Andrei_13', '5.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (3, 6, 2, 'the_winner', 'sunt_mitica', '19.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 9, 2, 'andrei13', 'Andrei_13', '39.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 10, 2, 'andrei13', 'Andrei_13', '12.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 12, 2, 'andrei13', 'Andrei_13', '9.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (3, 13, 3, 'The_Winner', 'winner62', '14.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (5, 14, 3, 'G_Vlad', 'gri123', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (2, 15, 4, 'BuzGiu', 'Giulian_17', '129.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (4, 16, 4, 'Horhe', 'Stefan_2342', '0');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 17, 5, 'Andrei_13', 'fabian125', '29.99');

INSERT INTO UTILIZATOR_JOC_VIDEO_PLATFORMA
VALUES (1, 18, 1, 'n_andrei13', 'Andrei13', '19.99');


-- DEZVOLTATOR_EDITOR_JOC_VIDEO
-- Adaugam dezvoltatori si editori manual la jocurile de baza
INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (1, 1, 1);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (4, 2, 2);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (6, 3, 3);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (9, 4, 4);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (13, 1, 5);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (15, 5, 6);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (17, 6, 2);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (18, 7, 7);

INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
VALUES (18, 8, 7);

-- Adaugam aceiasi dezvoltatori si aceiasi editori de la jocul de baza la dlc folosind o cerere
INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
(
    SELECT d.cod_joc, dejv.cod_dezvoltator, dejv.cod_editor
    FROM JOC_VIDEO jv
    JOIN DLC d ON (d.cod_joc_baza = jv.cod_joc)
    JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON (d.cod_joc_baza = dejv.cod_joc)
);

-- Adaugam aceiasi dezvoltatori si aceiasi editori de la jocul de baza la demo folosind o cerere
INSERT INTO DEZVOLTATOR_EDITOR_JOC_VIDEO
(
    SELECT d.cod_joc, dejv.cod_dezvoltator, dejv.cod_editor
    FROM JOC_VIDEO jv
    JOIN DEMO d ON (d.cod_joc_baza = jv.cod_joc)
    JOIN DEZVOLTATOR_EDITOR_JOC_VIDEO dejv ON (d.cod_joc_baza = dejv.cod_joc)
);



-- DESC
/*
DESC UTILIZATOR;
DESC PLATFORMA;
DESC JOC_VIDEO;
DESC DLC;
DESC DEMO;
DESC RECENZIE;
DESC COMENTARIU;
DESC CATEGORIE;
DESC DEZVOLTATOR;
DESC EDITOR;
DESC UTILIZATOR_UTILIZATOR;
DESC JOC_VIDEO_CATEGORIE;
DESC UTILIZATOR_JOC_VIDEO_PLATFORMA;
DESC DEZVOLTATOR_EDITOR_JOC_VIDEO;
 */

-- SELECT VALUES
/*
SELECT * FROM UTILIZATOR;
SELECT * FROM PLATFORMA;
SELECT * FROM JOC_VIDEO;
SELECT * FROM DLC;
SELECT * FROM DEMO;
SELECT * FROM RECENZIE;
SELECT * FROM COMENTARIU;
SELECT * FROM CATEGORIE;
SELECT * FROM DEZVOLTATOR;
SELECT * FROM EDITOR;
SELECT * FROM UTILIZATOR_UTILIZATOR;
SELECT * FROM JOC_VIDEO_CATEGORIE;
SELECT * FROM UTILIZATOR_JOC_VIDEO_PLATFORMA;
SELECT * FROM DEZVOLTATOR_EDITOR_JOC_VIDEO;
*/

-- DROP SEQUENCES
/*
DROP SEQUENCE secv_utilizator;
DROP SEQUENCE secv_platforma;
DROP SEQUENCE secv_joc_video;
DROP SEQUENCE secv_comentariu;
DROP SEQUENCE secv_categorie;
DROP SEQUENCE secv_dezvoltator;
DROP SEQUENCE secv_editor;
*/

-- DROP
/*
DROP TABLE UTILIZATOR_UTILIZATOR;
DROP TABLE JOC_VIDEO_CATEGORIE;
DROP TABLE UTILIZATOR_JOC_VIDEO_PLATFORMA;
DROP TABLE DEZVOLTATOR_EDITOR_JOC_VIDEO;
DROP TABLE DLC;
DROP TABLE DEMO;
DROP TABLE COMENTARIU;
DROP TABLE RECENZIE;
DROP TABLE UTILIZATOR;
DROP TABLE PLATFORMA;
DROP TABLE JOC_VIDEO;
DROP TABLE CATEGORIE;
DROP TABLE DEZVOLTATOR;
DROP TABLE EDITOR;
*/

-- DELETE VALUES
/*
DELETE FROM UTILIZATOR_UTILIZATOR;
DELETE FROM JOC_VIDEO_CATEGORIE;
DELETE FROM UTILIZATOR_JOC_VIDEO_PLATFORMA;
DELETE FROM DEZVOLTATOR_EDITOR_JOC_VIDEO;
DELETE FROM DLC;
DELETE FROM DEMO;
DELETE FROM COMENTARIU;
DELETE FROM RECENZIE;
DELETE FROM UTILIZATOR;
DELETE FROM PLATFORMA;
DELETE FROM JOC_VIDEO;
DELETE FROM CATEGORIE;
DELETE FROM DEZVOLTATOR;
DELETE FROM EDITOR;
*/