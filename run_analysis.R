
features<-read.table("UCI HAR Dataset/features.txt", header=F)

features<-as.character(features[,2])

activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt", header=F)

activityLabels<-as.character(activityLabels[,2], header=F)

dataTrainX<-read.table("UCI HAR Dataset/train/X_train.txt", header=F)
dataTrainY<-read.table("UCI HAR Dataset/train/y_train.txt", header=F)
dataTrainSubject<-read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
dataTestX<-read.table("UCI HAR Dataset/test/X_test.txt", header=F)
dataTestY<-read.table("UCI HAR Dataset/test/y_test.txt", header=F)
dataTestSubject<-read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
dataTrain<-data.frame(dataTrainSubject, dataTrainY, dataTrainX)
dataTest<-data.frame(dataTestSubject, dataTestY, dataTestX)

names(dataTrain)<-c(c("subject", "activity"), features)
names(dataTest)<-c(c("subject", "activity"), features)

data<-rbind(dataTrain, dataTest)
ExtractedData<-data[,which(colnames(data) %in% c("subject", "activity", grep("mean()|std()", colnames(data), value=TRUE)))]
ExtractedData$activity<-activityLabels[ExtractedData$activity]
names(ExtractedData)[-c(1:2)]<-gsub("^t", "time", names(ExtractedData)[-c(1:2)])
names(ExtractedData)[-c(1:2)]<-gsub("^f", "frequency", names(ExtractedData)[-c(1:2)])
names(ExtractedData)[-c(1:2)]<-gsub("Acc", "Accelerometer", names(ExtractedData)[-c(1:2)])
names(ExtractedData)[-c(1:2)]<-gsub("Gyro", "Gyroscope", names(ExtractedData)[-c(1:2)])
names(ExtractedData)[-c(1:2)]<-gsub("Mag", "Magnitude", names(ExtractedData)[-c(1:2)])
names(ExtractedData)[-c(1:2)]<-gsub("BodyBody", "Body", names(ExtractedData)[-c(1:2)])
names(ExtractedData)


tidyData<-aggregate(. ~ subject + activity, ExtractedData, mean)

tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)

