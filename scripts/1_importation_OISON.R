# Importation des données OISON

# Lire le fichier GPKG et ajouter une colonne annee
OISON <- st_read("raw_data/OISON_brute.gpkg") %>%
  mutate(annee = as.integer(Annee)) %>% 
  #mutate(Observateur = str_extract(email, "^[^@]+")) %>%
  mutate(cd_nom = as.character(Identifiant)) %>%
  rename(nom_scientifique = NomLatin,
         nom_vernaculaire = Identifiant.de.taxon,
         presence = Présence.de.taxon,
         type_recherche = Type.de.recherche)

OISON <- OISON %>% 
  select(annee,
         Observateur,
         cd_nom,
         nom_scientifique,
         nom_vernaculaire,
         presence,
         type_recherche,
         geom)

statuts_especes_simple <- read.csv("processed_data/statuts_especes_simple.csv") %>% 
  mutate(cd_nom = as.character(cd_nom))

# Joindre le statut espèce aux données
OISON <- OISON %>% 
  left_join(statuts_especes_simple, by="cd_nom") %>% 
  relocate(GROUP2_INPN,.after=nom_vernaculaire) %>%  # placer la colonne
  mutate(GROUP2_INPN = replace_na(GROUP2_INPN, "Non spécifié")) # Renomme les valeurs manquantes

st_write(OISON, "processed_data/OISON.gpkg",append=FALSE)

