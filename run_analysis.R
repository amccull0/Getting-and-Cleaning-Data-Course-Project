# Step 1 Merges the training and the test sets to create one data set.

## read in each of the 6 files
trainData <- read.table("./train/X_train.txt")
trainLabel <- read.table("./train/y_train.txt")
trainSubject <- read.table("./train/subject_train.txt")
testData <- read.table("./test/X_test.txt")
testLabel <- read.table("./test/y_test.txt") 
testSubject <- read.table("./test/subject_test.txt")

## combine data of similar types, train data first and test data second(order matters)
allData <- rbind(trainData, testData)
allLabel <- rbind(trainLabel, testLabel)
allSubject <- rbind(trainSubject, testSubject)


# Step 2 Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./features.txt")
 
## find only the columns that refernce mean and std specifically omitting the freq data
meanstd <- grep("mean\\(\\)|std\\(\\)", features[, 2])
allData <- allData[, meanstd]

## remove unwanted characters in the field
names(allData) <- gsub("\\(\\)", "", features[meanstd, 2]) 
names(allData) <- gsub("-", "", names(allData))  

# Setp 3 Uses descriptive activity names to name the activities in the data set

## Unlist this variable and change to int so that we can apply factor names to it
allLabel<- as.integer(unlist(allLabel))
## Create and apply the factor names
activity<- factor(allLabel, labels = c("Walking","Walking Upstairs", "Walking Downstairs",
                                "Sitting", "Standing","Laying"))

# Step 4 Appropriately labels the data set with descriptive variable names.
names(allSubject) <- "subject"
tidyData <- cbind(allSubject, activity, allData)
write.table(tidyData, "merged_data.txt") # write out the 1st dataset

# Step 5 From the data set in step 4, creates a second, independent tidy data set with the 
#   average of each variable for each activity and each subject.

## Group by subject and activity and then take summary output of mean for all other columns
library(dplyr) #you will need dplyr library to run below functions
tidyOut<-tidyData %>% group_by(subject,activity) %>% summarise_each(funs(mean))
write.table(tidyOut, "Summarized_Data.txt") # write out the 1st dataset


