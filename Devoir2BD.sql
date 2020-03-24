
----------------------------------------------->BINOME : KERDOUN WALID && AMAHRI LATIFA<------------------------------------------------
set serveroutput on;
-->Question C7

DECLARE
CURSOR c_pilote IS
SELECT nom, sal, comm
FROM pilote
WHERE nopilot BETWEEN 1280 AND 1999 FOR UPDATE;
 v_nom pilote.nom%type;
 v_sal pilote.sal%type;
 v_comm pilote.comm%type;
BEGIN
    open c_pilote;
    loop
        fetch c_pilote into v_nom, v_sal, v_comm;
        exit when c_pilote%NOTFOUND;
        if (v_comm > v_sal) THEN
            update pilote set sal = (v_sal + v_comm), comm = null where current of c_pilote;
        elsif (v_comm is null) THEN
            delete from pilote where current of c_pilote;
        end if;
    end loop;
    close c_pilote;
END;

-->Question C8

------------>Solution 1 sans création de table ERREUR
create or replace procedure p2 (num_pilote varchar2) is
    erreur_insr1 EXCEPTION;
    erreur_insr2 EXCEPTION;
    erreur_insr3 EXCEPTION;
     
    CURSOR c1 IS 
  	SELECT nopilot,sal,comm,nom
    FROM pilote;
    
    vnumpilote pilote.nopilot%type;
    vsal pilote.sal%type;
    vcomm pilote.comm%type;
    vnom pilote.nom%type;
    
begin
    open c1;
        loop
            fetch c1 into vnumpilote,vsal,vcomm,vnom;
            if c1%notfound then
                begin 
                    raise erreur_insr2;
                    exit;
                end;
            end if;
            if(num_pilote = vnumpilote and vcomm > vsal) then 
                raise erreur_insr3;
            end if;
            if(num_pilote = vnumpilote and vcomm < vsal) then 
                raise erreur_insr1;
            end if;
        end loop;
    close c1;
    EXCEPTION
        WHEN erreur_insr1 then
            dbms_output.put_line('Nom Pilote: ' || vnom || ' OK');  
        WHEN erreur_insr2 then
            dbms_output.put_line('PILOTE INCONNUE');
        WHEN erreur_insr3 then
            dbms_output.put_line('Nom Pilote: ' || vnom || ' OK');  
           dbms_output.put_line('Nom Pilote: ' || vnom || ' comm > sal');      
end;

execute p2('13337');


---------------->Solution 2 avec Vréation de table ERREUR
create table ERREUR (
nomPilote varchar2(20),
description varchar2(20));

create or replace procedure p3 (num_pilote varchar2) is
    erreur_insr1 EXCEPTION;
    erreur_insr2 EXCEPTION;
    erreur_insr3 EXCEPTION;
     
    CURSOR c1 IS 
  	SELECT nopilot,sal,comm,nom
    FROM pilote;
    
    vnumpilote pilote.nopilot%type;
    vsal pilote.sal%type;
    vcomm pilote.comm%type;
    vnom pilote.nom%type;
    
begin
    open c1;
        loop
            fetch c1 into vnumpilote,vsal,vcomm,vnom;
            if c1%notfound then
                begin 
                    raise erreur_insr2;
                    exit;
                end;
            end if;
            if(num_pilote = vnumpilote and vcomm > vsal) then 
                raise erreur_insr3;
            end if;
            if(num_pilote = vnumpilote and vcomm < vsal) then 
                raise erreur_insr1;
            end if;
        end loop;
    close c1;
    EXCEPTION
        WHEN erreur_insr1 then
            insert into ERREUR values (num_pilote,'OK');
            dbms_output.put_line('Nom Pilote: ' || vnom || ' OK');  
        WHEN erreur_insr2 then
            insert into ERREUR values (num_pilote,'PILOTE INCONNUE');
            dbms_output.put_line('PILOTE INCONNUE');
        WHEN erreur_insr3 then
            insert into ERREUR values (num_pilote,'OK');
            dbms_output.put_line('Nom Pilote: ' || vnom || ' OK');  
           dbms_output.put_line('Nom Pilote: ' || vnom || ' comm > sal');      
end;

execute p3('1333');

select * from ERREUR;

--Creation des VUES
-->Question D1

create or replace view v_pilote as 
SELECT * FROM pilote WHERE ville = 'PARIS'
WITH READ ONLY;

-->Question D2
-- il est interdit de modifier le salaire des pilotes qui habitent a PARIS car on utilise la clause WITH READ ONLY dans la question D1 qui interdit de MODIFIER ou INSERER ou SUPPRIMER sur la vue v_pilote 

-->Question D3
create or replace view dervol as
select avion,max(date_vol) as derniereDatedeVol from affectation group by avion;

-->Question D4
create or replace view cr_pilote as
select * from pilote where (ville = 'paris' and comm is not null) or (ville != 'paris' and comm is null)
WITH CHECK OPTION;

-->Question D5
create or replace view nomcomm as
select * from pilote where (nopilot in (select pilote from affectation ) and comm is not null ) 
or
(nopilot not in (select pilote from affectation ) and comm is null ) with check option;
select * from nomcomm ;






