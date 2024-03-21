drop database if exists eval_kiceo;

create database eval_kiceo;

use eval_kiceo;

-- Créer la table des lignes de bus
create table lignes
(
    id        int auto_increment primary key,
    nom_ligne varchar(255) not null
);

-- Créer la table des arrêts de bus
create table arrets
(
    id        int auto_increment primary key,
    nom_arret varchar(255) not null
);

-- Créer la table des horaires
create table horaires
(
    id           int auto_increment primary key,
    id_ligne     int,
    id_arret     int,
    heure_depart time           not null,
    jour         enum ('Lundi') not null,
    foreign key (id_ligne) references lignes (id),
    foreign key (id_arret) references arrets (id)
);

############################################################################################
-- QUESTION 3
-- Ajouter une colonne pour l'arrêt de remplacement dans la table 'arrets'
alter table arrets
    add column arret_remplacement int default null;

-- Ajouter une contrainte de clé étrangère pour 'arret_remplacement' se référant à 'id' dans la même table 'arrets'
alter table arrets
    add constraint fk_arret_remplacement
        foreign key (arret_remplacement) references arrets (id);

############################################################################################
-- QUESTION 10A (10B est dans le fichier queries.sql (ligne 103))
-- Création de la table 'schedule' et de la procédure 'insert_schedule'
create table if not exists schedule
(
    horaire time
);

delimiter //

create procedure insert_schedule(IN time_start time, IN time_end time, IN step time)
begin
    declare current_time_var time;
    set current_time_var = time_start;

    while current_time_var <= time_end do
            insert into schedule (horaire) values (current_time_var);
            set current_time_var = addtime(current_time_var, step);
        end while;
end//

delimiter ;

