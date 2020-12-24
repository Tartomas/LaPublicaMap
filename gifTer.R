# library(dplyr)
# library(purrr) 
# library(magick)
# library(mgcv)
# 
# http://ryanpeek.org/2016-10-19-animated-gif_maps_in_R/
# chennai_gif <- list.files(pattern = "IX_2019", full.names = F) %>% 
#   map(image_read) %>% 
#   image_join() %>% 
#   # image_annotate("Lake Puzhal, Chennai: June 2018 - June 2019", location = "+10+10", size = 20, color = "white") %>%
#   image_animate(fps=4) %>% 
#   image_write("chennai.gif")

# install.packages("av")
# av::av_demo()

library(av)


files = list.files(path = "IX/",pattern = ".png",full.names = T)
av::av_encode_video(input = files, 
                    framerate = 1, output = "GG1.mp4")

# files = list.files(path = "S2/",pattern = ".jpg",full.names = T)
# av::av_encode_video(input = files, 
#                     framerate = 15, output = "S2.mp4")
# 
# files = list.files(path = "SWIR/",pattern = ".jpg",full.names = T)
# av::av_encode_video(input = files, 
#                     framerate = 15, output = "SWIR.mp4")

