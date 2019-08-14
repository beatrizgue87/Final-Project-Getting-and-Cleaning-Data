# Final-Project-Getting-and-Cleaning-Data

Files 
    • README.md 
    • CodeBook.md -- describes the experiments, variables and data transformation.
    • run_analysis.R – R code 

Description

The experiments have been carried out with a group of 30 volunteers within an age range of 19-48 years. Using the cellphone’s embedded accelerometer and gyroscope, the 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz are captured.
Each person is wearing a smartphone (Samsung Galaxy S II) on the waist and performed six activities

The code run_analysis.R does the following
 
    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Libraries used 
    • library(dplyr) 
    • library(data.table) 
