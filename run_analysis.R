# Preparation
# Setting/creating the workdirectory
	setwd("C:/Users/nl22423/Documents/Cursussen/G&CData/Project")
# Downloading & unzipping of the data is done manually in the windows GUI maintaining the directory structure in zip-file
# sucessively reading data into dataframes for test and train data
	try_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
	subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
	y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
	try_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
	subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
	y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
# read activity names and feature names into dataframes
# assign the feature names to variables in both test and train
# establish the indices of the mean and std of the measurements for testdata in order to
# (some feature names have "Mean"starting with a capital letter: Because they are not proper means I wil not take them into account!!!)
# select only the features with mean and std of features from test an train data
	features<-read.table("./UCI HAR Dataset/features.txt")
	activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
	names(try_test)<-features$V2
	names(try_train)<-features$V2
	mean_std_ind<-grep("mean|std",names(try_train))
	try_test<-try_test[,mean_std_ind]
	try_train<-try_train[,mean_std_ind]
# the subject and activity columns must be added to the data for both test and train data
# column name "subject" to subject_test then as first column to test df
# create column "activity" to test df then fill "activity" column with substituted y_test
# as last step fill the remaining columns of test
	names(subject_test)<-"subject"
	test<-subject_test
	test$activity<-NA
	names(y_test)<-"activity"
	test$activity<-activities[y_test[,],2]
	test[names(try_test)]<-NA
	test[names(try_test)]<-try_test
# column name "subject" to subject_train then as first column to train df
# create column "activity" to train df then fill "activity" column with substituted y_train
# as last step fill the remaining columns of train
	names(subject_train)<-"subject"
	train<-subject_train
	train$activity<-NA
	names(y_train)<-"activity"
	train$activity<-activities[y_train[,],2]
	train[names(try_train)]<-NA
	train[names(try_train)]<-try_train
# finally join test an train verically and calculate de means of all remaining measurements per subject and activity combination
	result<-rbind(test,train)
	library(dplyr)
	grouped_result<-group_by(result,subject,activity)
	tidy_result<-summarise_each(grouped_result,"mean")
#location file must be updated
	write.table(tidy_result,file="tidy_result.txt",row.name=FALSE)