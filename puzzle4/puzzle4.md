---
title: "Advent of Code"
subtitle: "Day 4"
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

d <- read_csv(here::here("puzzle4", "data.txt"), col_names = paste0("s", 1:2))

separated <- d |>
  separate(s1, c("s1_lower", "s1_upper"), convert = TRUE) |>
  separate(s2, c("s2_lower", "s2_upper"), convert = TRUE) |>
  mutate(
    fully_contained = 
      ((s1_lower >= s2_lower) & (s1_upper <= s2_upper)) |
      ((s2_lower >= s1_lower) & (s2_upper <= s1_upper))
  ) 
  
separated |>
  count(fully_contained)
```

 
```
# A tibble: 2 × 2
  fully_contained     n
  <lgl>           <int>
1 FALSE             525
2 TRUE              475
```




## Part 2


 

```{.r .cell-code}
separated |>
  mutate(
    partially_contained = (s1_upper >= s2_lower) & (s2_upper >= s1_lower)
  ) |>
  count(partially_contained)
```

 
```
# A tibble: 2 × 2
  partially_contained     n
  <lgl>               <int>
1 FALSE                 175
2 TRUE                  825
```




# Solution in python

## Part 1


 

```{.python .cell-code}
import pandas as pd
```


 

```{.python .cell-code}
d = pd.read_csv("data.txt", sep = ",", names = ['s1', 's2'])
d[['s1_lower', 's1_upper']] = d['s1'].str.split('-', expand = True)
d[['s2_lower', 's2_upper']] = d['s2'].str.split('-', expand = True)

for column in [['s1_lower', 's1_upper', 's2_lower', 's2_upper']]:
  d[column] = d[column].astype('int')  
```


 

```{.python .cell-code}
c1 = ((d['s1_lower'] >= d['s2_lower']) & (d['s1_upper'] <= d['s2_upper']))
c2 = ((d['s2_lower'] >= d['s1_lower']) & (d['s2_upper'] <= d['s1_upper']))

(c1 | c2).sum()
```

 
```
475
```




## Part 2


 

```{.python .cell-code}
partially_contained = (d['s1_upper'] >= d['s2_lower']) & (d['s2_upper'] >= d['s1_lower'])

partially_contained.sum()
```

 
```
825
```

