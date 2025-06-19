--ex 10--

----crearea secventelor----

--secventa utilizator--
CREATE SEQUENCE seq_utilizator
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;




--secventa comanda--
CREATE SEQUENCE seq_comanda
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;




--secventa cd personalizat--
CREATE SEQUENCE seq_cd_pers
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;



--secventa playlist--
CREATE SEQUENCE seq_playlist
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;



--secventa recenzie--
CREATE SEQUENCE seq_recenzie
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;




drop sequence seq_utilizator;
drop sequence seq_comanda;
drop sequence seq_cd_pers;
drop sequence seq_playlist;
drop sequence seq_recenzie;
