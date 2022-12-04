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


::: {.cell}

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

::: {.cell-output .cell-output-stdout}
```
# A tibble: 2 × 2
  fully_contained     n
  <lgl>           <int>
1 FALSE             525
2 TRUE              475
```
:::
:::


## Part 2


::: {.cell}

```{.r .cell-code}
separated |>
  mutate(
    partially_contained = (s1_upper >= s2_lower) & (s2_upper >= s1_lower)
  ) |>
  count(partially_contained)
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 2 × 2
  partially_contained     n
  <lgl>               <int>
1 FALSE                 175
2 TRUE                  825
```
:::
:::
