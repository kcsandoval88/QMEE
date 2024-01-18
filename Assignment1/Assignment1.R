#Katy Celina Sandoval QMEE Assignment 1

library(readr)

srp <- read.csv(url("https://github.com/kcsandoval88/QMEE/blob/ff970eab46cb82d87143e147b303a498d101a8dc/Assignment1/PeaksSocialPhotometryData_RCAMP.csv"))

#check the structure of my data

str(srp)

#For this assignment purpose, I am assuming my z-score variable is normally distributed and I want to compare z-scores between male and female mice

peak<-subset(srp, Group == "Zscore")
sex<-subset(srp, Group == "Sex")

srp.t.test<-t.test(z_scores ~ sex, data = srp)

#print the t-test result

print(srp.t.test)

