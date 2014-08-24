# Getting and Cleaning Data
# Create one R script called run_analysis.R which does the below:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Merges the training and the test sets to create one data set.

# read activity labels
readActLabels <- read.table("activity_labels.txt")[,2]

# read features
readFeatures <- read.table("features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extFeatures <- grepl("mean|std", readFeatures)

# read X_test, y_test and subject_test

readX <- read.table("./test/X_test.txt")
readY <- read.table("./test/y_test.txt")
readSubjText <- read.table("./test/subject_test.txt")
names(readX) = readFeatures

readX = readX[,extFeatures]

#activity lables
readY[,2] = readActLabels[readY[,1]] 
names(readY) = c("Act_ID", "Act_Label") 
names(readSubjText) = "Act_Subj" 

testData <- cbind(as.data.table(readSubjText), readY, readX)


# read X_train,  y_train and subject train
readXtrain <- read.table("./train/X_train.txt")
readYtrain <- read.table("./train/y_train.txt")
readSubjTrain <- read.table("./train/subject_train.txt")
names(readXtrain) = readFeatures

readXtrain = readXtrain[,extFeatures]

#activity lables
readYtrain[,2] = readActLabels[readYtrain[,1]] 
names(readYtrain) = c("Act_ID", "Act_Label") 
names(readSubjTrain) = "Act_Subj" 

trainData <- cbind(as.data.table(readSubjTrain), readYtrain, readXtrain)

# merging train and test data 
mergeData = rbind(testData, trainData) 

colLabels  = c("Act_Subj", "Act_ID", "Act_Label") 
dataLabels = setdiff(colnames(mergeData), colLabels) 
meltData   = melt(mergeData, id = colLabels, measure.vars = dataLabels) 

# create tidy data file...
 tidy_data  = dcast(meltData, Act_Subj + Act_Label ~ variable, mean) 
 write.table(tidy_data, file = "./tidy_data.txt") 
