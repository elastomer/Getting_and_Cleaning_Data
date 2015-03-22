## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

####   1. Install the required R packages to perform the functions and Set Constants

# Set Working Directory
setwd("~/Coursera/Data Science Specialization/Finding and Cleaning Data/Final Project/Data/UCI HAR Dataset")

# Install Required R Packages
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)
install.packages("stringr")
library(stringr)
install.packages("Hmisc")
library(Hmisc)

####   2. Create a measurements data frame

# Read in features.txt which is the raw data for the Measurement Variables
MeasColNames <- read.table("features.txt",header = FALSE, sep = " ", na.strings = "NA")
#Add Column Name that Concatenates a Number to Variable to ensure sequence and uniqueness; can remove, later, if customer desires
MeasColNames <- mutate(MeasColNames,V3 = paste(V1, V2, sep = '_'))
# Create a list of the measurement variable names
MeasColNamesList <- as.character(MeasColNames[1:nrow(MeasColNames),3])
# Remove all Minus from all values and Replace with Underscore
MeasColNamesList <- str_replace_all(MeasColNamesList, "-", "_")
# Remove all Commas from all values and Replace with Underscore
MeasColNamesList <- str_replace_all(MeasColNamesList, "\\,","_")
# Remove all Left Parens from all values
MeasColNamesList <- str_replace_all(MeasColNamesList, "\\(","")
# Remove all Right Parens from all values
MeasColNamesList <- str_replace_all(MeasColNamesList, "\\)","")

####Create the Combined Measurements for Training and Test
#Read in the X Train Measurement Data Frame
ActivityMeasTrain <- read.table("train/X_train.txt",header = FALSE, na.strings = "NA")

#Read in the X Test Measurement Data Frame
ActivityMeasTest <- read.table("test/X_test.txt",header = FALSE, na.strings = "NA")

#Bind the Rows from X Train to X Test with All Columns
AllMeasurements <- rbind(ActivityMeasTrain,ActivityMeasTest)

# Add columnn names to the dataframe for Activity Measurements
colnames(AllMeasurements) <- MeasColNamesList

#Create data frame with only columns with a Mean or Std
AllMeasurementsMeanStd <- select(AllMeasurements,contains("mean",ignore.case=TRUE),contains("std",ignore.case=TRUE))

####	3. Create a subjects data frame

#Read the subjects file and insert into a combined Data Frame
SubjectsTrain <- read.table("train/subject_train.txt",header = FALSE, na.strings = "NA")
SubjectsTest <- read.table("test/subject_test.txt",header = FALSE, na.strings = "NA")
#Create one combined data frame AllSubjects for both Training and Test subject observations
AllSubjects <- rbind(SubjectsTrain,SubjectsTest)
#Rename column name for column to subjects
colnames(AllSubjects) <- "subjects"

####	4. Create an activity data frame with descriptive names rather than codes

#Create Activity Code Data Frame
ActivityCodeTrain <- read.table("train/y_train.txt",header = FALSE, na.strings = "NA")
ActivityCodeTest <- read.table("test/y_test.txt",header = FALSE, na.strings = "NA")
#Create one combined data frame AllActivityCodes for both Training and Test observations
AllActivityCodes <- rbind(ActivityCodeTrain,ActivityCodeTest)
#Rename the column name for the activity codes
colnames(AllActivityCodes) <- "activity_code"
#Add a column to the AllActivityCodes data frame to be able to resequence, in case sequence is reorder with Merge function
AllActivityCodes <- mutate(AllActivityCodes,activity_seq = 1:10299)

# Convert Activity Codes to Descriptive Activity Names
# Read table for Descriptive Activity Names and insert into new data frame called ActivityRef
ActivityRef <- read.table("activity_labels.txt",header = FALSE)
# Assign column names for ActivityRef data frame
colnames(ActivityRef) <- c("activity_code","activity")
#Merge the Descriptive Activity Names with the Activity Codes
AllActivities <- merge(AllActivityCodes,ActivityRef,by="activity_code")

#Reorders the Activities back to their original sequential order
#Should consider adding observation ID key in the future; will not be needed when subject and activity columns bind with their measurements
AllActivities <- arrange(AllActivities,activity_seq)
# Trim the AllActivity Dataframe to include only the activity column
AllActivities <- select(AllActivities,activity)

####  5. Bind the 3 dataframes (Subjects, Descriptive Activities, Measurements with Mean & Std) to create one tidy data frame

# Bind all columns to create Tidy Data Set
MeanStdObservations <- cbind(AllSubjects,AllActivities,AllMeasurementsMeanStd)
# Write the tidy data set to a CSV data file
write.csv(MeanStdObservations,"meanStdObservations.csv")

# MeanStdObservations is a Tidy Data Set since it meets the following criteria
#1. Only one observation per row
#2. It is a complete observation in that the actual data variables of the means and standard deviations are binded to the subject and activity which describe the measurements
#3. There is only one file for the same type of observations

####	6. Create a Data Frame of Means by Subjects and Activities

####Create a new tidy data set for the Means for Each Variable Grouped By both Subject and Activity
#convert data frame to a dplyr table
SumFun <- tbl_df(MeanStdObservations)
# Group By subject and activity
# Summarise each by running mean from first measurement column to last one
# !!!!!!!!!!!!!!!Need to find out why the dataframe is not found
SumFunMean <- SumFun %>% 
  group_by(subjects,activity) %>%
  summarise_each(funs(mean))
# ,1_tBodyAcc_mean_X:543_fBodyBodyGyroJerkMag_std

# Write the MeanStdObservationsSummary to a CSV file
write.csv(SumFunMean,"SumFunMean.csv")
write.table(SumFunMean,"SummariseFuncMeans.txt", row.names = FALSE)

#### Create a code Book using the Str Command for the Measurement or Variable, Type, and Samples
sink("MeanStdObservationsCodeBookStr.md")
# Write CodeBook to Text File
str(MeanStdObservations)
#Unlink the file
unlink("MeanStdObservationsCodeBookStr.txt")

#### Create a code Book using the Hmisc Package Describe Command for the Measurement or Variable, Type, and Samples
sink("MeanStdObservationsCodeBookDesc.md")
# Write CodeBook to Text File
describe(MeanStdObservations)
#Unlink the file
unlink("MeanStdObservationsCodeBookDesc.txt")Enter file contents here
