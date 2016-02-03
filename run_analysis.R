## set the path to the main folder of the working directory

wd <- "C:\\Users\\uszllv5\\Desktop\\Coursera\\Getting & Cleaning Data\\Week 4\\UCI HAR Dataset"

setwd(wd)
getwd()

## Read features
features <- read.table("features.txt")

## Read activity labels
activity_labels <- read.table("activity_labels.txt")


## Import test datasets

test_subject <- read.table(paste0(wd,"\\test\\subject_test.txt"))
test_dataset <- read.table(paste0(wd,"\\test\\X_test.txt"))
test_dataset_activity <- read.table(paste0(wd,"\\test\\y_test.txt"))

## Import training datasets

train_subject <- read.table(paste0(wd,"\\train\\subject_train.txt"))
train_dataset <- read.table(paste0(wd,"\\train\\X_train.txt"))
train_dataset_activity <- read.table(paste0(wd,"\\train\\y_train.txt"))

## Merge to create total datasets with proper column names
## Uses descriptive activity names to name the activities in the data set

total_subject <- rbind(train_subject, test_subject)
names(total_subject) <- "subject"

total_dataset_v1 <- rbind(train_dataset, test_dataset)
x_columns <- features[,2]
names(total_dataset_v1) <- x_columns

total_dataset_activity_v1 <- rbind(train_dataset_activity, test_dataset_activity)
total_dataset_activity_v2 <- merge(total_dataset_activity_v1, activity_labels)
total_dataset_activity_v3 <- as.data.frame(total_dataset_activity_v2[,2])
names(total_dataset_activity_v3) <- "activity"

total_dataset_v2 <- cbind(total_subject, total_dataset_activity_v3 ,total_dataset_v1)

## Extracting only the measurements on the mean and standard deviation for each measurement 
mean_column_numbers <- grep("\\bmean\\b",names(total_dataset_v2))
std_column_numbers <- grep("\\bstd\\b",names(total_dataset_v2))
column_numbers_to_keep <- c(1,2,mean_column_numbers,std_column_numbers)

total_dataset_v3 <- as.data.frame(total_dataset_v2[,column_numbers_to_keep])

temp_names_1 <- gsub("-","_",names(total_dataset_v3))
temp_names_2 <- gsub("()","",temp_names_1,fixed=TRUE)
temp_names_3 <- tolower(temp_names_2)
names(total_dataset_v3) <- temp_names_3

View(total_dataset_v3)


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

measures <- grep("^(t|f)",names(total_dataset_v3),value=TRUE)

summary_dataset <- aggregate(cbind(tbodyacc_mean_x,tbodyacc_mean_y,tbodyacc_mean_z,
                tgravityacc_mean_x, tgravityacc_mean_y, tgravityacc_mean_z,
                tbodyaccjerk_mean_x, tbodyaccjerk_mean_y, tbodyaccjerk_mean_z,
                tbodygyro_mean_x, tbodygyro_mean_y, tbodygyro_mean_z,
                tbodygyrojerk_mean_x, tbodygyrojerk_mean_y, tbodygyrojerk_mean_z,
                tbodyaccmag_mean, tgravityaccmag_mean, tbodyaccjerkmag_mean, tbodygyromag_mean,
                tbodygyrojerkmag_mean, tbodyacc_std_x, tbodyacc_std_y, tbodyacc_std_z,
                tgravityacc_std_x, tgravityacc_std_y, tgravityacc_std_z,
                tbodyaccjerk_std_x, tbodyaccjerk_std_y, tbodyaccjerk_std_z,
                tbodygyro_std_x, tbodygyro_std_y, tbodygyro_std_z,
                tbodygyrojerk_std_x, tbodygyrojerk_std_y, tbodygyrojerk_std_z,
                tbodyaccmag_std, tgravityaccmag_std, tbodyaccjerkmag_std, tbodygyromag_std, tbodygyrojerkmag_std) ~ subject + activity, total_dataset_v3, mean)

View(summary_dataset)
write.table(summary_dataset,file = "summary_data.txt", row.name=FALSE)
