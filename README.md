# Introduction
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set.
Please refer to the CodeBook.md for more details about input data sets and their variables.

The script `run_analysis.R` is logicaly devided into 6 steps (Step 0 - Step 6).
Below you can find a detailed description of how all of the scripts work.

## Step 0 
> Sets working directory and read files required for analysis

`setwd("C:\\Users\\ekaraseva\\Desktop\\data\\UCI HAR Dataset")
  activity_labels<-read.table("activity_labels.txt")
  features<-read.table("features.txt")
  subject_train<-read.table("./train/subject_train.txt")
  X_train<-read.table("./train/X_train.txt")
  y_train<-read.table("./train/y_train.txt")
  subject_test<-read.table("./test/subject_test.txt")
  X_test<-read.table("./test/X_test.txt")
  y_test<-read.table("./test/y_test.txt")`

## Step 1
> Merges the training and the test sets to create one data set

1. `'train/X_train.txt': Training set` and `'train/y_train.txt': Training labels` were merged together in order to identify types of activities tracked
2. `'test/X_test.txt': Test set` and `'test/y_test.txt': Test labels` were merged together in order to identify types of activities tracked
3. Data Sets from points 1 and 2 above were binded together in order to create one data set `test_and_train_df`

## Step 2
> Extracts only the measurements on the mean and standard deviation for each measurement

Regular expressions were used within `grep` FUN to identify required variable, i.e. ones that included `mean()` and `std()` obesrvations.
Returned vector was applied to `test_and_train_df` to filter out other variables. The resulting data frame named as `filtered_full_df1`.

## Step 3
> Uses descriptive activity names to name the activities in the data set

`filtered_full_df1` was merged with `activity_labels` in order to match numbers with activity names. The names were populated but the numbers were dropped, resulting in creation of another intermediate data frame called `human_activities_full`. 

## Step 4 
> Appropriately labels the data set with descriptive variable names

A series of editing actions was applied to variable names in `human_activities_full`. Included: elaboration on abbriviated terms, getting rid of special symbols like "-" and "(), lowering all cases.

## Step 5
> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

`human_activities_full` has been grouped by activity types. The data frame has been summarized by activity types using mean FUN. The resulting and final data frame was called `human_activities_summary`.
