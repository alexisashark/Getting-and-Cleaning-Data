library(reshape2)


#test group:test set, test labels, identifier of the subject

x_test<-read.table("X_test.txt")
y_test<-read.table("Y_test.txt")
subject_test<-read.table("subject_test.txt")
x_train<-read.table("X_train.txt")
y_train<-read.table("Y_train.txt")
subject_train<-read.table("subject_train.txt")

features<-read.table("features.txt")

dataset<-rbind(x_train,x_test)
labelset<-rbind(y_train,y_test)
idset<-rbind(subject_train,subject_test)

colnames(dataset)<-features$"V2"

dataset$"id"<-idset[[1]]

temp<-as.factor(labelset[[1]])
levels(temp)<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                "SITTING","STANDING","LAYING")
labelset[[1]]<-temp
dataset$"label"<-labelset[[1]]

splitdataset<-split(dataset,dataset$"id")

subdata<-data.frame()

for(i in seq(30)){
        temp<-melt(splitdataset[[i]],id=c("id","label"),measure.var=
                                   c("tBodyAcc-mean()-X","tBodyAcc-mean()-Y",
                                     "tBodyAcc-mean()-Z","tBodyAcc-std()-X",
                                     "tBodyAcc-std()-Y","tBodyAcc-std()-Z"))
        casttemp<-dcast(temp,label ~ variable,mean)
        casttemp$"id"<-i
        castdata<-rbind(castdata,casttemp)
}


write.table(castdata,file="tidydata.txt")