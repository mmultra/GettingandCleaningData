####Goals Of This Assignment####
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation 
#   for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.

#data from this site https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##install.packages("dplyr")
library(dplyr)

#for goal 1 load the training and tests sets and then combine them
trainx<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainy<-read.table("./UCI HAR Dataset/train/Y_train.txt")
testx<-read.table("./UCI HAR Dataset/test/X_test.txt")
testy<-read.table("./UCI HAR Dataset/test/Y_test.txt")

mergedX <- rbind(trainx, testx)
mergedY <- rbind(trainy, testy)

#goal 2: extract means and stdev
#load in features.txt which has all the dataset mean and stddevs
features<-read.table("./UCI HAR Dataset/features.txt")
mean_and_stddev<-features[grep("mean|std", features[,2]),]
mergedX<-mergedX[,mean_and_stddev[,1]]

#goal 3: make descriptive activity names 
#read in activity labels data
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

colnames(mergedY)<-"name"
mergedY$name<-factor(mergedY$name, labels=as.character(activity_labels[,2]))

#goal 4: give descriptive variable names
colnames(mergedX)<-features[mean_and_stddev[,1],2]

#goal 5: create tidy data set with the average of 
#each variable for each activity and each subject
#load in the subject data
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
sub<-rbind(subtrain, subtest)

colnames(sub) <- "name"
df <- cbind(mergedX, mergedY$name, sub) %>% group_by(mergedY$name, name) %>% 
      summarize_each(funs(mean))
names(df)[1]<-"Activity"
tidydf<- write.table(df, file = "./UCI HAR Dataset/tidydf.txt",row.names=FALSE, col.names=TRUE)

