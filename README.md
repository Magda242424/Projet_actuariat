# Modélisation de la Sinistralité Routière - SARIMAX (Hauts-de-Seine)

Ce projet d'actuariat présente une chaîne complète de traitement, d'analyse exploratoire (EDA) et de modélisation prédictive du nombre mensuel d'accidents corporels dans le département des Hauts-de-Seine (92).

---

##  Sources des Données & Documentation

Le jeu de données final est issu du croisement de plusieurs sources officielles de service public :

1. **Données Historiques (2006 - 2021) :**
   * [Data.gouv.fr - Accidents corporels de la circulation routière](https://www.data.gouv.fr/datasets/accidents-corporels-de-la-circulation-routiere)
   * [Data.gouv.fr - Bases de données annuelles de 2005 à nos jours](https://www.data.gouv.fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2024)
2. **Données de Validation Externe (Année 2022 complète) :**
   * Les données mensuelles réelles de l'année 2022 de validation ont été extraites du **Baromètre de la Sécurité Routière du mois de décembre 2022 (DRIEAT Île-de-France)**, publié par la Préfecture de la Région d'Île-de-France.
   * *Exemples de données réelles intégrées (Bilan 2022)* : Janvier = 162, Mai = 262, Juin = 276, Août = 127, Décembre = 204 accidents (Total annuel : 2 519 accidents corporels).
3. **Nomenclature & Méthodologie :**
   * Les règles métiers, l'organisation et la sémantique des variables proviennent des manuels méthodologiques de l'**ONISR (Observatoire National Interministériel de la Sécurité Routière)**.

---

##  Architecture des Données (MySQL)

Les données de la BAAC sont stockées et pré-agrégées dans une base de données MySQL nommée `projet_actuariat`.
* `accidents` / `accidents_propre` : Données brutes et nettoyées au niveau individuel.
* `accidents_mensuels` : Vue SQL calculant dynamiquement les agrégats mensuels (`nb_accidents`) et les indicateurs de structure (`pct_moto`, `pct_nuit`, `pct_meteo`, etc.).

---

##  Démarche Statistique & Modélisation

* **Analyse de la stationnarité :** Traitement de la rupture structurelle liée aux confinements (2020) et application d'une double différenciation $(d=1, D=1)_{12}$ validée par les tests ADF, KPSS et l'analyse des fonctions ACF/PACF.
* **Sélection des variables exogènes :** Évaluation de la multicolinéarité via le calcul du VIF (maximum mesuré à 2,39) et sélection sur grille des meilleures combinaisons par minimisation du RMSE.
* **Validation Croisée :** Évaluation des performances hors-échantillon par une méthodologie de fenêtre croissante (*Expanding Window*).
* **Modèle Retenu :** Structure $SARIMAX(2,0,1)(0,1,2)_{12}$ centrée sur la variable exogène `pct_moto`.

---

##  Résultats de la Validation Externe (2022)

Le modèle final a été confronté aux données réelles de la DRIEAT pour l'année 2022. Les indicateurs de performance prédictive sont :
* **MAE :** 22,58 accidents
* **RMSE :** 28,56 accidents
* **MAPE :** 10,58 %

Le modèle restitue avec précision la dynamique saisonnière globale (notamment le creux historique du mois d'août et la reprise d'automne), bien qu'il présente un léger lissage sur les pics d'exposition printaniers (mai/juin).
