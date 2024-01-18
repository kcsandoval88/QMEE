#Katy Celina Sandoval QMEE Assignment 1

#check directory
getwd()

#import data file
srp <- read.csv("PeaksSocialPhotometryData_RCAMP.csv")

#check the structure of my data

str(srp)

#For this assignment purpose, I am assuming my z-score variable is normally distributed and I want to compare z-scores between male and female mice

srp.t.test<-t.test(Zscore ~ Sex, data = srp)

#print the t-test result

print(srp.t.test)

#t(25.308)=1.8166, p=0.08114
#means: Females=0.02486724, Males=-0.21691981
#No significant difference is observed in the max Zscores between male and female mice