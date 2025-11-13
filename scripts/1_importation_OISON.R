# Importation des données OISON

# Lire le fichier GPKG et ajouter une colonne annee



OISON <- st_read("raw_data/OISON_brute.gpkg") %>%
  mutate(annee = as.integer(substr(date, 7,10))) %>% 
  #mutate(Observateur = str_extract(email, "^[^@]+")) %>%
  mutate(cd_nom = as.character(cd_nom),
         Observateur = paste(first_name, name)) %>%
  rename(nom_scientifique = nom_latin,
         nom_vernaculaire = vernacular_name,
         GROUP2_INPN = groupe2_inpn)

OISON <- OISON %>% 
  select(annee,
         Observateur,
         cd_nom,
         nom_scientifique,
         nom_vernaculaire,
         GROUP2_INPN,
         presence,
         type_recherche,
         geom)

statuts_especes_simple <- read.csv("processed_data/statuts_especes_simple.csv") %>% 
  mutate(cd_nom = as.character(cd_nom))

# Joindre le statut espèce aux données
OISON <- OISON %>% 
  left_join(statuts_especes_simple, by="cd_nom", suffix = c("", "_y")) %>% 
  relocate(GROUP2_INPN,.after=nom_vernaculaire) %>% # placer la colonne
  mutate(GROUP2_INPN = coalesce(GROUP2_INPN, GROUP2_INPN_y)) %>%
  mutate(GROUP2_INPN = replace_na(GROUP2_INPN, "Non spécifié")) %>% # Renomme les valeurs manquantes
  select(-GROUP2_INPN_y)

st_write(OISON, "processed_data/OISON.gpkg",append=FALSE)

