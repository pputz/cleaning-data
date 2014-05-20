## @knitr RoCo

RoCo <- function (x) {
    Cols <- as.integer(system(sprintf("cat '%s' | wc -l", x), intern=TRUE))
    Rows <- as.integer(system(sprintf("head -n1 '%s' | wc -w", x), intern=TRUE))
    c(Cols,Rows)
}

## @knitr import_test

library(data.table)

## import test data and convert to data.table

xTestFile <- "UCI_HAR_Dataset/test/X_test.txt"
xTestDim <- RoCo(xTestFile)

xTestDF <- read.table(xTestFile, sep="", 
                  nrows=xTestDim[1], 
                  colClasses=rep("numeric", xTestDim[2]))

xTestDT <- as.data.table(xTestDF)
rm(xTestDF)


## import "subject" and "activity" variables

yTestDT <- fread("UCI_HAR_Dataset/test/y_test.txt")
SubTestDT <- fread("UCI_HAR_Dataset/test/subject_test.txt")


## merge test data with subject and activity variable;
## delete unused data.tables

TestDT <- cbind(SubTestDT, yTestDT, xTestDT)
rm(SubTestDT, yTestDT, xTestDT)



## @knitr import_training

## import training data and convert to data.table;
## merge with "subject" and "activity variable"

xTrainFile <- "UCI_HAR_Dataset/train/X_train.txt"
xTrainDim <- RoCo(xTrainFile)

xTrainDF <- read.table(xTrainFile, sep="", 
                      nrows=xTrainDim[1], 
                      colClasses=rep("numeric", xTrainDim[2]))

xTrainDT <- as.data.table(xTrainDF)
rm(xTrainDF)


yTrainDT <- fread("UCI_HAR_Dataset/train/y_train.txt")
SubTrainDT <- fread("UCI_HAR_Dataset/train/subject_train.txt")


TrainDT <- cbind(SubTrainDT, yTrainDT, xTrainDT)
rm(SubTrainDT, yTrainDT, xTrainDT)


## @knitr merge

## merge test and training data;
## clean up

AllDT <- rbindlist(list(TestDT, TrainDT))
rm(TestDT, TrainDT)


## @knitr names

## add variable names based on "features.txt";
## replace characters not allowed in R names like "()" and "-"

featuresNames <- read.table("UCI_HAR_Dataset/features.txt",
                            row.names=1,
                            colClasses="character")

featuresNames <- gsub("()", "" , featuresNames[,1], fixed = TRUE)
featuresNames <- gsub("-", "_" , featuresNames, fixed = TRUE)

setnames(AllDT, c("subject", "activity",featuresNames))



# head(AllDT[,list(subject, activity, tBodyAcc_mean_X)], n=100)


## @knitr subset
## Create vetor with selected variable names; subset data.table
subsetMeansStd <- c("subject", "activity", featuresNames[grep("_mean_|_mean$|_std", featuresNames)])
SubsetDT <- AllDT[,subsetMeansStd, with=FALSE]



## @knitr activity_lables
## Import activity lables; change "activity" variable into factor;
## use the datatable funtion setattributes to change factor levels
activityLabels <- fread("UCI_HAR_Dataset/activity_labels.txt", colClasses="factor")
SubsetDT$activity <- as.factor(SubsetDT$activity)
setattr(SubsetDT$activity,"levels", tolower(activityLabels[ ,V2]))




## @knitr tidy
## set idexes for data.table; calculate group means; sort nicely
setkeyv(SubsetDT, c("subject", "activity"))
TidyDT <- SubsetDT[, lapply(.SD, mean), by="subject,activity", .SDcols=3:ncol(SubsetDT)]
setkeyv(TidyDT, c("subject", "activity"))

write.table(TidyDT, "HAR_Tidy.txt", quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)


