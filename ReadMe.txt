ReadMe.txt 

for 'Getting and Cleaning Data', fall 2014, course project

The project requirements are found at (registration required): 
https://class.coursera.org/getdata-007/human_grading/view/courses/972585/assessments/3/submissions
A copy of the most pertinent points is in this file n the project working directory:
DescriptionPage-andRubrics.txt 


The project requirements were broken down into the following activities (label in parenthesis references the step where the objective is implemented in code):

Download and extract data sets from zip file (Preliminary)
Initialize feature selection vector, 'selectData'.  (Step 1a)
Load data sets from files;  assign unique “id” value.  (Step 1b)
Label variables.  (Step 1c)
Prune data using selection vector.  (Step 1d)
Combine parts of each group into one group dataset.  (Step 2a)
Merge training and test Data sets into one data set.  (Step 2b)
Label activities.  (Step 2c)
For each subject and activity, calculate the average (mean) for all features.  (Step 3)


The following describes the steps taken to accomplish the project.

Preliminary

The files were downloaded and extracted outside of the analysis activity.  The R code used to download the file is shown below:

dataURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL, destfile = "./zipFile.zip", method = "curl")

Files were extracted from the zip file using the Archive.app on a Mac OsX 10.9.2

Step 1 part a  (The steps are referenced in the code to match these descriptions.)

A selection vector, 'selectData', is loaded manually with values of data columns that are described as 'mean' or 'std'.

Step 1 part b

Data frames are created from loading data from files. 
	A column “id” is added to all data frames.  The 'train' group data frames are assigned “id” values in the sequence 1:7352.  The 'test' group data frames are assigned “id” values in the sequence 7353:10299.    This step prepares to combine the three sets in each group according to shared “id” values.  Then the combined groups can be merged preserving all data due to the unique “id” values between the groups.

Step 1 part c

The columns in the 'data_X_train' and 'data_X_test' data frames are named using the values in the 'features.txt' file, loaded into the 'data_features_names' data frame.

Step 1 part d

The 'data_X_train' and 'data_X_test' data frames have columns selected by the selection vector, 'selectData', loaded into data frames 'select_X_train' and 'select_X_test'.

Step 2 part a

The three data sets in each group are merged into one.  The shared “id” values within the data sets of each group keep the data values aligned with the “subject' and 'activity' values.  As a result, the data frames 'all_train' and 'all_test' are created.  This is accomplished with a double merge as shown in the example code  below:

all_train = merge(merge(data_subject_train, data_y_train), select_X_train)

Step 2 part b

The combined data sets of the two groups are merged to form one data set.  The unique “id” values assigned to the data sets of each group allows the merged set to contain all data from both groups.

Step 2 part c

The descriptions corresponding to the activity values are added to the 'description' column that was created for this in Step 1 part c.  The data set 'all_data' available  at this point in the analysis is the first result of the project.

Step 3

To meet the second result of the project, two nested loops are created.  The first loops through the 'subject' values 1:30.  The second loops through the 'activity' values 1:6.  The row data is collected into the data frame 'subact_data' for each unique pair of subject/activity and the colMeans() function applied to obtain the mean for each feature in the numeric vector 'subact_Analysis'.  
	As each of these vectors is obtained for each unique pair they are added to the data frame 'all_subact_MeanValues' using the rbind() function  as shown in the code example below:

all_subact_MeanValues <- rbind.data.frame(all_subact_MeanValues, subact_Analysis)

The data frame 'all_subact_MeanValues' is the second result of the project.



