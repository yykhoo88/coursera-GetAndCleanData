#cleanup, change local working directory
rm(list=ls())
getwd()
setwd("/Dropbox/Dropbox/Codes/Rstudio")

library(reshape2)

#file handling: downloading dataset and unzip if not yet!
filename <- "getdata_dataset_GettingData_w4.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#lets first load activity labels and features.
#change them into characters
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#we only need features that are essentially mean/std dev
####objective 2: Extracts only the measurements on the mean and standard deviation for each measurement.
myFeatures <- grep(".*mean.*|.*std.*", features[,2]) #grep indexes
myFeatures.label <- features[myFeatures,2] #list all the wanted names

#loading dataset. Notice that:
#x_train.txt contain rows that correspond to y_train.txt (key is read on activity_latbels.txt)
#x_train.txt contain cols that correspond to features.txt
#subject_train.txt gives the person that done the training
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")[myFeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainData <- cbind(trainSubjects, trainActivities, trainData) #combine training data

#do the same for test data
testData <- read.table("UCI HAR Dataset/test/X_test.txt")[myFeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testData <- cbind(testSubjects, testActivities, testData)

#then we merge the dataset
####objective 1: Merges the training and the test sets to create one data set.
fullData <- rbind(trainData, testData)

#before putting myFeatures.label, lets clean it up
#clean up myFeatures.label
####objective 3: Uses descriptive activity names to name the activities in the data set
####objective 4: Appropriately labels the data set with descriptive variable names.
myFeatures.label = gsub('-mean', 'Mean', myFeatures.label)
myFeatures.label = gsub('-std', 'Std', myFeatures.label)
myFeatures.label <- gsub('[-()]', '', myFeatures.label)

#combine myFeatures inside, with first two column being subject & activity, then change subject & activities to factors (so easier to mean later)
colnames(fullData) <- c("subject", "activity", myFeatures.label)
fullData$activity <- factor(fullData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
fullData$subject <- as.factor(fullData$subject)

#we average all the data "for each activity, each subject"
####objective 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
fullData.melt <- melt(fullData, id = c("subject", "activity")) #melt data into columns (subject, activity, variable, value)
fullData.mean <- dcast(fullData.melt, subject + activity ~ variable, mean) #for each activity, each subject

#finally write it into a file
write.table(fullData.mean, "fullData_CleanedUp.txt", row.names = FALSE, quote = FALSE)
