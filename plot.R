source("tidy.R")

ggplot(
    data = tidied %>%
        filter(Sample.Date>"2023-01-01") %>%
        filter(Sample.Date<"2023-09-15"),
    aes(x = Sample.Date, y = Copies.mL)
) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~ Region) +
    ggtitle('MWRA Biobot COVID-19 RNA copies/mL, 2023')

ggsave('mwra-biobot-2023-copies-ml.png')

