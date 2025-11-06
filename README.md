# Valorisation des données OISON et PMCC de l'OFB
## Objectif
Ce projet produit des rapports automatisés de l'évolution de la saisies sur les données de l'OFB issues de OISON et du réseau PMCC. 
## Arborescence du projet
### Fichier "Make.R"
Lancer ce fichier après avoir téléchargé le zip du projet. Lancer les premiers scripts pour créer les fichiers intermédiaires dans processed_data.
Modifier les paramètres de la fonction rmarkdown::render pour changer les dates souhaitées pour les rapports et les bases à utiliser (OISON et/ou PMCC)

### Assets
Elements concernants les espèces et les limites administratives.
Les assets sont utilisées à la fois directement dans le Rmarkdown mais aussi pour générer des fichiers intermédiaires dans processed_data.

### Output
Sorties des rapports automatisés départemnataux et régionaux.

### Processed_data
Fichiers intémédiaires créés à partir des scripts et des fichiers dans assets et raw_data.

### Raw_data
Les données brutes utilisées (OISON et PMC).

### Scripts
- 0_chargement_packages
- 0_importations_statuts_especes
- 1_importation_communes_departements
- 1_importation_listes_rouge : importation des espèces menacées et envahissantes en Nouvelle-Aquitaine du dossier assets
- 1_importation_OISON : mise en forme du fichier OISON
- 1_importation_PMC : mise en forme du fichier PMC
- 2_assemblage_bases : script le plus important permettant de faire le lien entre toutes les bases (ajout des espèces protégées en Nouvelle-Aquitaine)
- 3_groupes_especes : création de divers graphiques sur les espèces et leur statut
- 3_observations_carto : réalisation de cartes par communes et de type carte de chaleur
- 3_saisies_observateurs : création de différents graphiques sur les observateurs et leur nombre de saisies
- Esquisse : aide pour la création de graphiques


### Templates
Scripts Rmarkdown pour la production des rapports automatisés et la création des graphiques.
