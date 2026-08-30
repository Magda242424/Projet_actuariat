
Oui. Voici le **README complet**, sans emoji, pensé pour un recruteur, avec les **8 graphiques directement visibles dans le README**.

Comme tes graphiques sont dans `docs/graphics/`, les chemins sont construits en conséquence.

````markdown
# Modélisation de la Sinistralité Routière par SARIMAX

## Prévision des accidents corporels dans les Hauts-de-Seine (92)

---

## Rapport complet

Le rapport complet présente l'ensemble de la démarche de modélisation, depuis la préparation des données jusqu'à la validation des prévisions.

**[Consulter le rapport HTML en ligne](https://magda242424.github.io/Projet_actuariat/)**

**[Consulter le code source R Markdown](./_Projet_Actuariat_.Rmd)**

---

# 1. Présentation du projet

Ce projet d'actuariat porte sur la **modélisation et la prévision du nombre mensuel d'accidents corporels de la circulation dans les Hauts-de-Seine (92)**.

L'objectif est de construire un modèle de séries temporelles capable de prévoir l'évolution de la sinistralité routière à partir :

- des données historiques de la Base des Accidents Corporels de la Circulation (BAAC) ;
- de variables explicatives décrivant les caractéristiques des accidents ;
- de la dynamique temporelle et de la saisonnalité mensuelle.

Le projet couvre l'ensemble de la chaîne de traitement :

**Données → Nettoyage → Analyse exploratoire → Création des variables → Modélisation → Validation croisée → Prévision → Validation externe**

---

# 2. Objectifs

Les principaux objectifs sont :

- analyser l'évolution temporelle de la sinistralité routière ;
- identifier la saisonnalité des accidents corporels ;
- étudier les caractéristiques des accidents ;
- construire des variables explicatives mensuelles ;
- vérifier la stationnarité de la série ;
- sélectionner les variables exogènes pertinentes ;
- comparer différents modèles SARIMAX ;
- utiliser une validation en fenêtre croissante ;
- mesurer les performances prédictives ;
- réaliser une validation externe sur les données de l'année 2022.

---

# 3. Données utilisées

## Données historiques

Les données historiques couvrent la période **2006–2021**.

Elles proviennent principalement de la **Base des Accidents Corporels de la Circulation (BAAC)**, disponible via les sources publiques officielles.

Sources :

- Base des Accidents Corporels de la Circulation (BAAC)
- data.gouv.fr
- Bases de données annuelles des accidents corporels de la circulation routière

Les données sont utilisées pour construire une série mensuelle du nombre d'accidents corporels dans le département des Hauts-de-Seine (92).

---

## Données de validation externe

La validation hors échantillon est réalisée sur l'année **2022**.

Les observations réelles utilisées pour cette validation proviennent notamment du :

- Baromètre de la Sécurité Routière – Décembre 2022 ;
- DRIEAT Île-de-France ;
- Préfecture de la Région Île-de-France.

Quelques valeurs observées :

| Mois | Nombre d'accidents |
|---|---:|
| Janvier | 162 |
| Mai | 262 |
| Juin | 276 |
| Août | 127 |
| Décembre | 204 |

**Total annuel 2022 : 2 519 accidents corporels**

---

# 4. Architecture des données

Les données sont stockées dans une base de données **MySQL** appelée :

```text
projet_actuariat
````

## Tables principales

### `accidents`

Contient les données brutes issues de la BAAC.

### `accidents_propre`

Contient les données nettoyées et préparées pour l'analyse.

## Vue SQL

La vue :

```text
accidents_mensuels
```

permet d'obtenir les indicateurs mensuels utilisés pour la modélisation.

Elle permet notamment de calculer :

* le nombre mensuel d'accidents ;
* la proportion de motocyclistes (`pct_moto`) ;
* la proportion d'accidents de nuit (`pct_nuit`) ;
* les indicateurs météorologiques ;
* différents indicateurs agrégés décrivant la sinistralité.

Les scripts SQL sont disponibles dans le dossier [`sql/`](./sql/).

---

# 5. Analyse exploratoire

L'analyse exploratoire permet d'étudier la dynamique temporelle de la sinistralité routière.

Elle porte notamment sur :

* l'évolution mensuelle du nombre d'accidents ;
* la tendance temporelle ;
* la saisonnalité ;
* la décomposition de la série ;
* les distributions ;
* les corrélations ;
* les caractéristiques des accidents.

## 5.1 Évolution mensuelle

L'évolution mensuelle permet d'identifier les principales variations du nombre d'accidents au cours de la période étudiée.

![Évolution mensuelle de la sinistralité](./docs/graphics/01_evolution_mensuelle.png)

---

## 5.2 Décomposition de la série

La décomposition permet de distinguer les principales composantes de la série temporelle :

* tendance ;
* saisonnalité ;
* résidus.

![Décomposition de la série temporelle](./docs/graphics/02_decomposition.png)

---

## 5.3 Analyse des distributions

L'étude des distributions permet de caractériser les principales variables utilisées dans l'analyse et d'identifier leur comportement statistique.

![Analyse des distributions](./docs/graphics/03_distributions.png)

---

## 5.4 Analyse des corrélations

L'analyse des corrélations permet d'étudier les relations entre le nombre d'accidents et les différentes variables explicatives candidates.

![Matrice des corrélations](./docs/graphics/04_correlations.png)

---

## 5.5 Analyse des variables explicatives

Les variables explicatives sont étudiées afin d'identifier les facteurs susceptibles d'améliorer les performances prédictives du modèle.

![Analyse des variables explicatives](./docs/graphics/05_variables_explicatives.png)

---

## 5.6 Analyse de la stationnarité

La stationnarité constitue une étape essentielle avant la modélisation de la série temporelle.

Les analyses reposent notamment sur :

* le test ADF ;
* le test KPSS ;
* l'ACF ;
* la PACF.

![Analyse de la stationnarité](./docs/graphics/06_stationnarite.png)

---

## 5.7 Validation du modèle

Les modèles candidats sont comparés à partir de leurs performances prédictives et de différents critères statistiques.

![Validation et comparaison des modèles](./docs/graphics/07_validation_modele.png)

---

## 5.8 Prévisions finales

La visualisation finale permet de comparer les valeurs observées aux prévisions du modèle sur la période de validation.

![Visualisation des prévisions](./docs/graphics/08_Visualisation_des_prévisions.png)

---

# 6. Stationnarité

La série temporelle est analysée afin de vérifier ses propriétés de stationnarité.

Les outils utilisés sont :

* test ADF (Augmented Dickey-Fuller) ;
* test KPSS ;
* fonction d'autocorrélation ACF ;
* fonction d'autocorrélation partielle PACF.

La modélisation prend en compte une saisonnalité annuelle de période :

```text
12 mois
```

La série est différenciée afin de tenir compte de la dynamique temporelle et de la saisonnalité.

Une attention particulière est portée à la rupture structurelle associée à la période des confinements de 2020.

---

# 7. Sélection des variables exogènes

Plusieurs variables candidates sont étudiées afin d'identifier celles permettant d'améliorer les performances du modèle.

La sélection repose notamment sur :

* l'analyse de la multicolinéarité ;
* le VIF (Variance Inflation Factor) ;
* une recherche sur grille (Grid Search) ;
* la comparaison des performances ;
* la minimisation du RMSE.

Le VIF maximal observé est :

**2,39**

Ce résultat indique une faible multicolinéarité entre les variables étudiées.

---

# 8. Validation croisée

Les performances des modèles sont évaluées à l'aide d'une validation en **fenêtre croissante (Expanding Window)**.

Cette méthode permet de reproduire les conditions réelles de prévision.

À chaque étape :

1. le modèle est entraîné sur les observations disponibles ;
2. une prévision est réalisée pour la période suivante ;
3. l'observation réelle est ajoutée à l'échantillon d'apprentissage ;
4. le processus est répété.

Cette approche permet d'éviter d'utiliser des observations futures lors de l'entraînement et fournit une évaluation plus réaliste de la capacité prédictive du modèle.

---

# 9. Modèle retenu

Après comparaison des modèles candidats, le modèle retenu est :

```text
SARIMAX(2,0,1)(0,1,2)[12]
```

avec comme variable exogène principale :

```text
pct_moto
```

Le modèle intègre :

* une composante autorégressive ;
* une composante moyenne mobile ;
* une différenciation saisonnière ;
* une saisonnalité annuelle de période 12 ;
* une variable explicative liée à la proportion de motocyclistes.

---

# 10. Validation externe sur l'année 2022

Le modèle final est évalué sur les observations réelles de l'année 2022.

Cette validation constitue une évaluation hors échantillon, les observations de 2022 n'étant pas utilisées pour entraîner le modèle historique.

## Performances

| Indicateur |      Valeur |
| ---------- | ----------: |
| **MAE**    |   **22,58** |
| **RMSE**   |   **28,56** |
| **MAPE**   | **10,58 %** |

Le modèle reproduit correctement la dynamique saisonnière globale.

Il permet notamment de restituer :

* le creux estival ;
* le minimum observé en août ;
* la reprise de l'activité à l'automne.

Une légère sous-estimation est observée lors des pics printaniers, notamment en mai et juin.

---

# 11. Principaux résultats

Les résultats obtenus montrent que le modèle est capable de reproduire correctement la dynamique globale de la sinistralité routière.

Les principaux enseignements sont :

* présence d'une saisonnalité annuelle marquée ;
* creux de sinistralité au mois d'août ;
* reprise de la sinistralité à l'automne ;
* bonne capacité de généralisation sur les données de 2022 ;
* MAPE de **10,58 %** sur la validation externe ;
* MAE de **22,58 accidents** ;
* RMSE de **28,56 accidents**.

Le modèle présente néanmoins un léger lissage des pics de sinistralité observés au printemps, notamment en mai et juin.

---

# 12. Visualisation des prévisions

La comparaison entre les valeurs observées et les valeurs prédites permet d'évaluer graphiquement la capacité du modèle à reproduire la dynamique réelle de la sinistralité.

![Prévisions du modèle SARIMAX](./docs/graphics/08_Visualisation_des_prévisions.png)

Cette visualisation met notamment en évidence :

* la bonne restitution de la saisonnalité ;
* le creux observé durant l'été ;
* la reprise automnale ;
* le léger lissage des pics printaniers.

---

# 13. Technologies utilisées

## Langages

* R
* SQL

## Base de données

* MySQL

## Packages R

* `dplyr`
* `ggplot2`
* `forecast`
* `tseries`
* `lmtest`
* `car`
* `DBI`
* `RMySQL`

## Outils

* R Markdown
* MySQL
* Git
* GitHub
* GitHub Pages

---

# 14. Structure du dépôt

```text
Projet_actuariat/
│
├── README.md
│
├── _Projet_Actuariat_.Rmd
│   └── Code source complet du rapport
│
├── docs/
│   ├── index.html
│   │   └── Rapport HTML
│   │
│   └── graphics/
│       ├── 01_evolution_mensuelle.png
│       ├── 02_decomposition.png
│       ├── 03_distributions.png
│       ├── 04_correlations.png
│       ├── 05_variables_explicatives.png
│       ├── 06_stationnarite.png
│       ├── 07_validation_modele.png
│       └── 08_Visualisation_des_prévisions.png
│
└── sql/
    ├── create_tables.sql
    └── create_view.sql
```

---

# 15. Accès aux fichiers

## Rapport HTML

**[Consulter le rapport complet en ligne](https://magda242424.github.io/Projet_actuariat/)**

## Code source R Markdown

**[Consulter le code source](./_Projet_Actuariat_.Rmd)**

## Scripts SQL

**[Consulter les scripts SQL](./sql/)**

## Graphiques

**[Consulter le dossier des graphiques](./docs/graphics/)**

---

# 16. Conclusion

Ce projet met en œuvre une démarche complète de **modélisation actuarielle appliquée à la prévision de la sinistralité routière**.

L'approche combine :

**SQL → préparation des données → analyse exploratoire → analyse statistique → séries temporelles → SARIMAX → validation croisée → validation externe**

Le modèle final :

```text
SARIMAX(2,0,1)(0,1,2)[12]
```

avec `pct_moto` comme variable exogène principale, obtient sur les données de validation 2022 :

**MAPE = 10,58 %**

Le modèle restitue correctement la dynamique saisonnière globale des accidents corporels dans les Hauts-de-Seine, notamment le creux du mois d'août et la reprise automnale.

Il présente cependant un léger lissage des pics printaniers observés en mai et juin.

Ce projet illustre ainsi l'application d'une méthodologie de **modélisation statistique et actuarielle à la prévision de la sinistralité**, en combinant gestion des données, SQL, analyse statistique, séries temporelles et évaluation prédictive.

---

## Projet d'actuariat

Projet réalisé dans le cadre d'un travail de modélisation actuarielle appliquée à la prévision de la sinistralité routière.

```

**Important :** j'ai utilisé les noms `03_distributions.png`, `04_correlations.png`, etc. parce que ton README mentionne 8 graphiques, mais je ne les ai pas vus tous précisément dans tes captures. **Si les noms réels dans `docs/graphics` sont différents, GitHub affichera une image cassée.** Le principe est bon, mais il faut que les noms correspondent exactement aux fichiers, y compris les majuscules, minuscules, accents et underscores.
```
