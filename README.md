# Getting-and-cleaning-data

DATA PROCESSING

•	Data sets loading:
Data were all loaded previous to processing. Path to the main directory was loaded in a dirpath character variable. Then all table are loaded using the read.table() function, and the path to the different file names included in the pattern= parameter,  is indicated using the dir() function including the dirpath variable and a recursive= TRUE parameter. All data table are loaded in a variable corresponding to file name.

>dirpath <- "C:/Users/soso/Documents/Coursera/Cours 3/UCI HAR Dataset"

>features <- read.table(dir(dirpath, recursive=T, pattern="features.txt", full.name=T))
>activity_labels <- (dir(dirpath, recursive=T, pattern="activity_labels.txt", full.name=T))
>X_train <- read.table (dir(dirpath, recursive=T, pattern="X_train.txt", full.names=T))
>X_test <- read.table (dir(dirpath, recursive=T, pattern="X_test.txt", full.names=T))
>y_train <- read.table (dir(dirpath, recursive=T, pattern="^y_train.txt", full.names=T))
>subject_train <- read.table (dir(dirpath, recursive=T, pattern="subject_train.txt", full.names=T))
>y_test <- read.table (dir(dirpath, recursive=T, pattern="^y_test.txt", full.names=T))
>subject_test <- read.table (dir(dirpath, recursive=T, pattern="subject_test.txt", full.names=T))
>activity_labels<- read.table (dir(dirpath, recursive=T, pattern="activity_labels.txt", full.names=T))

•	Merge training and test sets and name the different columns
Subject files subject_train.txt and subject_test.txt were merged by row binding rbind() in one dataset named subject, the same thing was done for the y_train.txt and y_test.txt files in a data set called Activity, and for the X_train.txt and X_test.txt files in a feature one.

>subject= rbind (subject_train, subject_test)
>activity= rbind(y_train, y_test)
>featureX= rbind(X_train, X_test)

Those three data sets are named using the colnames() function. The subject and activity one column datasets are named respectively “SUBJECT” and “ACTIVITY”. The featuresX columns are named using the features data sets second column “V2” still using the colnames() function. Then those three data sets are merged into one named mergedall by column binding using the cbind() function.

>colnames(subject) <- "SUBJECT"
>colnames(activity) <- "ACTIVITY"
>colnames(featureX)<- features$V2
>mergedall= cbind(subject, activity, featuresX)

•	Extracts only mean and SD columns
The column containing “men” or “std” sting are extracted from the featureX data table using the grepl() function, and stocked in a variable called extracteddata. A final data set called finaldata, including those extracted data is created using the cbind() function.

>extracteddata<-featureX[,grepl("mean|std",names(featureX))]
>finaldata<- cbind(subject, activity, extracteddata)

•	Name the activities in the data set
The activities included in the y_test and y_train data tables are coded according to a numeric correspondence which is included in the activity_labels data table. In order to replace the numbers in the activity by their corresponding names we matched the numbers in the first column of activity dataset with the second of the activity_labels one.
 
>activity[,1]= activity_labels[activity[,1],2]

•	Label appropriately the data set
Features in the finaldata table are named not properly. We Used the gsub() function to replace them. As a consequence Acc is replaced by Acceleration, Gyro by Gyroscope, Mag by Magnitude etc…

>names(finaldata)<-gsub("Acc", "Acceleration", names(finaldata))
>names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
>names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
>names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
>names(finaldata)<-gsub("^t", "Time", names(finaldata))
>names(finaldata)<-gsub("^f", "Frequency", names(finaldata))
>names(finaldata)<-gsub("tBody", "TimeBody", names(finaldata))
>names(finaldata)<-gsub("-mean()", "Mean", names(finaldata), ignore.case = TRUE)
>names(finaldata)<-gsub("-std()", "Standard deviation", names(finaldata), ignore.case = TRUE)
>names(finaldata)<-gsub("-freq()", "Frequency", names(finaldata), ignore.case = TRUE)
>names(finaldata)<-gsub("angle", "Angular", names(finaldata))
>names(finaldata)<-gsub("gravity", "Gravity", names(finaldata))

•	Create an independent tidy data set with the average of each variable for each activity and each subject
To finish we used the subject id as a factor to calculate the mean of the measures for each activity and used the aggregate() function to create a data set named tidy_data. Then we order this data set according to the activity and subject respectively. Using the write.table() function including an argument row.names=FALSE we recorded a “.txt” file names “tidy_data.txt” 

>finaldata[,1]<- as.factor(finaldata[,1])
>tidy_data = aggregate(. ~SUBJECT+ ACTIVITY, finaldata, mean)
>tidy_data<- order(finaldata$ACTIVITY, finaldata$SUBJECT)
>write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)
