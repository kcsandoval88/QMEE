#Step3: only select the first 5 events
library(openxlsx)
## BMB: I'd normally use readxl::read_excel(), but openxlsx seems OK too
## (it looks like read_excel is faster, but that doesn't matter here ...)
## https://stackoverflow.com/questions/44538199/fast-way-to-read-xlsx-files-into-r
## https://stackoverflow.com/questions/7049272/importing-excel-files-into-r-xlsx-or-xls
library(dplyr)
library(tidyr) ## BMB: need this for gather()/spread() (or just import the whole tidyverse)

# Define a function to process each sheet
process_sheet <- function(sheet_name) {
  cat("\nProcessing sheet:", sheet_name, "\n")
  
  # Read the combined data
  dd2 <- read.xlsx("MyDataAssignment/Cleaned_RCAMP.xlsx", sheet = sheet_name)

  ## BMB: pivot_longer is now preferred to gather() (and pivot_wider() to spread()),
  ##    but you can still use gather() if you'd rather
  dd3 <- dd2 %>%

      gather(key = "Column", value = "Value", -Time) %>%
      separate(Column, into = c("ID", "Event"), sep = "\\.") %>%
      filter(as.numeric(Event) <= 5) %>%  ## BMB: might use top_n()
      spread(key = "Event", value = "Value")

  ## Save the modified data to a new Excel file
  write.xlsx(dd3, file = paste("MyDataAssignment/First5_", sheet_name, ".xlsx", sep = ""), rowNames = FALSE)
}

# Specify the sheet names
sheet_names <- c("RCAMP_FAM", "RCAMP_UNFAM")

# Apply the process_sheet function to the specified sheets
for (sheet_name in sheet_names) {
  process_sheet(sheet_name)
}

## BMB: all library() calls should be at the top of the file
library(tidyverse)
library(openxlsx)

# Specify the file paths for the cleaned data
file_path_fam <- "MyDataAssignment/First5_RCAMP_FAM.xlsx"
file_path_unfam <- "MyDataAssignment/First5_RCAMP_UNFAM.xlsx"

# Read the cleaned data from both files
first5_data_fam <- read.xlsx(file_path_fam)
first5_data_unfam <- read.xlsx(file_path_unfam)

## BMB: check.names=FALSE prevents event numbers from getting mangled to X1, X2, ...
first5_both <- rbind(data.frame(Type_Stim = "Unfamiliar", first5_data_unfam, check.names = FALSE),
                     data.frame(Type_Stim = "Familiar", first5_data_fam, check.names = FALSE))
                     
## # Create a new Excel workbook
## combined_file <- createWorkbook()

## # Add the cleaned data from RCAMP_FAM as the first sheet
## addWorksheet(combined_file, sheetName = "RCAMP_FAM")
## writeData(combined_file, sheet = "RCAMP_FAM", first5_data_fam)

## # Add the cleaned data from RCAMP_UNFAM as the second sheet
## addWorksheet(combined_file, sheetName = "RCAMP_UNFAM")
## writeData(combined_file, sheet = "RCAMP_UNFAM", first5_data_unfam)

## BMB: NO absolute paths!! Please!!
# Save the combined data set
save_path <- "MyDataAssignment/first5_RCAMP.xlsx"
write.xlsx(first5_both, file = save_path, overwrite = TRUE)

## BMB: if you're going to delete the files anyway, you should probably just
## use the cleaned data as R objects rather than writing them out and then reading
## them back in again.
## I'd only keep them if you want to use the cleaned excel files for something else (e.g. if you
## want to examine them in Excel or in some other program, outside of R)

## Also, it will generally be better to save results as CSV (least-common-denominator, can be read
## by almost anything) *or* RDS (R-specific, can store more information about variables, faster to read)
## rather than XLSX.  You should only use XLSX if you *must* have the features offered by XLSX (e.g.
## coloring cells, annotations), but be aware that these are dangerous because they can't be used within
## a pipeline (i.e. they won't be preserved when you read data back into R -- it's theoretically possible,
## but a huge pain, and a bad idea)

## Delete the separate files
## unlink(c(file_path_fam, file_path_unfam))
