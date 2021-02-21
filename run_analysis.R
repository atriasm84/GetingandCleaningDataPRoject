library(dplyr)

#Obtain dataset
##First we create the folder structure
if(!file.exists("./data")) {
        dir.create(file.path("./", "data"), showWarnings = FALSE)
        }
if(!file.exists("./data/rawdata")) {
        dir.create(file.path("./data", "rawdata"),showWarnings = FALSE)
}
if(!file.exists("./data/tidydata")) {
        dir.create(file.path("./data", "tidydata"),showWarnings = FALSE)
}

##Now we download and unzip the file
datasetUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipPath<-"./data/zippedRawDataset.zip"
download.file(datasetUrl,zipPath)
unzip(zipPath,exdir="./data/rawdata")


#Merges the training and the test sets to create one data set.
#First we will read all the files
featuresList<-read.table("./data/rawdata/UCI HAR Dataset/features.txt")
activityLabels<-read.table("./data/rawdata/UCI HAR Dataset/activity_labels.txt")
subjectTest<-read.table("./data/rawdata/UCI HAR Dataset/test/subject_test.txt")
activitiesTest<-read.table("./data/rawdata/UCI HAR Dataset/test/y_test.txt")
XTest<-read.table("./data/rawdata/UCI HAR Dataset/test/X_test.txt")
subjectTraining<-read.table("./data/rawdata/UCI HAR Dataset/train/subject_train.txt")
activitiesTraining<-read.table("./data/rawdata/UCI HAR Dataset/train/y_train.txt")
XTraining<-read.table("./data/rawdata/UCI HAR Dataset/train/X_train.txt")

subject<-rbind(subjectTest,subjectTraining)
names(subject)<-"subject"
activity<-rbind(activitiesTest,activitiesTraining)
names(activity)<-"activity"
X<-rbind(XTest,XTraining)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresList <- read.table("./data/rawdata/UCI HAR Dataset/features.txt")
featuresList[,2]<- tolower(featuresList[,2])
namesPositions <-grep("mean|std",featuresList[,2])
namesDescriptions <- grep("mean|std",featuresList[,2],value = TRUE)
#Uses descriptive activity names to name the activities in the data set

activityLabels[,2] < tolower(activityLabels[,2])
activity[,1] <- factor(activity[,1], 
                       levels=activityLabels[,1], labels=activityLabels[,2])

#Appropriately labels the data set with descriptive variable names. 
features<-X[,namesPositions];
names(features)<-gsub("\\(|\\)|-","",namesDescriptions)
dataTidy<-cbind(subject,activity,features)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.        
averages <- dataTidy %>% dplyr::group_by(activity,subject) %>% 
        dplyr::summarize_all(mean)

write.table(averages, file="./data/tidydata/tidydata.txt", row.names=F)


