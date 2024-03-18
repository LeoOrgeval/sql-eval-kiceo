use eval_kiceo;

-- Insertion des données dans la table 'lignes'
insert into lignes (id, nom_ligne)
values (1, 'Ligne 2 Direction Kersec');

-- Insertion des données dans la table 'arrets'
-- Assurez-vous d'ajuster les noms des arrêts selon vos besoins
insert into arrets (id, nom_arret)
values (1, 'P+R Ouest'),
       (2, 'Fourchêne 1'),
       (3, 'Madelaine'),
       (4, 'République'),
       (5, 'PIBS 2'),
       (6, 'Petit Tohannic'),
       (7, 'Delestraint'),
       (8, 'Kersec');

-- Insérer des horaires pour les arrêts de la Ligne 2
insert into horaires (id_ligne, id_arret, heure_depart, jour)
values
    -- Horaires pour l'arrêt 'P+R Ouest' (ID 1)
    (1, 1, '06:32:00', 'Lundi'),
    (1, 1, '06:42:00', 'Lundi'),
    (1, 1, '06:52:00', 'Lundi'),
    (1, 1, '07:00:00', 'Lundi'),
    (1, 1, '07:10:00', 'Lundi'),

    -- Horaires pour l'arrêt 'Fourchene 1' (ID 2)
    (1, 2, '06:34:00', 'Lundi'),
    (1, 2, '06:44:00', 'Lundi'),
    (1, 2, '06:54:00', 'Lundi'),
    (1, 2, '07:02:00', 'Lundi'),
    (1, 2, '07:12:00', 'Lundi'),

    -- Horaires pour l'arrêt 'Madelaine' (ID 3)
    (1, 3, '06:37:00', 'Lundi'),
    (1, 3, '06:47:00', 'Lundi'),
    (1, 3, '06:57:00', 'Lundi'),
    (1, 3, '07:06:00', 'Lundi'),
    (1, 3, '07:16:00', 'Lundi'),

    -- Horaires pour l'arrêt 'République' (ID 4)
    (1, 4, '06:42:00', 'Lundi'),
    (1, 4, '06:52:00', 'Lundi'),
    (1, 4, '07:02:00', 'Lundi'),
    (1, 4, '07:12:00', 'Lundi'),
    (1, 4, '07:22:00', 'Lundi'),

    -- Horaires pour l'arrêt 'PIBS 2' (ID 5)
    (1, 5, '06:46:00', 'Lundi'),
    (1, 5, '06:56:00', 'Lundi'),
    (1, 5, '07:07:00', 'Lundi'),
    (1, 5, '07:17:00', 'Lundi'),
    (1, 5, '07:27:00', 'Lundi'),

    -- Horaires pour l'arrêt 'Petit Tohannic' (ID 6)
    (1, 6, '06:50:00', 'Lundi'),
    (1, 6, '07:00:00', 'Lundi'),
    (1, 6, '07:11:00', 'Lundi'),
    (1, 6, '07:21:00', 'Lundi'),
    (1, 6, '07:31:00', 'Lundi'),

    -- Horaires pour l'arrêt 'Delestraint' (ID 7)
    (1, 7, '06:51:00', 'Lundi'),
    (1, 7, '07:01:00', 'Lundi'),
    (1, 7, '07:12:00', 'Lundi'),
    (1, 7, '07:22:00', 'Lundi'),
    (1, 7, '07:32:00', 'Lundi'),

    -- Horaires pour l'arrêt 'Kersec' (ID 8)
    (1, 8, '06:55:00', 'Lundi'),
    (1, 8, '07:05:00', 'Lundi'),
    (1, 8, '07:16:00', 'Lundi'),
    (1, 8, '07:26:00', 'Lundi'),
    (1, 8, '07:36:00', 'Lundi');

############################################################################################
-- QUESTION 5A (5B est dans le fichier queries.sql)
-- Mettre à jour l'arrêt 'Petit Tohannic' avec l'arrêt de remplacement 'Delestraint'
update arrets
set arret_remplacement = 7  -- ID de 'Delestraint'
where id = 6;  -- ID de 'Petit Tohannic'

############################################################################################
-- QUESTION 6
-- Parcours de la ligne 2 Direction P+R Ouest avec les horaires
-- et message d'arrêt temporairement non desservi pour Petit Tohannic (Un passage de bus)
insert into lignes (nom_ligne) values ('Ligne 2 Direction P+R Ouest');
-- Calcul des horaires inversés pour la ligne 2
insert into horaires (id_ligne, id_arret, heure_depart, jour)
select
    (select max(id) from lignes) as id_ligne_inversée,
    a_inverse.id,
    h_inverse.heure_depart,
    h_inverse.jour
from
    (select id, (select max(id) from arrets) - id + 1 as id_arret_inverse from arrets) as a_inverse
        join
    (select id_arret, min(heure_depart) as heure_depart, jour from horaires where id_ligne = 1 and jour = 'Lundi' group by id_arret) as h_inverse
    on a_inverse.id_arret_inverse = h_inverse.id_arret;
