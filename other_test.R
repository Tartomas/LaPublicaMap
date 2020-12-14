
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
# filename = paste0(Region,"_test_sum.png")
# png(filename = filename, w = 5, h = 7, units = "in", res = 150)
# plot(shape["PNI"] , key.pos = 1,axes = TRUE, 
#      key.width = lcm(1.5), key.length = 1.0,
#      nbreaks = 10,pal = colores,
#      breaks = breaks,
#      at = breaks)
# # close the png file
# dev.off()

# library(RgoogleMaps)
# # define Lat and Lon
# 
# Lat <- c(-33.4,-33.5)
# Long <- c(-70.5,-70.8)
# # get the map tiles 
# # you will need to be online
# MyMap <- MapBackground(lat=Lat, lon=Long, maptype = "satellite",zoom = 10)
# PlotOnStaticMap(MyMap)


# library(tmap)
# 
# filename = paste0(Region,"_test_tmap_classic_sum.png")
# png(filename = filename, w = 5, h = 7, units = "in", res = 150)
# qtm(shape["PNI"], fill = "red", style = "natural")
# 
# qtm(shape, fill="PNI", text="Comuna", text.size=0.5, 
#     format="World_wide", style="classic", 
#     text.root=5, fill.title="PNI")
# 
# dev.off()
# 
# filename = paste0(Region,"_test_tmap_sum.png")
# png(filename = filename, w = 5, h = 7, units = "in", res = 150)
# 
# tm_shape(shape) +
#   tm_polygons("PNI", title = "2020-30-01", palette = colores, 
#               breaks = breaks, 
#               legend.hist = T) +
#   tm_scale_bar(width = 0.12,position = c(0.05, 0.5)) +
#   tm_compass(position = c(0.05, 0.6)) +
#   tm_layout(frame = F, 
#             title.size = 2, 
#             title.position = c(0.55, "top"), 
#             legend.outside = T,legend.stack = "vertical",
#             legend.hist.size = 0.9,legend.hist.width = 1)
# 
# # close the png file
# dev.off()
