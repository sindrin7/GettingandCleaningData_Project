### Data Science
### Course 3: Getting and Cleaning Data

rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization


### Data load-in
temp <- tempfile() # temp path
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE)
test.y <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
test.X <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
test.sub <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
train.y <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
train.X <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
train.sub <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) # remove temp link

# Rename the header for X
colnames(test.X) <- t(features[2])
colnames(train.X) <- t(features[2])

# Combine columns of y, sub into X for both test and training datasets
test.X$activity <- test.y[, 1]
test.X$subject <- test.sub[, 1]
train.X$activity <- train.y[, 1]
train.X$subject <- train.sub[, 1]

# 1. Merges the training and the test sets to create one data set.
MasterX <- rbind(train.X, test.X)
table(colnames(MasterX)[duplicated(colnames(MasterX)) == TRUE]) # Check duplicated variables
MasterC <- MasterX[, !duplicated(colnames(MasterX))]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
MasterC.mean <- MasterC[grep("[Mm]ean[(),]", names(MasterC), value = FALSE)]
MasterC.std <- MasterC[grep("[Ss]td[(),]", names(MasterC), value = FALSE)]

# 3. Uses descriptive activity names to name the activities in the data set
# File: activity_labels.txt
MasterC$activity[MasterC$activity == 1] <- "Walking"
MasterC$activity[MasterC$activity == 2] <- "Walking Upstairs"
MasterC$activity[MasterC$activity == 3] <- "Walking Downstairs"
MasterC$activity[MasterC$activity == 4] <- "Sitting"
MasterC$activity[MasterC$activity == 5] <- "Standing"
MasterC$activity[MasterC$activity == 6] <- "Laying"
MasterC$activity <- as.factor(MasterC$activity)

subject <- as.factor(paste("Participant", MasterC$subject))
MasterC$subject <- subject


# 4. Appropriately labels the data set with descriptive variable names.
des.names <- names(MasterC) 
des.names <- gsub("Acc", "Accelerator", des.names)
des.names <- gsub("Mag", "Magnitude", des.names)
des.names <- gsub("Gyro", "Gyroscope", des.names)
des.names <- gsub("^t", "time", des.names)
des.names <- gsub("^f", "frequency", des.names)
names(MasterC) <- des.names

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Master2nd <- data.table(MasterC)
#This takes the mean of every column broken down by participants and activities
MasterTidy <- Master2nd[, lapply(.SD, mean), by = 'subject,activity']
write.table(MasterTidy, file = "tidydata.txt", row.names = FALSE)

