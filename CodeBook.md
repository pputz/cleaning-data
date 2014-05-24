# Code Book

This code book describes the data file "HAR_Tidy.txt": the origin and content of the source data and transformations performed to create the tidy data set and its variables.


### UCI_HAR Data Set

The source data is the "Human Activity Recognition Using Smartphones Dataset" which was created by Jorge L. Reyes-Ortiz et al.[1]

I retrieved the data set "UCI_HAR_Dataset" from the following internet location:

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

For details and source code for each of these steps refer to the README.md file.


## Variables in HAR_Tidy.txt

HAR_Tidy.txt has 180 observations and 68 variables. The fist two variables are:

  - subject: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
  - activity: Each row identifies one of six activities observed: walking, walking_upstairs, walking_downstairs sitting, standing, laying. In the orignial experiment the subjects were videotaped in order to identify these activites.

**Each row in HAR_Tidy.txt represents observations for a unique combination of subject and activity.**

The remaining 66 variable are so-called "features". They come from the accelerometer and gyroscope 3-axial raw signals. Reyes-Ortiz et al. caputured these time domain signals (prefix 't' to denote time) at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

**Note:** The units for the measured data are standard gravity units (g) for the accelerometer data and rad/sec for the gyroscope data. However, **all features are normalized and bounded within [-1,1].**


  - tBodyAcc_Mean_X: Arithmetic mean of body acceleration in direction X.
  - tBodyAcc_Mean_Y: Arithmetic mean of body acceleration in direction Y.
  - tBodyAcc_Mean_Z: Arithmetic mean of body acceleration in direction Z.
  - tBodyAcc_Std_X: Standard deviation of body acceleration in direction X.
  - tBodyAcc_Std_Y: Standard deviation of body acceleration in direction Y.
  - tBodyAcc_Std_Z: Standard deviation of body acceleration in direction Z.
  - tGravityAcc_Mean_X: Arithmetic mean of gravity acceleration in direction X.
  - tGravityAcc_Mean_Y: Arithmetic mean of gravity acceleration in direction Y.
  - tGravityAcc_Mean_Z: Arithmetic mean of gravity acceleration in direction Z.
  - tGravityAcc_Std_X: Standard deviation of gravity acceleration in direction X.
  - tGravityAcc_Std_Y: Standard deviation of gravity acceleration in direction Y.
  - tGravityAcc_Std_Z: Standard deviation of gravity acceleration in direction Z.
  
Subsequently, Reyes-Ortiz et al. obtained Jerk signals of the body linear acceleration and angular velocity by deriving them in time. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm. 
 
 
  - tBodyAccJerk_Mean_X: Arithmetic mean of jerk signal of linear body acceleration in direction X.
  - tBodyAccJerk_Mean_Y: Arithmetic mean of jerk signal of linear body acceleration in direction Y.
  - tBodyAccJerk_Mean_Z: Arithmetic mean of jerk signal of linear body acceleration in direction Z.
  - tBodyAccJerk_Std_X: Standard deviation of jerk signal of linear body acceleration in direction X.
  - tBodyAccJerk_Std_Y: Standard deviation of jerk signal of linear body acceleration in direction Y.
  - tBodyAccJerk_Std_Z: Standard deviation of jerk signal of linear body acceleration in direction Z.
  - tBodyGyro_Mean_X: Arithmetic mean of angular body velocity in direction X.
  - tBodyGyro_Mean_Y: Arithmetic mean of angular body velocity in direction Y.
  - tBodyGyro_Mean_Z: Arithmetic mean of angular body velocity in direction Z.
  - tBodyGyro_Std_X: Standard deviation of angular body velocity in direction X.
  - tBodyGyro_Std_Y: Standard deviation of angular body velocity in direction Y.
  - tBodyGyro_Std_Z: Standard deviation of angular body velocity in direction Z.
  - tBodyGyroJerk_Mean_X: Arithmetic mean of jerk signal of angular body velocity in direction X.
  - tBodyGyroJerk_Mean_Y: Arithmetic mean of jerk signal of angular body velocity in direction Y.
  - tBodyGyroJerk_Mean_Z: Arithmetic mean of jerk signal of angular body velocity in direction Z.
  - tBodyGyroJerk_Std_X: Standard deviation of jerk signal of angular body velocity in direction X.
  - tBodyGyroJerk_Std_Y: Standard deviation of jerk signal of angular body velocity in direction Y.
  - tBodyGyroJerk_Std_Z: Standard deviation of jerk signal of angular body velocity in direction Z.
  - tBodyAccMag_Mean: Arithmetic mean of magnitude of linear body acceleration.
  - tBodyAccMag_Std: Standard deviation of magnitude of linear body acceleration.
  - tGravityAccMag_Mean: Arithmetic mean of magnitude of gravity acceleration.
  - tGravityAccMag_Std: Standard deviation of magnitude of gravity acceleration.
  - tBodyAccJerkMag_Mean: Arithmetic mean of jerk magnitude of linear body acceleration.
  - tBodyAccJerkMag_Std: Standard deviation of jerk magnitude of linear body acceleration.
  - tBodyGyroMag_Mean: Arithmetic mean of magnitude of angular body velocity.
  - tBodyGyroMag_Std: Standard deviation of magnitude of angular body velocity.
  - tBodyGyroJerkMag_Mean: Arithmetic mean of jerk magnitude of angular body velocity.
  - tBodyGyroJerkMag_Std: Standard deviation of jerk magnitude of angular body velocity.
  
Finally, Reyes-Ortiz et al. applied a Fast Fourier Transform (FFT) to some of these signals producing frequency domain signals (indicated by 'f').

  - fBodyAcc_Mean_X: Arithmetic mean of body acceleration in direction X (frequency domain).
  - fBodyAcc_Mean_Y: Arithmetic mean of body acceleration in direction Y (frequency domain).
  - fBodyAcc_Mean_Z: Arithmetic mean of body acceleration in direction Z (frequency domain).
  - fBodyAcc_Std_X: Standard deviation of body acceleration in direction X (frequency domain).
  - fBodyAcc_Std_Y: Standard deviation of body acceleration in direction Y (frequency domain).
  - fBodyAcc_Std_Z: Standard deviation of body acceleration in direction Z (frequency domain).
  - fBodyAccJerk_Mean_X: Arithmetic mean of jerk signal of linear body acceleration in direction X (frequency domain).
  - fBodyAccJerk_Mean_Y: Arithmetic mean of jerk signal of linear body acceleration in direction Y (frequency domain).
  - fBodyAccJerk_Mean_Z: Arithmetic mean of jerk signal of linear body acceleration in direction Z (frequency domain).
  - fBodyAccJerk_Std_X: Standard deviation of jerk signal of linear body acceleration in direction X (frequency domain).
  - fBodyAccJerk_Std_Y: Standard deviation of jerk signal of linear body acceleration in direction Y (frequency domain).
  - fBodyAccJerk_Std_Z: Standard deviation of jerk signal of linear body acceleration in direction Z (frequency domain).
  - fBodyGyro_Mean_X: Arithmetic mean of angular body velocity in direction X (frequency domain).
  - fBodyGyro_Mean_Y: Arithmetic mean of angular body velocity in direction Y (frequency domain).
  - fBodyGyro_Mean_Z: Arithmetic mean of angular body velocity in direction Z (frequency domain).
  - fBodyGyro_Std_X: Standard deviation of angular body velocity in direction X (frequency domain).
  - fBodyGyro_Std_Y: Standard deviation of angular body velocity in direction Y (frequency domain).
  - fBodyGyro_Std_Z: Standard deviation of angular body velocity in direction Z (frequency domain).
  - fBodyAccMag_Mean: Arithmetic mean of magnitude of linear body acceleration (frequency domain).
  - fBodyAccMag_Std: Standard deviation of magnitude of linear body acceleration (frequency domain).
  - fBodyBodyAccJerkMag_Mean: Arithmetic mean of jerk magnitude of linear body acceleration (frequency domain).
  - fBodyBodyAccJerkMag_Std: Standard deviation of jerk magnitude of linear body acceleration (frequency domain).
  - fBodyBodyGyroMag_Mean: Arithmetic mean of magnitude of angular body velocity (frequency domain).
  - fBodyBodyGyroMag_Std: Standard deviation of magnitude of angular body velocity (frequency domain).
  - fBodyBodyGyroJerkMag_Mean: Arithmetic mean of jerk magnitude of angular body velocity (frequency domain).
  - fBodyBodyGyroJerkMag_Std: Standard deviation of jerk magnitude of angular body velocity (frequency domain).

[1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
