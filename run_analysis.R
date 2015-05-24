install.packages("data.table")
install.packages("dplyr")

library(data.table)
library(dplyr)

#set the working directory path
dirpath <- "C:/Users/soso/Documents/Coursera/Cours 3/UCI HAR Dataset"

#load the features and activity labels
features <- read.table(dir(dirpath, recursive=T, pattern="features.txt", full.name=T))
activity_labels <- (dir(dirpath, recursive=T, pattern="activity_labels.txt", full.name=T))

#load the X data tables from train and test
X_train <- read.table (dir(dirpath, recursive=T, pattern="X_train.txt", full.names=T))
X_test <- read.table (dir(dirpath, recursive=T, pattern="X_test.txt", full.names=T))

#load the y and subject data tables from train and test

y_train <- read.table (dir(dirpath, recursive=T, pattern="^y_train.txt", full.names=T))
subject_train <- read.table (dir(dirpath, recursive=T, pattern="subject_train.txt", full.names=T))
y_test <- read.table (dir(dirpath, recursive=T, pattern="^y_test.txt", full.names=T))
subject_test <- read.table (dir(dirpath, recursive=T, pattern="subject_test.txt", full.names=T))

#load activity labels
activity_labels<- read.table (dir(dirpath, recursive=T, pattern="activity_labels.txt", full.names=T))

#create one data set for each experiment
subject= rbind (subject_train, subject_test)
activity= rbind(y_train, y_test)
featureX= rbind(X_train, X_test)

#name the y_"" and subject_"" sets column "ACTIVITY ID" and "SUBJECT" respectively
colnames(subject) <- "SUBJECT"
colnames(activity) <- "ACTIVITY"

#name the data set features
colnames(featureX)<- features$V2

#merge the train and test data sets to create one data set
mergedall= cbind(subject, activity, featuresX)

#Extracts only mean and SD columns
extracteddata<-featureX[,grepl("mean|std",names(featureX))]

#recreate a data set with requireddata and subject and activity

finaldata<- cbind(subject, activity, extracteddata)

#Name the activities in the data set
activity[,1]= activity_labels[activity[,1],2]

#label appropriately
names(finaldata)<-gsub("Acc", "Acceleration", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("^t", "Time", names(finaldata))
names(finaldata)<-gsub("^f", "Frequency", names(finaldata))
names(finaldata)<-gsub("tBody", "TimeBody", names(finaldata))
names(finaldata)<-gsub("-mean()", "Mean", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-std()", "Standard deviation", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-freq()", "Frequency", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("angle", "Angular", names(finaldata))
names(finaldata)<-gsub("gravity", "Gravity", names(finaldata))

#create a second, independent tidy data set with the average of each variable for each activity and each subject.
finaldata[,1]<- as.factor(finaldata[,1])
tidy_data = aggregate(. ~SUBJECT+ ACTIVITY, finaldata, mean)
tidy_data<- order(finaldata$ACTIVITY, finaldata$SUBJECT)
write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)

