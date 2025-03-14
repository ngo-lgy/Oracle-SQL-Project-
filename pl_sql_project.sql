--########################################################## PARTIE SQL ########################################################################

-- SUPPRESSION

drop table possedeAction cascade constraints;
drop table composeDe cascade constraints;
drop table Action cascade constraints;
drop table Region cascade constraints;
drop table possedeFCP cascade constraints;
drop table FCP cascade constraints;
drop table clients cascade constraints;


-- CREATION

create table clients(
numcli varchar2(10) not null
,prenomcli varchar2(50)
,nomcli varchar2(50)
,dateouverturecompte date
,constraint pk_clients_numcli primary key (numcli)

);


create table FCP(
codefcp number(4) not null
,nomfcp varchar2(50)
,datedebut date
,datefin date
,constraint pk_FCP_codefcp primary key (codefcp)
);

create table PossedeFCP(
numcli varchar2(10) not null
,codefcp number(6) not null
,quantitefcp number(7)
,CONSTRAINT PK_PossedeFCP_numcli_codefcp PRIMARY KEY (numCli, codefcp)
,constraint fk_PossedeFCP_clients foreign key(numcli) references clients (numcli)
,constraint fk_PossedeFCP_FCP foreign key(codefcp) references FCP (codefcp)
);

create table Region(
coderegion number(6) not null
,nomregion varchar2(50)
,CONSTRAINT PK_Region_coderegion PRIMARY KEY (coderegion)
);

create table Action(
codeact number(4) not null
,nomact varchar2(50)
,valeurcourante number(8)
,coderegion number(6)
,constraint pk_Action_codeact primary key (codeact)
,constraint fk_Action_Region foreign key(coderegion) references Region (coderegion)

);


create table ComposeDe(
codefcp number(6) not null
,codeact number(4) not null
,quantite number(8)
,prixachat number(7,3)
,constraint pk_ComposeDe_codefcp_codeact primary key (codefcp, codeact)
,constraint fk_ComposeDe_FCP foreign key(codefcp) references FCP (codefcp)
,constraint fk_ComposeDe_Action foreign key(codeact) references Action (codeact)
 
);

create table possedeAction(
numcli varchar2(10) not null
,codeact number(4) not null
,quantite number(8)
,prixachat number(7,3) 
,constraint pk_possedeAction_numcli_codeact primary key (numcli, codeact)
,constraint fk_possedeAction_Action foreign key(codeact) references Action (codeact)
,constraint fk_possedeAction_clients foreign key(numcli) references clients (numcli)
);


-- INSERTION

INSERT INTO clients VALUES(1, 'Pierre',  'Leloup', to_date('22/12/2000','DD/MM/YYYY'));
INSERT INTO clients VALUES(2, 'Paul',    'Durand', to_date('12/01/1998','DD/MM/YYYY'));
INSERT INTO clients VALUES(3, 'Louis',   'Dupont', to_date('15/03/2001','DD/MM/YYYY'));
INSERT INTO clients VALUES(4, 'Jacques', 'Martin', to_date('28/09/2001','DD/MM/YYYY'));
INSERT INTO clients VALUES(5, 'Pierre',  'Perrin', to_date('11/06/2000','DD/MM/YYYY'));
INSERT INTO clients VALUES(6, 'Aurélia',  'Dubois', to_date('13/01/2011','DD/MM/YYYY'));

INSERT INTO Region VALUES(1, 'Europe');
INSERT INTO Region VALUES(2, 'USA');

INSERT INTO Action VALUES(1, 'Alcatel',          5.1,  1);
INSERT INTO Action VALUES(2, 'Snecma',           19.3, 1);
INSERT INTO Action VALUES(3, 'General Electric', 95.6, 2);
INSERT INTO Action VALUES(4, 'BNP',              11.8, 1);
INSERT INTO Action VALUES(5, 'IBM',              21.3, 2);

INSERT INTO FCP 
	VALUES (1, 'MAXITUNE'	, to_date('15/01/2000','DD/MM/YYYY')
							, to_date('14/01/2016','DD/MM/YYYY'));
INSERT INTO FCP 
	VALUES (2, 'PEPERE'		, to_date('28/03/1999','DD/MM/YYYY')
							, to_date('27/03/2015','DD/MM/YYYY'));
INSERT INTO FCP 
	VALUES(3, 'DYNAMIQUE'	, to_date('01/04/2001','DD/MM/YYYY')
							, to_date('31/03/2015','DD/MM/YYYY'));

INSERT INTO possedeAction VALUES(1, 1, 100,   10.1);
INSERT INTO possedeAction VALUES(1, 2, 1000,  5.6);
INSERT INTO possedeAction VALUES(1, 3, 220,   20.5);
INSERT INTO possedeAction VALUES(2, 1, 134,   20);
INSERT INTO possedeAction VALUES(2, 5, 213,   15.3);
INSERT INTO possedeAction VALUES(3, 1, 24434, 18);
INSERT INTO possedeAction VALUES(3, 2, 112,   13.6);
INSERT INTO possedeAction VALUES(3, 4, 6000,  6.1);
INSERT INTO possedeAction VALUES(4, 3, 1000,  80.6);
INSERT INTO possedeAction VALUES(5, 3, 123,   75.1);
INSERT INTO possedeAction VALUES(5, 5, 500,   14.9);
-- INSERT INTO PossedeAction VALUES(6, 2, 100000,   10.3);

INSERT INTO composeDe VALUES (1, 1, 10, 12.7);
INSERT INTO composeDe VALUES (1, 2, 15, 5.2);
INSERT INTO composeDe VALUES (1, 4, 12, 18.4);
INSERT INTO composeDe VALUES (2, 1, 3,  22.1);
INSERT INTO composeDe VALUES (2, 2, 5,  21);
INSERT INTO composeDe VALUES (2, 3, 1,  10);
INSERT INTO composeDe VALUES (2, 4, 20, 12.4);
INSERT INTO composeDe VALUES (3, 3, 12, 68.1);
INSERT INTO composeDe VALUES (3, 5, 5,  15.3);

INSERT INTO possedeFCP VALUES(1, 1, 50);
INSERT INTO possedeFCP VALUES(1, 2, 75);
INSERT INTO possedeFCP VALUES(2, 1, 50);
INSERT INTO possedeFCP VALUES(4, 3, 100);

-- VERIFICATION DU CONTENU DES TABLES

SELECT * FROM clients;

SELECT * FROM Region;

SELECT * FROM Action;

SELECT * FROM FCP;

SELECT * FROM possedeAction;

SELECT * FROM composeDe;

SELECT * FROM possedeFCP;

-- REQUETE


-- 1. Liste des clients (nom et prenom) classés par ordre alphabétique.
select nomcli, prenomcli from clients order by nomcli asc;

-- 2. Liste des actions (code, nom et valeur courante).
select codeact,nomact,valeurcourante from Action;


-- 3. Action la plus chère, la moins chère
-- **** LA PLUS CHERE ****
-- Methode quand on maitrise 
select codeact,nomact,valeurcourante from Action where valeurcourante = (select Max(valeurcourante) from Action);

--Methode directe
select codeact,nomact,Max(valeurcourante) from Action group by codeact,nomact order by Max(valeurcourante) desc fetch first 1 rows only;

-- **** LA MOINS CHERE *****
-- Methode quand on maitrise 
select codeact,nomact,valeurcourante from Action where valeurcourante = (select Min(valeurcourante) from Action);

--Methode directe
select codeact,nomact,Min(valeurcourante) from Action group by codeact,nomact order by Min(valeurcourante) asc fetch first 1 rows only;

-- 4. Liste des actions possédées par Pierre Leloup.
select Action.codeact,nomact,valeurcourante from Action join possedeAction on Action.codeact=possedeAction.codeact
join clients on possedeAction.numcli=clients.numcli where nomcli= 'Leloup' and prenomcli='Pierre';

-- 5. Gain (ou perte) total potentiel sur les actions de Pierre Leloup (valeur courante - prix achat)
-- façon explicite
create or replace view gainactionPL(gaintotalaction) as
select sum(p.quantite*(a.valeurcourante - p.prixachat)) from Action a join possedeAction p on a.codeact=p.codeact
join (select c.numcli from clients c where c.nomcli= 'Leloup' and c.prenomcli='Pierre') srq on p.numcli=srq.numcli  ;
select * from gainactionPL;

-- façon moins explicite
select sum(quantite*(valeurcourante - prixachat)) from Action natural join possedeAction
natural join (select clients.numcli from clients where nomcli= 'Leloup' and prenomcli='Pierre');

-- 6. Gain (ou perte) potentiel par FCP
create or replace view gainfcp(codefcp, gainparfcp) as
select c.codefcp, sum(c.quantite*(a.valeurcourante - c.prixachat)) from Action a join ComposeDe c on a.codeact=c.codeact 
group by c.codefcp;
select * from gainfcp;


-- 7. FCP le plus performant, le moins performant
Drop View   Perffcp;
create or replace view Perffcp(Maxfcp, Minfcp) as
select max(gainparfcp), min(gainparfcp) from gainfcp;
select * from Perffcp;

--autre façon sans utiliser les vues
select max(somme), min(somme) from (
select c.codefcp, sum(c.quantite*(a.valeurcourante - c.prixachat)) somme from Action a join ComposeDe c on a.codeact=c.codeact
group by c.codefcp);

-- exemple de selection et de jointure avec les vues
select codefcp "fcp le plus puissant", gainparfcp from gainfcp join perffcp on gainparfcp=Maxfcp;
select codefcp "fcp le moins puissant", gainparfcp from gainfcp join perffcp on gainparfcp=Minfcp;


-- 8. Performance moyenne des FCP

-- avec les vues
select Round (avg(gainparfcp)) "performance des fcp" from gainfcp;


--sans les vues
select Round(avg(somme)) from (select c.codefcp, sum(c.quantite*(a.valeurcourante - c.prixachat)) somme from Action a join ComposeDe c 
on a.codeact=c.codeact 
group by c.codefcp ) ;

-- 9. Gain (ou perte) total potentiel de Pierre Leloup (actions + FCP)
-- sans les vues
select 
(select sum(p.quantitefcp*(c.quantite*(a.valeurcourante - c.prixachat))) from Action a join ComposeDe c on a.codeact=c.codeact
join possedeFCP p on c.codefcp=p.codefcp join (select numcli from clients cl where cl.nomcli='Leloup' and cl.prenomcli='Pierre') srq
on p.numcli=srq.numcli) +
(select sum(p.quantite*(a.valeurcourante - p.prixachat)) from Action a join possedeAction p on a.codeact=p.codeact
join (select c.numcli from clients c where c.nomcli= 'Leloup' and c.prenomcli='Pierre') srq on p.numcli=srq.numcli) from dual; 

-- autres façon sans les vues
select sum(sommetotal)  from
(select sum(p.quantitefcp*(c.quantite*(a.valeurcourante - c.prixachat))) sommetotal from Action a join ComposeDe c on a.codeact=c.codeact
join possedeFCP p on c.codefcp=p.codefcp join (select numcli from clients cl where cl.nomcli='Leloup' and cl.prenomcli='Pierre') srq
on p.numcli=srq.numcli
union all
select sum(p.quantite*(a.valeurcourante - p.prixachat)) sommetotal from Action a join possedeAction p on a.codeact=p.codeact
join (select c.numcli from clients c where c.nomcli= 'Leloup' and c.prenomcli='Pierre') srq on p.numcli=srq.numcli) ; 

-- autre façon sans les vues 
select sommefcppl + sommeactpl from 
(select sum(p.quantitefcp*(c.quantite*(a.valeurcourante - c.prixachat))) sommefcppl from Action a join ComposeDe c on a.codeact=c.codeact
join possedeFCP p on c.codefcp=p.codefcp join (select numcli from clients cl where cl.nomcli='Leloup' and cl.prenomcli='Pierre') srq
on p.numcli=srq.numcli),
(select sum(p.quantite*(a.valeurcourante - p.prixachat)) sommeactpl from Action a join possedeAction p on a.codeact=p.codeact
join (select c.numcli from clients c where c.nomcli= 'Leloup' and c.prenomcli='Pierre') srq on p.numcli=srq.numcli); 

-- ou toujours sans les vues
-- select sum(p.quantitefcp*(c.quantite*(a.valeurcourante - c.prixachat))) from Action a join ComposeDe c on a.codeact=c.codeact
-- join possedeFCP p on c.codefcp=p.codefcp join clients cl on p.numcli=cl.numcli
-- where cl.nomcli='Leloup' and cl.prenomcli='Pierre';...... 

--en utilisant les vues creer dans les questions précédentes
create or replace view gainfcplp(gainfcpPL) as
select sum(quantitefcp*gainparfcp) from gainfcp natural join possedeFCP natural join 
(select numcli from clients cl where cl.nomcli='Leloup' and cl.prenomcli='Pierre'); 
select gaintotalaction + gainfcpPL from gainactionPL cross join gainfcplp ;

-- 10. Client possédant le plus gros gain potentiel absolu (valeur)
--sans les vues
select numcli, nomcli, prenomcli, sum(somme) somme2 from (
select * from (
-- gain total parfcp par client
select cl.numcli,cl.nomcli, cl.prenomcli, sum(p.quantitefcp*(c.quantite*a.valeurcourante)) somme from Action a join 
ComposeDe c on a.codeact=c.codeact  join possedeFCP p on c.codefcp=p.codefcp join clients cl on p.numcli=cl.numcli
group by cl.numcli,cl.nomcli, cl.prenomcli
union all
-- gain total action par client
select cl.numcli,cl.nomcli, cl.prenomcli, sum(p.quantite*a.valeurcourante) from Action a join possedeAction p on 
a.codeact=p.codeact join clients cl on p.numcli=cl.numcli group by cl.numcli, cl.nomcli, cl.prenomcli 
)
) group by numcli, nomcli, prenomcli
order by somme2 desc fetch first 1 rows only;


--Avec les vues
-- gain total action par client
create or replace view gainactionCL(numcli, gaintotalactioncl) as
select cl.numcli, sum(p.quantite*a.valeurcourante ) from Action a join possedeAction p on a.codeact=p.codeact
join clients cl on p.numcli=cl.numcli group by cl.numcli  ;
select * from gainactionCL;

-- gain total parfcp par client
create or replace view gainFCPWA(codefcp, gaintotalfcpwa) as
select c.codefcp, sum(c.quantite*a.valeurcourante) from Action a join ComposeDe c on a.codeact=c.codeact 
group by c.codefcp;
select * from gainFCPWA;

create or replace view gainFCPCL(numcli, gaintotalfcpcl) as
select numcli, sum(quantitefcp*gaintotalfcpwa) from gainFCPWA natural join possedeFCP 
group by numcli;
select * from gainFCPCL;

-- on somme les gains fcp et action dans une jointure externe
create or replace view gainTTFCPACT(numcli, gainttfcpact) as
select numcli, nvl(gaintotalactioncl ,0) + nvl(gaintotalfcpcl ,0) from gainactionCL natural full outer join gainFCPCL  ;
select * from gainTTFCPACT;

-- on choisi le max, d'où la réponse à la question
select numcli, nomcli, prenomcli, gainttfcpact from gainTTFCPACT natural join clients where gainttfcpact = (select max(gainttfcpact) 
from gainTTFCPACT);


-- 11. Client possédant le plus gros gain potentiel relatif (par rapport à la somme engagée)

--sans les vues
select numcli, nomcli, prenomcli, sum(somme) somme2 from (
select * from (
-- gain total parfcp par client
select cl.numcli,cl.nomcli, cl.prenomcli, sum(p.quantitefcp*(c.quantite*(a.valeurcourante - c.prixachat))) somme from Action a join 
ComposeDe c on a.codeact=c.codeact  join possedeFCP p on c.codefcp=p.codefcp join clients cl on p.numcli=cl.numcli
group by cl.numcli,cl.nomcli, cl.prenomcli
union all
-- gain total action par client
select cl.numcli,cl.nomcli, cl.prenomcli, sum(p.quantite*(a.valeurcourante - p.prixachat)) from Action a join possedeAction p on 
a.codeact=p.codeact join clients cl on p.numcli=cl.numcli group by cl.numcli, cl.nomcli, cl.prenomcli 
)
) group by numcli, nomcli, prenomcli
order by somme2 desc fetch first 1 rows only;


--Avec les vues
-- gain total action par client
create or replace view gainactionCL(numcli, gaintotalactioncl) as
select cl.numcli, sum(p.quantite*(a.valeurcourante - p.prixachat)) from Action a join possedeAction p on a.codeact=p.codeact
join clients cl on p.numcli=cl.numcli group by cl.numcli  ;
select * from gainactionCL;

-- gain total parfcp par client
create or replace view gainFCPCL(numcli, gaintotalfcpcl) as
select numcli, sum(quantitefcp*gainparfcp) from gainfcp natural join possedeFCP 
group by numcli;
select * from gainFCPCL;

-- on somme les gains fcp et action dans une jointure externe
create or replace view gainTTFCPACT(numcli, gainttfcpact) as
select numcli, nvl(gaintotalactioncl ,0) + nvl(gaintotalfcpcl ,0) from gainactionCL natural full outer join gainFCPCL  ;
select * from gainTTFCPACT;

-- on choisi le max, d'où la réponse à la question
select numcli, nomcli, prenomcli, gainttfcpact from gainTTFCPACT natural join clients where gainttfcpact = (select max(gainttfcpact) 
from gainTTFCPACT);

-- 12. Client ayant le meilleur rendement annuel (vis-à-vis de la date d’ouverture de compte)

-- creation d'une vue qui va stocker la durée
create or replace view DUREE(numcli, duree) as
select numcli, to_char(sysdate, 'YYYY') - to_char(dateouverturecompte,'YYYY') from clients;
select * from DUREE;

-- creation d'une vue pour avoir les rendements par clients 
create or replace view RENPARCL(numcli, renparcl) as
select numcli, gainttfcpact/duree from gainTTFCPACT natural join DUREE; --natural join clients;
select * from RENPARCL;

-- creation d'une vue pour obtenir le max des rendements, d'ou la réponse à la question 
create or replace view CLMRD(numcli,nomcli,prenomcli, clmrd) as
select numcli,nomcli, prenomcli, renparcl from RENPARCL natural join clients where renparcl=(select max(renparcl) from RENPARCL);
select * from CLMRD;

--13. Liste des FCP commencés en 2000 
select * from FCP where to_char(datedebut, 'YYYY')='2000';

-- 14. Code et nom du FCP qui se termine le premier.
select * from FCP where datefin <= all (select datefin from fcp);

-- 15. FCP elligible au PEA (comportant uniquement des actions de la région “Europe”)
(select * from FCP)
minus
(select codefcp,nomfcp,datedebut,datefin from FCP natural join composeDe natural join Action natural join 
(select coderegion from Region where nomregion <> 'Europe'));


-- 16. Clients dont toutes valeurs sont elligibles au PEA

--vues des actions à exclures
create or replace view MVACT(codeact,nomact) as
select codeact, nomact from Action natural join (select coderegion from Region where nomregion <> 'Europe');
select * from MVACT;

--vues des FCP à exclure
create or replace view MVFCP (codefcp, nomfcp) as
select codefcp, nomfcp from FCP natural join composeDe natural join Action natural join (select coderegion from Region 
where nomregion <> 'Europe');
select * from MVFCP;


select numcli, nomcli, prenomcli from clients natural join (

(select numcli from possedeAction union select numcli from possedeFCP) 
minus
(select numcli from possedeAction natural join MVACT union select numcli from possedeFCP natural join MVFCP) 

);

-- #######################################################PARTIE PL/SQL###############################################################                                                        

-- #########################################################SOUS PARTIE 1##############################################################
-- ###################################################I-EXERCICES SIMPLES##############################################################

-- 1.Ecrire une procedure qui a partir de l'identifiant d'une région renvoie le nom des actions disponible dans cette region
create or replace procedure afficherActionsRegion(x in number) as
  cursor c is select nomact from Action where coderegion = x;
begin
    for ligne in c loop
        DBMS_OUTPUT.PUT_LINE(ligne.nomact);
    end loop;
end;
/
set serveroutput on;
declare
  region_id number := 1;
begin
  afficherActionsRegion(region_id);
end;
/

-- 2.Ecrire un script qui verifie si des combinaisons (codefcp,codeact) existent plusieurs fois dans la table composeDe 
-- et affiche le nombre d'occurence unique à chaque combinaison;
declare
    cursor c is select codefcp, codeact, count(*) count from composeDe 
    group by codefcp, codeact
    having count(*)>1;
    cpt number := 0;  
begin
    for ligne in c loop
        DBMS_OUTPUT.PUT_LINE(ligne.codefcp || ligne.codeact || ligne.count ); 
        cpt := cpt + 1;
    end loop;
    if cpt !=0 then 
        DBMS_OUTPUT.PUT_LINE('Le nbre de doublons dans la table composeDe est :' || cpt);
    else 
        DBMS_OUTPUT.PUT_LINE('Il n y a pas de doublons dans la table composeDe');
    end if;
end;
/


-- ################################################ SOUS PARTIE 2 ##########################################################################

-- Supposons maintenant qu'on a ajouté à la base de données précédentes une table nommée "mdp" pour "mot de passe" qui va stocker
-- les identifiants et mots de passes des clients.
-- Nous allons constuire une fonction qui rempli automatique la table "mdp" en se servant des attributs de la table clients
-- Dans les faits, la table "mdp" contiendra les attributs suivants : l'attribut identifiant client (idcl), similaire à numcli de la table 
-- clients, 
-- l'attribut "mot de passe client" (motdepassecli), construit en concaténant le numero de client (numcli), le nom du client (nomcli), 
-- la date d'ouverture du compte (dateouverturecompte) et un #. 
-- En bonus et comme c'est juste un exemple fictif, on ajoute un attribut "email client" (emailcli) qui corresponds entre autre à l'email
-- de récupération du mot de passe, il sera formé en concaténant le nom etle prénom du client avec gmail comme extension par défaut.
-- Il y a également un attribut date du jour (datedujour)


drop table mdp;

--creation de la table mdp
create table mdp (
idcl number not null
,motdepassecli varchar(50)
,emailcli varchar(50)
,datedujour date
,constraint pk_mdp_idcl primary key (idcl)
); 

-- creation des fonctions qui construisent le mot de passe et l'adresse email client 

create or replace Function mdpcli(x in number) return varchar2 as 
ligne clients%rowtype;
begin
select * into ligne from clients where numcli=x;
if ligne.numcli <> 0 then return
(ligne.numcli|| ligne.nomcli|| ligne.dateouverturecompte ||'#');
else return -1;
end if; 
end;
/


create or replace Function mailcli(x in number) return varchar2 as 
ligne clients%rowtype;
begin
select * into ligne from clients where numcli=x;
if ligne.numcli != 0 then return
(ligne.nomcli|| ligne.prenomcli||'@gmail.com');
else return -1;
end if; 
end;
/

-- Utilisation des fonctions pour remplir automatiquement la table mdp

declare
  cpt number := 0; 
  cursor c is select * from clients; 
begin
  for ligne in c loop 
    if ligne.numcli != 0 then
      insert into mdp values (ligne.numcli, mdpcli(ligne.numcli),mailcli(ligne.numcli), sysdate);
      cpt := cpt + 1; 
    end if;
  end loop;
    dbms_output.put_line('Nombre de lignes insérées dans la table mdp : ' || cpt); -- Affichage du compteur
end;
/

select * from mdp;

-- ################################################################SOUS PARTIE 3#########################################################
-- ################################################################EXERCICES INTERMEDIAIRES##############################################


-- 1.Ecrire une procedure qui calcul le total des actions d'un client (quantite dans possedeAction)
create or replace procedure nbreactionclient(x in number) as
    nbre_action_total number := 0;
begin
    select sum(quantite) into nbre_action_total from possedeAction
    where numcli=x;
    DBMS_OUTPUT.PUT_LINE('Le nombre d action posseder par le client de numero' || ' ' || x || ' ' || 'est :' || nbre_action_total );
    Exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Le client' || ' ' || x || ' ' || 'ne possède aucune action' ); 
        when others then
            DBMS_OUTPUT.PUT_LINE('une erreur est survenue : '||sqlerrm ); 
end;
/    
   
begin
  nbreactionclient(4);
end;
/

-- 2. Créer une procédure qui augmente de 10% les prix des actions d'une région donnée puis l'utilisée pour augmenter le prix 
-- des actions de la region Europe par exemple
create or replace procedure updateprixaction (x in number) as
begin
    update Action set valeurcourante=valeurcourante + (1/10)*valeurcourante where coderegion=x;
end;
/

begin
    updateprixaction(1);
end;
/
select * from Action; -- verification procedure

-- 3. Ecrire une fonction qui retourne la liste des FCP expirées (dont la date de fin est antérieure à la date actuelle)

create or replace Function FCPexpirees return varchar2 as
resultat varchar2(4000);
    cursor c is select codefcp, nomfcp, datefin from FCP where sysdate > datefin;
begin
    resultat := ' Liste des FCP expiréees : ' || CHR(10);
    for ligne in c loop
    resultat := resultat || 'codefcp :' || ligne.codefcp || ',  nomfcp : ' || ligne.nomfcp || ',  datefin : ' || ligne.datefin || CHR(10);
    end loop;
    if resultat = ' Liste des FCP expiréees : ' || CHR(10) then 
    return 'Aucun FCP expiré';
    else 
    return resultat;
    end if;
end;
/

declare 
liste varchar2(4000);
begin
    liste:= FCPexpirees;
    DBMS_OUTPUT.PUT_LINE(liste);
end;
/

-- #################################################SOUS PARTIE 4#####################################################################
-- #################################################EXERCICES AVANCEES################################################################

-- 1. créez une procédure qui ajoute automatiquement une action non associé à un FCP dans celui possédant le moins d'actions.
-- En d'autres termes : Si une action n'est pas associée à un FCP, l'associée à celui qui a le moins d'action.



create or replace procedure alloueractionFCP as
-- actions non associé à un fcp
    cursor c_actions is select codeact from action natural join (
    (select codeact from Action)
    minus 
    (select codeact from composeDe)
    );  
    fcp_min number;
    nb_actions number := 0;
begin
    --fcp possédant le moins d'action
    select codefcp into fcp_min from (select codefcp, count(codeact) as nombre_actions from composeDe 
    group by codefcp
    order by nombre_actions asc) where rownum=1;
    
    -- association des actions non associées à un fcp au fcp trouvé 
    -- avec un prix d'achat et une quantité arbitraire
    for action in c_actions loop
        insert into composeDe (codefcp, codeact, quantite, prixachat)  
        values (fcp_min, action.codeact, 100, 10.0);
        
        nb_actions := nb_actions + 1;
        
        --affichage du résultat
        DBMS_OUTPUT.PUT_LINE ('Action : ' || action.codeact || ' code FCP : ' || fcp_min);
        end loop;
    
    -- Vérification si aucune action n'était disponible
    if nb_actions = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucune action disponible pour allocation ');
    end if;
    
    exception
      when others then
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
end;
/

begin
alloueractionFCP;
end;
/

-- 2. créez une procédure qui génère un rapport client détaillé pour chaque client .
-- elle devra fournir : le nbre total d'actions possédées par le client, valeur total des actions detenues (quantite * prix), 
-- nombre de FCP dans lesquels il est investi.
-- Les résultats seront stockés dans une table rapport_client, qui servira d'historique.

drop table rapport_client;

create table rapport_client(
numcli varchar2(10) not null
,total_actions number not null
,valeur_total_actions number not null
,nbrefcp number(12,3) not null
);

drop procedure genererrapportclient;

create or replace procedure genererrapportclient as 
begin
    delete from rapport_client;
    insert into rapport_client(numcli, total_actions, valeur_total_actions, nbrefcp)
    select
        p.numcli,
        nvl(sum(p.quantite), 0) as total_actions,
        nvl(sum(p.quantite * a.valeurcourante), 0) as valeur_total_actions,
        nvl(count(distinct pf.codefcp), 0) as nbrefcp
    from possedeAction p join Action a on p.codeact=a.codeact join composeDe c on a.codeact=c.codeact
    join possedeFCP pf on c.codefcp=pf.codefcp
    group by p.numcli;
        
    DBMS_OUTPUT.PUT_LINE('Rapport client généré avec succès.');
end;
/


begin
genererrapportclient;
end;
/

select * from rapport_client;

-- 3. Mettre en place un audit des transactions qui ont lieu sur la table possedeAction
-- Pour cela, ajouter un trigger sur la table possedeActiion pour conserver un historique de chaque modification(insert, update, 
-- delete). Utilisez une nouvelle table audit_possedeAction pour enregistrer les modifications avec la date et le type 
-- d'operation inclu.

-- creation de la table audit_possedeAction pour l'enregistrement des différents audits qui seront réalisés sur 
-- la table possedeAction

create table audit_possedeAction (
    audit_num number generated by default as identity
    ,numcli varchar2(10) not null
    ,codeact number(4) not null
    ,quantite number(8)
    ,prixachat number(7,3)
    ,operation_type varchar2(10) -- "INSERT", "UPDATE" ou "DELETE"
    ,operation_date date default sysdate
    ,constraint pk_audit_possedeAction_audit_num primary key (audit_num)
);


-- creation du trigger qui servira a l'enregistrement des lignes insérées dans la table possedeAction

create or replace trigger trg_audit_possedeAction_insert
after insert on possedeAction
for each row
begin
    insert into audit_possedeAction (numcli, codeact, quantite, prixachat, operation_type)
    values (:new.numcli, :new.codeact, :new.quantite, :new.prixachat, 'insert');
end;
/


-- creation du trigger qui servira a l'enregistrement des lignes de la table mise à jour 

create or replace trigger trg_audit_possedeAction_update
after update of quantite, prixachat on possedeAction 
for each row
begin
    insert into audit_possedeaction (numcli, codeact, quantite, prixachat, operation_type)
    values (:new.numcli, :new.codeact, :new.quantite, :new.prixachat, 'update');
end;    
/    


-- creation du trigger qui servira a l'enregistrement des lignes supprimées de la table possedeAction

create or replace trigger trg_audit_posseAction_delete
after delete on possedeAction
for each row
begin
    insert into audit_possedeAction (numcli, codeAct, quantite, prixachat, operation_type)
    values (:old.numcli, :old.codeact, :old.quantite, :old.prixachat, 'delete');
end;
/



-- vérification de la fonctionnalité effective des triggers crées et de l'enregistrement des modifications associées dans la table 
-- audit_possedeAction
 
 
 -- insertion
 insert into possedeAction(numcli, codeact, quantite, prixachat)
 values(1, 10, 200, 15.0);
 select * from audit_possedeAction where operation_type='insert';


-- mise à jour
update possedeAction
set quantite = 250
where numcli= 1 and codeact=2;
select * from audit_possedeAction where operation_type ='update';


-- suppression
delete from possedeAction where numcli=1 and codeact = 3;
select * from audit_possedeAction where operation_type='delete';

-- voir toutes les modifications ensemble
select * from audit_possedeAction order by operation_date desc;


-- 4. Céer une procedure qui supprime les actions sans possésseurs, c'est à dire celle qui ne sont possédées par
-- aucun client(aucune entrée dans possedeAction)

create or replace procedure suppsansposs as
    cursor c_actions is
    select codeact from (
    select codeact from Action
    minus
    select distinct codeact from possedeAction
    );
    nbre_actions_sans_poss number :=0;
begin   
    for actionss in c_actions loop
        delete from Action where codeact= actionss.codeact;
        nbre_actions_sans_poss := nbre_actions_sans_poss + 1;
    end loop;    
    DBMS_OUTPUT.PUT_LINE('nbre d actions supprimées : ' || nbre_actions_sans_poss );
end;
/

begin
suppsansposs;
end;
/
select * from Action;


-- #################################################SOUS PARTIE 5#####################################################################
-- #################################################EXERCICES TRES AVANCEES################################################################

-- 1. créer une procédure qui génère un portefeuille optiùmal pour chaque client, c'est à dire les actions les plus recommandées
-- pour un client

create or replace function portefeuilleoptimal (x in number, nbreactions in number)
return sys_refcursor as
    v_cursor sys_refcursor;
begin
-- ouverture d'un curseur qui va récupérer les actions les plus rentables du client
    open v_cursor for
    select p.codeact, a.nomact, p.quantite, a.valeurcourante, (a.valeurcourante - p.prixachat)/p.prixachat as rentabilite
    from possedeAction p join Action a on p.codeact=a.codeact
    where p.numcli=x order by rentabilite desc
    fetch first nbreactions rows only;
    return v_cursor;
 end;
 /
    
declare
    v_cursor sys_refcursor;
    v_codeact number;
    v_nomact varchar2(50);
    v_quantite number;
    v_prixaction number;
    v_rentabilite number(4,2);
    
begin
    v_cursor := portefeuilleoptimal(1,3);
    loop
     fetch v_cursor into v_codeact, v_nomact, v_quantite, v_prixaction, v_rentabilite;
     exit when v_cursor%notfound;
     dbms_output.put_line('Action: ' || v_nomact || ' - Rentabilite: ' || v_rentabilite);
    end loop; 
    close v_cursor;
end;    
/

-- 2. calculer la rentabilité des fcp, en ecrivant une fonction qui calcul la rentabilité d'un fcp en fonction 
-- des actions qu'il contient
--


drop table rentabilitefcp;
-- creation de la table pour stocker les rentabilités
create table rentabilitefcp (
    codefcp number(4)
    ,valeur_initiale number(10,5)
    ,valeur_actuelle number(10,5)
    ,rentabilite number(10,5)
    ,statut varchar2(50) --"rentable" ou "Non rentable"
);

create or replace procedure rentabfcp as
begin
    delete from rentabilitefcp;
    
    -- Calcul de la rentabilité de chaque FCP puis insertion dans la table
    insert into rentabilitefcp (codefcp, valeur_initiale, valeur_actuelle, rentabilite, statut)
    select codefcp, 
    nvl(sum(c.quantite * c.prixachat),0) as valeur_initiale, 
    nvl(sum(c.quantite * a.valeurcourante),0) as
    valeur_actuelle,
    case
     when sum(c.quantite * c.prixachat) = 0 Then NULL
     else round (sum(c.quantite * a.valeurcourante) / sum(c.quantite * c.prixachat), 2)
     end as rentabilite,
    case
     when sum(c.quantite * c.prixachat)=0 THEN 'Aucune donnée'
     when sum(c.quantite * a.valeurcourante) > sum(c.quantite * c.prixachat) Then 'Rentable'
     else 'Non rentable'
    end as statut
    from composeDe c join Action a on c.codeact = a.codeact
    group by c.codefcp;
    
    commit;
    dbms_output.put_line('calcul de la rentabilité des fcp terminé.');
end;
/
    
    
begin
    rentabfcp;
end; 
/

select * from rentabilitefcp order by rentabilite desc;



-- 3. Comparaison de portefeuilles entre clients : créer une procédure qui prend deux identifiants de clients en entrée et 
-- compare leurs portefeuilles : total des actions, nombre de fcp communs, valeur totale des portefeuilles.


-- Création de la table comparportf qui stockera les résultats de comparaison
  
drop table comparportf;    
create table comparportf (
    tclient1 number
    ,tclient2 number
    ,tactions_communes number
    ,tvaleur_client1 number
    ,tvaleur_client2 number
    ,tdifference_valeur number
    ,trentabilite_client1 number
    ,trentabilite_client2 number
    ,tavantage varchar2(50)

);

-- comparaoison des portefeuilles
create or replace procedure compportf(numcli1 in number, numcli2 in number) as
    actions_communes number :=0;
    valeur_client1 number :=0;
    valeur_client2 number :=0;
    rentabilite_client1 number :=0;
    rentabilite_client2 number :=0;
    difference_valeur number :=0;
    avantage varchar2(50);
begin
    delete from comparportf where tclient1=numcli1 and tclient2=numcli2;    
    
    -- nbre d'action communes 
    select count(*) into actions_communes from possedeAction p1 join possedeAction p2 on p1.codeact=p2.codeact 
    where p1.numcli=numcli1 and p2.numcli=numcli2;
    
    -- valeur totale du portefeuille des deux clients
    select nvl(sum(p.quantite * a.valeurcourante),0) into valeur_client1
    from possedeAction p join Action a on p.codeact=a.codeact
    where p.numcli=numcli1;
    select nvl(sum(p.quantite * a.valeurcourante),0) into valeur_client2
    from possedeAction p join Action a on p.codeact=a.codeact
    where p.numcli=numcli2;
    
    --rentabilité des portefeuilles
    select
    case when sum(p.quantite * p.prixachat) = 0 Then 0
        else round (sum(p.quantite * a.valeurcourante) / sum(p.quantite * p.prixachat), 2)
    end into rentabilite_client1   
    from possedeAction p join Action a on  p.codeact=a.codeact
    where  p.numcli=numcli1;
    select
    case when sum(p.quantite * p.prixachat) = 0 Then 0
        else round (sum(p.quantite * a.valeurcourante) / sum(p.quantite * p.prixachat), 2)
    end into rentabilite_client2   
    from possedeAction p join Action a on  p.codeact=a.codeact
    where  p.numcli=numcli2;
    -- différence des valeurs
    difference_valeur := valeur_client1 - valeur_client2;
    
    -- client possedant l'avantage
    if rentabilite_client1 > rentabilite_client2 then
      avantage := 'client1';
    elsif rentabilite_client2 > rentabilite_client1 then 
      avantage :='client2';
    else  
      avantage :='Egalite';
    end if;
    -- insertion des résultats dans la table de comparaison
    insert into comparportf(tclient1, tclient2, tactions_communes, tvaleur_client1, tvaleur_client2, tdifference_valeur, trentabilite_client1,
    trentabilite_client2, tavantage) values (numcli1, numcli2, actions_communes, valeur_client1, valeur_client2, difference_valeur,
    rentabilite_client1, rentabilite_client2, avantage);
    
    commit;
    DBMS_OUTPUT.PUT_LINE('Comparaison des portefeuilles terminée.');
end;
/


begin 
compportf(1,2);
end;
/

select * from comparportf;

