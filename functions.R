
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
  sheets_auth_configure(api_key = Sys.getenv("GGDRIVE_key"))
  sheets_deauth()
  
  sheetdata = read_sheet(ss = book, 
                         sheet = sheet)
  return(sheetdata)
}
