

library(ggplot2)
theme_set(theme_bw())
library(dplyr)
library(tidyverse)
library(ggrepel)
library(gganimate)
library(av)
## https://tmieno2.github.io/R-as-GIS-for-Economists/color-scale.html


source("functions.R")


book = "https://docs.google.com/spreadsheets/d/10ZiHU3YUueuR3XBcUGNywfzJEpXKsUOy211uBYDCnqk/edit?usp=sharing"

Region = "RM"
Region = "VIII"
Region = "IX"

if(Region == "RM"){
  # Publica$`23/10` = as.numeric(unlist(Publica$`23/10`))  
  # Publica$Sum = rowSums(Publica[,colnames(Publica)[4:29]])
  #comunas=Publica$Comuna[1:] 
  reg_label = "Región Metropolitana de Santiago"
}else if(Region == "IX"){
  
  reg_label = "Región de La Araucanía"
}else if(Region == "XIII"){
  # Not run
  # Publica$Sum = rowSums(Publica[,colnames(Publica)[2:27]])
  # comunas=Publica$Comuna[1:10] 
  # reg_label = "Región del Bío-Bío"
  shape %>%  filter(Region == reg_label) %>% select(Comuna) %>% as.data.frame() %>% select(Comuna) %>% write.csv("Biobio_comunas.csv")
}

## RM ##
book = "https://docs.google.com/spreadsheets/d/16qjbB6rneQHqI0t-sQj9J97jOqXXRFXwU5CSXVcfYLI/edit?usp=sharing"
sheet = "Map"

# Araucania
book = "https://docs.google.com/spreadsheets/d/10ZiHU3YUueuR3XBcUGNywfzJEpXKsUOy211uBYDCnqk/edit?usp=sharing"
sheet = "Map"

# Load La Publica Data
Publica = load_data_dict(book = book,sheet=sheet)

colnames(Publica)
summary(Publica)

##### Sum Data per comune and date ####
dim_row = dim(Publica)[1]
dim_col = dim(Publica)[2]

Publica_comuna = tidyr::gather(Publica,date,value,-Comuna) %>% 
  mutate(date = lubridate::ydm(paste0("2019/",date)))

##### For map ####
Publica$Sum = rowSums(Publica[,colnames(Publica)[2:dim_col]],na.rm = T)
Sum_date = colSums(Publica[,colnames(Publica)[2:dim_col]],na.rm = T)

date = lubridate::ydm(paste0("2019/",names(Sum_date)))
total_date = data.frame(date = date,total = Sum_date)


Publica = rbind(Publica,c(Comuna = "Total",Sum_date))


#### GIB Bar Plot ####


seq_breaks = seq(30, max(Sum_date,2),10)
seq_labels = seq(30, max(Sum_date,2),10)

title = latex2exp::TeX(paste0("Número de Carabineros de \\textbf{Civil Activos} en la \\textbf{",reg_label,"}"))

anim <- ggplot(total_date, aes(date, total, fill = total)) +
  geom_col() +
  scale_y_continuous(limits = c(0,80))+
  scale_x_date(date_breaks = "3 days", date_minor_breaks = "1 week",
               date_labels = "%d-%b") +
  scale_fill_distiller(name="N°",palette = "RdYlGn",guide = "colourbar", na.value = "grey",
                       breaks=seq_breaks,labels=seq_labels,limits = c(30,  max(Sum_date,2))) +
  theme_minimal() +
  xlab("Fecha") + ylab("Total") +
  labs(title= title) +
  theme(
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "white"),
    panel.ontop = TRUE
  )
anim
# p +
# transition_states(date, wrap = FALSE) +
#   shadow_mark()

animate(
  anim + transition_states(date, wrap = FALSE) +
    shadow_mark() +
    labs(subtitle = 'Fecha: {closest_state}'),
  width = 1000, height = 600,res = 150,
  renderer = av_renderer(file = paste("tmp/",Region,"_bar.mp4"))
)


library("viridis")           

anim_com <- ggplot(
  Publica_comuna,
  aes(date, value,group = Comuna, color = factor(Comuna))
) +
  geom_line() +
  scale_y_continuous(limits = c(0,20))+
  scale_x_date(date_breaks = "3 days", date_minor_breaks = "1 week",
               date_labels = "%d-%b") +
  # scale_color_discrete(name="Comuna") +
  scale_color_viridis(name="Comuna",discrete = TRUE, option = "D")+
  scale_fill_viridis(discrete = TRUE) +
  theme_minimal() +
  
  xlab("Fecha") + ylab("Total") +
  labs(title= title) +
  theme(legend.position = "top")

anim_com

animate(
  anim_com + 
    geom_point() +
    transition_reveal(date),width = 1000, height = 600,res = 150,
  renderer =  av_renderer(file = paste("tmp/",Region,"_lines.mp4"))
)
