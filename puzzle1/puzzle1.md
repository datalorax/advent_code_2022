---
title: "Advent of Code"
subtitle: "Day 1"
format: html
execute:
  keep-md: true
  message: false
  warning: false
---



# Solution in R


```{.r .cell-code}
library(tidyverse)

d <- tibble(
  calories = parse_number(readLines(here::here("puzzle1", "data.txt")))
)
```

## Part 1


```{.r .cell-code}
total_calories_by_elf <- d |>
  mutate(elf = cumsum(is.na(calories))) |>
  group_by(elf) |>
  summarize(total_calories = sum(calories, na.rm = TRUE)) 

total_calories_by_elf |>
  filter(total_calories == max(total_calories))
```


```
# A tibble: 1 × 2
    elf total_calories
  <int>          <dbl>
1   196          69501
```

## Part 2

```{.r .cell-code}
total_calories_by_elf |>
  arrange(desc(total_calories)) |>
  slice(1:3) |>
  summarize(top_three_total = sum(total_calories))
```


```
# A tibble: 1 × 1
  top_three_total
            <dbl>
1          202346
```



# Solution in python

```{.python .cell-code}
import pandas as pd
import re
```

```{.python .cell-code}
with open("data.txt") as f:
  d = f.readlines()

d = pd.DataFrame(
  [re.sub("\n", "", x) for x in d],
  columns=['calories']
)

d['calories'] = pd.to_numeric(
  d['calories'],
  errors = 'coerce'
)

d['elf'] = d['calories'].isna().astype(int).cumsum()

total_calories_by_elf = (
  d
  .groupby(['elf'])
  .sum()
)
```


## Part 1

```{.python .cell-code}
total_calories_by_elf.loc[
  total_calories_by_elf['calories'] == max(
    total_calories_by_elf['calories']
  )
]
```

```
     calories
elf          
196   69501.0
```


## Part 2

```{.python .cell-code}
(
  total_calories_by_elf
  .sort_values(
    by = ['calories'],
    ascending = False
  )
  .iloc[0:3]
  .sum()
)
```

```
calories    202346.0
dtype: float64
```
