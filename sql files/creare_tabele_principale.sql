----Crearea tabelelor principale --


CREATE TABLE UTILIZATOR (
    utilizator_id NUMBER PRIMARY KEY,
    nume VARCHAR2(25) NOT NULL,
    prenume VARCHAR2(25) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    parola VARCHAR2(50) NOT NULL,
    telefon NUMBER(15),
    strada VARCHAR2(100),
    numar NUMBER(5),
    oras VARCHAR2(50),
    judet VARCHAR2(50),
    cod_postal NUMBER(20),
    data_inregistrare DATE DEFAULT SYSDATE,
    CONSTRAINT ck_email_format CHECK (email LIKE '%@%.%')
);


CREATE TABLE ARTIST (
    artist_id NUMBER PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL,
    biografie VARCHAR(500)
);


CREATE TABLE GEN_MUZICAL (
    gen_id NUMBER PRIMARY KEY,
    denumire VARCHAR2(25) NOT NULL,
    descriere VARCHAR(100)
);


CREATE  TABLE ALBUM (
    album_id NUMBER PRIMARY KEY,
    titlu VARCHAR2(50) NOT NULL,
    artist_id NUMBER NOT NULL,
    data_lansare DATE,
    pret NUMBER(6,2) NOT NULL,
    stoc NUMBER(5) DEFAULT 0 NOT NULL,
    rating NUMBER(3,2) CHECK (rating BETWEEN 1.00 AND 5.00),
    descriere VARCHAR2(500),
    numar_piese NUMBER(10) NOT NULL,
    format VARCHAR2(50) DEFAULT 'CD',

    CONSTRAINT fk_album_id FOREIGN KEY (artist_id) REFERENCES ARTIST(artist_id),
    CONSTRAINT ck_album_format CHECK ( format IN ('CD','DIGITAL') )
);


CREATE TABLE MELODIE (
    melodie_id NUMBER PRIMARY KEY,
    titlu VARCHAR2(50) NOT NULL,
    album_id NUMBER NOT NULL,
    durata NUMBER(5) NOT NULL,
    pret_individual NUMBER(5,2) NOT NULL,

    CONSTRAINT fk_melodie_album_id FOREIGN KEY (album_id) REFERENCES ALBUM(album_id)
);


CREATE TABLE CD_PERSONALIZAT(
    cd_pers_id NUMBER PRIMARY KEY,
    utilizator_id NUMBER NOT NULL,
    titlu VARCHAR2(50) NOT NULL,
    data_creare DATE NOT NULL,
    pret_total NUMBER(6,2) NOT NULL,
    numar_piese NUMBER NOT NULL,

    CONSTRAINT fk_cd_pers_utilizator  FOREIGN KEY (utilizator_id) REFERENCES UTILIZATOR(utilizator_id),
    CONSTRAINT ck_cd_pers_piese CHECK (numar_piese BETWEEN 5 AND 30)
);


CREATE TABLE COMANDA (
    comanda_id NUMBER PRIMARY KEY,
    utilizator_id NUMBER NOT NULL,
    data_plasare DATE DEFAULT SYSDATE NOT NULL ,
    status VARCHAR2(20) DEFAULT 'Plasată' NOT NULL,
    adresa_livrare VARCHAR(200) NOT NULL,
    metoda_plata VARCHAR2(50) NOT NULL,
    cost_total NUMBER(10,2) NOT NULL,
    cost_transport NUMBER(5,2) NOT NULL,

    CONSTRAINT fk_comanda_utilizator FOREIGN KEY (utilizator_id) REFERENCES UTILIZATOR(utilizator_id),
    CONSTRAINT ck_comanda_status CHECK (status IN ('Plasată', 'Procesată', 'Expediată', 'Livrată', 'Anulată')),
    CONSTRAINT ck_comanda_metoda_plata CHECK (metoda_plata IN ('Card', 'Ramburs','Pe caiet'))
);



CREATE TABLE RECENZIE (
    recenzie_id NUMBER PRIMARY KEY,
    utilizator_id NUMBER NOT NULL,
    album_id NUMBER NOT NULL,
    rating NUMBER(1) NOT NULL,
    comentariu VARCHAR2(200),
    data_adaugare DATE NOT NULL,

    CONSTRAINT fk_recenzie_utilizator FOREIGN KEY (utilizator_id) REFERENCES UTILIZATOR(utilizator_id),
    CONSTRAINT fk_recenzie_album FOREIGN KEY (album_id) REFERENCES ALBUM(album_id),
    CONSTRAINT ck_recenzie_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT u_recenzie UNIQUE (utilizator_id, album_id)
);


CREATE TABLE LOIALITATE (
    loialitate_id NUMBER PRIMARY KEY,
    utilizator_id NUMBER NOT NULL,
    puncte NUMBER(10) DEFAULT 0 NOT NULL,
    nivel VARCHAR2(20) DEFAULT 'Bronz' NOT NULL,
    beneficii VARCHAR2(500),

    CONSTRAINT fk_loialitate_utilizator FOREIGN KEY (utilizator_id) REFERENCES UTILIZATOR(utilizator_id),
    CONSTRAINT ck_loialitate_nivel CHECK (nivel IN ('Bronz', 'Argint', 'Aur', 'Platină')),
    CONSTRAINT u_loialitate UNIQUE (utilizator_id)
);





CREATE TABLE WISHLIST (
    wishlist_id NUMBER PRIMARY KEY,
    utilizator_id NUMBER NOT NULL,

    CONSTRAINT fk_wishlist_utilizator FOREIGN KEY (utilizator_id) REFERENCES UTILIZATOR(utilizator_id),
    CONSTRAINT u_wishlist UNIQUE (utilizator_id)
);




CREATE TABLE EVENIMENT (
    eveniment_id NUMBER PRIMARY KEY,
    nume VARCHAR2(100) NOT NULL,
    data DATE NOT NULL,
    locatie VARCHAR2(100) NOT NULL,
    capacitate NUMBER(10) NOT NULL,
    descriere VARCHAR2(500)
);



CREATE TABLE BILET (
    bilet_id NUMBER PRIMARY KEY,
    eveniment_id NUMBER NOT NULL,
    pret NUMBER(5,2) NOT NULL,
    CONSTRAINT fk_bilet_eveniment FOREIGN KEY (eveniment_id) REFERENCES EVENIMENT(eveniment_id)
);




DROP TABLE ALBUM;
DROP TABLE ARTIST;
DROP TABLE GEN_MUZICAL;
DROP TABLE ALBUM;
DROP TABLE MELODIE;
DROP TABLE CD_PERSONALIZAT;
DROP TABLE COMANDA;
DROP TABLE RECENZIE;
DROP TABLE LOIALITATE;
DROP TABLE WISHLIST;
DROP TABLE EVENIMENT;
DROP TABLE BILET;