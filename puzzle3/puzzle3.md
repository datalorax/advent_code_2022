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


::: {.cell}

```{.r .cell-code}
library(tidyverse)
d <- read_csv(
  here::here("puzzle3", "data.txt"),
  col_names = "rucksack"
)
```
:::

::: {.cell}

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
:::

::: {.cell}

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
:::

::: {.cell}

```{.r .cell-code}
score_table <- tibble(
  key = c(letters, LETTERS),
  score = 1:52
)

common |>
  left_join(score_table, join_by(common == key)) |>
  summarize(total = sum(score))
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 1 × 1
  total
  <int>
1  7889
```
:::
:::


## Part 2


::: {.cell}

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

::: {.cell-output .cell-output-stdout}
```
# A tibble: 1 × 1
  total
  <int>
1  2825
```
:::
:::