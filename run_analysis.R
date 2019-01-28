# Getting and Cleaning Data Course Project

if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("dplyr")) {
  install.packages("dplyr")
}
library(data.table)
library(dplyr)

inertial <- "Inertial Signals"
pathMerged <- "./merged"
pathInertial <- paste(".", inertial, sep = "/")

# downloaded data suppose to be in this folder
setwd("./UCI HAR Dataset")

# 1. merge teast and train data and save it to 'merged' directory
if (!file.exists(pathMerged)) {
  dir.create(pathMerged)
  
  setwd(pathMerged)
  if (!file.exists(pathInertial)) {dir.create(pathInertial)}
  
  setwd("../test")
  filesInRoot <- list.files()
  filesInRoot <- filesInRoot[filesInRoot != inertial]
  filesInInertial <- list.files(pathInertial)
  filesInInertial <- lapply(filesInInertial, function(x) {paste(pathInertial, x, sep = "/")})
  files <- c(filesInRoot, filesInInertial)
  
  setwd("..")
  
  pathTest <- "./test"
  pathTrain <- "./train"
  
  print(paste("WD", getwd()))
  
  # merge data into new directory 'merged'
  for (file in files) {
    print(file)
    # read file from test
    f1 <- read.table(paste(pathTest, file, sep = "/"))
    print(dim(f1))
    #read file from train
    f2 <- read.table(paste(pathTrain, sub("test", "train", file), sep = "/"))
    print(dim(f2))
  
    # merge data
    fmerged <- rbind(f1, f2)
    # write to merged directory
    write.table(fmerged, paste(pathMerged, sub("test", "merged", file), sep = "/"), row.names = FALSE, col.names = FALSE)
  }
}

# read subjects
subject <- read.table(paste(pathMerged, "subject_merged.txt", sep = "/"))
# 4. labels approprietely
names(subject) <- "Subject"

# read features
features <- read.table("features.txt")[,2]
# filter std or mean features
selectedFeatures <- grepl("std|mean", features)

# read measured data
X <- read.table(paste(pathMerged, "X_merged.txt", sep = "/"))
# 4. labels approprietely
names(X) <- features

# read activity labels
activities <- read.table("activity_labels.txt")[,2]

# read activities
y <- read.table(paste(pathMerged, "y_merged.txt", sep = "/"))
# 3. uses descriptive activity name
y <- activities[y[,1]]
# 4. labels approprietely
y <- data.table(Activity = y)

# 2. extract only columns foe std or mean
X <- X[,selectedFeatures]

# base tidy set 
#     1. merged test and train
#     2. extracted columns for str or mean
#     3. used descriptive activity names
#     4. approprietely labeled variables
tidyBase <- cbind(subject, y, X)

# change working directory where this script is 
setwd("..")

# write tidy to file
write.table(tidyBase, "tidy.txt")

# 5. group by subject and activity and compute mean of all other fields
tidy <- tidyBase %>% group_by(Subject, Activity) %>% summarise_all(funs(mean)) 

# write mean summarised to file
write.table(tidy, "tidy_mean.txt", row.name = FALSE)
