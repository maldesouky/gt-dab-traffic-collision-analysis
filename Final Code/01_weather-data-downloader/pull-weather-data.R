#
# pull-weather-data.R
#
# This script calls weather API to pull relevant weather data for
# crashes in crashes-cleaned table.
# 
# This file requires an API call table from the database.
# This table provides coordinates, API call for these coordinates.
# This will require using purchasing an API key.
#
# Server: Microsoft SQL Server
# Database: nyc-collisions
# Data Table: crashes-weather-uncalled-api
#
# For a data sample, please take a look at sample-api-call-table.csv
#

# set working directory to current file's path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# clear environment
rm(list = ls())

# needed libraries
library(RODBC)
library(dplyr)
library(foreach)
library(doParallel)
library(RCurl)
library(stringr)

# open connection - database: nyc-collisions
db.nyc <- odbcDriverConnect('driver={SQL Server};server=localhost;database=nyc-collisions;trusted_connection=true')
db.nyc.csv <- "zeft.csv"


# query API calls. as.is is added because sqlQuery fails to query views without it
api.call.df <- sqlQuery(db.nyc, 'select * from [crashes-weather-uncalled-api]', as.is = TRUE)

# function to pull weather record for a specific api call
update_weather_record <- function(dbConn, calling_record){
  result <- tryCatch({
    httpsConn <- getURL(calling_record$API_CALL, ssl.verifypeer = FALSE)
    w <- read.csv(textConnection(httpsConn)) 
    
    w <- cbind(calling_record[, c('COLLISION_ID', 'CRASH_DATETIME',
                                  'LATITUDE', 'LONGITUDE', 'ZIPCODE')], w)
    
    write.table(w, file = db.nyc.csv, append = TRUE, quote = TRUE, sep = '\t',
                col.names = FALSE, row.names = FALSE)
    
    #sqlSave(dbConn, w, tablename = 'crashes-cleaned-weather', append = TRUE, rownames = FALSE)
    
    return(c("SUCCESS", w, ""))
    
  }, error=function(error_message) {
    return(c("FAILED", w, error_message))
    
  })
}

#nrow(api.call.df)
for(i in 11:1000) {
  if (api.call.df[i,]$API_CALL != "COMPLETED"){
    
    r <- update_weather_record(db.nyc, api.call.df[i,])
    if(r[1] == "SUCCESS") {
      api.call.df[i,]$API_CALL <- "COMPLETED"
    } else {
      api.call.df[i,]$API_CALL <- "FAILED"
    }
    
  }
}

# q <- update_weather_record(db.nyc, api.call.df[1,])

# close connection
odbcCloseAll()
