# Getting and Cleaning Data 

## Project Description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# What you find in this repository
CodeBook.md: information about raw and tidy data set and elaboration made to transform them

LICENSE: license terms for text and code

README.md: this file

run_analysis.R: R script to transform raw data set in a tidy one

# Steps to work on this course project

1. Download the data source and put into a folder on your local drive. You'll have a UCI HAR Dataset folder.
2. Put run_analysis.R in the parent folder of UCI HAR Dataset, then set it as your working directory using setwd() function in RStudio.
3. Run source("run_analysis.R"), then it will generate a new file tiny_data.txt in your working directory.

# Additional Information

You can find additional information about the variables, data and transformations in the CodeBook.MD file.
