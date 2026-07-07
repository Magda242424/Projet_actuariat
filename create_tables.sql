-- ============================================================================
-- PROJET ACTUARIAT : MODÉLISATION DE LA SINISTRALITÉ ROUTIÈRE
-- Script de création des tables de données (BAAC)

-- ============================================================================

-- 1. Création de la table brute (Historique des accidents)
CREATE TABLE IF NOT EXISTS `accidents` (
    `date_accident` DATE DEFAULT NULL,
    `luminosite` VARCHAR(37) DEFAULT NULL,
    `cond_atmos` VARCHAR(19) DEFAULT NULL,
    `lieu` VARCHAR(33) DEFAULT NULL,
    `cat_route1` VARCHAR(54) DEFAULT NULL,
    `nb_pie` INT DEFAULT NULL,
    `nb_mot` INT DEFAULT NULL
);

-- 2. Création de la table nettoyée et standardisée (Data Cleaning)
CREATE TABLE IF NOT EXISTS `accidents_propre` (
    `date` DATE DEFAULT NULL,
    `luminosite` VARCHAR(37) DEFAULT NULL,
    `cond_atmos` VARCHAR(19) DEFAULT NULL,
    `lieu` VARCHAR(33) DEFAULT NULL,
    `cat_route1` VARCHAR(20) DEFAULT NULL,
    `nb_pie` INT DEFAULT NULL,
    `nb_mot` INT DEFAULT NULL
);
