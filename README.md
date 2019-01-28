# Getting and Cleaning Data Course Project

1. script requires data in the directory "UCI HAR Dataset"
2. script goes through all files in "test" and "train" and merges it into directory "merged"
3. subjects data are read and labeled
4. features are read and subset with desired fields "std" and "mean" is created
5. X data are read and labeled with names from features
6. activities are read 
7. y data are read and activity names are replaced
8. X data are filtered to consist desired columns only
9. subjects activities and selected X data are binded into one data set
10. tidy data set is grouped and summarised 