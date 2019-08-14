# Getting and Cleaning Data Course Project
# Name: Beatriz Guerra Santana

library(dplyr)
library(data.table)

# Getting the data:

if(!file.exists("/home/beatriz/Desktop/GDC_Coursera/Final_project/data")){dir.create("/home/beatriz/Desktop/GDC_Coursera/Final_project/data")}
urlData<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlData,destfile="/home/beatriz/Desktop/GDC_Coursera/Final_project/data/project_data.zip")
unzip(zipfile="/home/beatriz/Desktop/GDC_Coursera/Final_project/data/project_data.zip",exdir="/home/beatriz/Desktop/GDC_Coursera/Final_project/data")

#------------------ Merging the training and the test sets to create one data set-----------------

# General datasets

activ_Labels<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
features_Lab<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/features.txt", header = FALSE)
features_Labels<-features_Lab$V2 # taking the second column of the dataframe (features' name)

#### Test set
test<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
testLabels<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity.Labels")
testSubject<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject.ID")


# Modifiying the test set
colnames(test)<-features_Labels
Full_testSet<-cbind(testLabels, testSubject, test)
str(Full_testSet)


#### Train set
train<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainLabels<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity.Labels")
trainSubject<-read.table("/home/beatriz/Desktop/GDC_Coursera/Final_project/data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject.ID")



# Modifiying the train set
colnames(train)<-features_Labels
Full_trainSet<-cbind(trainLabels, trainSubject, train)
str(Full_trainSet)

# Combining train and test sets

full_ds<-rbind(Full_trainSet, Full_testSet)
dim(full_ds)


#------------------ Extracting only the measurements on the mean and standard deviation for each measurement-----------------


mean_std_ds<-full_ds[,grep("mean|std|Activity.Labels|Subject.ID", names(full_ds))]


#----------------Using descriptive activity names to name the activities in the data set-------------------------

dsWithActivities <- merge(activ_Labels, mean_std_ds, by.x = "V1", by.y ="Activity.Labels", all=TRUE)


#-------------- Appropriately labeling the data set with descriptive variable names. ------------------------------

# Getting variables names 
var_names<-colnames(dsWithActivities)

#Changing names
var_names<- gsub("V1", "Activity.ID", var_names)
var_names<- gsub("V2", "Activity", var_names)
var_names<- gsub("^t", "Time.", var_names)
var_names<- gsub("^f", "Freq.", var_names)
var_names<- gsub("Acc", "Accelerometer", var_names)
var_names<- gsub("Gyro", "Gyroscope", var_names)
var_names<- gsub("Mag", "Magnitude", var_names)

colnames(dsWithActivities)<-var_names
str(dsWithActivities)

# -----------From the data set in step 4, creating a second, independent tidy data set with the average of each variable 
# for each activity and each subject.-------------------------------------

group_activ_subjects<-group_by(dsWithActivities, Activity, Subject.ID)
tidy_dataset<-summarise_all(group_activ_subjects, mean)

write.table(tidy_dataset, "final_dataset.txt", row.names = FALSE)
