library(tidyverse)
library(readxl)

## run from head of the repository
dd0 <- (read_excel("MyDataAssignment/SocialPhotometryData_RCAMP.xlsx"))

## find first completely empty column (janitor package?)
first_empty <- min(which(apply(is.na(dd0), 2, all)))
dd0 <- dd0[,1:first_empty]

#Exploring my data for practice
glimpse(dd0) #shows data structure & dimension 
        #dim(dd0) #dimension of my data
        #str(dd0) #structure of data frame
names(dd0) #to know what variables I have in my data
        #in this case I have time and the ID.sniffnumber for each column

#Step1: Calculate the average for each column from -5 to -10 seconds

#Filter rows for the time range -5 to -10 seconds
filtered_data<-dd0 %>%
  filter(Time>=-10 & Time<=-5)
#Calculate average for each column
averages<-filtered_data %>%
  summarise(across(everything(), mean, na.rm=TRUE))
print(averages)
        #confirmed correct w/ previous manual calculations done (yay!)

#Step2: Subtract the average of each column from each element in that column
dd1 <- dd0

columns_to_subtract <- grep("^F|^H", names(dd1), value = TRUE)

for (col in columns_to_subtract) {
  dd1[[col]] <- dd1[[col]] - averages[[col]]
}

# Print the modified data
print(dd1)        
       #confirmed correct w/ previous manual calculations done (double yay!)

# Graph my baseline corrected dataset
library(ggplot2)
library(tidyr)

# Gather the data into long format
dd1_long <- dd1 %>%
  gather(key = "Column", value = "Value", -Time)

# Create a line plot for all columns
ggplot(dd1_long, aes(x = Time, y = Value, color = Column)) +
  geom_line() +
  labs(title = "Line Plot of Modified Measurements Over Time",
       x = "Time",
       y = "ZScore",
       color = "Column") +
  theme_minimal()

#Graph only F69 mouse
library(ggplot2)
library(tidyr)

# Gather the data into long format and filter the specified columns
dd1_long <- dd1 %>%
  gather(key = "Column", value = "Value", -Time)

# Filter columns that start with "F69"
dd1_filtered <- dd1_long %>%
  filter(grepl("^F69", Column))

# Create a line plot for columns starting with "F69"
ggplot(dd1_filtered, aes(x = Time, y = Value, color = Column)) +
  geom_line() +
  labs(title = "Line Plot of Modified Measurements (F69) Over Time",
       x = "Time",
       y = "ZScore",
       color = "Column") +
  theme_minimal()
