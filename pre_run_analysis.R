######################################################################
## to run inside your working directory
## if directory "UCI HAR Dataset" not present
## in your working directory
## 
## library(downloader) was needed with Linux (distr. Ubuntu 12.04)
## for solving problems with https
######################################################################

library(downloader)

nameFile<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
tempFile1<-tempfile(pattern="UCIData",tmpdir=getwd(),fileext=".zip")

download(nameFile, destfile=tempFile1)
unzip(zipfile=tempFile1,list=T) 

