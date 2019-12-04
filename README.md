# GettingAndCleaningDataFinalProject
Repository for submitting the peer graded assignment at the end of the Coursera course Getting and Cleaning Data

Repository Contents
1. Run_Analysis.R - R script that cleans the Samsung data and produces a tidy dataset of average measurement by subject and activity
2. Codebook.Md

## Run_Analysis Walk Through
The run analysis script follows this procedure:
1. Read in the text data files from the Samsung zip file using read.delim. The data sets are x_train, y_train, subject_train, x_test, y_test, subject_test, activity labels, features.
2. Rename the columns of the feature data to match the variables in the features file. This is done for x_train and x_test.
3. Relabel the y data with the activity from the activity labels. This is done for y_train and y_test.
4. Using cbind, combine the x, y, and subject data sets to have one train data set with features and labels and one test dataset with features and labels.
5. Using rbind, combine the train and test data sets to produce one data frame with all the relevant data.
6. Select only the features that use the mean(), std(), or meanFreq() metric. This is done using grep() on the column names. As a note the columns that used a mean value to create the variable were not used, only the features that had mean as the metric.
7. Group the data by subject and activity and take the mean of each feature. This was done using data.table.
8. Write the resulting data.table to a text file using write.table.

## Why is the dataset tidy?
According to "Tidy Data" by Hadley Wickham tidy data must satisfy three principles:
1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

Criteria 1 is satisifed because each column is it's own feature of the data. It would be possible to further parse the data with an addiotional column containing the statistical metric (ie. mean(), std(), meanFreq()). However, this was not done because it's not obvious that would make the data any easier to work with or more clear.  
Criteria 2 is satisfied because each row is a single observation about a specific subject and activity.  
Criteria 3 is satisfied because we only have one table that contains observational units about subject's accelerometer data. 
