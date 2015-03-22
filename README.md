# Getting_and_Cleaning_Data
#Final Project for Getting and Cleaning Data Course
## Help File for the run_Analysis.r Macros for Cleansing and Merging the Test and Training Data Sets
##
##
## Summary Steps for Preparing the Data Sets
##  1. Install the required R packages to perform the functions and Set Constants
##  2. Create a measurements data frame
##    a. Cleanse and create a unique list of column names
##       Note: Cleansed Column Names to Remove or Replace Special Characters, such as Parens, Minus, Space
##             Inserted Underscore as separator.  In Future, may remove Underscores, if customer desires, as some Stat Packages may not accept underscores
##             Inserted Leading Numeric to Variables to Ensure Uniqueness; No Specific Customer Requirement for Column Names, so it was left it; Can remove in future, if customer desires, using grep
##	  b. Read Training and Test Measurements, then Bind in one Data Frame
##	  c. Assign Column names to the Combined Data Frame
##	  d. Filter columns by name that contains upper or lower case "mean" or "std" and save in a new dataframe
##	3. Create a subjects data frame
##	  a. Read in the subjects data for training and test, then bind them
##	  b. Rename the column name to subjects
##	4. Create an activity data frame with descriptive names rather than codes
##	  a. Read a short reference data table that contained the activity codes with descriptive names
##	  b. Read in the training and test data files into data frames with the activity codes
##	  c. Append a sequence number to all the activity codes
##	  d. Merge the Descriptive activity names to the Activity code data frame
##	  e. Resort the new activity data frame to ensure that any issue with merge resorting data is prevented
##  5. Bind the 3 dataframes (Subjects, Descriptive Activities, Measurements with Mean & Std) to create one tidy data frame
##	  a. Bind the 3 data frames into one data frame
##	  b. Output the data frame into a csv file
##	  c. Created a Codebook using the STR function
##	  d. Minor adjustment of the Codebook file to improve readability
##	6. Create a Data Frame of Means by Subjects and Activities
##	  a. Group the combined data frame from Step 5 by two variables (Subjects and Activities)
##	  b. Summarize All Means for all Variables
##	  c. Output the Means into a CSV file
##
## Completed Assignment and Followed Instructions to Post the Result Files, Readme, Codebook into GitHub
