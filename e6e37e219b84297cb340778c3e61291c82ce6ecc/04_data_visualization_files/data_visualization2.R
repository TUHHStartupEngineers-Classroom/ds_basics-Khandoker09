"
Name : Data visualization challage-2
Author: Khandoker Tanjim Ahammad
date: 07.05.21

"

# import dependencies 

library(tidyverse)
library(lubridate)
library(ggthemes)
library(ggrepel)
library(purrr)
library(maps)


# load data and preprocess 

covid_data_tbl <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")%>%
mutate(mort_rate = total_deaths/population)%>%
group_by(location) %>% summarise(Mortality_Rate = last(mort_rate))%>%
select(location, Mortality_Rate)%>%
mutate(location = case_when(

#  join the lat/long data and the covid data   
  
location == "United Kingdom" ~ "UK",
location == "United States" ~ "USA",
location == "Democratic Republic of Congo" ~ "Democratic Republic of the Congo",
TRUE ~ location
    
  )) %>%
distinct()
world <- map_data("world")
covid_coord <- merge(x=world,y=covid_data_tbl, by.x = "region", by.y = "location")%>%
select(region, long,lat,Mortality_Rate)

# creating world map plot using geom map

covid_coord %>% ggplot() + 
geom_map(aes(x = long, y = lat, map_id = region, fill = Mortality_Rate), map = world) +

# labeling the plot
  
scale_fill_continuous(labels = scales::percent_format(accuracy = 0.001), low = "navyblue", high = "turquoise1") +
labs(
  title = "Confirmed COVID-19 deaths relative to the size of the population",
  subtitle = "Around 3 Million confirmed Covid-19 deaths worldwide",
  caption = "Date: 05/07/2021") +


theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank()) +

theme(title = element_text(face = "bold", color = "gray15"),
      legend.position  = "right")


