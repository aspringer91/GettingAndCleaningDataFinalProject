# The following two lines of comments can be used to download and unzip the data into the working directory if needed
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","AccelerometerData.zip")
#unzip("AccelerometerData.zip")

RunAnalysis <- function () {
      #Call packages we will need
      library(textclean)
      library(data.table)

      #The below assumes the zip file has been unzipped into the working directory
      #The script will read in the accelerometer data, process it, and write a text file,
      #containing the summarized tidy data set,into the working directory 

      #Read in training data X, Y, and subject
      train_x <- read.delim("./UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="",dec=".")
      train_y <- read.delim("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
      train_subject <- read.delim("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

      #Read in testing data X, Y, and subject
      test_x <- read.delim("./UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="",dec=".")
      test_y <- read.delim("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
      test_subject <- read.delim("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)

      #Read in activity labels and features
      activity_labels <- read.delim("./UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
      features <- read.delim("./UCI HAR Dataset/features.txt",header = FALSE,sep="")

      #Rename the variable columns with features data
      newcolnames <- as.character(features[ ,2])
      names(train_x) <- newcolnames
      names(test_x) <- newcolnames

      #Relabel the activity from a number to text decription using activity labels
      relabel_y_train <- mgsub(train_y[ ,1],activity_labels[ ,1],activity_labels[ ,2])
      relabel_y_test <- mgsub(test_y[ ,1],activity_labels[ ,1],activity_labels[ ,2])

      #bind columns in X, Y, and subject to create 1 training data set
      train_data <- cbind(train_x,relabel_y_train)
      names(train_data)[562] <- "activity"
      names(train_subject) <- "subject"
      train_data <- cbind(train_data, train_subject)

      #bind columns in X, Y and subject to create 1 test data set
      test_data <- cbind(test_x,relabel_y_test)
      names(test_data)[562] <- "activity"
      names(test_subject) <- "subject"
      test_data <- cbind(test_data, test_subject)

      #bind rows in train and test to make 1 dataset
      all_data <- rbind(train_data,test_data)

      #Select only columns that are mean() and std() measurements, or activity and subject
      mean_and_std_cols <- grep("mean\\()|std\\()|meanFreq\\()",names(all_data),ignore.case = TRUE)
      mean_and_std_data <- all_data[,c(mean_and_std_cols,562,563)]

      #create a data.table object to perform grouping and summarizing
      data_table <- data.table(mean_and_std_data)
      # group data by subject and activity and take mean of each variable
      mean_by_subject_and_activity <- data_table[ , lapply(.SD, mean), by=c("subject","activity")]
      mean_by_subject_and_activity

      #Send the output to the working directory as a text file
      write.table(mean_by_subject_and_activity,"RunAnalysisOutput.txt",row.name = FALSE)
      
      #Return the tidy data set
      return(mean_by_subject_and_activity)
}      
