# R script - Course Project from Coursera
# Getting and cleaning data

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

library("dplyr")

# Dataset download and extraction
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url,"Dataset_DataCleaning_Project.zip",method="curl")
unzip("Dataset_DataCleaning_Project.zip")

# Load data sets and rename colums adequatly
activity_numbers <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")

data_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
names(data_test) <- features[,2]
labels_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
names(labels_test) <- "activity"
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
names(subject_test) <- "subject"
dataset_test <- cbind(labels_test,subject_test,data_test)
rm(data_test,labels_test,subject_test)

data_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
names(data_train) <- features[,2]
labels_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
names(labels_train) <- "activity"
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
names(subject_train) <- "subject"
dataset_train <- cbind(labels_train,subject_train,data_train)
rm(data_train,labels_train,subject_train)

# Merges the training and the test sets to create one data set.
DATASET_all <- rbind(dataset_train,dataset_test)

# Extracts dataset containing only the measurements on the mean and standard deviation for each measurement.
# Use of grepl to find any instances of mean or std in the data set variable names,

var_names <- names(DATASET_all)
dataset_extract <- DATASET_all[, grepl("activity",var_names) | grepl("subject",var_names) | grepl("mean",var_names) | grepl("std",var_names)]


# Uses descriptive activity names to name the activities in the data set
dataset_extract$activity_description <- activity_numbers[dataset_extract$activity,2]
dataset_extract$activity <- NULL

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

SubjectActivity <- unique(select(dataset_extract,c("subject","activity_description")))

dataset_grouped <-group_by(dataset_extract,subject,activity_description)
TidySet <- summarize_all(dataset_grouped,mean)
  
