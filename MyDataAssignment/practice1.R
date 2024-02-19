library(tidyverse)
library(openxlsx)


# Define a function to process each sheet
process_sheet <- function(sheet_name) {
  cat("\nProcessing sheet:", sheet_name, "\n")
  
## run from head of the repository
  dd0 <- read.xlsx("MyDataAssignment/SocialPhotometryData_RCAMP.xlsx", sheet = sheet_name)

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


# Save the modified data to a new excel file for further analysis
write.xlsx(dd1, file = paste("MyDataAssignment/Modified_", sheet_name, ".xlsx", sep = ""), rowNames = FALSE)

# Graph my baseline corrected dataset
library(ggplot2)
library(tidyr)

# Gather the data into long format
dd1_long <- dd1 %>%
  gather(key = "Column", value = "Value", -Time)

# Filter columns that start with "F69" - code to graph only one mouse
#dd1_filtered <- dd1_long %>%
 # filter(grepl("^F69", Column))

# Create a line plot for all columns
ggplot(dd1_long, aes(x = Time, y = Value, color = Column)) +
  geom_line() +
  labs(title = "Calcium activity of oxytocin neurons during social interaction",
       x = "Time",
       y = "ZScore",
       color = "Column") +
  theme_minimal()
}

# Specify the sheet names
sheet_names <- c("RCAMP_FAM", "RCAMP_UNFAM")

# Apply the process_sheet function to the specified sheets
for (sheet_name in sheet_names) {
  process_sheet(sheet_name)
}

library(tidyverse)
library(openxlsx)



# Specify the file paths for the cleaned data
file_path_fam <- "MyDataAssignment/Cleaned_RCAMP_FAM.xlsx"
file_path_unfam <- "MyDataAssignment/Cleaned_RCAMP_UNFAM.xlsx"

# Read the cleaned data from both files
cleaned_data_fam <- read.xlsx(file_path_fam)
cleaned_data_unfam <- read.xlsx(file_path_unfam)

# Create a new Excel workbook
combined_file <- createWorkbook()

# Add the cleaned data from RCAMP_FAM as the first sheet
addWorksheet(combined_file, sheetName = "RCAMP_FAM")
writeData(combined_file, sheet = "RCAMP_FAM", cleaned_data_fam)

# Add the cleaned data from RCAMP_UNFAM as the second sheet
addWorksheet(combined_file, sheetName = "RCAMP_UNFAM")
writeData(combined_file, sheet = "RCAMP_UNFAM", cleaned_data_unfam)

# Save the combined Excel file
save_path <- "C:/PhD/QMEE/MyDataAssignment/Cleaned_RCAMP.xlsx"
saveWorkbook(combined_file, file = save_path, overwrite = TRUE)

# Delete the separate files
unlink(c(file_path_fam, file_path_unfam))

#next step in a different R script