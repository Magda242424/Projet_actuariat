-- ============================================================================
-- PROJET ACTUARIAT : MODÉLISATION DE LA SINISTRALITÉ ROUTIÈRE
-- Script de création de la Vue d'Agrégation Mensuelle et des Ratios Exogènes
-- ============================================================================

CREATE OR REPLACE VIEW accidents_mensuels AS 
SELECT 
    YEAR(accidents_propre.date) AS annee,
    MONTH(accidents_propre.date) AS mois,
    COUNT(0) AS nb_accidents,
    
    -- Calcul du pourcentage d'accidents de nuit
    AVG((CASE WHEN accidents_propre.luminosite LIKE 'Nuit%' THEN 1 ELSE 0 END)) AS pct_nuit,
    
    -- Calcul du pourcentage d'accidents sous météo dégradée
    AVG((CASE WHEN accidents_propre.cond_atmos IN ('Pluie légère', 'Pluie forte', 'Neige / grêle', 'Brouillard / fumée', 'Vent fort / tempête') THEN 1 ELSE 0 END)) AS pct_meteo,
    
    -- Calcul du pourcentage d'accidents en intersection
    AVG((CASE WHEN accidents_propre.lieu IN ('Intersection en T', 'Intersection en X', 'Intersection en Y', 'Intersection à plus de 4 branches', 'Autre intersection') THEN 1 ELSE 0 END)) AS pct_intersection,
    
    -- Calcul du pourcentage d'accidents sur autoroute
    AVG((CASE WHEN accidents_propre.cat_route1 = 'Autoroute' THEN 1 ELSE 0 END)) AS pct_autoroute,
    
    -- Ratios d'implication des usagers vulnérables (Piétons et Deux-roues)
    AVG(accidents_propre.nb_pie) AS pct_pieton,
    AVG(accidents_propre.nb_mot) AS pct_moto

FROM 
    accidents_propre 
WHERE 
    YEAR(accidents_propre.date) >= 2007 
GROUP BY 
    YEAR(accidents_propre.date),
    MONTH(accidents_propre.date) 
ORDER BY 
    annee, 
    mois;
