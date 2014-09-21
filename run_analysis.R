##  run_analysis.R  ##
################################################################################
##  Step 1, part a  (Reference ReadMe.txt for a full description of steps.)
##  create selection vector for desired data columns
selectData <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 
                240:241, 253:254, 266:271, 294:296, 345:350, 373:375, 424:429, 
                452:454, 503:504, 513, 516:517, 529:530, 539, 542:543, 552, 555:561)

##  Step 1, parts b, c  ##
##    get the test data and add the appropriate column names
data_y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(data_y_train) <- "activity"
data_y_train$description <- ""  ##  add column for activity description

data_y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(data_y_test) <- "activity"
data_y_test$description <- ""  ##  add column for activity description

##  set-up constants for number of train and test records
numTrainRec <- nrow(data_y_train); numTestRec <- nrow(data_y_test)

data_y_train <- cbind("id"=1:numTrainRec, data_y_train)
data_y_test <- cbind("id"=(numTrainRec+1):(numTrainRec+numTestRec), data_y_test)

data_subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(data_subject_train) <- "subject"
data_subject_train <- cbind("id"=1:numTrainRec, data_subject_train)

data_subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(data_subject_test) <- "subject"
data_subject_test <- cbind("id"=(numTrainRec+1):(numTrainRec+numTestRec), data_subject_test)

##  Step 1, parts b and c  ##
##    get the feature names
data_feature_names <- read.table("./UCI HAR Dataset/features.txt")
names(data_feature_names) <- c("column", "feature")
##  assign feature names to data columns
data_X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(data_X_train) <- data_feature_names$feature
data_X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(data_X_test) <- data_feature_names$feature

##  Step 1, parts b and d  ##
##      remove un-needed columns
select_X_train <- data_X_train[ , selectData]
select_X_train <- cbind("id"=1:numTrainRec, select_X_train)
select_X_test <- data_X_test[ , selectData]
select_X_test <- cbind("id"=(numTrainRec+1):(numTrainRec+numTestRec), select_X_test)

##  Step 2, part a  ##
##    join all train data, all share "id"s; join all test data, shared "id"s
all_train = merge(merge(data_subject_train, data_y_train), select_X_train)
all_test = merge(merge(data_subject_test, data_y_test), select_X_test)

##  Step 2, part b  ##
##    merge 'train' and 'test' data, "id"s are all unique
all_data <- merge(all_train, all_test, all=T)

##  Step 2, part c  ##
##  insert activity descriptions
all_data$description <- data_activity[all_data$activity, "V2"]
##  all_data contains the values for all 'mean' and 'std' varialbles ##

##  Step 3  ##
all_subact_MeanValues <- data.frame()  ##  initialize df for results
##  loop for all subjects
for(sub in 1:30){
    ##  loop for all activities
    for(act in 1:6){
        ##  make data frame for this specific subject/activity
        subact_data = subset(all_data, (subject==sub & activity==act), select=4:88)
        subact_Analysis <- colMeans(subact_data)  ##  a numeric vector with names
        ##  add sub/act labels for a named vector with mean results
        subact_Analysis <- c("subject"=sub, "activity"=act, subact_Analysis)
        ##  add these results to the aggregate result df
        all_subact_MeanValues <- rbind.data.frame(all_subact_MeanValues, subact_Analysis)
        ##  add names to the aggregate result df
        names(all_subact_MeanValues) <- names(subact_Analysis)
    }
}
################################################################################
