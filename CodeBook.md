# Code Book

This code book describes the data file "HAR_Tidy.txt": the origin of the source data, transformations performed to create the tidy data set its variables.

In my CodeBook I will provide a detailed description of the variables, activity labels, my naming strategy, variable selection method, and notation. I am not sure of the value of including detailed descriptions of the meaning and interpretation of each of the many variables that I included. I think it is safer to explain the correspondence and transformations that were applied and link to the original documentation / citation materials (since my dataset and analysis script are both entirely dependent upon it).

### UCI_HAR Data Set

The source data is the "Human Activity Recognition Using Smartphones Dataset" which was created by [Jorge L. Reyes-Ortiz et al.][1]

I retieved the data set "UCI_HAR_Dataset" from the following internet location:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]([https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip])

The "UCI_HAR_Datset" contains a README.txt file which describes the underlaying experiment:

> "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

The "UCI_HAR_Datset" consitsts of multiple files wich are described in the included README.txt:

```
## UCI_HAR_Dataset
## ├── README.txt
## ├── activity_labels.txt
## ├── features.txt
## ├── features_info.txt
## ├── test
## │   ├── Inertial\ Signals
## │   │   ├── body_acc_x_test.txt
## │   │   ├── body_acc_y_test.txt
## │   │   ├── body_acc_z_test.txt
## │   │   ├── body_gyro_x_test.txt
## │   │   ├── body_gyro_y_test.txt
## │   │   ├── body_gyro_z_test.txt
## │   │   ├── total_acc_x_test.txt
## │   │   ├── total_acc_y_test.txt
## │   │   └── total_acc_z_test.txt
## │   ├── X_test.txt
## │   ├── subject_test.txt
## │   └── y_test.txt
## └── train
##     ├── Inertial\ Signals
##     │   ├── body_acc_x_train.txt
##     │   ├── body_acc_y_train.txt
##     │   ├── body_acc_z_train.txt
##     │   ├── body_gyro_x_train.txt
##     │   ├── body_gyro_y_train.txt
##     │   ├── body_gyro_z_train.txt
##     │   ├── total_acc_x_train.txt
##     │   ├── total_acc_y_train.txt
##     │   └── total_acc_z_train.txt
##     ├── X_train.txt
##     ├── subject_train.txt
##     └── y_train.txt
## 
## 4 directories, 28 files
```

I am using the following files as raw data for my analysis: 

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

I chose to ignore all files inside the two "Inertial Signals" folders because they merely hold instument data (also already preprossed) which the study authors used to calculate the variables (or features) in X_test.txt and X_train.txt.


### Data Transformations

I am using the following steps to transform the above mentioned raw data files into a single tidy data set "HAR_Tidy.txt":

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Assign descriptive activity names to name the activities in the data set.
4. Appropriately label the data set with descriptive activity names. 
5. Create an independent tidy data "HAR_Tidy.txt" set with the average of each variable for each activity and each subject.

For details and source code for each of these step refer to the README.md file.


## Variables in HAR_Tidy.txt


  - subject: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
  - activity: Each row identifies one of six activities observed: walking, walking_upstairs, walking_downstairs sitting, standing, laying
  - tBodyAcc_Mean_X: 
  - tBodyAcc_Mean_Y: 
  - tBodyAcc_Mean_Z: 
  - tBodyAcc_Std_X: 
  - tBodyAcc_Std_Y: 
  - tBodyAcc_Std_Z: 
  - tGravityAcc_Mean_X: 
  - tGravityAcc_Mean_Y: 
  - tGravityAcc_Mean_Z: 
  - tGravityAcc_Std_X: 
  - tGravityAcc_Std_Y: 
  - tGravityAcc_Std_Z: 
  - tBodyAccJerk_Mean_X: 
  - tBodyAccJerk_Mean_Y: 
  - tBodyAccJerk_Mean_Z: 
  - tBodyAccJerk_Std_X: 
  - tBodyAccJerk_Std_Y: 
  - tBodyAccJerk_Std_Z: 
  - tBodyGyro_Mean_X: 
  - tBodyGyro_Mean_Y: 
  - tBodyGyro_Mean_Z: 
  - tBodyGyro_Std_X: 
  - tBodyGyro_Std_Y: 
  - tBodyGyro_Std_Z: 
  - tBodyGyroJerk_Mean_X: 
  - tBodyGyroJerk_Mean_Y: 
  - tBodyGyroJerk_Mean_Z: 
  - tBodyGyroJerk_Std_X: 
  - tBodyGyroJerk_Std_Y: 
  - tBodyGyroJerk_Std_Z: 
  - tBodyAccMag_Mean: 
  - tBodyAccMag_Std: 
  - tGravityAccMag_Mean: 
  - tGravityAccMag_Std: 
  - tBodyAccJerkMag_Mean: 
  - tBodyAccJerkMag_Std: 
  - tBodyGyroMag_Mean: 
  - tBodyGyroMag_Std: 
  - tBodyGyroJerkMag_Mean: 
  - tBodyGyroJerkMag_Std: 
  - fBodyAcc_Mean_X: 
  - fBodyAcc_Mean_Y: 
  - fBodyAcc_Mean_Z: 
  - fBodyAcc_Std_X: 
  - fBodyAcc_Std_Y: 
  - fBodyAcc_Std_Z: 
  - fBodyAccJerk_Mean_X: 
  - fBodyAccJerk_Mean_Y: 
  - fBodyAccJerk_Mean_Z: 
  - fBodyAccJerk_Std_X: 
  - fBodyAccJerk_Std_Y: 
  - fBodyAccJerk_Std_Z: 
  - fBodyGyro_Mean_X: 
  - fBodyGyro_Mean_Y: 
  - fBodyGyro_Mean_Z: 
  - fBodyGyro_Std_X: 
  - fBodyGyro_Std_Y: 
  - fBodyGyro_Std_Z: 
  - fBodyAccMag_Mean: 
  - fBodyAccMag_Std: 
  - fBodyBodyAccJerkMag_Mean: 
  - fBodyBodyAccJerkMag_Std: 
  - fBodyBodyGyroMag_Mean: 
  - fBodyBodyGyroMag_Std: 
  - fBodyBodyGyroJerkMag_Mean: 
  - fBodyBodyGyroJerkMag_Std: 

[1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
