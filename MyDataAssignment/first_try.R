library(tidyverse)
library(readxl)

## run from head of the repository
dd0 <- (read_excel("MyDataAssignment/SocialPhotometry1st5SniffData_RCAMP.xlsx",
                   col_types = "text")
    ## column 'J' has asterisks at the end
    ## it would be better to go upstream and figure out why those are
    ## there/get rid of them (are they meaningful???)
    ## but in the meantime this is a hack to get rid of them:
    ## 1. read in _everything_ as character strings
    ## 2. delete '*' from the strings
    ## 3. turn everything into numeric
    |> mutate(across(everything(), ~ stringr::str_remove_all(., fixed("*"))))
    |> mutate(across(everything(), as.numeric))
    |> rename(time = "Time(s)")
    |> pivot_longer(-time)
)

## I'm going to assume that 'N-N' is a particular behaviour
## it will be easier to deal with this if it *doesn't* contain a hyphen
## so I'm convert it to 'N_N' (this may be a mistake ...)
dd1 <- (dd0
    |> mutate(across(name, ~stringr::str_replace(., "N-N", "N_N")))
    |> separate(name, into = c("mouse", "behav_no", "behaviour"),
                sep = "-")
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

unique(dd3$behaviour)
## [1] "AnoChasing"     "AnoMutual"      "N_N"            "Body"          
## [5] "Body/Ano"       "Ano"            "Ano/Body"       "N_N/AnoChasing"
## [9] "BodyMutual"

## from here I'm not sure what to do.
## * What do the various abbreviations mean?
## * I can see two activities coded as "Mutual" -- is everything else
##   unidirectional?
## * where is the metadata that tells me the sex of each mouse?

