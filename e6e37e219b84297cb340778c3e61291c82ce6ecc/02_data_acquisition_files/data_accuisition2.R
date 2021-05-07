"
Name : data accuisition1
Author: Khandoker Tanjim Ahammad
date: 07.05.21

"
# Import dependencies 

library(tidyverse) 
library(rvest)     
library(xopen)     
library(jsonlite)  
library(glue)      
library(stringi)   

# load data from rose bike

url_home          <- "https://www.rosebikes.de/fahrr%C3%A4der/e-bike"

# Read in the HTML for the entire webpage

html_home         <- read_html(url_home)

# Web scraping the bike models 
bike_model <- html_home %>% 
  
  html_nodes(css = ".catalog-category-bikes__title-text") %>% 
  html_text() %>%
  
  str_remove_all("\n") 

bike_model

# scraping bike prices

bike_price <- html_home %>%
  
  html_nodes(css = ".catalog-category-bikes__price-title") %>%
  html_text() %>%
  
  str_remove_all("\\.") %>%
  stringr::str_replace_all(pattern = "\nab ", replacement = "") %>%
  stringr::str_replace_all(pattern = "\n", replacement = "") 

bike_price

# merging the two tables into one

data_accuisition2 <- tibble(bike_model, bike_price)
data_accuisition2 <- data_accuisition2 %>% mutate(bike_price = as.character(gsub("€", "", bike_price)))
d<-data_accuisition2
d$bike_price <- as.character(gsub("ab","",d$bike_price))
d$bike_price <- as.character(gsub(",","",d$bike_price))
data_accuisition2 <- d

# save the data into readable format like csv or rds 

write_rds(data_accuisition2, "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\data_accuisition2.rds")
write.csv(x=data_accuisition2, file="F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\data_accuisition2.csv")


