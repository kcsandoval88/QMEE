My data assignment (in progress)

  Step 1: Calculate the average for each column from -10 to -5 seconds => baseline correction
  
  Step 2: Deduct the baseline correction value to each value in a column, and for each column. => data corrected
  
  Step 3: Only select the 1st 5 activities for each mouse
  
  Step 4: Identify the type of sniff for each activity
  
  Step 5: Separate sniffs by type of sniff "mutual" or "unidirectional"
  
  Step 6: Separate sniffs by sex "female" or "male"
  
  
Data file description:

  - The csv file "SocialPhotometryData_RCAMP" contains the Raw data of experimental mice F69, H25, H28, H82.
  
  - The 1st column is time(s) from -10 to 10 seconds.
  
  - Each column depicts 1 sniff interaction from the experimental mouse to the stimulus mouse.
  
  - Mice have different number of sniff activities (eg: F69 has 6 sniff activites, H25 has 5 sniff activites).
  
  - In the data file I have also left the manual calculation I had done for the baseline correction value (step 1) and data corrected (step 2). [This can be used for confirmation or I can delete if unnecessary.]
  
  
  - The csv file "SocialPhotometry1st5SniffData_RCAMP" contains the data corrected of only the 1st 5 sniffs of experimental mice F69, H25, H28, H82.
  
  - In the 1st row, titles for each column include "mouseID-NumberOfTheSniff-TypeOfSniff" (eg: F69-3-AnoMutual => mouse id = F69, number of sniff = 3rd sniff activity, type of sniff = Ano mutual).