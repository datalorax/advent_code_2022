---
title: "Advent of Code"
subtitle: "Day 3"
format: html
execute:
  keep-md: true
  message: false
  warning: false
---



# Solution in R

## Part 1




```{.r .cell-code}
library(tidyverse)
d <- read_csv(
  here::here("puzzle3", "data.txt"),
  col_names = "rucksack"
)
```




```{.r .cell-code}
compartment_separate <- function(str) {
  lngth <- nchar(str)
  first <- substr(str, 1, lngth/2)
  second <- substr(str, lngth/2 + 1, lngth)
  c(first, second)
  # tibble(first_compartment = first, second_compartment = second)
}
rs_separated <- lapply(d$rucksack, compartment_separate)

compartments <- tibble(
  compartment1 = vapply(
    rs_separated, 
    `[[`,
    1,
    FUN.VALUE = character(1)
  ),
  compartment2 = vapply(
    rs_separated, 
    `[[`,
    2,
    FUN.VALUE = character(1)
  )
)
```




```{.r .cell-code}
str_to_vec <- function(str) {
  strsplit(str, "")[[1]]
}

str_intersect <- function(...) {
  vecs <- lapply(c(...), str_to_vec)
  Reduce(intersect, vecs)
}

common <- compartments |>
  mutate(common = map2_chr(compartment1, compartment2, str_intersect))
```




```{.r .cell-code}
score_table <- tibble(
  key = c(letters, LETTERS),
  score = 1:52
)

common |>
  left_join(score_table, join_by(common == key)) |>
  summarize(total = sum(score))
```

 
```
# A tibble: 1 × 1
  total
  <int>
1  7889
```




## Part 2




```{.r .cell-code}
by_group <- d |>
  mutate(group = rep(1:100, each = 3)) |>
  nest_by(group)

by_group |>
  mutate(badge = str_intersect(data$rucksack)) |>
  left_join(score_table, join_by(badge == key)) |>
  ungroup() |>
  summarize(total = sum(score))
```

 
```
# A tibble: 1 × 1
  total
  <int>
1  2825
```




# Solution in python
## Part 1




```{.python .cell-code}
import pandas as pd
from functools import reduce
from string import ascii_letters
```




```{.python .cell-code}
d = pd.read_csv("data.txt", names = ['rucksack'])
```




```{.python .cell-code}
def compartment_separate(str):
  lngth = len(str)
  lngth_half = int(lngth / 2)
  return [str[0:lngth_half], str[lngth_half:lngth]]
  
compartments_data = [compartment_separate(rucksack) for rucksack in d['rucksack']]
```




```{.python .cell-code}
def intersect(a, b):
  return a.intersection(b)

def str_intersect(str_vec):
  sets = [set(list(x)) for x in str_vec]
  return list(reduce(intersect, sets))

common = [str_intersect(compartments) for compartments in compartments_data]
```




```{.python .cell-code}
for i in range(0, len(compartments_data)):
  compartments_data[i].extend(common[i])

compartments = pd.DataFrame(
  data = compartments_data,
  columns = ['compartment1', 'compartment2', 'common']
)
```




```{.python .cell-code}
letters = ascii_letters

score_table = pd.DataFrame(
  data = {
    'key': list(letters),
    'score': list(range(1, 53))
  }
)
```




```{.python .cell-code}
compartments = compartments.merge(
  score_table,
  left_on = "common",
  right_on = "key",
  how = "left"
)
```




```{.python .cell-code}
sum(compartments['score'])
```

 
```
7889
```




## Part 2




```{.python .cell-code}
id_list = [[i, i, i] for i in range(1, 101)]

# move the list of lists into a single list
ids = [item for sublist in id_list for item in sublist]

d['group'] = ids
```




```{.python .cell-code}
by_group = dict(list(d.groupby('group')))
badge_data = {key: str_intersect(value['rucksack']) for key, value in by_group.items()}
badge_data_values = badge_data.values()
badge_data_values_list = [item for sublist in badge_data_values for item in sublist]

badge = pd.DataFrame(
  data = {
    "group": badge_data.keys(), 
    "badge": badge_data_values_list
  }
)
```




```{.python .cell-code}
scored = badge.merge(
  score_table,
  left_on = "badge",
  right_on = "key",
  how = "left"
)
sum(scored['score'])
```

 
```
2825
```


