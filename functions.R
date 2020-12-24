
addDatePNI = function(shape,comunas, date_lab){
  
  shape$PNI = NA
  
  for(ee in 1:length(comunas)){
    com = comunas[ee]
    
    select_com = which(shape$Comuna==com)
    shape$PNI[select_com] = (Publica[date_lab] %>% unlist())[ee]
  }  
  # Remove nulls NA comunnes
  return(shape)
}


load_data_dict = function(book=NULL,sheet=NULL){
  if(is.null(book) || is.null(book)){
    return(print("Define book or sheet!"))
  }
  
  library(googlesheets4)
  gs4_auth_configure(api_key = Sys.getenv("GGDRIVE_key"))
  gs4_deauth()
  
  sheetdata = read_sheet(ss = book, 
                         sheet = sheet)
  return(sheetdata)
}


create_video = function(region){
  
  files = list.files(path = "tmp",pattern = ".png",full.names = T)
  files = grep(pattern = region,files,value=T)
  
  av::av_encode_video(input = files, 
                      framerate = 1, output = paste0("tmp/",region,".mp4"))
}
