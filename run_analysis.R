

# What directory we are in? ####
# getwd() and setwd()
getwd()
setwd("C:/Users/semiyari/Desktop/R/c.era")
 
# Install and load pckages ####
install.packages("pacman")                 #First we install {pacman}
 pacman::p_load(pacman, rio, tidyverse, dplyr, data.table)
 library(dplyr)
 
# Download and prepare data ####
 
## For a full description of data please visit following site
 browseURL("http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones")


## Download the zip file 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "proj.data")

## Unzip the zip file so you can have access to data
if(!file.exists("UCI HAR Dataset")) {
unzip("proj.data")
}



## Load the data This tab seperated text so we can use 
## read.delim or read.table but it takes time
## fread() is faster  and all control such as "sep", "colClasses" and "nrows"
## are automatically detected

## read subject_train and subject_test data and merge them in tidy_data
## wITH file.choose(), you can lead R step be step to find your file 

#s.train_d <- fread(file.choose(), header = F, sep = "\t", col.names = "subject_train" )


feature <- read.table ("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = feature$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = feature$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


##part 1: Merges the training and the test sets to create one data set #####
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subjects <- rbind(s_train, s_test)
merged <- cbind(subjects, y, x)


## part 2: Extracts only the measurements on the mean and standard deviation for each measurement.######
tidy_d <- merged %>%
        select(subject, code, contains("mean"), contains("std"))


## Part 3: Use descriptive activity names to name the activities in the data set. ######
tidy_d$code <- activities[tidy_d$code, 2]
names(tidy_d)[2] = "activity"

## Part 4: Appropriately labels the data set with the descriptive variables names. ######
New_name <- names(tidy_d)
New_name <- gsub("^t", "Time_Domain", New_name)
New_name <- gsub("-mean()", "Mean", New_name)
New_name <- gsub("-std()", "STD", New_name)
New_name <- gsub("-freq()", "Frequency", New_name)
New_name <- gsub("^f", "Frequency_Domain", New_name)
New_name <- gsub("Acc", "Accelerometer", New_name)
New_name <- gsub("Gyro", "Gyroscope", New_name)
New_name <- gsub("Mag", "Magnitude", New_name)
New_name <- gsub("-freq()", "Frequency", New_name)

names(tidy_d) <- New_name


## Part 5:  Fro data set in part 4. Creates a second independent tidy data ####
##set with the average of each variable for each activity and each subject.####

New_tidy <- tidy_d %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))



write.table(New_tidy, "new_data.txt", row.names = FALSE)




str(new_data)




