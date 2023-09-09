library(tidyverse)

data <- read_csv(
    'mwra-biobot.csv',
    comment='#',
    col_types=cols(
        col_date(format = "%m/%d/%Y"),
        col_integer(),
        col_integer(),
        col_integer(),
        col_integer(),
        col_integer(),
        col_integer(),
        col_integer(),
        col_integer()
    )
)

ggplot(
    data=data %>% filter(`Sample Date`>"2022-01-01") %>% filter(`Sample Date`<"2023-09-15"),
    aes(x = `Sample Date`, y = `Northern \n7 day avg`)
) +
    geom_point() +
    geom_smooth(method="gam" , color="red", fill="#69b3a2", se=TRUE)

ggsave('mwra-biobot.png')
