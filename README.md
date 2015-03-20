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
####Setting/creating the workdirectory:
	setwd("C:/Users/nl22423/Documents/Cursussen/G&CData/Project")
####Downloading & unzipping of the data is done manually in the windows GUI maintaining the directory structure in zip-file
## Data manipulation
####Sucessively read data into dataframes for test and train data:
	try_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
	subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
	y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
	try_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
	subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
	y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
####Read activity names and feature names into dataframes, assign the feature names to variables in both test and train.
####Establish the indices of the mean and std of the measurements for testdata in order to (some feature names have "Mean"starting with a capital letter: Because they are not proper means I wil not take them into account!!!) select only the features with mean and std of features from test an train data:
	features<-read.table("./UCI HAR Dataset/features.txt")
	activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
	names(try_test)<-features$V2
	names(try_train)<-features$V2
	mean_std_ind<-grep("mean|std",names(try_train))
	try_test<-try_test[,mean_std_ind]
	try_train<-try_train[,mean_std_ind]
####The subject and activity columns must be added to the data for both test and train data; column name "subject" to subject_test then as first column to test df; create column "activity" to test df then fill "activity" column with substituted y_test, as last step fill the remaining columns of test:
	names(subject_test)<-"subject"
	test<-subject_test
	test$activity<-NA
	names(y_test)<-"activity"
	test$activity<-activities[y_test[,],2]
	test[names(try_test)]<-NA
	test[names(try_test)]<-try_test
####Add column name "subject" to subject_train and then as first column to train df, create column "activity" to train df then fill "activity" column with substituted y_train and as last step fill the remaining columns of train:
	names(subject_train)<-"subject"
	train<-subject_train
	train$activity<-NA
	names(y_train)<-"activity"
	train$activity<-activities[y_train[,],2]
	train[names(try_train)]<-NA
	train[names(try_train)]<-try_train
####Finally join test and train vertically and calculate de means of all remaining measurements per subject and activity combination:
	result<-rbind(test,train)
	library(dplyr)
	grouped_result<-group_by(result,subject,activity)
	tidy_result<-summarise_each(grouped_result,"mean")
##Write the tidy table into tidy_result.txt in the Working directory:
	write.table(tidy_result,file="tidy_result.txt",row.name=FALSE)
# CodeBook
For each real number variable 30 x 6 observations are included containing the mean per combination of subject (30) and activity (6).

|Variable Name		|Description		|Value Type
|"subject" 		|			|Integer 1-30
|"activity" 		|			|{"LAYING","sITTING","STANDING","WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS"} 
|"tBodyAcc-mean()-X" 	|			|REAL NUMBER <-1,+1>
"tBodyAcc-mean()-Y" 				REAL NUMBER <-1,+1>
"tBodyAcc-mean()-Z" 				REAL NUMBER <-1,+1>
"tBodyAcc-std()-X" 				REAL NUMBER <-1,+1>
"tBodyAcc-std()-Y" 				REAL NUMBER <-1,+1>
"tBodyAcc-std()-Z" 				REAL NUMBER <-1,+1>
"tGravityAcc-mean()-X" 				REAL NUMBER <-1,+1>
"tGravityAcc-mean()-Y" 				REAL NUMBER <-1,+1>
"tGravityAcc-mean()-Z" 				REAL NUMBER <-1,+1>
"tGravityAcc-std()-X" 				REAL NUMBER <-1,+1>
"tGravityAcc-std()-Y" 				REAL NUMBER <-1,+1>
"tGravityAcc-std()-Z" 				REAL NUMBER <-1,+1>
"tBodyAccJerk-mean()-X" 			REAL NUMBER <-1,+1>
"tBodyAccJerk-mean()-Y"  			REAL NUMBER <-1,+1>
"tBodyAccJerk-mean()-Z"  			REAL NUMBER <-1,+1>
"tBodyAccJerk-std()-X"  			REAL NUMBER <-1,+1>
"tBodyAccJerk-std()-Y"  			REAL NUMBER <-1,+1>
"tBodyAccJerk-std()-Z"  			REAL NUMBER <-1,+1>
"tBodyGyro-mean()-X"  				REAL NUMBER <-1,+1>
"tBodyGyro-mean()-Y"  				REAL NUMBER <-1,+1>
"tBodyGyro-mean()-Z" 	 			REAL NUMBER <-1,+1>
"tBodyGyro-std()-X" 	 			REAL NUMBER <-1,+1>
"tBodyGyro-std()-Y" 	 			REAL NUMBER <-1,+1>
"tBodyGyro-std()-Z"  				REAL NUMBER <-1,+1>
"tBodyGyroJerk-mean()-X"  			REAL NUMBER <-1,+1>
"tBodyGyroJerk-mean()-Y"  			REAL NUMBER <-1,+1>
"tBodyGyroJerk-mean()-Z"  			REAL NUMBER <-1,+1>
"tBodyGyroJerk-std()-X"  			REAL NUMBER <-1,+1>
"tBodyGyroJerk-std()-Y"  			REAL NUMBER <-1,+1>
"tBodyGyroJerk-std()-Z"  			REAL NUMBER <-1,+1>
"tBodyAccMag-mean()"  				REAL NUMBER <-1,+1>
"tBodyAccMag-std()"  				REAL NUMBER <-1,+1>
"tGravityAccMag-mean()"  			REAL NUMBER <-1,+1>
"tGravityAccMag-std()"  			REAL NUMBER <-1,+1>
"tBodyAccJerkMag-mean()"  			REAL NUMBER <-1,+1>
"tBodyAccJerkMag-std()"  			REAL NUMBER <-1,+1>
"tBodyGyroMag-mean()"  				REAL NUMBER <-1,+1>
"tBodyGyroMag-std()" 	 			REAL NUMBER <-1,+1>
"tBodyGyroJerkMag-mean()" 	 		REAL NUMBER <-1,+1>
"tBodyGyroJerkMag-std()"  			REAL NUMBER <-1,+1>
"fBodyAcc-mean()-X" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-mean()-Y" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-mean()-Z" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-std()-X" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-std()-Y" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-std()-Z" 	 			REAL NUMBER <-1,+1>
"fBodyAcc-meanFreq()-X"  			REAL NUMBER <-1,+1>
"fBodyAcc-meanFreq()-Y"  			REAL NUMBER <-1,+1>
"fBodyAcc-meanFreq()-Z"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-mean()-X"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-mean()-Y"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-mean()-Z"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-std()-X"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-std()-Y"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-std()-Z"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-meanFreq()-X"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-meanFreq()-Y"  			REAL NUMBER <-1,+1>
"fBodyAccJerk-meanFreq()-Z"  			REAL NUMBER <-1,+1>
"fBodyGyro-mean()-X" 				REAL NUMBER <-1,+1> 
"fBodyGyro-mean()-Y"  				REAL NUMBER <-1,+1>
"fBodyGyro-mean()-Z" 	 			REAL NUMBER <-1,+1>
"fBodyGyro-std()-X" 	 			REAL NUMBER <-1,+1>
"fBodyGyro-std()-Y"  				REAL NUMBER <-1,+1>
"fBodyGyro-std()-Z"  				REAL NUMBER <-1,+1>
"fBodyGyro-meanFreq()-X"  			REAL NUMBER <-1,+1>
"fBodyGyro-meanFreq()-Y"  			REAL NUMBER <-1,+1>
"fBodyGyro-meanFreq()-Z"  			REAL NUMBER <-1,+1>
"fBodyAccMag-mean()"  				REAL NUMBER <-1,+1>
"fBodyAccMag-std()" 	 			REAL NUMBER <-1,+1>
"fBodyAccMag-meanFreq()" 			REAL NUMBER <-1,+1>
"fBodyBodyAccJerkMag-mean()"  			REAL NUMBER <-1,+1>
"fBodyBodyAccJerkMag-std()"  			REAL NUMBER <-1,+1>
"fBodyBodyAccJerkMag-meanFreq()" 		REAL NUMBER <-1,+1> 
"fBodyBodyGyroMag-mean()"  			REAL NUMBER <-1,+1>
"fBodyBodyGyroMag-std()"  			REAL NUMBER <-1,+1>
"fBodyBodyGyroMag-meanFreq()"  			REAL NUMBER <-1,+1>
"fBodyBodyGyroJerkMag-mean()"  			REAL NUMBER <-1,+1>
"fBodyBodyGyroJerkMag-std()"  			REAL NUMBER <-1,+1>
"fBodyBodyGyroJerkMag-meanFreq()" 		REAL NUMBER <-1,+1>
