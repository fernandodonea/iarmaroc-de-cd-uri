--inserarea datelor in tabela UTILIZATOR--

INSERT INTO UTILIZATOR (utilizator_id, nume, prenume,
                        email, parola, telefon,
                        strada, numar, oras, judet, cod_postal,
                        data_inregistrare)
VALUES (seq_utilizator.NEXTVAL, 'Dan', 'Fernando',
        'fernandodan@gmail.com', 'parolaparola','0767601625',
        'Str. Lalelelor', 23, 'Roman','Neamt',617466,
        TO_DATE('2020-01-15', 'YYYY-MM-DD'));


INSERT INTO UTILIZATOR (utilizator_id, nume, prenume,
                        email, parola, telefon,
                        strada, numar, oras, judet, cod_postal,
                        data_inregistrare)
VALUES (seq_utilizator.NEXTVAL, 'Popescu', 'Vlad',
        'popescuvlad22@outlook.com', 'parola456', '07787617823',
        'Str. Libertății', 15, 'Cluj-Napoca', 'Cluj', 400000,
        TO_DATE('2023-02-22', 'YYYY-MM-DD'));



INSERT INTO UTILIZATOR (utilizator_id, nume, prenume,
                        email, parola, telefon,
                        strada, numar, oras, judet, cod_postal,
                        data_inregistrare)
VALUES (seq_utilizator.NEXTVAL, 'Bejenescu', 'Cosmin',
        'cosmin_beje@yahoo.com', 'parola789', '0745678901',
        'Spl. Independentei', 68, 'Bucuresti', 'Bucuresti', 700000,
        TO_DATE('2021-03-18', 'YYYY-MM-DD'));


INSERT INTO UTILIZATOR (utilizator_id, nume, prenume,
                        email, parola, telefon,
                        strada, numar, oras, judet, cod_postal,
                        data_inregistrare)
VALUES (seq_utilizator.NEXTVAL, 'Tudor', 'Arghezi',
        'tudor_arghezi@gmail.com', 'parola012', '0756789012',
        'Str. Tudor Arghezi', 25, 'Iasi', 'Iasi', 300000,
        TO_DATE('2023-04-05', 'YYYY-MM-DD'));


INSERT INTO UTILIZATOR (utilizator_id, nume, prenume,
                        email, parola, telefon,
                        strada, numar, oras, judet, cod_postal,
                        data_inregistrare)
VALUES (seq_utilizator.NEXTVAL, 'Dumitrescu', 'Andrei',
        'andrei.dumitrescu@gmail.com', 'parola345', '0767890123',
        'Str. Avram Iancu', 30, 'Brașov', 'Brașov', 500000,
        TO_DATE('2023-05-12', 'YYYY-MM-DD'));



