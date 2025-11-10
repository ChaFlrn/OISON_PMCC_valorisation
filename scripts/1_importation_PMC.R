# Importation "especes_pmc" pour faire correspondre les noms d'espèces à un code nom et à un nom scientifique

especes_PMC <- read.csv2("assets/especes_pmc.csv", fileEncoding = "latin1") %>% 
  mutate(cd_nom = as.character(cd_nom))

# Importation des données PMCC
PMC <- read.csv2("raw_data/PMC_brute.csv", fileEncoding = "latin1") # Prendre à partir du serveur

PMC <- st_read("raw_data/PMC_brute.gpkg") %>%
  mutate(annee = as.integer(substr(date_obs, 7, 10))) %>% 
  mutate(INSEE_DEP = str_extract(insee_dep, "\\d+")) %>% 
  rename(Espece = cd_nom) %>%
  mutate(GROUP2_INPN = "PMC") %>%   # groupe d'espèce = PMC
  stringdist_join(especes_PMC, by = c("Espece" = "nom_vernaculaire"), method = "jw", max_dist = 0.1) %>% 
  select(annee,
         Observateur = observateu,
         cd_nom,
         nom_scientifique,
         nom_vernaculaire,
         GROUP2_INPN,
         geom)


# Sauvegarder en GeoPackage
st_write(PMC, "processed_data/PMC.gpkg", driver = "GPKG",append=FALSE)  
