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
