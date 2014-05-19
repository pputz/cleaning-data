# Getting and Cleaning Data Course Project

I set up this repo for the Coursera course "Getting and Cleaning Data" (Jeff Leek, Roger D. Peng, Brian Caffo) in May 2012, specifically to share the results of the course project with the same name.

The repo contains the following files:

1. README.md: Description of this repo and details of the R script run_analysis.R
2. Codebook.md: Describes the variables, the data, and any transformations or work that I performed to clean up the data for the tidy data set
3. :Tidy data set
4. run_analysis.R: R script to create the tidy data set from a set of raw data files.



You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


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



```r
1 + 1
```

```
## [1] 2
```



