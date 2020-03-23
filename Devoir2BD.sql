
----------------------------------------------->BINOME : KERDOUN WALID && AMAHRI LATIFA<------------------------------------------------

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
        update pilote set sal = (v_sal + v_comm), comm = 0 where current of c_pilote;
    elsif (v_comm is null) THEN
        delete from pilote where current of c_pilote;
    end if;
    end loop;
    close c_pilote;
END;

-->Question C8

create or replace procedure p1 (num_pilote varchar2) is
    erreur_insr1 EXCEPTION;
    erreur_insr2 EXCEPTION;
    
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
            exit when c1%notfound;
        
        if(num_pilote = vnumpilote and vsal > vcomm) then 
            raise erreur_insr1;
        end if;
        if (num_pilote != vnumpilote) then
            raise erreur_insr2;
        end if;
        end loop;
    close c1;
        
    EXCEPTION
        WHEN erreur_insr1 then
            dbms_output.put_line('Nom Pilote: ' || vnom || ' OK');
            dbms_output.put_line('Nom Pilote: ' || vnom || ' comm > sal');
        WHEN erreur_insr2 then
            dbms_output.put_line('PILOTE INCONNUE');
end;

execute p1('1333');

--Creation des VUES
-->Question D1

create or replace view v_pilote as 
SELECT * FROM pilote WHERE ville = 'PARIS'
WITH READ ONLY;

-->Question D2
-- il est interdit de modifier le salaire des pilotes qui habitent a PARIS car on utilise la clause WITH READ ONLY qui interdit de MODIFIER ou INSERER ou SUPPRIMER sur la vue v_pilote 

-->Question D3
create or replace view dervol as
select vol,max(date_vol) as derniereDatedeVol from affectation group by vol;

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






