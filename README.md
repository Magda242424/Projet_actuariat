# Modélisation de la Sinistralité Routière par SARIMAX

### Prévision des accidents corporels dans les Hauts-de-Seine (92)

---

## Rapport complet

**[Voir le rapport complet en ligne](https://magda242424.github.io/Projet_actuariat/)**

**[Voir le code source R Markdown](./_Projet_Actuariat_.Rmd)**

Le rapport présente l'ensemble de la démarche de modélisation, depuis la préparation des données jusqu'à la validation des prévisions.

---

## Présentation du projet

Ce projet d'actuariat porte sur la modélisation et la prévision du nombre mensuel d'accidents corporels de la circulation dans les Hauts-de-Seine (92).

L'objectif est de construire un modèle de séries temporelles capable de prévoir l'évolution de la sinistralité routière à partir des données historiques de la Base des Accidents Corporels de la Circulation (BAAC) et de variables explicatives décrivant les caractéristiques des accidents.

Le projet couvre l'ensemble de la chaîne de traitement :

**Données → Nettoyage → Analyse exploratoire → Variables explicatives → Modélisation SARIMAX → Validation croisée → Prévision → Validation externe**

---

## Analyse exploratoire

L'analyse porte sur le nombre mensuel d'accidents corporels dans les Hauts-de-Seine.

Elle permet notamment d'identifier :

- la tendance temporelle ;
- la saisonnalité annuelle ;
- les variations mensuelles ;
- les effets liés à la période des confinements ;
- les périodes de forte et faible sinistralité.

### Évolution mensuelle de la sinistralité

![Évolution mensuelle du nombre d'accidents](docs/graphics/01_evolution_mensuelle.png)

### Décomposition de la série temporelle

La décomposition permet d'identifier séparément la tendance, la saisonnalité et les résidus.

![Décomposition de la série temporelle](docs/graphics/02_decomposition.png)

---

## Sources des données

Les données utilisées proviennent exclusivement de sources publiques et officielles.

### Données historiques — 2006 à 2021

- Base des Accidents Corporels de la Circulation (BAAC)
- data.gouv.fr
- Bases de données annuelles des accidents corporels de la circulation routière

### Données de validation externe — 2022

Les observations utilisées pour la validation hors échantillon proviennent du :

- Baromètre de la Sécurité Routière – Décembre 2022
- DRIEAT Île-de-France
- Préfecture de la Région Île-de-France

Quelques valeurs observées :

| Mois | Nombre d'accidents |
|------|-------------------:|
| Janvier | 162 |
| Mai | 262 |
| Juin | 276 |
| Août | 127 |
| Décembre | 204 |

**Total annuel 2022 : 2 519 accidents corporels**

### Documentation méthodologique

La définition des variables et leur nomenclature reposent sur les documents méthodologiques de l'Observatoire National Interministériel de la Sécurité Routière (ONISR).

---

## Architecture des données

Les données sont stockées dans une base MySQL nommée :

```text
projet_actuariat
