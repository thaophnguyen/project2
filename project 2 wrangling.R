# bechdel dataset
raw_bechdel <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-09/raw_bechdel.csv')
View(raw_bechdel)

# creates binary variables for each bechdel criteria (0 = does not meet any, 1 = has at least two named women in it, 2 = who talk to each other, 3 = about something besides a man.)
raw_bechdel2 <- raw_bechdel %>% 
  mutate(zero = ifelse(rating==0, 1, 0)) %>% 
  mutate(one = ifelse(rating>=1, 1, 0)) %>%
  mutate(two = ifelse(rating>=2, 1, 0)) %>%
  mutate(three = ifelse(rating==3, 1, 0)) %>%
  select(-2) %>%
  rename(id = 'imdb_id')

# add 'tt' to imdb id
raw_bechdel2$id <- sub("^", "tt", raw_bechdel2$id )

# joined dataset from project 1
View(join3)

# keeps only movie types, remove adult films, remove tv show-related columns
movie <- join3 %>% 
  filter(type == 'movie') %>%
  filter(isAdult == 0) %>% 
  select(-originalTitle,-isAdult) %>%
  rename('title' = 'title.x') %>% 
  mutate_all(funs(str_replace(., "\\\\N", NA_character_))) %>%
  select(1:4, 6:9)
  
# makes numerical columns numeric
cols_num <- c(4:6, 8:9)
movie[cols_num] <- sapply(movie[cols_num], as.numeric)

# left join raw_bechdel2 and movie dataset
bechdel <- left_join(raw_bechdel2, movie, by = 'id')
bechdel <- bechdel %>% select(-'type') %>% select(-'title.y') %>% select(-'startYear')
bechdel <- bechdel %>% filter(year >= 1970)


