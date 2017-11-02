## Step 0 - Set working directory and Read files required for analysis with read.table
  
  setwd("C:\\Users\\ekaraseva\\Desktop\\data\\UCI HAR Dataset")
  activity_labels<-read.table("activity_labels.txt")
  features<-read.table("features.txt")
  subject_train<-read.table("./train/subject_train.txt")
  X_train<-read.table("./train/X_train.txt")
  y_train<-read.table("./train/y_train.txt")
  subject_test<-read.table("./test/subject_test.txt")
  X_test<-read.table("./test/X_test.txt")
  y_test<-read.table("./test/y_test.txt")

## Step 1 - Merges the training and the test sets to create one data set
  
  #rename variables in test and train data sets according to the list of all features
  names(X_test)<-features[,2]
  names(X_train)<-features[,2]
  
  #bind data sets with the lables
  test_df<-cbind.data.frame(y_test, X_test)
  train_df<-cbind.data.frame(y_train, X_train)
  test_and_train_df<-rbind.data.frame(test_df, train_df)
  
## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
  
  #locate column numbers that contain mean or standard deviation measurements by exact match to 
  # "mean()" and "std()"
  required_columns_vector<-grep("V1|\\bmean()\\b|\\bstd()\\b", names(test_and_train_df),ignore.case = TRUE)
  #create a filterted data frame that contains only required columns/measurments
  filtered_full_df1<-full_df[,required_columns_vector]
  
## Step 3 - Uses descriptive activity names to name the activities in the data set
  
  library(dplyr)
  human_activities_full <- filtered_full_df1 %>%
                          merge(activity_labels) %>%
                          select(68,2:67) %>%
                          rename(activity=V2)
  
##  Step 4 - Appropriately labels the data set with descriptive variable names 
  
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
 
## Step 5 - From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable for each activity and each subject
  
  human_activities_summary<- human_activities_full %>% 
                group_by(activity) %>%
                summarise_all(funs(mean(., na.rm=TRUE))) %>%
                as.data.frame()
  
  print(human_activities_summary)
 
  
  
