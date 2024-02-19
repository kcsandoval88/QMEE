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
save_path <- "C:/PhD/QMEE/MyDataAssignment/Combined_RCAMP.xlsx"
saveWorkbook(combined_file, file = save_path, overwrite = TRUE)



#Step3: only select the first 5 events
dd2 <- dd1 %<%
  group_by(ID.sniffnumber) %>%
  slice_head(n = 5)

# Gather the data into long format
dd2_long <- dd2 %>%
  gather(key = "Column", value = "Value", -Time)

# Save the modified data to a new excel file for further analysis
write.xlsx(dd2, file = paste("First5Modified_", sheet_name, ".xlsx", sep = ""), rowNames = FALSE)