# Importation des fichiers COMMUNE.gpkg et DEPARTEMENT.gpkg

departements <- st_read("assets/limites_administratives/departements.gpkg") %>% 
  
  select(INSEE_DEP,
         NOM_DEP,
         geom) %>% 
  
  rename(Departement = NOM_DEP)

communes <- st_read("assets/limites_administratives/communes.gpkg") %>% 
  
  select(departement,
         code,
         Code_postal,
         nom,
         geom) %>% 
  
  rename(INSEE_DEP = departement,
         INSEE_COM = code,
         Commune = nom)

st_write(communes, "processed_data/communes.gpkg",append=FALSE)
st_write(departements, "processed_data/departements.gpkg",append=FALSE)
