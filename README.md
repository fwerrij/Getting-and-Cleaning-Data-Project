# Getting-and-Cleaning-Data-Project
My Preparation starts with manually downloading & unzipping of the data in the windows GUI maintaining the directory structure in zip-file. 
This structure is first investigated.
My general approach is based on the idea to not combine test and train data into one big table before the selection of the 79 required columns, 
with mean and std of the measuments, from the original 561 columns of both test and train data. 
So I will first complete the test and train data into df's with 79 + 2 (subject and activity) columns. For the selection I use the features after adding them
as column headers to the test data. I select only feature columns with "mean" or "std" in it. After the selection I build the complete 2947x81 test table and 
the 7352x81 train table by adding the subject and activity colummns (after replacing the activity codes with labels) to them.
Finally I join test an train tables vertically and calculate de means of all remaining measurements per subject and activity combination, using the group_by 
and summarize_each verbs from the dplyr library.

I have just one script with all steps in it. The script with explanatory comments is fully included:

## Preparation
#####Setting/creating the workdirectory:
	setwd("C:/Users/nl22423/Documents/Cursussen/G&CData/Project")
#####Downloading & unzipping of the data is done manually in the windows GUI maintaining the directory structure in zip-file
## Data manipulation
#####Sucessively read data into dataframes for test and train data:
	try_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
	subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
	y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
	try_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
	subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
	y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
#####Read activity names and feature names into dataframes, assign the feature names to variables in both test and train.
#####Establish the indices of the mean and std of the measurements for testdata in order to (some feature names have "Mean"starting with a capital letter: Because they are not proper means I wil not take them into account!!!) select only the features with mean and std of features from test an train data:
	features<-read.table("./UCI HAR Dataset/features.txt")
	activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
	names(try_test)<-features$V2
	names(try_train)<-features$V2
	mean_std_ind<-grep("mean|std",names(try_train))
	try_test<-try_test[,mean_std_ind]
	try_train<-try_train[,mean_std_ind]
#####The subject and activity columns must be added to the data for both test and train data; column name "subject" to subject_test then as first column to test df; create column "activity" to test df then fill "activity" column with substituted y_test, as last step fill the remaining columns of test:
	names(subject_test)<-"subject"
	test<-subject_test
	test$activity<-NA
	names(y_test)<-"activity"
	test$activity<-activities[y_test[,],2]
	test[names(try_test)]<-NA
	test[names(try_test)]<-try_test
#####Add column name "subject" to subject_train and then as first column to train df, create column "activity" to train df then fill "activity" column with substituted y_train and as last step fill the remaining columns of train:
	names(subject_train)<-"subject"
	train<-subject_train
	train$activity<-NA
	names(y_train)<-"activity"
	train$activity<-activities[y_train[,],2]
	train[names(try_train)]<-NA
	train[names(try_train)]<-try_train
#####Finally join test and train vertically and calculate de means of all remaining measurements per subject and activity combination:
	result<-rbind(test,train)
	library(dplyr)
	grouped_result<-group_by(result,subject,activity)
	tidy_result<-summarise_each(grouped_result,"mean")
##Write the tidy table into tidy_result.txt in the Working directory:
	write.table(tidy_result,file="tidy_result.txt",row.name=FALSE)
# CodeBook
For each real number variable 30 x 6 observations are included containing the mean per combination of subject (30) and activity (6).

|Variable_Name| Concise_Variable_Description| Value_Type|
|:------------- |:--------------------|:---------|
| "subject"      | subject no  | Integer 1-30|
| "activity"     | activity label     |  one of { "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS" }  |
|"tBodyAcc-mean()-X" | mean of body accelerometer X-axis time domain signals	|REAL NUMBER <-1,+1>|
|"tBodyAcc-mean()-Y"| mean of body accelerometer Y-axis time domain signals |	REAL NUMBER <-1,+1>|
|"tBodyAcc-mean()-Z"| mean of body accelerometer Z-axis time domain signals |	REAL NUMBER <-1,+1>|
|"tBodyAcc-std()-X" | st dev of body accelerometer X-axis time domain signals |	REAL NUMBER <-1,+1>|
|"tBodyAcc-std()-Y" | st dev of body accelerometer Y-axis time domain signals|	REAL NUMBER <-1,+1>|
|"tBodyAcc-std()-Z" 	|st dev of body accelerometer Z-axis time domain signals|REAL NUMBER <-1,+1>|
|"tGravityAcc-mean()-X" |mean of gravity accelerometer X-axis time domain signals|REAL NUMBER <-1,+1>|
|"tGravityAcc-mean()-Y" |mean of gravity accelerometer Y-axis time domain signals|REAL NUMBER <-1,+1>|
|"tGravityAcc-mean()-Z"|mean of gravity accelerometer X-axis time domain signals| REAL NUMBER <-1,+1>|
|"tGravityAcc-std()-X" |st dev of gravity accelerometer X-axis time domain signals|REAL NUMBER <-1,+1>|
|"tGravityAcc-std()-Y" 	|st dev of gravity accelerometer Y-axis time domain signals|REAL NUMBER <-1,+1>|
|"tGravityAcc-std()-Z" 	|st dev of gravity accelerometer Y-axis time domain signals|REAL NUMBER <-1,+1>|
|"tBodyAccJerk-mean()-X" |mean derivation of linear acceleration X-axis |REAL NUMBER <-1,+1>
|"tBodyAccJerk-mean()-Y"  |mean derivation of linear acceleration Y-axis|REAL NUMBER <-1,+1>
|"tBodyAccJerk-mean()-Z"  |mean derivation of linear acceleration X-axis|REAL NUMBER <-1,+1>
|"tBodyAccJerk-std()-X"  |st dev derivation of linear acceleration X-axis|REAL NUMBER <-1,+1>
|"tBodyAccJerk-std()-Y"  |st dev derivation of linear acceleration Y-axis|REAL NUMBER <-1,+1>
|"tBodyAccJerk-std()-Z"  |st dev derivation of linear acceleration Z-axis|REAL NUMBER <-1,+1>
|"tBodyGyro-mean()-X"  	|mean of angular velocity X-axis time domain signals|REAL NUMBER <-1,+1>
|"tBodyGyro-mean()-Y"  	|mean of angular velocity Y-axis time domain signals|	REAL NUMBER <-1,+1>
|"tBodyGyro-mean()-Z" 	 |mean of angular velocity X-axis time domain signals|	REAL NUMBER <-1,+1>
|"tBodyGyro-std()-X" 	 |st dev of angular velocity X-axis time domain signals|REAL NUMBER <-1,+1>
|"tBodyGyro-std()-Y" 	 |mean of angular velocity X-axis time domain signals|	REAL NUMBER <-1,+1>
|"tBodyGyro-std()-Z"  	|mean of angular velocity X-axis time domain signals|	REAL NUMBER <-1,+1>
|"tBodyGyroJerk-mean()-X"  |mean derivation of angular velocity  X-axis signals |REAL NUMBER <-1,+1>
|"tBodyGyroJerk-mean()-Y"  |mean derivation of angular velocity  Y-axis signals|REAL NUMBER <-1,+1>
|"tBodyGyroJerk-mean()-Z"  |mean derivation of angular velocity  Z-axis signals|REAL NUMBER <-1,+1>
|"tBodyGyroJerk-std()-X"  |st dev derivation of angular velocity  X-axis signals|REAL NUMBER <-1,+1>
|"tBodyGyroJerk-std()-Y"  |st dev derivation of angular velocity  X-axis signals|REAL NUMBER <-1,+1>
|"tBodyGyroJerk-std()-Z"  |st dev derivation of angular velocity  X-axis signals|REAL NUMBER <-1,+1>
|"tBodyAccMag-mean()"  	|mean euclidian magnitude of corresp three dim signal|	REAL NUMBER <-1,+1>
|"tBodyAccMag-std()"  	|st dev euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tGravityAccMag-mean()"  |mean euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tGravityAccMag-std()"  |st dev euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tBodyAccJerkMag-mean()"  |mean euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tBodyAccJerkMag-std()"  |st dev euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tBodyGyroMag-mean()"  |mean euclidian magnitude of corresp three dim signal|	REAL NUMBER <-1,+1>
|"tBodyGyroMag-std()" 	 |st dev euclidian magnitude of corresp three dim signal|REAL NUMBER <-1,+1>
|"tBodyGyroJerkMag-mean()"|mean euclidian magnitude of corresp three dim signal| REAL NUMBER <-1,+1>
|"tBodyGyroJerkMag-std()" |st dev euclidian magnitude of corresp three dim signal| REAL NUMBER <-1,+1>
|"fBodyAcc-mean()-X" 	 |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-mean()-Y" 	 |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-mean()-Z" 	 |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-std()-X" 	|st dev F F transform of corresp signal| 	REAL NUMBER <-1,+1>
|"fBodyAcc-std()-Y" 	 |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-std()-Z" 	 |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-meanFreq()-X"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-meanFreq()-Y"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAcc-meanFreq()-Z"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-mean()-X"  |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-mean()-Y" |mean F F transform of corresp signal| 	REAL NUMBER <-1,+1>
|"fBodyAccJerk-mean()-Z"  |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-std()-X"  |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-std()-Y"  |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-std()-Z"  |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccJerk-meanFreq()-X" |mean freq F F transform of corresp signal| REAL NUMBER <-1,+1>
|"fBodyAccJerk-meanFreq()-Y"|mean freq F F transform of corresp signal|  REAL NUMBER <-1,+1>
|"fBodyAccJerk-meanFreq()-Z"  |mean freq F F transform of corresp signal| REAL NUMBER <-1,+1>
|"fBodyGyro-mean()-X" 	|mean F F transform of corresp signal|	REAL NUMBER <-1,+1> 
|"fBodyGyro-mean()-Y"  	|mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyGyro-mean()-Z" 	 |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyGyro-std()-X" 	 |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyGyro-std()-Y"  	|st dev F F transform of corresp signal|REAL NUMBER <-1,+1>
|"fBodyGyro-std()-Z"  	|st dev F F transform of corresp signal| REAL NUMBER <-1,+1>
|"fBodyGyro-meanFreq()-X"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyGyro-meanFreq()-Y"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyGyro-meanFreq()-Z"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccMag-mean()"  	|mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccMag-std()" 	 |st dev F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyAccMag-meanFreq()" |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyBodyAccJerkMag-mean()"  	|mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyBodyAccJerkMag-std()"  	|st dev F F transform of corresp signal|REAL NUMBER <-1,+1>
|"fBodyBodyAccJerkMag-meanFreq()"|mean freq F F transform of corresp signal| 	REAL NUMBER <-1,+1> 
|"fBodyBodyGyroMag-mean()"  	|mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyBodyGyroMag-std()"  	|st dev F F transform of corresp signal|REAL NUMBER <-1,+1>
|"fBodyBodyGyroMag-meanFreq()"  |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyBodyGyroJerkMag-mean()"  |mean F F transform of corresp signal|	REAL NUMBER <-1,+1>
|"fBodyBodyGyroJerkMag-std()"  	|st dev F F transform of corresp signal|REAL NUMBER <-1,+1>
|"fBodyBodyGyroJerkMag-meanFreq()" |mean freq F F transform of corresp signal|	REAL NUMBER <-1,+1>
