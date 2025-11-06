#Importation OISON_PMC
OISON_PMC <- st_read("processed_data/OISON_PMC.gpkg")

###############################################
#  Evolution de la saisie par groupe d'espèce
###############################################
colors_esp <- c(
  "Arachnides" = "#E41A1C",     
  "Autres" = "#377EB8",         
  "Reptiles" = "#4DAF4A",       
  "Poissons" = "#984EA3",       
  "Angiospermes" = "#FF7F00",  
  "Amphibiens" = "#FFFF33",     
  "Insectes" = "#A65628",        
  "Mammifères" = "#F781BF",      
  "PMC" = "#D8B365",             
  "Crustacés" = "#66C2A5",       
  "Oiseaux" = "#3288BD"          
)

colors_dep <- c(
  "16" = "#FF6F61",   
  "17" = "#3A6EA5",   
  "19" = "#E3B23C",   
  "23" = "#9DBE8C",  
  "24" = "#FF9B85",   
  "33" = "#B0C4DE",   
  "40" = "#F3E000",   
  "47" = "#2C3E50",  
  "64" = "#C17ECF",   
  "79" = "#B2957B",    
  "86" = "#8F5B34",   
  "87" = "#FFF3B4"   
)

# Regrouper les espèces par années
groupes_espece_par_annee <- OISON_PMC %>% 
  group_by(annee,GROUP2_INPN) %>% 
  summarise(nb_saisies = n()) %>% 
  st_set_geometry(NULL) %>% 
  filter(annee >= 2020) %>%
  arrange(desc(nb_saisies))

# Ordre des espèces dans la légende décroissante
groupes_espece_par_annee$GROUP2_INPN <- factor(groupes_espece_par_annee$GROUP2_INPN, 
                                               levels = unique(groupes_espece_par_annee$GROUP2_INPN))

# Graphique
ggplot(groupes_espece_par_annee) +
  aes(x = annee, y = nb_saisies, colour = GROUP2_INPN) +
  geom_smooth(se = FALSE) +
  scale_colour_manual(values = colors_esp) +
  labs(x = "Années",
       y = "Nombre de saisies",
       colour = "Groupes d'espèce",
       title = "Evolution du nombre de saisies par groupe d'espèce (OISON+PMC)") +
  theme_minimal()

######################################################
#   Proportion de groupes d'espèces par département
######################################################

# Graphique Radar
ggplot(OISON_PMC) +
  aes(x = GROUP2_INPN, fill = INSEE_DEP) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = colors_dep) +
  labs(
    x = "",
    y = "",
    fill = "Départements",
    title = "Proportion des groupes d'espèces par département (OISON + PMC)"
  ) +
  coord_polar(theta = "x") +
  theme_minimal()

groupes_espece_radar <- OISON_PMC %>% 
  group_by(GROUP2_INPN,INSEE_DEP) %>% 
  summarise(nombre_saisies=n()) %>% 
  st_set_geometry(NULL)


###############################################
# Proportion des saisies par groupe d'espèce
###############################################

# Calcul des proportions
groupes_espece <- OISON_PMC %>% 
  group_by(GROUP2_INPN) %>% 
  summarise(nb_saisies = n()) %>% 
  st_set_geometry(NULL) %>% 
  arrange(nb_saisies) %>% 
  mutate(pourcentage = round((nb_saisies / sum(nb_saisies)) * 100)) %>% 
  mutate(cumulative = pourcentage / 2 + c(0, cumsum(pourcentage)[-length(pourcentage)]))

# Ordre des espèces décoissant  
groupes_espece$GROUP2_INPN <- groupes_espece$GROUP2_INPN %>% 
  factor(levels = rev(groupes_espece$GROUP2_INPN))

# Graphique Camembert
ggplot(groupes_espece)+
  aes(x = factor(1), y = pourcentage, fill = GROUP2_INPN) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar(theta = "y")+
  theme_void()+
  scale_fill_manual(values = colors_esp) +
  
  geom_text(data=tail(groupes_espece,4),
            aes(x = 1.7, 
                y = cumulative, 
                label=paste(GROUP2_INPN,"\n",pourcentage, "%"))
            )+
  labs(
    fill = "Groupes d'espèce",
    title = "Proportion des saisies par groupe d'espèce depuis 2020 (OISON + PMC)"
    )
