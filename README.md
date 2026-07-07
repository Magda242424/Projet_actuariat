# Modélisation de la Sinistralité Routière par SARIMAX
### Prévision des accidents corporels dans les Hauts-de-Seine (92)

## Présentation

Ce projet d'actuariat présente une chaîne complète de traitement, d'analyse exploratoire et de modélisation prédictive du nombre mensuel d'accidents corporels dans le département des **Hauts-de-Seine (92)**.

L'objectif est de construire un modèle de séries temporelles capable de prévoir l'évolution mensuelle de la sinistralité routière à partir des données historiques de la Base des Accidents Corporels de la Circulation (BAAC) et de variables explicatives décrivant les caractéristiques des accidents.

---

## Structure du dépôt

```text
Projet_actuariat/
├── README.md                    # Présentation du projet
├── .gitignore                   # Fichiers ignorés par Git
├── _Projet_Actuariat_.Rmd       # Code source du rapport R Markdown
├── docs/
│   └── index.html               # Rapport HTML
├── graphics/                    # Graphiques générés
│   ├── 01_evolution_mensuelle.png
│   ├── 02_decomposition.png
│   ├── ...
│   └── 08_Visualisation_des_prévisions.png
└── sql/
    ├── create_tables.sql
    └── create_view.sql
```

---

## Sources des données

Les données utilisées proviennent exclusivement de sources publiques officielles.

### Données historiques (2006–2021)

- Base des Accidents Corporels de la Circulation (BAAC)
- data.gouv.fr – Accidents corporels de la circulation routière
- data.gouv.fr – Bases de données annuelles (2005 à aujourd'hui)

### Données de validation externe (année 2022)

Les observations réelles utilisées pour la validation hors échantillon proviennent du :

- **Baromètre de la Sécurité Routière – Décembre 2022**
- DRIEAT Île-de-France
- Préfecture de la Région Île-de-France

Exemple des valeurs observées :

| Mois | Nombre d'accidents |
|------:|-------------------:|
| Janvier | 162 |
| Mai | 262 |
| Juin | 276 |
| Août | 127 |
| Décembre | 204 |

**Total annuel 2022 : 2 519 accidents corporels**

### Documentation méthodologique

La définition des variables et la nomenclature proviennent des documents méthodologiques de l'Observatoire National Interministériel de la Sécurité Routière (ONISR).

---

## Architecture des données

Les données sont stockées dans une base **MySQL** nommée :

```
projet_actuariat
```

### Tables

- **accidents** : données brutes BAAC
- **accidents_propre** : données nettoyées

### Vue SQL

**accidents_mensuels**

Cette vue calcule automatiquement :

- nombre mensuel d'accidents ;
- proportion de motocyclistes (`pct_moto`) ;
- proportion d'accidents de nuit (`pct_nuit`) ;
- conditions météorologiques (`pct_meteo`) ;
- autres indicateurs agrégés.

Les scripts SQL sont disponibles dans le dossier :

```
sql/
```

---

## Méthodologie

### 1. Préparation des données

- nettoyage des données BAAC ;
- agrégation mensuelle ;
- création des variables exogènes.

### 2. Analyse exploratoire (EDA)

- évolution temporelle ;
- saisonnalité ;
- décomposition de la série ;
- distributions ;
- corrélations ;
- visualisations graphiques.

Les figures sont disponibles dans :

```
graphics/
```

---

## Modélisation statistique

### Stationnarité

La série a été rendue stationnaire après prise en compte de la rupture structurelle liée aux confinements de 2020.

Le modèle repose sur :

- différenciation non saisonnière : **d = 1**
- différenciation saisonnière : **D = 1**
- période saisonnière : **12 mois**

La stationnarité est validée par :

- test ADF ;
- test KPSS ;
- analyse des fonctions ACF et PACF.

---

### Sélection des variables exogènes

Les variables candidates ont été évaluées à partir :

- du facteur d'inflation de variance (VIF) ;
- d'une recherche sur grille (Grid Search) ;
- de la minimisation du RMSE.

Le VIF maximal observé est :

**2,39**

indiquant une faible multicolinéarité.

---

### Validation croisée

Les performances sont évaluées par une validation en **fenêtre croissante (Expanding Window)**.

Cette approche reproduit les conditions réelles de prévision en utilisant uniquement les observations disponibles à chaque date.

---

## Modèle retenu

Le meilleur modèle obtenu est :

**SARIMAX(2,0,1)(0,1,2)[12]**

avec comme variable exogène principale :

- **pct_moto**

---

## Validation externe (année 2022)

Le modèle est testé sur les données réelles de la DRIEAT pour l'année 2022.

### Performances

| Indicateur | Valeur |
|------------|--------|
| MAE | 22,58 |
| RMSE | 28,56 |
| MAPE | 10,58 % |

Le modèle reproduit correctement :

- la saisonnalité annuelle ;
- le minimum estival observé en août ;
- la reprise de l'activité à l'automne.

Une légère sous-estimation est observée lors des pics printaniers (mai–juin).

---

## Technologies utilisées

- R
- R Markdown
- MySQL
- SQL
- dplyr
- ggplot2
- forecast
- tseries
- lmtest
- car
- DBI
- RMySQL

---

## Rapport

Le rapport complet est disponible :

- **Version HTML** : `docs/index.html`
- **Code source** : `_Projet_Actuariat_.Rmd`

---

## Auteur

**M**

Projet réalisé dans le cadre d'un travail de modélisation actuarielle appliquée à la prévision de la sinistralité routière.
Le modèle restitue avec précision la dynamique saisonnière globale (notamment le creux historique du mois d'août et la reprise d'automne), bien qu'il présente un léger lissage sur les pics d'exposition printaniers (mai/juin).
