--inserare recenzie--
INSERT INTO RECENZIE (recenzie_id, utilizator_id, album_id, rating, comentariu, data_adaugare)
VALUES (seq_recenzie.NEXTVAL, 1, 3, 5, 'Album extraordinar! Damn. este capodoperă.', TO_DATE('2024-05-06', 'YYYY-MM-DD'));

INSERT INTO RECENZIE (recenzie_id, utilizator_id, album_id, rating, comentariu, data_adaugare)
VALUES (seq_recenzie.NEXTVAL, 2, 9, 3, 'Nice!', TO_DATE('2024-05-07', 'YYYY-MM-DD'));

INSERT INTO RECENZIE (recenzie_id, utilizator_id, album_id, rating, comentariu, data_adaugare)
VALUES (seq_recenzie.NEXTVAL, 3, 1, 4, 'Unul dintre cele mai bune albume ale lui Kendrick.', TO_DATE('2024-05-08', 'YYYY-MM-DD'));

INSERT INTO RECENZIE (recenzie_id, utilizator_id, album_id, rating, comentariu, data_adaugare)
VALUES (seq_recenzie.NEXTVAL, 4, 5, 5, 'Vocea lui Taylor Swift este incredibilă. Albumul m-a emoționat profund.', TO_DATE('2024-05-09', 'YYYY-MM-DD'));

INSERT INTO RECENZIE (recenzie_id, utilizator_id, album_id, rating, comentariu, data_adaugare)
VALUES (seq_recenzie.NEXTVAL, 5, 6, 4, 'Daft Punk este un artist complet. Instant Crush este piesa mea preferată.', TO_DATE('2024-05-10', 'YYYY-MM-DD'));

commit;