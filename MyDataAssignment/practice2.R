#Step3: only select the first 5 events
library(openxlsx)
library(dplyr)

# Define a function to process each sheet
process_sheet <- function(sheet_name) {
  cat("\nProcessing sheet:", sheet_name, "\n")
  
  # Read the combined data
dd2 <- read.xlsx("MyDataAssignment/Cleaned_RCAMP.xlsx", sheet = sheet_name)

dd3 <- dd2 %>%
  gather(key = "Column", value = "Value", -Time) %>%
  separate(Column, into = c("ID", "Event"), sep = "\\.") %>%
  filter(as.numeric(Event) <= 5) %>%
  spread(key = "Event", value = "Value")

# Save the modified data to a new Excel file
write.xlsx(dd3, file = paste("MyDataAssignment/First5_", sheet_name, ".xlsx", sep = ""), rowNames = FALSE)


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
file_path_fam <- "MyDataAssignment/First5_RCAMP_FAM.xlsx"
file_path_unfam <- "MyDataAssignment/First5_RCAMP_UNFAM.xlsx"

# Read the cleaned data from both files
first5_data_fam <- read.xlsx(file_path_fam)
first5_data_unfam <- read.xlsx(file_path_unfam)

# Create a new Excel workbook
combined_file <- createWorkbook()

# Add the cleaned data from RCAMP_FAM as the first sheet
addWorksheet(combined_file, sheetName = "RCAMP_FAM")
writeData(combined_file, sheet = "RCAMP_FAM", first5_data_fam)

# Add the cleaned data from RCAMP_UNFAM as the second sheet
addWorksheet(combined_file, sheetName = "RCAMP_UNFAM")
writeData(combined_file, sheet = "RCAMP_UNFAM", first5_data_unfam)

# Save the combined Excel file
save_path <- "C:/PhD/QMEE/MyDataAssignment/first5_RCAMP.xlsx"
saveWorkbook(combined_file, file = save_path, overwrite = TRUE)

# Delete the separate files
unlink(c(file_path_fam, file_path_unfam))
