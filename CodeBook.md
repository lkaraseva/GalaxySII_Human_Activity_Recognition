# Introduction and data set descriptions
The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set.
The goal is to prepare tidy data that can be used for later analysis

> Data Source

The data is coming from Machine Learning Repository UCI:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Data sets have been downloaded using the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

> Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

> Attribute Information

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

> The dataset included in analysis

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

> Variables

The complete list of variables of each feature vector is available in 'features.txt'

# Transformations Performed

## Step 1 - Merges the training and the test sets to create one data set.
1. 'train/X_train.txt': Training set and 'train/y_train.txt': Training labels were merged together in order to identify types of activities tracked
2. 'test/X_test.txt': Test set and 'test/y_test.txt': Test labels were merged together in order to identify types of activities tracked
3. Data Sets from 1.1 and 1.2 were binded together in order to create one data set `test_and_train_df`

## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
Regular expressions were used within grep FUN to identify required variable, i.e. ones that included mean() and std() obesrvations.
Returned vector was applied to test_and_train_df to filter out other variables. The resulting data frame named as filtered_full_df1.

## Step 3 - Uses descriptive activity names to name the activities in the data set
filtered_full_df1 was merged with activity_labels in order to match numbers with activity names. The names were populated but the numbers were dropped, resulting in creation of another intermediate data frame called >human_activities_full. 

## Step 4 - Appropriately labels the data set with descriptive variable names.
A series of editing actions was applied to variable names in human_activities_full. Included: elaboration on abbriviated terms, getting rid of special symbols like "-" and "(), lowering all cases.

## Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
human_activities_full has been grouped by activity types. The data frame has been summarized by activity types using mean FUN. The resulting and final data frame was called human_activities_summary.
