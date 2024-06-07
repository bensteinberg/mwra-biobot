source("tidy.R")

ggplot(
  data = tidied %>%
    drop_na(Copies.mL) %>%
    filter(Sample.Date > "2022-11-01"),
  aes(x = Sample.Date, y = Copies.mL)
) +
  geom_point() +
  geom_smooth(method = "loess", span = 0.3) +
  scale_x_date(guide = guide_axis(angle = 45)) +
  facet_wrap(~ Region) +
  ggtitle("MWRA Biobot COVID-19 RNA copies/mL, November 2022-")

ggsave("mwra-biobot-2023-copies-ml.png")
