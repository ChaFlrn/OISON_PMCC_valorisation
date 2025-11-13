#Permet de retrouver les GROUP2_INP à partir du cd_nom
#Script à lancer avant "importation_OISON"


taxref <- read_delim(
  "assets/TAXREFv18.txt",
  delim = "\t",               # généralement TAB dans TAXREF
  col_types = cols(.default = "c"),  # tout en caractère pour éviter les facteurs ou problèmes de conversion
  trim_ws = TRUE              # supprime les espaces en début/fin de champs
  )

statuts_especes_simple <- taxref %>%
  select(CD_NOM, GROUP2_INPN) %>%
  rename(cd_nom = CD_NOM) %>%
  mutate(cd_nom = as.character(cd_nom)) #%>%
  #distinct(cd_nom, .keep_all = TRUE)
  
write.csv(statuts_especes, file= "processed_data/statuts_especes_simple.csv", row.names=FALSE)
