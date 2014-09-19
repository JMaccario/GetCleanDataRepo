######################################################################
## libraries needed
######################################################################
library(data.table)
library(plyr)
library(dplyr)
library(tidyr)
######################################################################
## function to get rid of "bad" characters in names
######################################################################
cleanNames <- function(setOfNames){
  W<-stringr::str_replace_all(rawNamesOfFeatures,"-","_")
  W<-stringr::str_replace_all(W,"\\(","")
  W<-stringr::str_replace_all(W,"\\)","")
}
######################################################################
## function to get set of values in UCI HAR Dataset
## and shaping them in a data frame
######################################################################
FetchAndBuildFrame<-function(nameOfDir="./UCI HAR Dataset/",
	nameOfSet="test") {
## getting labels and names 
  rawNamesOfFeatures <- read.table(
	paste(nameOfDir,"features.txt",sep=""),
	stringsAsFactors =F)$V2
  namesOfFeatures<-cleanNames(rawNamesOfFeatures)
  namesOfActivity <- read.table(
	paste(nameOfDir,"activity_labels.txt",sep=""),
	stringsAsFactors =F)$V2
  dirName <- paste(nameOfDir,nameOfSet,"/",sep="")
## getting values indide the subdir /nameOfSet (train or test)
  setOfValues<-read.table(paste(dirName,"X_",nameOfSet,".txt",sep=""))
## getting labels and names indide the subdir /nameOfSet (train or test)
  names(setOfValues)<-namesOfFeatures
  codesOfActivities<-scan(paste(dirName,"y_",nameOfSet,".txt",sep=""))
  codesOfSubjects<-scan(paste(dirName,"subject_",nameOfSet,".txt",sep=""))
## getting names of features with "mean" or "std" inside
  getColWithMean<-grepl(pattern="mean()",namesOfFeatures)
  getColWithStd<-grepl(pattern="std()",namesOfFeatures)
  getAllProperCol<-getColWithMean | getColWithStd
## selecting the values in the appropriate cols
  leanSetOfValues<-setOfValues[,getAllProperCol]
## shaping the final data frame
  leanSetOfValuesWithCodes <- cbind("Subject"=codesOfSubjects,
	"ActivityCode"=codesOfActivities,
	"ActivityName"=factor(codesOfActivities,labels=namesOfActivity),
	"Set"=nameOfSet,
	leanSetOfValues)
return(leanSetOfValuesWithCodes)
}
######################################################################
## combining train and test
## and shaping them in a data frame
######################################################################
W1<-FetchAndBuildFrame()
W2<-FetchAndBuildFrame(nameOfSet="train")
finalSetOfValues<-rbind(W1,W2)
######################################################################
## after conversion in data.table
## summarizing this last dataframe 
## by subject and activity
######################################################################
groupedDTSetOfValues<-group_by(data.table(finalSetOfValues),
	Subject,ActivityName)
finalTidyFrame<-summarise_each(groupedDTSetOfValues,
	funs="mean",
	vars=tBodyAcc_mean_X:fBodyBodyGyroJerkMag_meanFreq)
## renaming the features after summarizing
OldNames<-names(finalTidyFrame)
NewNames<-names(groupedDTSetOfValues)[c(1,3,5:83)]
setnames(finalTidyFrame,OldNames,NewNames)

write.table(finalTidyFrame,file="finalTable.txt",row.names=F)









}

