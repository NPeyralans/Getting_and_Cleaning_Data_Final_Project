library(dplyr)
library(plyr)
library(data.table)
activity_test <- read.table("test/y_test.txt", header = FALSE)
activity_train <- read.table("train/y_train.txt", header = FALSE)
subject_test <- read.table("test/subject_test.txt", header = FALSE)
subject_train <- read.table("train/subject_train.txt", header = FALSE)
features_test <- read.table("test/x_test.txt", header = FALSE)
features_train <- read.table("train/x_train.txt", header = FALSE)
subject_data <- rbind(subject_train, subject_test)
activity_data <- rbind(activity_train, activity_test)
features_data <- rbind(features_train, features_test)
names(subject_data) <- "subject"
names(activity_data) <- "activity"
features_data_names <- read.table("features.txt",head=FALSE)
names(features_data) <- features_data_names$V2
subject_activity_data <- cbind(subject_data, activity_data)
all_data <- cbind(features_data, subject_activity_data)
mean_sd_features_names <- features_data_names$V2[grep("mean\\(\\)|std\\(\\)", features_data_names$V2)]
selected_names <- c(as.character(mean_sd_features_names), "subject", "activity")
mean_sd_data <- subset(all_data, select=selected_names)
mean_sd_data$activity[mean_sd_data$activity == 1] <- "walking"
mean_sd_data$activity[mean_sd_data$activity == 2] <- "walking_upstairs"
mean_sd_data$activity[mean_sd_data$activity == 3] <- "walking_downstairs"
mean_sd_data$activity[mean_sd_data$activity == 4] <- "sitting"
mean_sd_data$activity[mean_sd_data$activity == 5] <- "standing"
mean_sd_data$activity[mean_sd_data$activity == 6] <- "laying"
mean_sd_data$activity <- as.factor(mean_sd_data$activity)
names(mean_sd_data) <- gsub("^t", "time", names(mean_sd_data))
names(mean_sd_data) <- gsub("^f", "frequency", names(mean_sd_data))
names(mean_sd_data) <- gsub("Acc", "Accelerometer", names(mean_sd_data))
names(mean_sd_data) <- gsub("Gyro", "Gyroscope", names(mean_sd_data))
names(mean_sd_data) <- gsub("Mag", "Magnitude", names(mean_sd_data))
names(mean_sd_data) <- gsub("BodyBody", "Body", names(mean_sd_data))
mean_sub_act <- aggregate(. ~subject + activity, mean_sd_data, mean)
mean_sub_act <- mean_sub_act[order(mean_sub_act$subject, mean_sub_act$activity),]
write.table(mean_sub_act, file = "mean_subject_activity.txt", row.name=FALSE)


