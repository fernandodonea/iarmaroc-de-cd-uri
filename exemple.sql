
--------------------------- ex 12--------------------------------


---------------------------Cererea1----------------------------

---Care sunt utilizatorii care au comandat albumele personalizate care includ
--melodii din cele mai multe albume diferite.

WITH albume_per_cd AS (
    SELECT cp.cd_pers_id, cp.utilizator_id, cp.titlu AS titlu_cd,
           COUNT(DISTINCT m.album_id) AS numar_albume_diferite --numaram cate albume diferite sunt in fiecare cd pers
    FROM cd_personalizat cp
    JOIN playlist p ON cp.cd_pers_id = p.cd_pers_id
    JOIN melodie m ON p.melodie_id = m.melodie_id
    GROUP BY cp.cd_pers_id, cp.utilizator_id, cp.titlu --grupam rezultatele dupa cd pers
),--pentru fiecare cd personalizat stim din cate albume diferite contine melodii
max_albume AS (
    SELECT MAX(numar_albume_diferite) AS max_albume_diferite
    FROM albume_per_cd
) --aflam numarul maxim de albume diferite
SELECT u.utilizator_id, u.nume, u.prenume,
       apc.cd_pers_id, apc.titlu_cd, apc.numar_albume_diferite,
       (SELECT COUNT(DISTINCT album_id)
        FROM melodie m
        JOIN playlist p ON m.melodie_id = p.melodie_id
        WHERE p.cd_pers_id = apc.cd_pers_id) AS total_albume
FROM utilizator u
JOIN albume_per_cd apc ON u.utilizator_id = apc.utilizator_id
JOIN max_albume ma ON apc.numar_albume_diferite = ma.max_albume_diferite --filtram doar cd-urile cu nr maxim
ORDER BY u.nume, u.prenume;



--------------------------- Cererea 2--------------------------------

--Pentru fiecare gen muzical sa se afisze numarul de albume comandate
--si numarul de albume incluse In playlisturi.


SELECT gm.gen_id, gm.denumire,
       NVL(albume_comandate.nr_albume, 0) AS numar_albume_comandate, --daca nu gasim albume comandate
       NVL(albume_playlist.nr_albume, 0) AS numar_albume_playlist, -- daca nu gasim albume in playlist-uri
       DECODE(
           SIGN(NVL(albume_comandate.nr_albume, 0) - NVL(albume_playlist.nr_albume, 0)),
           1, 'Mai popular in comenzi',
           0, 'Popularitate egala',
          -1, 'Mai popular In playlisturi'
       ) AS comparatie_popularitate
FROM gen_muzical gm
LEFT JOIN (
    SELECT agm.gen_id, COUNT(DISTINCT ca.album_id) AS nr_albume
    FROM album_gen_muzical agm
    JOIN comanda_albume ca ON agm.album_id = ca.album_id
    GROUP BY agm.gen_id
) albume_comandate ON gm.gen_id = albume_comandate.gen_id --aflam albumele comandantate grupate dupa gen
LEFT JOIN (
    SELECT agm.gen_id, COUNT(DISTINCT m.album_id) AS nr_albume
    FROM album_gen_muzical agm
    JOIN album a ON agm.album_id = a.album_id
    JOIN melodie m ON a.album_id = m.album_id
    JOIN playlist p ON m.melodie_id = p.melodie_id
    GROUP BY agm.gen_id
) albume_playlist ON gm.gen_id = albume_playlist.gen_id --aflam albumele din playlisturi
ORDER BY numar_albume_comandate + numar_albume_playlist DESC;



--------------------------- Cererea 3--------------------------------

--Afisarea artistilor care au albume cu rating-ul mediu mai mare decat media rating-urilor tuturor albumelor,
--alaturi de numarul de albume si numarul de utilizatori care au albume ale artistului In wishlist.

SELECT a.artist_id, a.nume,
       NVL(COUNT(DISTINCT alb.album_id), 0) AS numar_albume, --cate albume are artistul
       AVG(alb.rating) AS rating_mediu, --ratingul mediu al albumelor
       DECODE(COUNT(DISTINCT wa.wishlist_id), 0, 'Niciun wishlist',
              TO_CHAR(COUNT(DISTINCT wa.wishlist_id))) AS numar_wishlist
FROM artist a
LEFT JOIN album alb ON a.artist_id = alb.artist_id
LEFT JOIN (SELECT wa.album_id, w.wishlist_id
           FROM wishlist_album wa
           JOIN wishlist w ON wa.wishlist_id = w.wishlist_id) wa
     ON alb.album_id = wa.album_id
GROUP BY a.artist_id, a.nume
HAVING AVG(alb.rating) > (SELECT AVG(rating) FROM album) --media artistului > media generala a albumelor
ORDER BY rating_mediu DESC, numar_wishlist DESC;



--------------------------- Cererea 4--------------------------------

--Afisarea informatiilor despre comenzi cu detalii despre status, vechime,
-- timpul trecut de la plasare si valoarea totala,
-- analizand cat reprezinta costul transportului din total.


SELECT c.comanda_id,
       UPPER(u.nume) || ' ' || INITCAP(u.prenume) AS client, --initcap litera mare
       TO_CHAR(c.data_plasare, 'DD-MON-YYYY') AS data_plasare,
       ROUND(MONTHS_BETWEEN(SYSDATE, c.data_plasare), 1) AS vechime_luni, --diferenta in luni
       CASE
           WHEN MONTHS_BETWEEN(SYSDATE, c.data_plasare) < 1 THEN 'Comanda recenta'
           WHEN MONTHS_BETWEEN(SYSDATE, c.data_plasare) < 6 THEN 'Comanda din ultimele 6 luni'
           WHEN MONTHS_BETWEEN(SYSDATE, c.data_plasare) < 12 THEN 'Comanda din ultimul an'
           ELSE 'Comanda veche'
       END AS vechime,
       c.status,
       c.cost_total,
       c.cost_transport,
       ROUND((c.cost_transport / c.cost_total) * 100, 2) || '%' AS procent_transport,
       TO_CHAR(ADD_MONTHS(c.data_plasare, 12), 'DD-MON-YYYY') AS data_limita_garantie --adaugam garantie 12 luni de la data plasarii
FROM comanda c
JOIN utilizator u ON c.utilizator_id = u.UTILIZATOR_ID
ORDER BY c.data_plasare DESC;



--------------------------- Cererea 5--------------------------------

--Afisarea artistilor si a evenimentelor lor viitoare,cu numarul total de albume, rating mediu
-- si numarul de fani (utilizatori cu albume ale artistului In wishlist).

WITH artisti_populari AS (
    SELECT a.artist_id, a.nume, COUNT(DISTINCT alb.album_id) AS nr_albume, --cate albume are
           AVG(alb.rating) AS rating_mediu
    FROM artist a
    JOIN album alb ON a.artist_id = alb.artist_id
    GROUP BY a.artist_id, a.nume --o linie dupa artitst
),
fani_artist AS (
    SELECT a.artist_id,
           COUNT(DISTINCT w.utilizator_id) AS nr_fani --cati utilizatori distincti au albumul in wishlist
    FROM artist a
    JOIN album alb ON a.artist_id = alb.artist_id
    JOIN wishlist_album wa ON alb.album_id = wa.album_id
    JOIN wishlist w ON wa.wishlist_id = w.wishlist_id
    GROUP BY a.artist_id
)
SELECT ap.artist_id, ap.nume, ap.nr_albume, ap.rating_mediu,
       NVL(fa.nr_fani, 0) AS numar_fani, --daca nu ar fani
       e.eveniment_id, e.nume AS nume_eveniment, e.data, e.locatie, e.capacitate
FROM artisti_populari ap
LEFT JOIN fani_artist fa ON ap.artist_id = fa.artist_id --ia numarul de fani
JOIN lineup l ON ap.artist_id = l.artist_id
JOIN eveniment e ON l.eveniment_id = e.eveniment_id
ORDER BY e.data, ap.rating_mediu DESC;













---------------------------ex 13--------------------------------

--------------------------- Operatia 1--------------------------------

--Actualizarea rating-ului albumelor pe baza mediei recenziilor

--Descriere: Actualizarea rating-ului pentru toate albumele pentru a reflecta
-- media rating-urilor din recenziile utilizatorilor.


UPDATE album a
SET rating = ( --calculam ratingul mediu
    SELECT AVG(r.rating)
    FROM recenzie r
    WHERE r.album_id = a.album_id
    GROUP BY r.album_id
)
WHERE EXISTS (
    SELECT 1
    FROM recenzie r
    WHERE r.album_id = a.album_id --actualizam doar albumele care au recenzii
);



---------------------------Operatia 2--------------------------------

--Actualizarea nivelului de loialitate pentru utilizatori

--Descriere: Actualizarea nivelului de loialitate pentru utilizatori
-- In functie de numarul total de comenzi plasate si valoarea acestora.


UPDATE loialitate l
SET nivel = (
    CASE
        WHEN (SELECT COUNT(*) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) >= 5
             OR (SELECT SUM(cost_total) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) > 500
        THEN 'Platina'
        WHEN (SELECT COUNT(*) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) >= 3
             OR (SELECT SUM(cost_total) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) > 300
        THEN 'Aur'
        WHEN (SELECT COUNT(*) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) >= 2
             OR (SELECT SUM(cost_total) FROM comanda c WHERE c.utilizator_id = l.utilizator_id) > 150
        THEN 'Argint'
        ELSE 'Bronz'
    END
)
WHERE EXISTS (
    SELECT 1 FROM comanda c WHERE c.utilizator_id = l.utilizator_id
);



---------------------------Operatia 3--------------------------------

-- stergerea melodiilor din CD-urile personalizate pentru care durata totala depaseste un anumit prag

-- Descriere: stergerea melodiilor care au cea mai mica durata din CD-urile personalizate pentru care durata totala a
-- melodiilor depaseste 60 de minute (3600 secunde).

DELETE FROM playlist p
WHERE p.melodie_id IN (
    SELECT m.melodie_id
    FROM playlist p2
    JOIN melodie m ON p2.melodie_id = m.melodie_id
    WHERE p2.cd_pers_id = p.cd_pers_id
    AND m.durata = (
        SELECT MIN(m2.durata)
        FROM playlist p3
        JOIN melodie m2 ON p3.melodie_id = m2.melodie_id
        WHERE p3.cd_pers_id = p.cd_pers_id
    )--gasim melodia cu durata minima
)
AND p.cd_pers_id IN (
    SELECT cd.cd_pers_id
    FROM cd_personalizat cd
    WHERE (
        SELECT SUM(m3.durata)
        FROM playlist p4
        JOIN melodie m3 ON p4.melodie_id = m3.melodie_id
        WHERE p4.cd_pers_id = cd.cd_pers_id
    ) > 3600 --stergem melodii doar din albume cu durata > 1 ora
)
AND ROWNUM = 1; --stergem doar o melodie





---------------------------ex 14--------------------------------

-- Crearea unei unei vizualizari complexe care afiseaza informatii despre
-- utilizatori, comenzile lorsi albumele din wishlist

CREATE OR REPLACE VIEW vizualizare_utilizatori_completa AS
SELECT
    u.utilizator_id,
    u.nume || ' ' || u.prenume AS nume_complet,
    u.email,
    u.oras || ', ' || u.judet AS locatie,
    COUNT(DISTINCT c.comanda_id) AS numar_comenzi,
    NVL(SUM(c.cost_total), 0) AS valoare_totala_comenzi,
    l.nivel AS nivel_loialitate,
    l.puncte AS puncte_loialitate,
    COUNT(DISTINCT wa.album_id) AS albume_in_wishlist,
    COUNT(DISTINCT cp.cd_pers_id) AS cd_personalizate_create,
    ROUND(AVG(r.rating), 2) AS rating_mediu_recenzii,
    COUNT(DISTINCT r.recenzie_id) AS numar_recenzii
FROM utilizator u
LEFT JOIN comanda c ON u.utilizator_id = c.utilizator_id
LEFT JOIN loialitate l ON u.utilizator_id = l.utilizator_id
LEFT JOIN wishlist w ON u.utilizator_id = w.utilizator_id
LEFT JOIN wishlist_album wa ON w.wishlist_id = wa.wishlist_id
LEFT JOIN cd_personalizat cp ON u.utilizator_id = cp.utilizator_id
LEFT JOIN recenzie r ON u.utilizator_id = r.utilizator_id
GROUP BY u.utilizator_id, u.nume, u.prenume, u.email, u.oras, u.judet,
         l.nivel, l.puncte;










--operatie permisa
SELECT nume_complet, nivel_loialitate, numar_comenzi, valoare_totala_comenzi
FROM vizualizare_utilizatori_completa;




--operatie nepermisa
UPDATE vizualizare_utilizatori_completa
SET nivel_loialitate = 'Platina'
WHERE utilizator_id = 1;




---------------------------ex 15--------------------------------


--------------------------- Cererea 1 - OUTER JOIN pe minimum 4 tabele --------------------------------
-- Afisarea tuturor artistilor cu informatii despre ei si evenimentele lor



SELECT
    a.artist_id,
    a.nume AS nume_artist,
    a.biografie,
    e.nume AS nume_eveniment,
    e.data AS data_eveniment,
    e.locatie,
    b.pret AS pret_bilet
FROM artist a
LEFT OUTER JOIN lineup l ON a.artist_id = l.artist_id --outer join  afisam toti artistii, chiar daca nu au evenimente
LEFT OUTER JOIN eveniment e ON l.eveniment_id = e.eveniment_id
LEFT OUTER JOIN bilet b ON e.eveniment_id = b.eveniment_id
ORDER BY a.nume, e.data;




--------------------------- Cererea 2 - Operatia DIVISION --------------------------------
-- Gasirea utilizatorilor care NU au comandat niciun album Hip-Hop


SELECT u.utilizator_id, u.nume, u.prenume
FROM utilizator u
WHERE EXISTS (
    -- verifccam ca utilizatorul sa fi facut macar o comanda
    SELECT 1
    FROM comanda c
    WHERE c.utilizator_id = u.utilizator_id
)
AND NOT EXISTS (
    -- NU trebuie sa existe nicio comanda cu genul albumului hip-hop
    SELECT 1
    FROM comanda c
    JOIN comanda_albume ca ON c.comanda_id = ca.comanda_id
    JOIN album alb ON ca.album_id = alb.album_id
    JOIN album_gen_muzical agm ON alb.album_id = agm.album_id
    JOIN gen_muzical gm ON agm.gen_id = gm.gen_id
    WHERE c.utilizator_id = u.utilizator_id
    AND gm.denumire = 'Hip-Hop'
);


--------------------------- Cererea 3-Analiza TOP-N --------------------------------

-- Top 3 albume cu cele mai mari vanzari

SELECT album_id, titlu, artist, total_vandut
FROM (
    SELECT
        alb.album_id,
        alb.titlu,
        art.nume AS artist,
        SUM(ca.cantitate) AS total_vandut
    FROM album alb
    JOIN artist art ON alb.artist_id = art.artist_id
    JOIN comanda_albume ca ON alb.album_id = ca.album_id
    GROUP BY alb.album_id, alb.titlu, art.nume
    ORDER BY SUM(ca.cantitate) DESC
    --calcualm pentru fiecare album vanzarile
)
WHERE ROWNUM <= 3;


