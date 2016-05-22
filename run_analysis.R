## Project Work for Getting and Cleaning Data

fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip", method = "curl")

## unzipped files locally in my folder.

##  Broad Guidelines for Script
    
    ## set the working directory
    ## read the features file and give column names and save file
    ## read activity label file and give column names and save file
            
          setwd("~/Desktop/R/UCI")
          features <- read.table("features.txt", col.names = c("code", "measure"))
          activityLabels <- read.table("activity_labels.txt",col.names=c("code","activity"))

    ### Simplify the "measure" labels sfrom "features" file such that brevity and description are balanced.

      features$measure <- gsub("\\(|\\)|,","",features$measure)
      features$measure <- gsub("-|\\.","_",features$measure)
      features$measure <- gsub("^t","time_",features$measure)
      features$measure <- gsub("BodyAcc","BA",features$measure)
      features$measure <- gsub("BAJerk","BAJ",features$measure)
      features$measure <- gsub("GravityAcc","GA",features$measure)
      features$measure <- gsub("BodyGyroJerkMag","BdGyJkMag",features$measure)
      features$measure <- gsub("BodyGyroJerk","BdGyJk",features$measure)
      features$measure <- gsub("BodyGyroMag","BdGyMg",features$measure)
      features$measure <- gsub("BodyGyro_bandsEnergy","BdGyMgEn",features$measure)
      features$measure <- gsub("BodyGyro","BdGy",features$measure)
      features$measure <- gsub("^f","FFT_",features$measure)
      features$measure <- gsub("BodyBody","Body",features$measure)
      features$measure <- gsub("^angle","angle_",features$measure)

    # Join all Test files together in TestData

    TestData<-cbind(
      read.table("./test/subject_test.txt",col.names=c("subjectID")),
      read.table("./test/y_test.txt",col.names = c("activity")),
      read.table("./test/X_test.txt",col.names=as.character(features$measure))
       ),

    # Join all Training files together in TrainingData  

      TrainData<-cbind(
      read.table("./train/subject_train.txt",col.names=c("subjectID")),
      read.table("./train/y_train.txt",col.names = c("activity")),
      read.table("./train/X_train.txt",col.names=as.character(features$measure))
    )
 
    ## Join the test and training data using rbind

    JoinedData<- rbind(TestData, TrainData)
   
    # Replace numeric activity codes to Activity labels   
      JoinedData <- JoinedData %>% 
            mutate(activity = activityLabels[ JoinedData$activity,2 ]) %>%
  
    # Remove columns that are not for mean() or std() or meanFreq(), by using gsub feature of editing texts
    # but retain the first two columns: subject (column 1) and activity (column 2).
    # Concatenate column 1 and 2 with the rest of the columns that satisfy the condition.
  
          select(c(1,2,2 + grep(".*[Mm][Ee][Aa][Nn].*|.*[Ss][Tt][Dd].*",features$measure))) %>%
  
    # Group by subjectID and activity
    # Summarize to take the average(mean) based on grouping for all other variables
  
        group_by(subjectID,activity) %>%
        summarize_each(funs(mean))

    # Write file to project_tidyData.txt
    write.table(JoinedData,"./project_tidyData.txt",row.names = FALSE)

    ## We can also melt the data into ID variables and measure variables and decase on subjectID and activity

## Note: This is my second attempt. I have learnt the process through peer reviews. I acknowlege the same. 





