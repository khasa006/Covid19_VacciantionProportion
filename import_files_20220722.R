# Importing Lots of (Excel) Files
# Gabriel Odom
# 2022-07-21

library(readxl)
library(tidyverse)

# get the names of all the data files
getwd()
dataFile_char <- list.files("data_CDC_raw/", pattern = "Community_Profile_Report")
dataPath_char <- paste0("data_CDC_raw/", dataFile_char)


###  Test import of one file  ###
# counties_char <- c(
#   "Miami-Dade County, FL", "Broward County, FL", "Palm Beach County, FL"
# )
# readxl::read_xlsx(
#   path = dataPath_char[1],
#   sheet = "Counties",
#   skip = 1
# ) %>% 
#   # filter(County %in% counties_char)
#   # FL is 12; mdc is 086, broward is 011, pbc is 099
#   filter(`FIPS code` %in% c(12086, 12011, 12099))


###  Make it a Function  ###
ImportSFL <- function(
    filePath_char,
    sheetName = "Counties",
    FIPScode_int = c(12086, 12011, 12099)) {
  # Document
  
  readxl::read_xlsx(
    path = filePath_char,
    sheet = sheetName,
    skip = 1
  ) %>%
    filter(`FIPS code` %in% FIPScode_int)
  
}

# Test
# ImportSFL(dataPath_char[1]) # "data_CDC_raw/Community_Profile_Report_20220419.xlsx"


###  Apply the Function  ###
data_df <- map(
  .x = dataPath_char,
  .f = ImportSFL
) %>% 
  map(\(x) mutate(x, across(`FEMA region`, as.double))) %>%
  bind_rows() %>% 
  select(
    County, 
    `People who are fully vaccinated - ages 65+`, 
    `People who are fully vaccinated as % of population - ages 65+`
  )

###  Exceptions for Dates  ###
# library(lubridate)
# class("20220705")
# lubridate::as_date("20220705", format = "%Y%m%d")
# lubridate::ymd("20220705")
# 
# class(lubridate::ymd("20220705"))
# 
# # logic on dates
# lubridate::ymd("20220705") < lubridate::ymd("20220721")



#### String Split and Create Date Column
x <- str_split(dataFile_char, ".xlsx", simplify = TRUE)
x <- x[, 1]
x <- str_split(x, "_", simplify = TRUE)
date <- x[,4]
date <- ymd(date)