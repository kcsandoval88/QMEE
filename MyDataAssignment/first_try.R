library(tidyverse)
library(readxl)

## run from head of the repository
dd0 <- (read_excel("MyDataAssignment/SocialPhotometry1st5SniffData_RCAMP.xlsx")
    |> rename(time = "Time(s)")
)

## find rows corresponding to -10 to -5 seconds
## (assume we start at -10 ...)

(dd0
    |> filter(time<(-5))
    |> summarise(across(-time, mean))
)

