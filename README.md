# Introduction
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set.
Please refer to the CodeBook.md for more details about input data sets and their variables.

The script `run_analysis.R` is logicaly devided into 6 steps (Step 0 - Step 6).
Below you can find a detailed description of how all of the scripts work.

## Step 0 
> Sets working directory
#### Note! In order to avoid any errors you need to change the path to `UCI HAR Dataset` folder according to the location on your computer
  ```{r eval=FALSE}
  setwd("C:\\Users\\ekaraseva\\Desktop\\data\\UCI HAR Dataset")
  ```  
> Reads files required for analysis
  ```{r eval=FALSE}  
  activity_labels<-read.table("activity_labels.txt")
  features<-read.table("features.txt")
  subject_train<-read.table("./train/subject_train.txt")
  X_train<-read.table("./train/X_train.txt")
  y_train<-read.table("./train/y_train.txt")
  subject_test<-read.table("./test/subject_test.txt")
  X_test<-read.table("./test/X_test.txt")
  y_test<-read.table("./test/y_test.txt")`
  ```
## Step 1
#### Merges the training and the test sets to create one data set
1. `'train/X_train.txt': Training set` and `'train/y_train.txt': Training labels` are merged together in order to identify types of activities tracked
2. `'test/X_test.txt': Test set` and `'test/y_test.txt': Test labels` are merged together in order to identify types of activities tracked
3. Data Sets from points 1 and 2 above were binded together in order to create one data set `test_and_train_df`
> Renames variables in test and train data sets according to the list of all features
  ```{r eval=FALSE}  
  names(X_test)<-features[,2]
  names(X_train)<-features[,2]
  names(subject_test)<-"subject"
  names(subject_train)<-"subject"
  names(y_test)<-"activity"
  names(y_train)<-"activity"
  ```
> Binds data sets with the lables
  ```{r eval=FALSE}  
  test_df<-cbind.data.frame(subject_test, y_test, X_test)
  train_df<-cbind.data.frame(subject_train, y_train, X_train)
  test_and_train_df<-rbind.data.frame(test_df, train_df)
  ```    
## Step 2
#### Extracts only the measurements on the mean and standard deviation for each measurement
Regular expressions are used within `grep` FUN to identify required variable, i.e. ones that included `mean()` and `std()` obesrvations.
Returned vector was applied to `test_and_train_df` to filter out other variables. The resulting data frame named as `filtered_full_df1`.
> Locates column numbers that contain mean or standard deviation measurements by exact match to `mean()` and `std()`
  ```{r eval=FALSE}  
  required_columns_vector<-grep("subject|activity|\\bmean()\\b|\\bstd()\\b", names(test_and_train_df),ignore.case = TRUE)
  ```
> Creates a filterted data frame that contains only required columns/measurments
  ```{r eval=FALSE}  
  filtered_full_df1<-test_and_train_df[,required_columns_vector]
  ```
## Step 3
#### Uses descriptive activity names to name the activities in the data set
`filtered_full_df1` is merged with `activity_labels` in order to match numbers with activity names. The names were populated but the  numbers were dropped, resulting in creation of another intermediate data frame called `human_activities_full`.
  ```{r eval=FALSE}
  library(dplyr)
  human_activities_full <- filtered_full_df1 %>%
                            merge(activity_labels,by.x="activity",by.y="V1",all=TRUE) %>%
                            select(2,69,3:68) %>%
                            rename(activity=V2) %>%
                            arrange(subject,activity)
  ```
## Step 4 
#### Appropriately labels the data set with descriptive variable names
A series of editing actions was applied to variable names in `human_activities_full`. Included: elaboration on abbriviated terms, getting rid of special symbols like "-" and "(), lowering all cases.
  ```{r eval=FALSE}
  NewVarNames <- gsub("-","",names(human_activities_full))
  NewVarNames <- gsub("^t","timesignalof",NewVarNames)
  NewVarNames <- gsub("^f","frequencysignalof",NewVarNames)
  NewVarNames <- gsub("[()]","",NewVarNames)
  NewVarNames <- gsub("mean","average",NewVarNames)
  NewVarNames <- gsub("std","standarddeviation",NewVarNames)
  NewVarNames <- gsub("Body","bodymotion",NewVarNames)
  NewVarNames <- gsub("Gravity","gravitationalmotion",NewVarNames)
  NewVarNames <- gsub("Acc","fromaccelerometer",NewVarNames)
  NewVarNames <- gsub("Gyro","fromgyroscope",NewVarNames)
  NewVarNames <- gsub("Mag","magnitude",NewVarNames)
  NewVarNames <- tolower (NewVarNames)
  names(human_activities_full)<-NewVarNames
  ```
## Step 5
#### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
`human_activities_full` has been grouped by activity types. The data frame has been summarized by activity types using mean FUN. The resulting and final data frame was called `human_activities_summary`.
  ```{r eval=FALSE}
  human_activities_summary<- human_activities_full %>% 
                group_by(subject, activity) %>%
                summarise_all(funs(mean(., na.rm=TRUE))) %>%
                as.data.frame()
  
  print(human_activities_summary)
  #or
  write.table(human_activities_summary,file="run_analysis.txt",row.names = FALSE)
  ```
