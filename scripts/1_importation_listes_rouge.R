# Lire les fichiers des espèces en liste rouge
# Ajouter pour chaque fichier un identifiant "Origine_LR" pour retrouver l'origine après

# Importation type de fichiers nationaux
monde_toute_especes <- read.table("assets/listes_rouge/monde_toute_especes.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL, na.strings = "")
monde_toute_especes$Origine_LR <- "monde_toute_especes"

europe_toute_especes <- read.table("assets/listes_rouge/europe_toute_especes.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL, na.strings = "")
europe_toute_especes$Origine_LR <- "europe_toute_especes"

fr_toute_especes <- read.table("assets/listes_rouge/fr_toute_especes.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL, na.strings = "")
fr_toute_especes$Origine_LR <- "fr_toute_especes"

fr_poissons_eau_douce <- read.table("assets/listes_rouge/fr_poissons_eau_douce.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL, na.strings = "")
fr_poissons_eau_douce$Origine_LR <- "fr_poissons_eau_douce"

fr_crustaces_eau_douce <- read.table("assets/listes_rouge/fr_crustaces_eau_douce.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL, na.strings = "")
fr_crustaces_eau_douce$Origine_LR <- "fr_crustaces_eau_douce"

fr_especes_envahissantes <- read.table("assets/fr_especes_envahissantes.csv", header=TRUE , sep=";", fill=TRUE, row.name=NULL)
fr_especes_envahissantes$Origine_LR <- "fr_especes_envahissantes"

# Importation type de fichiers régionaux






# Renommer les colonnes pour faire correspondre les bases
fr_especes_envahissantes <- fr_especes_envahissantes %>% 
  rename(STATUT = Statut.,
         NOM_CITE = Nom.de.référence)




# Ne garder que les colonnes CD_NOM, NOM_CITE, STATUT et Origine_LR
monde_toute_especes <- monde_toute_especes %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)
europe_toute_especes <- europe_toute_especes %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)
fr_toute_especes <- fr_toute_especes %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)
fr_crustaces_eau_douce <- fr_crustaces_eau_douce %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)
fr_poissons_eau_douce <- fr_poissons_eau_douce %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)
fr_especes_envahissantes <- fr_especes_envahissantes %>% select(CD_NOM, NOM_CITE, STATUT, Origine_LR)



# Combiner les bases de données dans l'ordre des dates (et en dernier la liste fr_toute_especes)
liste_rouge <- bind_rows(hdf_mollusques,
                         hdf_oiseaux_nicheurs,
                         hdf_papillons_de_jour,
                         fr_poissons_eau_douce,
                         hdf_flore,
                         nord_airaignees,
                         nord_amphibiens_reptiles,
                         picardie_faune,
                         nord_odonates,
                         fr_crustaces_eau_douce,
                         fr_toute_especes,
                         europe_toute_especes,
                         monde_toute_especes,
                         fr_especes_envahissantes)

# Gérer les doublons CD_REF en priorisant les premiers dans la liste de bind_rows(...)
liste_rouge <- liste_rouge %>% distinct(CD_NOM, .keep_all = TRUE)

# Output liste_rouge
write.csv(liste_rouge, "processed_data/liste_rouge.csv", row.names=FALSE)