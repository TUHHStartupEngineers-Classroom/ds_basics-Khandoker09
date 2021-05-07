"
Name : Data visualization challage-1
Author: Khandoker Tanjim Ahammad
date: 07.05.21

"
# Import dependencies 

library(tidyverse)
library(lubridate)
library(ggthemes)
library(ggrepel)
library(purrr)
library(maps)


#load data and preprocess 
covid_data_tbl <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv") %>%
  select(location, date, total_cases) %>%
  filter(location == "Germany" | location == "United Kingdom" | location == "France" | location == "Spain" | location == "United States")%>%
  mutate(cases_dec = scales::dollar(total_cases, big.mark = ".", 
                                    decimal.mark = ",", 
                                    prefix = "", 
                                    suffix = ""))


#challenge 1 : plotting data

covid_data_tbl %>%
ggplot(aes(x = date, y = total_cases, color = location)) +


geom_line(size = 1) +

geom_label_repel(aes(x=date, y=total_cases, label=cases_dec) , 
                 data = covid_data_tbl %>% slice(which.max(total_cases)),
                 vjust = 0.5, 
                 hjust = 0.5,color = "green")+

expand_limits(y = 0) +

scale_y_continuous(labels = scales::dollar_format(scale = 1/1e6,
                                                  prefix = "",
                                                  suffix = "M")) +

scale_x_date(date_labels = "%B %Y", 
             date_breaks = "1 month", 
             expand = c(0,NA)) +
# # labeling the plot
  
labs(
  title = "Confirmed cases Covid-19 around the world",
  subtitle = "As of 07/05/2021",
  x = "Months",
  y = "Cumulative Cases",
  color = "Country or Location"
  )  +
  
  theme_light() +
  theme(title = element_text(face = "bold", color = "Black"),
        legend.position  = "bottom",
        axis.text.x = element_text(angle = 45))