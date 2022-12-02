library(tidyverse)

d <- tibble(
  calories = parse_number(readLines("puzzle1/data.txt"))
)

# part 1
total_calories_by_elf <- d |>
  mutate(elf = cumsum(is.na(calories))) |>
  group_by(elf) |>
  summarize(total_calories = sum(calories, na.rm = TRUE)) 

total_calories_by_elf |>
  filter(total_calories == max(total_calories))

# part 2
total_calories_by_elf |>
  arrange(desc(total_calories)) |>
  slice(1:3) |>
  summarize(top_three_total = sum(total_calories))
