
library(ggplot2)
theme_set(theme_bw())
library(sf)
library(dplyr)
library(sf)

## https://tmieno2.github.io/R-as-GIS-for-Economists/color-scale.html

library(ggspatial)
source("functions.R")


book = "https://docs.google.com/spreadsheets/d/10ZiHU3YUueuR3XBcUGNywfzJEpXKsUOy211uBYDCnqk/edit?usp=sharing"

Region = "RM"
Region = "VIII"
Region = "IX"

## RM ##
book = "https://docs.google.com/spreadsheets/d/16qjbB6rneQHqI0t-sQj9J97jOqXXRFXwU5CSXVcfYLI/edit?usp=sharing"
sheet = "TOTALES (CALCULADOS POR LA PÚBLICA)"

# Araucania
book = "https://docs.google.com/spreadsheets/d/10ZiHU3YUueuR3XBcUGNywfzJEpXKsUOy211uBYDCnqk/edit?usp=sharing"
sheet = "Map"

# Load La Publica Data
Publica = load_data_dict(book = book,sheet=sheet)

colnames(Publica)
summary(Publica)

# https://arbor-analytics.com/post/making-animated-gif-maps-in-r-visualizing-ten-years-of-emerald-ash-borer-spread-in-minnesota/

shape = st_read("shape/comunas_lapublica.geojson")
# st_transform(stgo, "+init=epsg:3857")

Publica$Comuna
shape$Comuna

colnames(Publica)

if(Region == "RM"){
  Publica$`23/10` = as.numeric(unlist(Publica$`23/10`))  
  Publica$Sum = rowSums(Publica[,colnames(Publica)[4:29]])
  #comunas=Publica$Comuna[1:] 
  reg_label = "Región Metropolitana de Santiago"
}else if(Region == "IX"){
  Publica$Sum = rowSums(Publica[,colnames(Publica)[2:27]])
  comunas=Publica$Comuna[1:10] 
  reg_label = "Región de La Araucanía"
}else if(Region == "XIII"){
  # Not run
  # Publica$Sum = rowSums(Publica[,colnames(Publica)[2:27]])
  # comunas=Publica$Comuna[1:10] 
  # reg_label = "Región del Bío-Bío"
  shape %>%  filter(Region == reg_label) %>% select(Comuna) %>% as.data.frame() %>% select(Comuna) %>% write.csv("Biobio_comunas.csv")
}


## ADD PNI to shapefile ####
colnames(Publica)

date_lab = "18/10"
date_lab_reg = colnames(Publica)[2:27]

library(tidyverse)
library(ggrepel)

for(ee in 1:length(date_lab_reg)){
  
  date_lab = date_lab_reg[ee]
  shape_PNI = addDatePNI(shape,comunas, date_lab=date_lab)
  shape_PNI = shape_PNI %>% 
    filter(Region == reg_label) %>% 
    mutate(
      CENTROID = map(geometry, st_centroid),
      COORDS = map(CENTROID, st_coordinates),
      COORDS_X = map_dbl(COORDS, 1),
      COORDS_Y = map_dbl(COORDS, 2)
      ) 
    

  seq_breaks = seq(0, 20,2)
  seq_labels = seq(0, 20,2)
  
  title = latex2exp::TeX(paste0("Número de Carabineros de \\textbf{Civil Activos} en la \\textbf{",reg_label,"}"))
  subtitle = latex2exp::TeX(paste0("\\textbf{",date_lab,"}/2019"))
  
  
  shape_PNI$nudge_x <- 0
  shape_PNI$nudge_y <- 0
  
  x_range <- abs(Reduce("-", range(shape_PNI$COORDS_X)))
  y_range <- abs(Reduce("-", range(shape_PNI$COORDS_Y)))
  
  ix <- shape_PNI$name %in% c("Temuco")
  shape_PNI$nudge_x[ix] <- -1 * 0.15 * x_range
  shape_PNI$nudge_y[ix] <- 1 * 0.15 * y_range
  
  ix <- shape_PNI$name %in% c("Temuco")
  shape_PNI$nudge_x[ix] <- 1 * 0.2 * x_range
  shape_PNI$nudge_y[ix] <- -1 * 0.15 * y_range
  

  ggmap = ggplot(data = shape_PNI) +
    geom_sf() +
    geom_sf(data = shape_PNI,aes(fill = PNI)) +
    # theme_void() +
    scale_fill_distiller(name="N°",palette = "RdYlGn",guide = "colourbar", na.value = "grey",
                         breaks=seq_breaks,labels=seq_labels,limits = c(0, 20))+
    geom_text_repel(
      mapping = aes(
        x = COORDS_X,
        y = COORDS_Y,
        label = Comuna
      ),
      nudge_x = shape_PNI$nudge_x,
      nudge_y = shape_PNI$nudge_y,
      size = 3,
      min.segment.length = 0,
      point.padding = NA,
      segment.color = "grey50"
    ) +
    
    xlab("Longitud") + ylab("Latitud") +
    labs(title= title,subtitle = subtitle) +
    
    annotation_scale(location = "br", width_hint = 0.3) +
    annotation_north_arrow(location = "br", which_north = "true", 
                           pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                           style = north_arrow_fancy_orienteering)+
    theme(panel.grid.major = element_line(color = gray(0.5), linetype = "dashed", 
                                          size = 0.3), 
          panel.background = element_rect(fill = "transparent"))
  # ggmap
  dategg = as.Date(paste0(date_lab,"/2019"),format = "%d/%m/%Y")
  filename = paste0(Region,"_",gsub("/","_",dategg),"_frame1.png")
  ggsave(ggmap,filename = filename,width = 8,height = 7,device = "png", bg = "transparent")
  
}





