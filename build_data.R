
library(faraway)
library(dplyr)
library(readr)
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

write_csv(dat1, "data/intro-r/diabetes.csv")
write_csv(dat2, "data/intro-r/chol.csv")
