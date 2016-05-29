
library(faraway)
library(gapminder)
library(dplyr)
library(readr)

data(gapminder)

write_csv(gapminder, "intro-r/all-gapminder.csv")

for(this_year in unique(gapminder$year))
    gapminder %>%
    filter(year == this_year) %>%
    write_csv(paste0("intro-r/gapminder-",this_year,".csv"))

data(diabetes)

dat <- diabetes %>%
    transmute(
        subject = factor(paste0("S",id)),
        glyhb, chol, location, age, gender, height, weight, frame
    )

set.seed(42)

dat1 <- dat %>%
    select(-chol) %>%
    filter(runif(n()) < 0.9)

dat2 <- dat %>%
    select(subject, chol) %>%
    filter(runif(n()) < 0.9)

write_csv(dat1, "intro-r/diabetes.csv")
write_csv(dat2, "intro-r/chol.csv")
