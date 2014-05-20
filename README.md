# Course Project: Getting and Cleaning Data

This repo is set up for the Coursera course "Getting and Cleaning Data" (May 2012 by Jeff Leek, Roger D. Peng, Brian Caffo), specifically to share the results of the course project with the same name.

The repo contains the following files:

1. README.md: Description of this repo and details of the R script run_analysis.R
2. Codebook.md: Describes the variables, the data, and any transformations or work that I performed to clean up the data for the tidy data set
3. :Tidy data set
4. run_analysis.R: R script to create the tidy data set from a set of raw data files.


The assignment for the course project was to clean up a specific set of accelerometer data [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]([https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]) and also provide a code book for the tidy data.

Specifically, the assignment states:

> create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive activity names. 
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

So here we go:




## 1. Merge the training and the test sets to create one data set

I am assuming that the "raw" data set alrady exists in the local directory at the same level as the run_analysis.R script. The data set consitsts of multiple files:

# ```{r file-tree, engine='bash', echo=FALSE}
# tree UCI_HAR_Dataset
# ```

Not all data files are used to produce the tidy data set. I am considering the files X_test.txt and X_train.txt the main source for creating the tidy data set. I am ignoring the content of the "Inertial Signal" folders since they hold the data - also already preprossed - that were used to calculate the variables (or features) in X_test.txt and X_train.txt.

I am using data.tables and the associated function fread() for data import into R. However, I could not find a way for fread() to deal with the extra white spaces in the two main data files X_test.txt and X_train.txt. Therefore, I am using read.table() for those two files and convert the data.frames later into data.tables. 

I created a fuction RoCo() that uses bash commands to return the number of rows and columns in a text file. I am using the results as attributes in the read.table() funtion in order to improve its speed.


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


The result is a data.table with 563 columns and 10299 rows. The last step is to add variable names. I import the names for the feature variables from features.txt and manually add the lables "subject" and "activity" for the first two columns. However, the names in features.txt contain strings that cause problems in R like "(", ")", and "-". So I delete or replace them.


```r
## add variable names based on 'features.txt'; replace characters not allowed
## in R names like '()' and '-'

featuresNames <- read.table("UCI_HAR_Dataset/features.txt", row.names = 1, colClasses = "character")

featuresNames <- gsub("()", "", featuresNames[, 1], fixed = TRUE)
featuresNames <- gsub("-", "_", featuresNames, fixed = TRUE)

setnames(AllDT, c("subject", "activity", featuresNames))



# head(AllDT[,list(subject, activity, tBodyAcc_mean_X)], n=100)
```


## 2. Extract only the measurements on the mean and standard deviation for each measurement

This is a tricky one. I decide to use all variables that have "_std" in their names. However, for the "mean" variables I exlclude "meanFreq()" and all "angle" variables. The resulting subset contains an equal number of 33 mean and std variables.


```r
## Create vetor with selected variable names; subset data.table
subsetMeansStd <- c("subject", "activity", featuresNames[grep("_mean_|_mean$|_std", 
    featuresNames)])
SubsetDT <- AllDT[, subsetMeansStd, with = FALSE]
```


## 3. Use descriptive activity names to name the activities in the data set

I import activity labels from activity_labels.txt. Then change the "activity" variable of the data.table into a factor and finally change the level attributes using the activity labels.


```r
## Import activity lables; change 'activity' variable into factor; use the
## datatable funtion setattributes to change factor levels
activityLabels <- fread("UCI_HAR_Dataset/activity_labels.txt", colClasses = "factor")
SubsetDT$activity <- as.factor(SubsetDT$activity)
setattr(SubsetDT$activity, "levels", tolower(activityLabels[, V2]))
```



## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

For this I use the data.table capabilties. First I use "subject" and "activity" as keys for the data.table. Then caclulate the group means using the "by" argument. Then I sort the resulting TidyDT nicely by subject and activity. And finally I write out the tidy data set as a tab separated text file.


```r
## set idexes for data.table; calculate group means; sort nicely
setkeyv(SubsetDT, c("subject", "activity"))
TidyDT <- SubsetDT[, lapply(.SD, mean), by = "subject,activity", .SDcols = 3:ncol(SubsetDT)]
setkeyv(TidyDT, c("subject", "activity"))

write.table(TidyDT, "HAR_Tidy.txt", quote = FALSE, sep = "\t", row.names = FALSE, 
    col.names = TRUE)
```


