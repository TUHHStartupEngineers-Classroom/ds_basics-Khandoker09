"
Name : data accuisition1
Author: Khandoker Tanjim Ahammad
date: 07.05.21

"
# Import dependencies 
library(httr)
library(glue)
library(tibble)
library(jsonlite)
library(tidyverse)
library(purrr)
library(stringr)
library('rvest')
library(xml2)
 
#challenge 1
# load data from api using website 

webpage_url <- "https://apify.com/covid-19"
webpage <- xml2::read_html(webpage_url)
data_accuisition1 <- rvest::html_table(webpage)[[1]] %>% 
  tibble::as_tibble(.name_repair = "unique") # repair the repeated columns
data_accuisition1 %>% dplyr::glimpse(45)

# save data in readable format < csv and rds 

write.csv(x=data_accuisition1, file="F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\covid_data.csv")
write_rds(data_accuisition1, "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\data_accuisition1.rds")