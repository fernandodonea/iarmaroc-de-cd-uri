-- creare tabele asociative

CREATE TABLE ALBUM_GEN_MUZICAL (
    album_id NUMBER,
    gen_id NUMBER,

    PRIMARY KEY (album_id, gen_id),
    FOREIGN KEY (album_id) REFERENCES ALBUM(album_id),
    FOREIGN KEY (gen_id) REFERENCES GEN_MUZICAL(gen_id)
);



CREATE TABLE WISHLIST_ALBUM (
    wishlist_id NUMBER,
    album_id NUMBER,

    PRIMARY KEY (wishlist_id, album_id),
    FOREIGN KEY (wishlist_id) REFERENCES WISHLIST(wishlist_id),
    FOREIGN KEY (album_id) REFERENCES ALBUM(album_id)
);

CREATE TABLE COMANDA_ALBUME (
    comanda_id NUMBER,
    album_id NUMBER,
    cantitate NUMBER(3) DEFAULT 1 NOT NULL,

    PRIMARY KEY (comanda_id, album_id),
    FOREIGN KEY (comanda_id) REFERENCES COMANDA(comanda_id),
    FOREIGN KEY (album_id) REFERENCES ALBUM(album_id)
);


CREATE TABLE PLAYLIST (
    playlist_id NUMBER PRIMARY KEY,
    melodie_id NUMBER NOT NULL,
    cd_pers_id NUMBER NOT NULL,

    FOREIGN KEY (melodie_id) REFERENCES MELODIE(melodie_id),
    FOREIGN KEY (cd_pers_id) REFERENCES CD_PERSONALIZAT(cd_pers_id)
);


CREATE TABLE LINEUP (
    lineup_id NUMBER PRIMARY KEY,
    artist_id NUMBER NOT NULL,
    eveniment_id NUMBER NOT NULL,

    FOREIGN KEY (artist_id) REFERENCES ARTIST(artist_id),
    FOREIGN KEY (eveniment_id) REFERENCES EVENIMENT(eveniment_id),
    CONSTRAINT u_lineup UNIQUE (artist_id, eveniment_id)
);


