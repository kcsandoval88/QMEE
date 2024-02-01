library(tidyverse)
library(readxl)

## run from head of the repository
dd0 <- (read_excel("MyDataAssignment/SocialPhotometryData_RCAMP.xlsx"))
## find first completely empty column (janitor package?)
first_empty <- min(which(apply(is.na(dd0), 2, all)))
dd0 <- dd0[,1:first_empty]

## process column names (except the first, which is the time column)
nm1 <- names(dd0)[-1] |> stringr::str_remove("...[0-9]+")
nm1[nm1 == ""] <- NA
nm1 <- zoo::na.locf(nm1)
nm2 <- split(nm1, nm1)
nm2 <- nm2[unique(nm1)]  ## preserve order!
## number sub-lists
nm2 <- lapply(nm2, function(x) paste(x, 1:length(x), sep = "."))
## put it back together
nm3 <- unlist(nm2, use.names = FALSE)

names(dd0) <- c("time", nm3)


## I'm going to assume that 'N-N' is a particular behaviour
## it will be easier to deal with this if it *doesn't* contain a hyphen
## so I'm convert it to 'N_N' (this may be a mistake ...)
dd1 <- (dd0
    |> pivot_longer(-time)
    ## need \\. to split on a *literal* dot
    |> separate(name, into = c("mouse", "behav_no"), sep = "\\.")
    |> mutate(across(behav_no, as.numeric))
)

## Steps 1, 2
dd2 <- (dd1
    |> group_by(mouse, behav_no)
    ## calculate baseline value and subtract
    |> mutate(baseline = mean(value[time<(-5)]),
              value_norm = value - baseline)
    ## rearrange so we can see value/baseline/value_norm more clearly
    |> arrange(mouse, behav_no)
)

## step 3
dd3 <- (dd2
    |> filter(behav_no <= 5)
)
