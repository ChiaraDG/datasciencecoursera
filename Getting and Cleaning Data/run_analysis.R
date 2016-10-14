library(dplyr)

# Download the data in a zip file called data.zip
if(!file.exists("data")){
      dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Reproducible Research/Peer Assessment 2/data/data.zip", method = "curl")

# Unzip the datasets necessary for the analysis
dat <- unzip("./Getting and Cleaning Data/data.zip")
Xtrain <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
features <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/features.txt")
ytrain <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
Xtest <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")
activity <- read.table("./Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")

featuresname <- features$V2
names(Xtrain) <- featuresname
names(Xtest) <- featuresname
names(ytrain) <- "Activity"
names(ytest) <- "Activity"

names(subjecttrain) <- "SubjectID"
Xtrain <- cbind(subjecttrain, Xtrain)
traindat <- cbind(ytrain, Xtrain)

names(subjecttest) <- "SubjectID"
Xtest <- cbind(subjecttest, Xtest)
testdat <- cbind(ytest, Xtest)

# Merge the training and the test sets to create one data set.
datMerge <- rbind(traindat, testdat)
rm(Xtrain); rm(Xtest); rm(ytrain); rm(ytest)
rm(subjecttest); rm(subjecttrain); rm(features)

# Extract the measurements on the mean and standard deviation for each measurement.
datMerge <- datMerge[,c(1:2,grep("(mean|std)\\(\\)", names(datMerge)))]

# Use descriptive activity names to name the activities in the data set.
datMerge$Activity <- factor(datMerge$Activity)
levels(datMerge$Activity) <- activity$V2
table(datMerge$Activity)


# Creates a tidy data set with the average of each variable for each activity and each subject.
datmean <- datMerge %>% group_by(SubjectID,Activity) %>% summarise_each(funs(mean))
# Label the data set with descriptive variable names
newname <- gsub("^(t)","Time",names(datmean))
newname <- gsub("Acc","Acceleration",newname)
newname <- gsub("\\()","",newname)
newname <- gsub("-mean","Mean",newname)
newname <- gsub("-X","X",newname)
newname <- gsub("-Y","Y",newname)
newname <- gsub("-Z","Z",newname)
newname <- gsub("-std","STD",newname)

names(datmean) <- newname

# Save the newly created dataset in txt format
write.table(datmean, "MeanAndStdByActivityAndID.txt")
