use eval_kiceo;

############################################################################################
-- Q1A. Horaires à l'arrêt Madelaine le lundi
select heure_depart as "Horaires à l'arrêt Madelaine (Lundi)"
from horaires
         join arrets on horaires.id_arret = arrets.id
            join lignes on horaires.id_ligne = lignes.id
where arrets.nom_arret = 'Madelaine'
  and horaires.jour = 'Lundi' and lignes.id = 1
order by heure_depart;

-- Q1B. Horaires à l'arrêt République le lundi
select heure_depart as "Horaires à l'arrêt République (Lundi)"
from horaires
         join arrets on horaires.id_arret = arrets.id
            join lignes on horaires.id_ligne = lignes.id
where arrets.nom_arret = 'République'
  and horaires.jour = 'Lundi' and lignes.id = 1
order by heure_depart;

############################################################################################
-- Q2. Parcours de la ligne 2 Direction Kersec
select arrets.nom_arret as "Parcours de la ligne 2"
from horaires
         join arrets on horaires.id_arret = arrets.id
where horaires.id_ligne = 1
group by arrets.nom_arret
order by min(horaires.heure_depart);


############################################################################################
-- Q4. Parcours de la ligne 2 Direction Kersec avec les horaires et message d'arrêt temporairement non desservi pour Petit Tohannic
select
    arrets.nom_arret as 'Parcours de la ligne 2 Direction Kersec',
    case
        when arrets.arret_remplacement is not null then 'Arrêt temporairement non desservi. Veuillez vous reporter à l’arrêt Delestraint.'
        else time_format(horaires.heure_depart, '%H:%i:%s')
        end as horaires
from horaires
         join arrets on horaires.id_arret = arrets.id
where horaires.jour = 'Lundi'
order by arrets.id;

############################################################################################
-- QUESTION 5B (5A est dans le fichier data.sql)
-- Q5B. Message d'arrêt temporairement non desservi pour Petit Tohannic en concaténant le message avec le nom de l'arrêt de remplacement dynamiquement
select
    concat('L\'arrêt n\'est pas desservi. Veuillez vous reporter à l\'arrêt ',
           (select nom_arret from arrets where id = (select arret_remplacement from arrets where nom_arret = 'Petit Tohannic'))) as "Horaires à l'arrêt Petit Tohannic (Lundi)"
from arrets
where nom_arret = 'Petit Tohannic'
  and arret_remplacement is not null;

############################################################################################
-- Q7. Afficher le parcours complet des deux lignes dans l'ordre de passage en y mentionnant les arrêts non desservis
select
    l.nom_ligne as "Ligne",
    group_concat(
            case
                when l.nom_ligne = 'Ligne 2 Direction Kersec' and a.arret_remplacement is not null
                    then concat(a.nom_arret, ' (non desservi, reportez-vous à l\'arrêt ', ar.nom_arret, ')')
                when l.nom_ligne = 'Ligne 2 Direction P+R Ouest' and a.arret_remplacement is not null
                    then concat(a.nom_arret, ' (non desservi, reportez-vous à l\'arrêt ', (select nom_arret from arrets where id = a.arret_remplacement - 2), ')')
                else a.nom_arret
                end order by
            case
                when l.nom_ligne = 'Ligne 2 Direction P+R Ouest' then -ha.id_arret
                else ha.id_arret
                end
    ) as "Arrêts desservis"
from
    lignes l
        join (
        select distinct id_ligne, id_arret from horaires
    ) ha on l.id = ha.id_ligne
        join
    arrets a on ha.id_arret = a.id
        left join
    arrets ar on a.arret_remplacement = ar.id
group by
    l.id
order by
    l.id;

############################################################################################
-- QUESTION 10B (10A est dans le fichier schema.sql)
call insert_schedule('06:32:00', '06:41:00', '00:01:00');
-- Q10B. Appel de la procédure stockée insert_schedule
select * from schedule;


