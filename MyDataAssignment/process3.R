## complete steps 4-? of README processing flow
library(openxlsx)
library(tidyverse)

## from practice2.R: first 5 columns for each mouse,
##  adjusted for initial values, long(ish) format
d0 <- (read.xlsx("MyDataAssignment/first5_RCAMP.xlsx")
    |> pivot_longer(-c(Time, ID, Type_Stim), values_to = "value", names_to = "Event")
)                    

d1 <- (read.xlsx("MyDataAssignment/PhotometryMetadata.xlsx")
    |> separate(ID_Event, into = c("ID", "Event"), sep = "\\.")
)

## by merging metadata (d1) and data (d0) we perform steps 4-6 of the README process
with(d0, table(ID, Event, Type_Stim))
with(d1, table(ID, Event, Type_Stim))
## right_join() drops ID/event/type combos for which metadata (d1, the second [right] argument) is missing
## - these are ID/event/type combos that weren't measured
d01 <- (right_join(d0, d1, by = c("ID", "Event", "Type_Stim")))


gg1 <- (ggplot(d01, aes(Time, value, colour = Type_Sniff))
    + geom_line(aes(group=Notes, linetype = Sniff_Direction))
    + facet_grid(Sex ~ Type_Stim))
print(gg1)

### BMB: might want to split processing step here (write out intermediate results to a .RDS file)

get_avg_max <- function(time, value) {
    max_time <- which.max(value) ## should we worry about possibly repeated max values? probably not
    min_time <- max(1,max_time-5)
    max_time <- min(length(time),max_time+5)
    avg <- mean(value[min_time:max_time])
    return(avg)
}
    
d_avgmax <- (d01
    ## could drop Notes (redundant), but good for cross-checking
    ## group_by() everything **except** Time and value
    |> group_by(across(-c(Time, value)))
    |> summarise(avg_max = get_avg_max(Time, value), .groups = "drop")
)

## now we have averaged values
gg1 <- (ggplot(d_avgmax, aes(Type_Sniff, avg_max))
    + geom_point(aes(colour=Type_Stim, shape = Sniff_Direction), size =5)
    + facet_wrap(~Sex)
)
print(gg1)
