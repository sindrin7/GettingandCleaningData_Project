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
activity_labels <- read.table(unzip(temp, "UCI HAR Dataset/activity_labels.txt"))
unlink(temp) # remove temp link

# Rename the header for X
colnames(test.X) <- t(features[2])
colnames(train.X) <- t(features[2])

# Combine columns of y, sub into X for both test and training datasets
test.X$ActivityCD <- test.y[, 1]
test.X$Subject <- test.sub[, 1]
train.X$ActivityCD <- train.y[, 1]
train.X$Subject <- train.sub[, 1]

# 1. Merges the training and the test sets to create one data set.
MasterX <- rbind(train.X, test.X)
table(colnames(MasterX)[duplicated(colnames(MasterX)) == TRUE]) # Check duplicated variables
MasterC <- MasterX[, !duplicated(colnames(MasterX))]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# MasterC.mean <- MasterC[grep("[Mm]ean[(),]", names(MasterC), value = FALSE)]
# MasterC.std <- MasterC[grep("[Ss]td[(),]", names(MasterC), value = FALSE)]
MasterC.Sub <- MasterC[,grepl("mean|std|Subject|Activity", names(MasterC))]

# 3. Uses descriptive activity names to name the activities in the data set
# File: activity_labels.txt

# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 1] <- "Walking"
# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 2] <- "Walking Upstairs"
# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 3] <- "Walking Downstairs"
# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 4] <- "Sitting"
# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 5] <- "Standing"
# MasterC.Sub$Activity[MasterC.Sub$ActivityCD == 6] <- "Laying"
# MasterC.Sub$Activity <- as.factor(MasterC.Sub$ActivityCD)

names(activity_labels) <- c("ActivityCD", "Activity")
MasterC.Sub <- join(MasterC.Sub, activity_labels, by = "ActivityCD", match = "first")[,-1]

# Replace Subject
# subject <- as.factor(paste("Participant", MasterC.mean.std$subject))
# MasterC.mean.std$subject <- subject


# 4. Appropriately labels the data set with descriptive variable names.
des.names <- names(MasterC.Sub) 

# To remove parentheses
des.names <- gsub('\\(|\\)', "", des.names, perl = TRUE)
# To make syntactically valid names
des.names <- make.names(des.names)
# Make clearer names
des.names <- gsub('Acc', "Acceleration", des.names)
des.names <- gsub('GyroJerk', "AngularAcceleration", des.names)
des.names <- gsub('Gyro', "AngularSpeed", des.names)
des.names <- gsub('Mag', "Magnitude", des.names)
des.names <- gsub('^t', "TimeDomain.", des.names)
des.names <- gsub('^f', "FrequencyDomain.", des.names)
des.names <- gsub('\\.mean', ".Mean", des.names)
des.names <- gsub('\\.std', ".StandardDeviation", des.names)
des.names <- gsub('Freq\\.', "Frequency.", des.names)
des.names <- gsub('Freq$', "Frequency", des.names)
names(MasterC.Sub) <- des.names


# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Master2nd <- data.table(MasterC.Sub)
#This takes the mean of every column broken down by participants and activities
MasterTidy <- Master2nd[, lapply(.SD, mean), by = 'Subject,Activity']
write.table(MasterTidy, file = "tidydata.txt", row.names = FALSE)

