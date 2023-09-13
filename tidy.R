library(tidyverse)

data <- read_csv(
  "mwra-biobot.csv",
  comment = "#",
  col_types = cols(
    col_date(format = "%m/%d/%Y"),
    col_integer(),
    col_integer(),
    col_integer(),
    col_integer(),
    col_integer(),
    col_integer(),
    col_integer(),
    col_integer()
  ),
  name_repair = "universal"
)

tidied <- data %>%
  rename_with(~ stringr::str_replace_all(., "\\.+", ".")) %>%
  rename_with(~ stringr::str_replace_all(., "\\.$", "")) %>%
  rename_with(~ stringr::str_replace_all(., "copies.mL", "Copies.mL")) %>%
  pivot_longer(
    cols = !Sample.Date,
    names_to = c("Region", ".value"),
    names_pattern = "(Northern|Southern).(.*)"
  )

write_csv(tidied, "mwra-biobot-tidied.csv")
