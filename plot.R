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
    data=data %>% filter(`Sample Date`>"2023-01-01") %>% filter(`Sample Date`<"2023-09-15"),
    aes(x = `Sample Date`, y = `Northern \n(copies/mL)`)
) + geom_point() + geom_smooth()

ggsave('mwra-biobot-2023-northern-copies-ml.png')
