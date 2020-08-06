library(dplyr)
library(tidyr)

## Read the Feature COlumn names from "fetures.txt"
colNames <- read.table("UCI HAR Dataset/features.txt")
colNames <- colNames[,2]

## Read Training set features and labels

X_trainData <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = colNames)
Y_trainData <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = c("ActivityLabel"))

## Merge the two tables into one
trainset <- cbind(Y_trainData, X_trainData)


## Read Test set features and labels

X_testData <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = colNames)
Y_testData <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = c("ActivityLabel"))

## Merge the two tables into one
testset <- cbind(Y_testData, X_testData)


## Combine the Train set and Test set data to form a single dataframe

dataset <- rbind(trainset, testset)

## Remove temporary DataFrames from the Memory

rm(X_trainData, Y_trainData, trainset, X_testData, Y_testData, testset)


## Extract only the Means and Standard Deviations of the measurements
cols <- grep("(mean|std)[...]", names(dataset), value = TRUE)
dataset <- select(dataset, c(ActivityLabel, all_of(cols)))

# Read Activity labels from "activity_labels.txt" as a table
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityLabel", "ActivityName"))

# Remove "_" from activity names
activities <- activities %>%
  mutate(ActivityName = sub("_", " ", ActivityName))


# Merge the Activity Table with the dataset matching by the ActivityLabel
dataset <- merge(activities, dataset, by = "ActivityLabel")


# Remove ActivityLabel Column from the dataset
dataset <- dataset %>%
  select(-"ActivityLabel")

# Convert ActivityName to Factor variable
dataset <- dataset %>%
  mutate(ActivityName = as.factor(ActivityName))
levels(dataset$ActivityName) <- activities$ActivityName

## Replace "." from column names with "_"
names(dataset) <- gsub("[.]{1,3}", "_", names(dataset))

# Remove trailing "_" from the column names
names(dataset) <- sub("_$", "", names(dataset))

# Remove Repeated "Body" from column names
names(dataset) <- sub("BodyBody", "Body", names(dataset))

# Add suffix "_Magnitude" to the variable names denoting Magnitudes and remove "Mag" from middle of the name
names(dataset) <- sub("(*.Mag.*)$", "\\1_Magnitude", names(dataset))
names(dataset) <- sub("Mag(.+)", "\\1", names(dataset))

# Remove "_" from in front of "mean" and "std"
names(dataset) <- sub("_mean", "Mean", names(dataset))
names(dataset) <- sub("_std", "Std", names(dataset))


# Create tidy Dataset

tidyDataset <- dataset %>%
  mutate(Observation = as.factor(seq_along(ActivityName)), .before = 1) %>%
  gather(collection, values, -c(ActivityName, Observation)) %>%
  separate(collection, into = c("variable", "Direction")) %>%
  mutate(Direction = as.factor(Direction)) %>%
  pivot_wider(names_from = variable, values_from = values) %>%
  arrange(Observation)