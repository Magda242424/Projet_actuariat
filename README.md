

# Modélisation de la Sinistralité Routière par SARIMAX

### Prévision des accidents corporels dans les Hauts-de-Seine (92)

---

## Rapport complet


 **[Voir le rapport en ligne avec GitHub Pages](https://magda242424.github.io/Projet_actuariat/)**

Le rapport présente l'ensemble de la démarche de modélisation, depuis la préparation des données jusqu'à la validation des prévisions.

---

##  Présentation du projet

Ce projet d'actuariat porte sur la **modélisation et la prévision du nombre mensuel d'accidents corporels de la circulation dans les Hauts-de-Seine (92)**.

L'objectif est de construire un modèle de séries temporelles capable de prévoir l'évolution de la sinistralité routière à partir :

- des données historiques de la **Base des Accidents Corporels de la Circulation (BAAC)** ;
- de variables explicatives décrivant les caractéristiques des accidents ;
- de la saisonnalité mensuelle de la sinistralité.

Le projet couvre l'ensemble de la chaîne de traitement :

**données → nettoyage → analyse exploratoire → création des variables → modélisation → validation croisée → prévision → validation externe.**

---

##  Structure du dépôt

```text
Projet_actuariat/
│
├── README.md
│
├── _Projet_Actuariat_.Rmd
│   └── Code source complet du rapport R Markdown
│
├── docs/
│   ├── index.html
│   │   └── Rapport HTML
│   │
│   └── graphics/
│       ├── 01_evolution_mensuelle.png
│       ├── 02_decomposition.png
│       ├── ...
│       └── 08_Visualisation_des_prévisions.png
│
├── graphics/
│   └── Graphiques générés lors de l'analyse
│
└── sql/
    ├── create_tables.sql
    └── create_view.sql
````

---

#  Sources des données

Les données utilisées proviennent exclusivement de sources publiques et officielles.

### Données historiques — 2006 à 2021

* **Base des Accidents Corporels de la Circulation (BAAC)**
* **data.gouv.fr**
* Bases de données annuelles des accidents corporels de la circulation routière

### Données de validation externe — 2022

Les observations utilisées pour la validation hors échantillon proviennent du :

* **Baromètre de la Sécurité Routière – Décembre 2022**
* **DRIEAT Île-de-France**
* **Préfecture de la Région Île-de-France**

Quelques valeurs observées :

| Mois     | Nombre d'accidents |
| -------- | -----------------: |
| Janvier  |                162 |
| Mai      |                262 |
| Juin     |                276 |
| Août     |                127 |
| Décembre |                204 |

**Total annuel 2022 : 2 519 accidents corporels**

### Documentation méthodologique

La définition des variables et leur nomenclature reposent sur les documents méthodologiques de l'**Observatoire National Interministériel de la Sécurité Routière (ONISR)**.

---

#  Architecture des données

Les données sont stockées dans une base **MySQL** nommée :

```text
projet_actuariat
```

### Tables principales

* `accidents` : données brutes issues de la BAAC
* `accidents_propre` : données nettoyées et préparées

### Vue SQL

La vue :

```text
accidents_mensuels
```

permet d'obtenir automatiquement les indicateurs mensuels utilisés pour la modélisation, notamment :

* nombre mensuel d'accidents ;
* proportion de motocyclistes (`pct_moto`) ;
* proportion d'accidents de nuit (`pct_nuit`) ;
* indicateurs météorologiques ;
* autres variables agrégées.

Les scripts SQL sont disponibles dans :

```text
sql/
```

---

# 🔎 Méthodologie

## 1. Préparation des données

Les principales étapes sont :

* nettoyage des données BAAC ;
* sélection du département des Hauts-de-Seine (92) ;
* contrôle et préparation des variables ;
* agrégation des observations à une fréquence mensuelle ;
* création des variables exogènes.

---

## 2. Analyse exploratoire

L'analyse exploratoire comprend :

* évolution temporelle du nombre d'accidents ;
* identification de la saisonnalité ;
* décomposition de la série temporelle ;
* analyse des distributions ;
* étude des corrélations ;
* visualisation des principales caractéristiques de la sinistralité.

Les graphiques sont disponibles dans :

```text
graphics/
```

---

# 📈 Modélisation statistique

## Stationnarité

La série temporelle est analysée afin de vérifier ses propriétés de stationnarité.

Les outils utilisés sont :

* test **ADF (Augmented Dickey-Fuller)** ;
* test **KPSS** ;
* fonctions **ACF** et **PACF**.

La modélisation prend en compte :

* une différenciation non saisonnière ;
* une différenciation saisonnière ;
* une saisonnalité de période **12 mois**.

Une attention particulière est portée à la rupture structurelle associée aux confinements de 2020.

---

## 🔬 Sélection des variables exogènes

Les variables candidates sont évaluées à partir de :

* l'analyse de la multicolinéarité ;
* du **Variance Inflation Factor (VIF)** ;
* d'une recherche sur grille (**Grid Search**) ;
* de la comparaison des performances prédictives ;
* de la minimisation du **RMSE**.

Le VIF maximal observé est :

**2,39**

ce qui indique une faible multicolinéarité entre les variables retenues.

---

#  Validation croisée

Les performances du modèle sont évaluées à l'aide d'une validation en **fenêtre croissante (Expanding Window)**.

Cette méthode permet de reproduire les conditions réelles de prévision :

1. le modèle est entraîné sur les observations disponibles ;
2. une prévision est réalisée pour la période suivante ;
3. l'observation réelle est ensuite intégrée à l'échantillon d'apprentissage ;
4. le processus est répété au fil du temps.

Cette approche permet notamment de limiter les biais liés à une utilisation d'informations futures lors de l'entraînement.

---

#  Modèle retenu

Après comparaison des modèles, le modèle retenu est :

```text
SARIMAX(2,0,1)(0,1,2)[12]
```

avec comme variable exogène principale :

```text
pct_moto
```

Le modèle combine ainsi :

* une composante autorégressive ;
* une composante moyenne mobile ;
* une différenciation saisonnière ;
* une saisonnalité annuelle ;
* une variable explicative liée à la proportion de motocyclistes.

---

#  Validation externe — Année 2022

Une validation hors échantillon est réalisée sur les observations réelles de l'année **2022** fournies par la DRIEAT.

### Performances obtenues

| Indicateur |    Résultat |
| ---------- | ----------: |
| **MAE**    |   **22,58** |
| **RMSE**   |   **28,56** |
| **MAPE**   | **10,58 %** |

Ces résultats montrent une bonne capacité du modèle à reproduire la dynamique globale de la sinistralité.

Le modèle restitue notamment :

* la saisonnalité annuelle ;
* le creux estival observé en août ;
* la reprise de l'activité à l'automne.

Une légère sous-estimation apparaît lors des pics de sinistralité observés au printemps, notamment en **mai et juin**.

---

#  Principaux résultats

Le modèle permet de reproduire correctement la dynamique temporelle globale du nombre d'accidents corporels.

### Points principaux

* Bonne restitution de la **saisonnalité annuelle** ;
* identification du **creux historique du mois d'août** ;
* bonne représentation de la **reprise automnale** ;
* performances satisfaisantes sur les données 2022 ;
* erreur moyenne absolue de **22,58 accidents** ;
* RMSE de **28,56 accidents** ;
* MAPE de **10,58 %**.

Le modèle présente toutefois un léger lissage des pics d'exposition printaniers, en particulier sur les mois de mai et juin.

---

#  Technologies utilisées

### Langages

* **R**
* **SQL**

### Base de données

* **MySQL**

### Principaux packages R

* `dplyr`
* `ggplot2`
* `forecast`
* `tseries`
* `lmtest`
* `car`
* `DBI`
* `RMySQL`

### Outils

* R Markdown
* Git
* GitHub
* GitHub Pages

---

#  Documents du projet

### Rapport HTML

 **[Lire le rapport complet](docs/index.html)**

### Rapport en ligne

 **[Ouvrir le rapport avec GitHub Pages](https://magda242424.github.io/Projet_actuariat/)**

### Code source

 **[*Projet_Actuariat*.Rmd](./_Projet_Actuariat_.Rmd)**

### Scripts SQL

 **[Consulter les scripts SQL](./sql/)**

### Graphiques

 **[Consulter les graphiques](./graphics/)**

---

#  Conclusion

Ce projet met en œuvre une démarche complète de **modélisation actuarielle appliquée à la sinistralité routière**.

L'approche combine :

**SQL → préparation des données → analyse statistique → séries temporelles → SARIMAX → validation croisée → validation externe.**

Le modèle retenu permet de restituer avec une bonne précision la dynamique saisonnière globale des accidents corporels dans les Hauts-de-Seine et fournit des prévisions cohérentes sur les données de validation de 2022.

---













































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


Projet réalisé dans le cadre d'un travail de modélisation actuarielle appliquée à la prévision de la sinistralité routière.
Le modèle restitue avec précision la dynamique saisonnière globale (notamment le creux historique du mois d'août et la reprise d'automne), bien qu'il présente un léger lissage sur les pics d'exposition printaniers (mai/juin).
