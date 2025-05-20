--inserare date cd personalizat--

INSERT INTO CD_PERSONALIZAT (cd_pers_id, utilizator_id, titlu, data_creare, pret_total, numar_piese)
VALUES (seq_cd_pers.NEXTVAL, 1, 'Colecția Mea Rock', TO_DATE('2022-05-10', 'YYYY-MM-DD'), 24.95, 5);

INSERT INTO CD_PERSONALIZAT (cd_pers_id, utilizator_id, titlu, data_creare, pret_total, numar_piese)
VALUES (seq_cd_pers.NEXTVAL, 2, 'Hiturile Vechi', TO_DATE('2023-02-11', 'YYYY-MM-DD'), 29.95, 6);

INSERT INTO CD_PERSONALIZAT (cd_pers_id, utilizator_id, titlu, data_creare, pret_total, numar_piese)
VALUES (seq_cd_pers.NEXTVAL, 3, 'Cele Mai Bune Balade', TO_DATE('2024-1-12', 'YYYY-MM-DD'), 34.95, 7);

INSERT INTO CD_PERSONALIZAT (cd_pers_id, utilizator_id, titlu, data_creare, pret_total, numar_piese)
VALUES (seq_cd_pers.NEXTVAL, 4, 'Pop Mix', TO_DATE('2025-05-01', 'YYYY-MM-DD'), 39.95, 8);

INSERT INTO CD_PERSONALIZAT (cd_pers_id, utilizator_id, titlu, data_creare, pret_total, numar_piese)
VALUES (seq_cd_pers.NEXTVAL, 5, 'Muzica de cartier', TO_DATE('2024-05-14', 'YYYY-MM-DD'), 44.95, 9);