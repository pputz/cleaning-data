RoCo <- function (x) {
    Cols <- as.integer(system(sprintf("cat '%s' | wc -l", x), intern=TRUE))
    Rows <- as.integer(system(sprintf("head -n1 '%s' | wc -w", x), intern=TRUE))
    c(Cols,Rows)
}

library(data.table)


xTestFile <- "UCI_HAR_Dataset/test/X_test.txt"
xTestDim <- RoCo(xTestFile)

xTestDF <- read.table(xTestFile, sep="", 
                  nrows=xTestDim[1], 
                  colClasses=rep("numeric", xTestDim[2]))

xTestDT <- as.data.table(xTestDF)
rm(xTestDF)

featuresNames <- read.table("UCI_HAR_Dataset/features.txt",
                            row.names=1,
                            colClasses="character")

featuresNames <- gsub("()", "" , featuresNames[,1], fixed = TRUE)
featuresNames <- gsub("-", "_" , featuresNames, fixed = TRUE)

setnames(xTestDT, featuresNames)


yTestFile <- "UCI_HAR_Dataset/test/y_test.txt"
yTestDT <- fread(yTestFile)
setnames(yTestDT, "activity")
yTestDT$activity <- as.factor(yTestDT$activity)

SubTestFile <- "UCI_HAR_Dataset/test/subject_test.txt"
SubTestDT <- fread(SubTestFile)
setnames(SubTestDT, "subject")
#SubTestDT$subject <- as.factor(SubTestDT$subject)

TestDT <- cbind(SubTestDT, yTestDT, xTestDT)
rm(SubTestDT, yTestDT, xTestDT)


xTrainFile <- "UCI_HAR_Dataset/train/X_train.txt"
xTrainDim <- RoCo(xTrainFile)

xTrainDF <- read.table(xTrainFile, sep="", 
                      nrows=xTrainDim[1], 
                      colClasses=rep("numeric", xTrainDim[2]))

xTrainDT <- as.data.table(xTrainDF)
rm(xTrainDF)

yTrainFile <- "UCI_HAR_Dataset/train/y_train.txt"
yTrainDT <- fread(yTrainFile)
setnames(yTrainDT, "activity")
yTrainDT$activity <- as.factor(yTrainDT$activity)

SubTrainFile <- "UCI_HAR_Dataset/train/subject_train.txt"
SubTrainDT <- fread(SubTrainFile)
setnames(SubTrainDT, "subject")
#SubTrainDT$subject <- as.factor(SubTrainDT$subject)

TrainDT <- cbind(SubTrainDT, yTrainDT, xTrainDT)
rm(SubTrainDT, yTrainDT, xTrainDT)

AllDT <- rbindlist(list(TestDT, TrainDT))
rm(TestDT, TrainDT)

setnames(AllDT, c("subject", "activity",featuresNames))



# head(AllDT[,list(subject, activity, tBodyAcc_mean_X)], n=100)


subsetMeansStd <- c("subject", "activity", featuresNames[grep("_mean_|_std_", featuresNames)])

SubsetDT <- AllDT[,subsetMeansStd, with=FALSE]

setkeyv(SubsetDT, c("subject", "activity"))

FinalDT <- SubsetDT[,lapply(.SD, mean),by="subject,activity",.SDcols=3:50]
setkeyv(FinalDT, c("subject", "activity"))

activityLabels <- fread("UCI_HAR_Dataset/activity_labels.txt", colClasses="factor")
setattr(FinalDT$activity,"levels", tolower(activityLabels[ ,V2]))
