"
Name : Data visualization wranling-1+2
Author: Khandoker Tanjim Ahammad
date: 07.05.21

"
# Import dependencies 

library(tidyverse)
library(vroom)
library(data.table)
library(tictoc)

# challenge part 1
# Loading data

col_types_assignee <- list(
  id = col_character(),
  type = col_character(),
  organization = col_character()
)

assignee_tbl <- vroom(
  file       = "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\Patent_data_reduced\\assignee.tsv", 
  delim      = "\t", 
  col_types  = col_types_assignee,
  na         = c("", "NA", "NULL")
)

# converting to a data table
assignee_data_frame <- as.data.table(assignee_tbl %>% rename(assignee_id = id))

assignee_data_frame %>% glimpse()

# importing patent assignee data

col_types_patent_assignee <- list(
  patent_id = col_character(),
  assignee_id = col_character()
  
)

patent_assignee_tbl <- vroom(
  file       = "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\Patent_data_reduced\\patent_assignee.tsv", 
  delim      = "\t", 
  col_types  = col_types_patent_assignee,
  na         = c("", "NA", "NULL")
)

# converting it to a data table

patent_assignee_data_frame <- as.data.table(patent_assignee_tbl)

patent_assignee_data_frame %>% glimpse()

# merging data( assignee and patent assignee)

tic()
combined_data <- merge(x = assignee_data_frame, y = patent_assignee_data_frame, 
                       by    = "assignee_id", 
                       all.x = TRUE, 
                       all.y = FALSE)
toc()

combined_data %>% glimpse()

# Answer to patent dominance question
Patent_Dominance <- combined_data %>%
  
  filter(!is.na(type) & type == 2) %>%
  group_by(organization, type) %>%
  tally(sort = T) %>%
  ungroup() %>%
  arrange(desc(n))
# Patent Dominance: What US company / corporation has the most patents? 
Patent_Dominance

Patent_Dominance_top10 <- head(Patent_Dominance,10)

# challenge part 2
# importing the reduced patent data

col_types_patent <- list(
  id = col_character(),
  date = col_date("%Y-%m-%d"),
  num_claims = col_double()
  
)

patent_tbl <- vroom(
  file       = "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\Patent_data_reduced\\patent.tsv", 
  delim      = "\t", 
  col_types  = col_types_patent,
  na         = c("", "NA", "NULL")
)

patent_tbl

# converting to data frame

patent_data_frame <- as.data.table(patent_tbl %>% rename(patent_id = id)) 


patent_data_frame %>% glimpse()

# merging data( assignee and patent assignee and patent)

tic()
combined_new_data <- merge(x = combined_data, y = patent_data_frame, 
                           by    = "patent_id", 
                           all.x = TRUE, 
                           all.y = FALSE)
toc()

combined_new_data %>% glimpse()

#manipulating data

merged_data <- combined_new_data %>%
  
  select(organization, date, type) %>%
  mutate(year = year(date)) %>%
  filter(year == 2014)

merged_data %>% glimpse()

# Answer to recent patent activity question
# What US company had the most patents granted in August 2014? 
most_patents_2014 <- merged_data %>%
  
  filter(!is.na(type) & type == 2) %>%
  group_by(organization, type, year) %>%
  tally(sort = T) %>%
  ungroup() %>%
  arrange(desc(n))

most_patents_2014

most_patents_2014_top10 <- head(most_patents_2014,10)
# challange part 3
# importing uspc data

col_types_uspc <- list(
  patent_id = col_character(),
  mainclass_id = col_character(),
  sequence = col_character()
)

uspc_tbl <- vroom(
  file       = "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\Patent_data_reduced\\uspc.tsv", 
  delim      = "\t", 
  col_types  = col_types_uspc,
  na         = c("", "NA", "NULL")
)

# converting to a data table
uspc_data_frame <- as.data.table(uspc_tbl)

uspc_data_frame %>% glimpse()

# # merging data( assignee and patent assignee and uspc)

tic()
combined_newest_data <- merge(x = combined_data, y = uspc_data_frame, 
                              by    = "patent_id", 
                              all.x = TRUE, 
                              all.y = FALSE)
toc()

combined_newest_data %>% glimpse()

# what are the top 5 USPTO tech main classes?

top_ten_uspto <- combined_newest_data %>%
  
  select(organization, type, mainclass_id, sequence) %>%
  filter(sequence == 0) %>%
  group_by( mainclass_id) %>%
  tally(sort = T) %>%
  ungroup() %>%
  arrange(desc(n))


top_ten_uspto

top_ten_uspto_top10 <- head(top_ten_uspto,10)

data_wranling1 <- most_patents_2014_top10

write_rds(data_wranling1, "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\data_wranling1.rds")


data_wranling2 <- top_ten_uspto_top10

write_rds(data_wranling2, "F:\\1edutuhh\\business data\\git\\ds_basics-Khandoker09\\data_wranling2.rds")



