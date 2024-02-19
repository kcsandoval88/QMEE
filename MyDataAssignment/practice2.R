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
saveWorkbook(combined_file, file = "MyDataAssignment/Combined_RCAMP.xlsx", overwrite = TRUE)



# Define a function to process each sheet
process_sheet <- function(sheet_name) {
  cat("\nProcessing sheet:", sheet_name, "\n")
  
  ## run from head of the repository
  dd0 <- read.xlsx("MyDataAssignment/Cleaned_RCAMP_FAM.xlsx", sheet = sheet_name)
  
  #Exploring my data for practice
  glimpse(dd0) #shows data structure & dimension 
  #dim(dd0) #dimension of my data
  #str(dd0) #structure of data frame
  names(dd0) #to know what variables I have in my data
  #in this case I have time and the ID.sniffnumber for each column
  
  
#Step3: only select the first 5 events
dd2 <- dd1 %<%
  group_by(ID.sniffnumber) %>%
  slice_head(n = 5)

# Gather the data into long format
dd2_long <- dd2 %>%
  gather(key = "Column", value = "Value", -Time)

# Save the modified data to a new excel file for further analysis
write.xlsx(dd2, file = paste("First5Modified_", sheet_name, ".xlsx", sep = ""), rowNames = FALSE)