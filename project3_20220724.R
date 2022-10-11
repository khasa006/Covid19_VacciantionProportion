# Project 3
# Kazi Tanvir Hasan
# 2022-07-24

library(readxl)
library(lubridate)
library(tidyverse)

# get the names of all the data files
# getwd()
dataFile_char <- list.files("data_CDC_raw/", pattern = ".xlsx")
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
###  Make it a Function  ###
ImportSFL <- function(
    filePath_char,
    sheetName = "Counties",
    FIPScode_int = c(12086, 12011, 12099)) {
  
  # Document
  out_df <- 
    readxl::read_xlsx(
      path = filePath_char,
      sheet = sheetName,
      skip = 1
    ) %>%
    filter(`FIPS code` %in% FIPScode_int)
  
  # this assumes an 8-digit date in the file name (assuming YYYYMMDD)
  out_df$Date <- ymd(str_extract(filePath_char, pattern = "\\d{8}"))
  out_df
  
}


# Test
ImportSFL(dataPath_char[1]) # "data/Community_Profile_Report_20220419.xlsx"


###  Apply the Function  ###
data_df <- map(
  .x = dataPath_char,
  .f = ImportSFL
) %>% 
  map(~{ mutate(.x, across(`FEMA region`, as.double)) }) %>%
  bind_rows() %>% 
  select(
    Date,
    County, 
    `People who are fully vaccinated - ages 65+`, 
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



CountyPopulation2021_df <- read_excel(
  "county_population_20210515.xlsx", 
  skip = 4
) %>% 
  rename(
    County = Agegroup2, 
    `65-74` = `65-74...36`, 
    `75-84` = `75-84...37`,
    `85+` = `85+...38`
  ) %>% 
  filter(County %in% c("Miami-Dade", "Broward", "Palm Beach")) %>% 
  mutate(
    `65-74` = as.numeric(
      as.character(gsub(",","", `65-74`))
    ),
    `75-84` = as.numeric(
      as.character(gsub(",","", `75-84`))
    ),
    `85+` = as.numeric(
      as.character(gsub(",","", `85+`))
    )
  ) %>% 
  select(County, `65-74`, `75-84`, `85+`) %>% 
  mutate(population = rowSums(across(where(is.numeric)))) %>% 
  mutate(
    County = replace(County, County == "Miami-Dade",  "Miami-Dade County, FL"),
    County = replace(County, County == "Broward",  "Broward County, FL"),
    County = replace(County, County == "Palm Beach",  "Palm Beach County, FL")
  ) %>% 
  select(County, population)



COVID_df <- full_join(data_df, CountyPopulation2021_df, by = "County") %>% 
  mutate(
    `Proportion Vaccinated, 65+` =
      `People who are fully vaccinated - ages 65+` / population
  ) %>% 
  filter(Date > "2021-04-11")

ggplot(data = COVID_df) +
  
  aes(
    x = Date,
    y = `Proportion Vaccinated, 65+`,
    color = County
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_color_brewer(palette = "Dark2") +
  labs (
    title = "65+ Vaccinated Proportion",
    x = "Date",
    y = "Proportion Vaccinated, 65+"
  ) +
  theme(legend.position = "bottom") +
  
  geom_line() 


######## 


CountyPopulation2022_df <- read_excel(
  "Population by Year by County_2022 (1).xlsx", 
  skip = 4
) %>% 
  rename(
    County = Agegroup2, 
    `65-74` = `65-74...36`, 
    `75-84` = `75-84...37`, 
    `85+` = `85+...38`
  ) %>% 
  filter(County %in% c("Miami-Dade", "Broward", "Palm Beach")) %>% 
  mutate(
    `65-74` = as.numeric(
      as.character(gsub(",","", `65-74`))
    ),
    `75-84` = as.numeric(
      as.character(gsub(",","", `75-84`))
    ),
    `85+` = as.numeric(
      as.character(gsub(",","", `85+`))
    )
  ) %>% 
  select(County, `65-74`, `75-84`, `85+`) %>% 
  mutate(population = rowSums(across(where(is.numeric)))) %>% 
  mutate(
    County = replace(County, County == "Miami-Dade",  "Miami-Dade County, FL"),
    County = replace(County, County == "Broward",  "Broward County, FL"),
    County = replace(County, County == "Palm Beach",  "Palm Beach County, FL")
  ) %>% 
  select(County, population)


COVID2022_df <- full_join(data_df, CountyPopulation2022_df, by = "County") %>% 
  mutate(
    `Proportion Vaccinated, 65+` =
      `People who are fully vaccinated - ages 65+` / population
  ) %>% 
  filter(Date > "2021-04-11")

ggplot(data = COVID2022_df) +
  
  aes(
    x = Date,
    y = `Proportion Vaccinated, 65+`,
    color = County
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_color_brewer(palette = "Dark2") +
  labs (
    title = "65+ Vaccinated Proportion",
    x = "Date",
    y = "Proportion Vaccinated, 65+"
  ) +
  theme(legend.position = "bottom") +
  
  geom_line() 
