# Course Project: Getting and Cleaning Data

This repo is for the Coursera course "Getting and Cleaning Data" (May 2012 by Jeff Leek, Roger D. Peng, Brian Caffo), specifically to share the results of the course project with the same name.

The repo contains the following files:

1. README.md: Description of the files in this repo and details of the R script run_analysis.R
1. README.Rmd: R markdown file with knitr commands used to create the README.md file
2. Codebook.md: Describes the variables, the data, and any transformations performed to clean up the data for the tidy data set
3. HAR_Tidy.txt :Tidy data set (tab delimited text file)
4. run_analysis.R: R script to create the tidy data set from a set of raw data files.


The assignment for the course project was to clean up a specific set of accelerometer and gyroscope data and also provide a code book for the tidy data. The source data can be downloaded here (see CodeBood.md details on origin and content):

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]([https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip])

Specifically, the assignment states:

> create one R script called run_analysis.R that does the following: 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive activity names. 
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

So here we go:




### 1. Merge the training and the test sets to create one data set

I am assuming that the "raw" data set alrady exists in the local directory at the same level as the run_analysis.R script. The data set consitsts of multiple files:


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


Not all data files are used to produce the tidy data set. I am considering the files X_test.txt and X_train.txt the main source for creating the tidy data set. I am ignoring the content of the "Inertial Signal" folders since they hold the data - also already preprossed - that were used to calculate the variables (or features) in X_test.txt and X_train.txt.

I am using data.tables and the associated function fread() for data import into R. However, I could not find a way for fread() to deal with the extra white spaces in the two main data files X_test.txt and X_train.txt. Therefore, I am using read.table() for those two files and convert the data.frames later into data.tables. 

I created a function RoCo() that uses bash commands to return the number of rows and columns in a text file. I use the results as attributes in the read.table() function to improve its speed.


```r
RoCo <- function(x) {
    Cols <- as.integer(system(sprintf("cat '%s' | wc -l", x), intern = TRUE))
    Rows <- as.integer(system(sprintf("head -n1 '%s' | wc -w", x), intern = TRUE))
    c(Cols, Rows)
}
```


With this, I am ready to read in the test data and merge (cbind) them with the variables subject and activities.


```r
library(data.table)

## import test data and convert to data.table

xTestFile <- "UCI_HAR_Dataset/test/X_test.txt"
xTestDim <- RoCo(xTestFile)

xTestDF <- read.table(xTestFile, sep = "", nrows = xTestDim[1], colClasses = rep("numeric", 
    xTestDim[2]))

xTestDT <- as.data.table(xTestDF)
rm(xTestDF)


## import 'subject' and 'activity' variables

yTestDT <- fread("UCI_HAR_Dataset/test/y_test.txt")
SubTestDT <- fread("UCI_HAR_Dataset/test/subject_test.txt")


## merge test data with subject and activity variable; delete unused
## data.tables

TestDT <- cbind(SubTestDT, yTestDT, xTestDT)
rm(SubTestDT, yTestDT, xTestDT)
```


Next, do the same with the training data.


```r
## import training data and convert to data.table; merge with 'subject' and
## 'activity variable'

xTrainFile <- "UCI_HAR_Dataset/train/X_train.txt"
xTrainDim <- RoCo(xTrainFile)

xTrainDF <- read.table(xTrainFile, sep = "", nrows = xTrainDim[1], colClasses = rep("numeric", 
    xTrainDim[2]))

xTrainDT <- as.data.table(xTrainDF)
rm(xTrainDF)


yTrainDT <- fread("UCI_HAR_Dataset/train/y_train.txt")
SubTrainDT <- fread("UCI_HAR_Dataset/train/subject_train.txt")


TrainDT <- cbind(SubTrainDT, yTrainDT, xTrainDT)
rm(SubTrainDT, yTrainDT, xTrainDT)
```


Now, let's merge the training and test data.table.


```r
## merge test and training data; clean up

AllDT <- rbindlist(list(TestDT, TrainDT))
rm(TestDT, TrainDT)
```


The result is a data.table with 563 columns and 10299 rows. The next step is to add variable names. I import the names for the feature variables from features.txt and manually add the labels "subject" and "activity" for the first two columns. However, the names in features.txt contain strings that cause problems in R like "()" and "-". So I delete or replace them.


```r
## add variable names based on 'features.txt'; replace characters not allowed
## in R names like '()' and '-'

featuresNames <- read.table("UCI_HAR_Dataset/features.txt", row.names = 1, colClasses = "character")

featuresNames <- gsub("()", "", featuresNames[, 1], fixed = TRUE)
featuresNames <- gsub("-", "_", featuresNames, fixed = TRUE)

setnames(AllDT, c("subject", "activity", featuresNames))
```


Finally, I check for any NAs and if all values are within the expected ranges.


```r
## test for NAs;
test <- NULL
test[1] <- any(is.na(AllDT))

## test whether all values are within the expected ranges
test[2] <- any(AllDT$subject < 1 | AllDT$subject > 30)
test[3] <- any(AllDT$activity < 1 | AllDT$activity > 6)

test[4] <- any(AllDT[, 3:ncol(AllDT), with = FALSE] < -1)
test[5] <- any(AllDT[, 3:ncol(AllDT), with = FALSE] > 1)

any(test == TRUE)  ## expected result: FALSE
```

```
## [1] FALSE
```


So everything looks good!

### 2. Extract only the measurements on the mean and standard deviation for each measurement

I decide to use all variables that have "_std" in their names. However, for the "mean" variables I exlclude "meanFreq()" and all "angle" variables. The resulting subset contains an equal number of 33 mean and std variables.


```r
## Create vetor with selected variable names; subset data.table
subsetMeansStd <- c("subject", "activity", featuresNames[grep("_mean_|_mean$|_std", 
    featuresNames)])
SubsetDT <- AllDT[, subsetMeansStd, with = FALSE]
```


### 3. Use descriptive activity names to name the activities in the data set

I import activity labels from activity_labels.txt. Then change the "activity" variable of the data.table into a factor and finally change the level attributes using the activity labels.


```r
## Import activity labels; change 'activity' variable into factor; use the
## datatable funtion setattributes to change factor levels
activityLabels <- fread("UCI_HAR_Dataset/activity_labels.txt", colClasses = "factor")
SubsetDT$activity <- as.factor(SubsetDT$activity)
setattr(SubsetDT$activity, "levels", tolower(activityLabels[, V2]))
```


### 4. Appropriately label the data set with descriptive activity names

My goal is to use labels that a) describe the variable as good as possible, b) are concise (i.e. brief), c) easy to read, and d) do not contain any charcters that create trouble in R. I have dealt with d) already in step 1 above. Looking at the current labels, I find them already pretty good (e.g. "tBodyAcc_std_X", "fBodyGyro_mean_Z"). They already are very descriptive and carry a lot of meaning. Surely, I could spell out all the individual components but such long labels would violate my criterion b).

The only little thing, I'd like to change is to use upper case for "Mean" and "Std". In my mind it enhances readability through a better "camel case" rhythm. I like the underscores before Mean/Std and before X/Y/Z because it separates the label into three differen components: technical description of the measurement, statistical metric, and spacial direction.


```r
## Get current labels and change _mean and _std to upper case; apply new
## labels to data.table

newLabels <- gsub("_mean", "_Mean", names(SubsetDT), fixed = TRUE)
newLabels <- gsub("_std", "_Std", newLabels, fixed = TRUE)
setnames(SubsetDT, newLabels)
```



### 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

For this I use the data.table capabilties. First I use "subject" and "activity" as keys for the data.table. Then caclulate the group means using the "by" argument. Then I sort the resulting TidyDT nicely by subject and activity. And finally I write out the tidy data set as a tab separated text file. HAR_Tidy.txt has 180 observations and 68 variables.


```r
## set idexes for data.table; calculate group means; sort nicely
setkeyv(SubsetDT, c("subject", "activity"))
TidyDT <- SubsetDT[, lapply(.SD, mean), by = "subject,activity", .SDcols = 3:ncol(SubsetDT)]
setkeyv(TidyDT, c("subject", "activity"))

write.table(TidyDT, "HAR_Tidy.txt", quote = FALSE, sep = "\t", row.names = FALSE, 
    col.names = TRUE)
```


