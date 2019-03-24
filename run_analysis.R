library (data.table)

if(!file.exists("./data")){
    dir.create("./data")
}

inputurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(inputurl,destfile="./data/homeworkdataset.zip")

# Unzip the downloaded data set to the /data directory
unzip(zipfile="./data/homeworkdataset.zip",exdir="./data")

# Reading in trainings, testing, feature and activity label data sets 
xtraining <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytraining <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjecttraining <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

xtesting <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytesting <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjecttesting <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activitylabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Add column names to make the data more readable

# use feature names as the column names for xtraining and xtesting
colnames(xtraining) <- features[,2] 
colnames(xtesting) <- features[,2] 

# ytraining and ytesting contains the corresponding activity id
colnames(ytraining) <-"activityid"
colnames(ytesting) <- "activityid"

# subjecttraining and subjecttesting contains the subject ids for the volunteers 
colnames(subjecttraining) <- "subjectid"
colnames(subjecttesting) <- "subjectid"

colnames(activitylabels) <- c("activityid","activityname")

# Merge all training data together using cbind
completetraining <- cbind(subjecttraining, ytraining, xtraining)

# Merge all testing data together using cbind
completetesting <- cbind(subjecttesting, ytesting, xtesting)

#merge trainig and testing using rbind
completedata <- rbind(completetraining, completetesting)

# extracting measurements on the mean and std in addition to subject id
# and activity id from all the columns
colnames <- colnames(completedata)

colnamestobeextracted <- (grepl ("subjectid", colnames) |
                          grepl ("activityid", colnames) |
                          grepl ("mean()", colnames, fixed=TRUE) |
                          grepl ("std()", colnames, fixed=TRUE))

extracteddata <- completedata[, colnamestobeextracted==TRUE]

# merge extracted data and activitylabels data set by activityid
extractedatawithactivitylabel <- merge (extracteddata, activitylabels, 
                                        by="activityid", all.x=TRUE)

# convert the data frame into data table for easy manipulation
extractedatawithactivitylabeldt <- data.table(extractedatawithactivitylabel)

# order the data set by subject id then activity id 

ordercols <- c("subjectid", "activityid")
ordereddt <- setorderv(extractedatawithactivitylabeldt, ordercols)

# Calculate mean and group by subject id and activity id
aggregateddt <- aggregate(. ~subjectid + activityid, ordereddt, mean)

# write the aggregated data into a text file and omit row names
write.table(aggregateddt, "aggregateddata.txt", row.name=FALSE, sep = "\t")

