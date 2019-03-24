# GettingAndCleaningData
Repo for Cousera Class - Getting and Cleaning Data

Homework Requirements and Instructions
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

Input Data
One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Assignment
Student is required to create an R script run_analysis.R that performs the following steps:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data processing script

1. Creating data folder, download and unzip data
1.1 Create input folder if it does not exist
if(!file.exists("./data")){
    dir.create("./data")
}

1.2 Download the zip file
inputurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(inputurl,destfile="./data/homeworkdataset.zip")

1.3 Unzip the downloaded data set to the /data directory
unzip(zipfile="./data/homeworkdataset.zip",exdir="./data")

2. Reading input data and assign column names for readability
2.1 Read in the input data
xtraining <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytraining <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjecttraining <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

xtesting <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytesting <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjecttesting <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activitylabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

2.2 Set columnn names
colnames(xtraining) <- features[,2] 
colnames(xtesting) <- features[,2] 

colnames(ytraining) <-"activityid"
colnames(ytesting) <- "activityid"

colnames(subjecttraining) <- "subjectid"
colnames(subjecttesting) <- "subjectid"

colnames(activitylabels) <- c("activityid","activityname")

3. Merge data columns and rows to generate complete data set
completetraining <- cbind(subjecttraining, ytraining, xtraining)

completetesting <- cbind(subjecttesting, ytesting, xtesting)

completedata <- rbind(completetraining, completetesting)

4. Extracting measurements on the mean and std
4.1 Extract only meansurements on mean and std
colnames <- colnames(completedata)

colnamestobeextracted <- (grepl ("subjectid", colnames) |
                          grepl ("activityid", colnames) |
                          grepl ("mean..", colnames) |
                          grepl ("std..", colnames))

extracteddata <- completedata[, colnamestobeextracted==TRUE]

4.2 Merge extracted data and activity labels
extractedatawithactivitylabel <- merge (extracteddata, activitylabels, 
                                        by="activityid", all.x=TRUE)

4.3 Convert extracted data from data frame to data table for the ease of manipulation
extractedatawithactivitylabeldt <- data.table(extractedatawithactivitylabel)

4.4 Order the data table by subject id and activity id
ordercols <- c("subjectid", "activityid")
ordereddt <- setorderv(extractedatawithactivitylabeldt, ordercols)

5. Calculate mean and group by subject id and activity id
aggregateddt <- aggregate(. ~subjectid + activityid, ordereddt, mean)

6. Write the aggregated data into a text file
write.table(aggregateddt, "aggregateddata.txt", row.name=FALSE, sep = "\t")
