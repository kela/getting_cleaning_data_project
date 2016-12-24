#getting-and-cleaning-data-course-project

#load libraries
library(plyr)

# step1: Merges the training and the test sets to create one data set
#####################################################################
# gather training data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")


#gather testing data
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# merge test and traing data sets
x_data<- rbind(x_train, x_test)
y_data<- rbind(y_train, y_test)
subject_data <-rbind(subject_train, subject_test)





# step2: Extracts only the measurements on the mean and standard deviation for each measurement
#####################################################################

features<-read.table("features.txt")
mean_std_features <-grep("-(mean|std)\\(\\)" , features$V2)

x_data<-x_data[, mean_std_features]
names(x_data) <-features[mean_std_features, 2]


#step3: Uses descriptive activity names to name the activities in the data set
#####################################################################
activities<-read.table("activity_labels.txt")
#update y_data with activities lables extacted from activities data frame
y_data[, 1]<-activities[y_data[, 1], 2]

#replace column name of y_data
names(y_data)<-"activity"


# step4: Appropriately labels the data set with descriptive variable names.
#####################################################################
#change label of subject  data set
names(subject_data)<-"subject"

#step5: create an independent tidy data set with the average of each variable for each activity and each subject
#####################################################################

new_data<-cbind(x_data, y_data, subject_data)
avg_new_data<-ddply(new_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(avg_new_data, "averages_data.txt", row.name=FALSE)


