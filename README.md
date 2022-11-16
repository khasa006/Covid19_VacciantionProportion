---
title: "Analysing the COVID-19 Vaccination Proportion Trend"
author: "Kazi Tanvir Hasan, Lea Nehme and Alvonee Pen"
date: 2021-08-03
---
  

## Introduction
The aim of this project was to apply the skills learned in Advanced R programming class in wrangling, cleaning, and extracting information from the CDC's open data repository related to the Delta variant of COVID-19 Vaccination Proportion trend for three Florida Counties namely Miami-Dade, Palm Beach, and Broward.


## Our Processs
In order to replicate our work, here are the following steps:

1. Go to <https://healthdata.gov/Health/COVID-19-Community-Profile-Report/gqxm-d9w9> and download the `.xlsx` files for the dates of interest. We check for new data files daily. 
2. Save the selected data files to `data_CDC_raw/` (do not change the file names; they should all be in the form "Community_Profile_Report_[YYYYMMDD]_Public.xlsx").
3. Wrangle all the data files in the `data_CDC_raw/` directory: the most recent script (as of 12 January 2022) is `scripts/wrangle_CDC_20220112.R`. Write the first "draft" of the wrangled data to `data_clean/` with this script.
4. After wrangling the data (the first pass), we run the plotting script `scripts/all_plots_20220112.R`. This script includes additional figure-specific data wrangling steps; the resulting data sets are saved to the `COVID19/` directory for use in our Shiny app. Additionally, this script will save two sets of figures (summary and vaccine specific) to the the `figures/` directory.

