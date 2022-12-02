---
title: "Advent of Code"
subtitle: "Day 2"
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
d <- read_delim(
  here::here("puzzle2", "data.txt"),
  delim = " ",
  col_names = c("opponent", "you")
)
```


```{.r .cell-code}
shape_score <- tibble(
  you = c("X", "Y", "Z"),
  shape_score = 1:3
)
```


```{.r .cell-code}
d
```

```
# A tibble: 2,500 × 2
   opponent you  
   <chr>    <chr>
 1 A        Z    
 2 A        Z    
 3 C        Y    
 4 A        X    
 5 A        X    
 6 A        Z    
 7 C        X    
 8 A        X    
 9 C        Y    
10 A        Z    
# … with 2,490 more rows
```


```{.r .cell-code}
key <- expand.grid(
    you = LETTERS[24:26], 
    opponent = LETTERS[1:3]
  ) |>
  mutate(result_score = c(3, 6, 0, 0, 3, 6, 6, 0, 3))
```

```{.r .cell-code}
d |>
  left_join(shape_score) |>
  left_join(key) |>
  mutate(score = shape_score + result_score) |>
  summarize(total = sum(score))
```

```
# A tibble: 1 × 1
  total
  <dbl>
1 12855
```


## Part 2


```{.r .cell-code}
needed_outcome <- tibble(
  you = LETTERS[24:26],
  result = c("lose", "draw", "win")
)
```

```{.r .cell-code}
key <- key |>
  mutate(
    result = case_when(
      result_score == 0 ~ "lose",
      result_score == 3 ~ "draw",
      TRUE ~ "win"
    )
  ) 
```

```{.r .cell-code}
d |>
  left_join(needed_outcome) |>
  select(-you) |>
  left_join(key, join_by(opponent, result)) |>
  left_join(shape_score) |>
  mutate(score = shape_score + result_score) |>
  summarize(total = sum(score))
```

```
# A tibble: 1 × 1
  total
  <dbl>
1 13726
```

# Solution in python

```{.python .cell-code}
import pandas as pd
import numpy as np
```

```{.python .cell-code}
d = pd.read_csv(
  "data.txt",
  delim_whitespace = True,
  names = ['opponent', 'you']
)
```


## Part 1

```{.python .cell-code}
shape_score_data = {
  "you" : ["X", "Y", "Z"],
  "shape_score" : [1, 2, 3]
}
shape_score = pd.DataFrame(data = shape_score_data)
```

```{.python .cell-code}
comparisons = [(o, y) for o in ["A", "B", "C"] for y in ["X", "Y", "Z"]]
key = pd.DataFrame(data = comparisons, columns = ['opponent', 'you'])
key['result_score'] = [3, 6, 0, 0, 3, 6, 6, 0, 3]
```

```{.python .cell-code}
scored = d.merge(
  shape_score,
  on = 'you',
  how = 'left'
).merge(
  key,
  on = ['opponent', 'you'],
  how = 'left'
)
```

```{.python .cell-code}
total = scored['shape_score'] + scored['result_score']
sum(total)
```

```
12855
```


## Part 2

```{.python .cell-code}
needed_outcome_data = {
  "you" : ["X", "Y", "Z"],
  "result" : ["lose", "draw", "win"]
}
needed_outcome = pd.DataFrame(data = needed_outcome_data)
```

```{.python .cell-code}
conditions = [(key['result_score'] == 0), (key['result_score'] == 3)]
output = ['lose', 'draw']

key['result'] = np.select(conditions, output, default = 'win')
```

```{.python .cell-code}
scored_new = (
  d
  .merge(
    needed_outcome,
    on = 'you',
    how = 'left'
  )
  .drop('you', axis = 1)
  .merge(
    key,
    on = ['opponent', 'result'],
    how = 'left'
  )
  .merge(
    shape_score,
    on = 'you',
    how = 'left'
  )
)
```

```{.python .cell-code}
total_new = scored_new['shape_score'] + scored_new['result_score']
sum(total_new)
```

```
13726
```
