Code Book

This code book describes the data used in the analysis that produced the second tidy data set that has been uploaded, as well as the processing steps that have been undertaken to produce the resulting second tidy data set.

Data Overview:
30 volunteers were recruited and performed 6 different activities while wearing a Samsung smartphone. The smartphone captured various data about their activities.  The data set from the 30 volunteers were divided into the training set (21 volunteers) and tesing set (9 volunteers).

Brief Description of the Data Files:

X_train.txt: 7352 observations of the 561 features for the training set

y_train.txt: A vector of 7352 integers which denotes the activity id of the activity.  Each activity id matches with the observation on the corresponding row in X_train.txt.

subject_train.txt: A vector of 7352 integers which denotes the subject id of each volunteer. Each subject id matches with the observation on the corresponding row in X_train.txt.

X_test.txt: 2947 observations of the 561 features for the testing set

y_test.txt: A vector of 2947 integers which denotes the activity id of the activity.  Each activity id matches with the observation on the corresponding row in X_test.txt.

subject_test.txt: A vector of 2947 integers which denotes the subject id of each volunteer. Each subject id matches with the observation on the corresponding row in X_test.txt.

features.txt: Names of the 561 features captured by the smart phones.

activity_labels.txt: Ids and names mapping for the 6 activities

Additional information about the files can be found in the README.txt. Additional information about the features can be found in features_info.txt.  README.txt and features_info.txt were not used in the run_analysis.R script.

Raw data files in the "Inertial Signals" folders of training and testing data sets were ignored.

Processing Steps:

All of the relevant data files were first read into data frames.  After that, appropriate column headers were added for readability.  All data frames for training and testing were combined into a training data frame and testing data frame. An additional step to combine training and testing was performed to produce the complete data set.
All feature columns that are not subjectid or activityid or did not contain "mean" or "std" were removed. 
The activity label column is added to the the extracted data table.
A second tidy data set was created by calculating the mean by subjectid and activityid.  Since there are 30 subjects and 6 activities.  The resulting second tidy data file has 180 rows.
The resulting second tidy data set was output to a tab delimited text file.
