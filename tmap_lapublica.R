
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

Publica = suppressMessages(load_data_dict(book = book,sheet=sheet))

colnames(Publica)
summary(Publica)

# https://arbor-analytics.com/post/making-animated-gif-maps-in-r-visualizing-ten-years-of-emerald-ash-borer-spread-in-minnesota/

shape = st_read("/home/tarto/Documents/GIS/Comunas/comunas_lapublica.geojson")
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
}else if(Region == "IX"){
  # Publica$Sum = rowSums(Publica[,colnames(Publica)[2:27]])
  # comunas=Publica$Comuna[1:10] 
  reg_label = "Región del Bío-Bío"
}

shape %>%  filter(Region == reg_label) %>% select(Comuna) %>% as.data.frame() %>% select(Comuna) %>% write.csv("Biobio_comunas.csv")

# # Create centroid for visualization GGPLOT
# Comunas <- st_centroid(shape) %>% na.omit()
# Comunas$lng = st_coordinates(Comunas)[,1]
# Comunas$lat = st_coordinates(Comunas)[,2]

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



# hist(shape_PNI$PNI)
# plot(shape_PNI$PNI)

# library(jamba)
# library(RColorBrewer)
# brewer.pal(11, "YlOrRd")
# 
# colores = jamba::color2gradient(list(Greens=c("green"),
#                                      Yellow = c("yellow"), 
#                                      Reds=c("red")), n=c(3,3,3));
# values = showColors(colores)

# colores = c("#5CFF5CFF","#36E036FF","#00A300FF",
#             "#FFFF5CFF","#F0F048FF","#D1D126FF",
#             "#FF5C5CFF","#E03636FF","#C21717FF","#A30000FF")
# 
# length(colores)

# 
# if(Region = "RM"){
#   break_sum = seq(0,1200,by=120)
#   length(break_sum)
#   breaks = seq(0,50,by=5)
# }else if(Region = "IX"){
#   # break_sum = seq(0,1200,by=120)
#   # length(break_sum)
#   # For sum
#   breaks = seq(25,max(shape_PNI$PNI)+15,by=20);length(breaks)
#   # For Date
#   breaks = seq(0,max(shape_PNI$PNI)+2,by=1.5);length(breaks)
#   (length(breaks)==(length(colores)+1))
# }

# breaks = break_sum

# plot(shape_PNI["PNI"] , key.pos = 1,axes = TRUE, 
#      key.width = lcm(1.5), key.length = 1.0,
#      nbreaks = 10,pal = colores,
#      breaks = breaks,
#      at = breaks)
# plot(shape_PNI["Comuna"])






# open the file
filename = paste0(Region,"_test_sum.png")
png(filename = filename, w = 5, h = 7, units = "in", res = 150)
plot(shape["PNI"] , key.pos = 1,axes = TRUE, 
     key.width = lcm(1.5), key.length = 1.0,
     nbreaks = 10,pal = colores,
     breaks = breaks,
     at = breaks)
# close the png file
dev.off()

# library(RgoogleMaps)
# # define Lat and Lon
# 
# Lat <- c(-33.4,-33.5)
# Long <- c(-70.5,-70.8)
# # get the map tiles 
# # you will need to be online
# MyMap <- MapBackground(lat=Lat, lon=Long, maptype = "satellite",zoom = 10)
# PlotOnStaticMap(MyMap)


library(tmap)

filename = paste0(Region,"_test_tmap_classic_sum.png")
png(filename = filename, w = 5, h = 7, units = "in", res = 150)
qtm(shape["PNI"], fill = "red", style = "natural")

qtm(shape, fill="PNI", text="Comuna", text.size=0.5, 
    format="World_wide", style="classic", 
    text.root=5, fill.title="PNI")

dev.off()

filename = paste0(Region,"_test_tmap_sum.png")
png(filename = filename, w = 5, h = 7, units = "in", res = 150)

tm_shape(shape) +
  tm_polygons("PNI", title = "2020-30-01", palette = colores, 
              breaks = breaks, 
              legend.hist = T) +
  tm_scale_bar(width = 0.12,position = c(0.05, 0.5)) +
  tm_compass(position = c(0.05, 0.6)) +
  tm_layout(frame = F, 
            title.size = 2, 
            title.position = c(0.55, "top"), 
            legend.outside = T,legend.stack = "vertical",
            legend.hist.size = 0.9,legend.hist.width = 1)

# close the png file
dev.off()


library(ggplot2)
library(maps)
library(ggthemes)

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

map <- world +
  geom_point(aes(x = lon, y = lat, size = followers),
             data = rladies, 
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8), 
                        breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Followers')

