---
title: "Read Me"
author: "Tariqul Islam"
date: "8/4/2020"
output: html_document
---

## Data Analysis Steps
This document is a step-by-step demonstration of the data analysis process followed for this project. The whole process is divided into 5 individual parts similar to those mentioned in the project instruction. The data manipulations performed in each part of the process are described in their respective steps.

For a visually guided description, please view the `ReadMe.Rmd` file in the repository.


### Load Packages

Before beginning any data manipulation, the required R Packages are imported first. The R Packages used in this project are `dplyr` and `tidyr`.

```{r include = FALSE}
library(dplyr)
library(tidyr)
```

### Part 1: Merge the training and the test sets to create one data set

The Raw data is divided into two main data sets - the *Training Set* and the *Test Set*. The data contained in each of these data sets are then divided into two parts - the measurement data as `X_****.txt` and the activity label as `Y_****.txt`. Here the `****` denoted either `train` or `test`, depending on the data set we are using.

The variable names for the measurements in the `X_****.txt` are included in a separate file named `features.txt`. These variable names will become the column names for the data frame.

Completion of this part of the analysis involves the following steps.
- Read in the column names from the `features.txt` file
- Read in the measurement data and the activity labels from `X_train.txt` and `Y_train.txt`, and merge them into a single table named `trainset`. The merging of these data is done horizontally, i.e. the data are joined as columns. The columns of this table are named using the column names from the first step.
- Read in the measurement data and the activity labels from `X_test.txt` and `Y_test.txt`, and merge them into a single table named `testset`. The merging of these data is done horizontally, i.e. the data are joined as columns. The columns of this table are named using the column names from the first step.
- The `trainset` and the `testset` tables are then joined together to form a single data frame named `dataset`. This joining is done vertically, i.e. the tables are joined as rows.
- Finally, all the temporary tables created in the previous steps are removed to free up memory.

The code used for these steps are as follows.

```{r}

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

```


### Part 2: Extract only the measurements on the mean and standard deviation for each measurement
As instructed in the project requirements, only the measurements on the mean and standard deviation for each measurement are to be extracted to keep in this data set. Our data frame contains 562 columns in it.

If we view the column names of our data frame, we can see that the variable names contain the words `mean`, `std`, `mad`, etc. to denote the type of the measurement contained in the columns. We need to extract only the columns that contain the string `mean` or `std` in their names, along with the first column, `ActivityLabel`. We will use Regular expressions for this task. The steps are:
- Get the column names containing `mean` and `std` in them using `grep()` and store in a list named `cols`
- Use the `select()` functionality of `dplyr` to select only the `ActivityName` and the columns in `cols`, and reassign them into the `dataset` data frame.

Here is the code for this.

```{r}
## Extract only the Means and Standard Deviations of the measurements
cols <- grep("(mean|std)[...]", names(dataset), value = TRUE)
dataset <- select(dataset, c(ActivityLabel, all_of(cols)))
```

Now our data frame contains *only* the measurements on the mean and standard deviation for each measurement.

### Part 3: Use descriptive activity names to name the activities in the data set
The `ActivityLabel` column in our data frame contains only a number denoting the activity performed during an observation. It might have been useful for feeding into a machine learning model, but it is meaningless to human eyes. A mere number cannot appropriately introduce the activity that was being performed during an observation to a human user. So, we need to replace this numbers with appropriate activity name, so that it can easily be understood.

The activity names corresponding to the numeric activity labels can be found in the `activity_labels.txt` file. We can read in this file and use it to replace our activity labels with appropriate activity names. The steps for this are as follows.

- Read in the activity labels with their corresponding activity name into a table named `activities`
- Modify the activity names in the table (if required) to be human readable
- Merge the `activities` table with our `dataset` by the `ActivityLabel` column, common to both data frames.
- Remove the `ActivityLabel` column from the `dataset`, as it will be now redundant.
- Finally, modify the `ActivityName` column to be a categorical variable with factor levels as presented in the `activities` table.

The code for performing these steps are given below.

```{r}
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

```

Now our data frame contains descriptive activity names for each observation instead of a numeric activity label.

### Part 4: Appropriately label the data set with descriptive variable names

The column names contain some unnecessary and extra dots(.) in them. This is the result of dynamically applying column names to our data frame. If the column name we are trying to use contains any invalid characters, R will automatically convert them to a dot(.) when applied to a data frame.

We will replace these dots(.) with the underscore(_) character. We can see that all of the column names contain variable number of dots ranging between 1 and 3. We will use the `gsub()` function of `dplyr` to replace these dots in the column names and reassign them back to the data frame.

```{r}
## Replace "." from column names with "_"
names(dataset) <- gsub("[.]{1,3}", "_", names(dataset))
names(dataset)
```
The auto-generated dots(.) are gone from the column names, but now some columns contain a trailing underscore(_) character at the end of their names. We will take care of this by removing the trailing underscores.

```{r}
# Remove trailing "_" from the column names
names(dataset) <- sub("_$", "", names(dataset))
names(dataset)
```
We've now taken care of the unwanted extra characters in our column names. Now, if we look carefully, we will see that the last few columns contain repeated strings (e.g. `fBodyBodyGyroMag_std` instead of `fBodyGyroMag_std`) in their names. This repetition only occurs with the phrase `Body` in the column name.

So, we will now find the columns with repeated `Body` in their names and replace them with a single one.

```{r}
# Remove Repeated "Body" from column names
names(dataset) <- sub("BodyBody", "Body", names(dataset))
names(dataset)
```
And thus we have *cleaned* our column names i.e., removed any unwanted or repeated characters.

Now we will modify our column names so as to be more meaningful, consistent, and also to be ready for the next part where we will tidy our data set. We will achieve this modification step-by-step.

Each variable in our data frame is divided into four separate columns denoting the X axis, Y axis, Z axis and Magnitude measurements. This is also mentioned in the `feature_info.txt` file. The column names used in our data frame to denote these variation are a little inconsistent. The axes names are denoted at the end of each variable name, separated with an underscore (_X, _Y, _Z) whereas the magnitude variable contains the string `Mag` in the middle of the variable name.

We will change the names of the *magnitude* variables to contain the string *Magnitude* at the end of the name, separated by an underscore, and remove the string *Mag* from the middle of the name e.g. `fbodyGyroJerkMag_std` will become `fbodyGyroJerk_std_Magnitude`. This will achieve two purposes.
- Be consistent with the naming of the axis variables
- Be ready for splitting the columns based on the measurement direction (X, Y, Z, Magnitude) in a later part of the project

The code for this is as follows.

```{r}
# Add suffix "_Magnitude" to the variable names denoting Magnitudes and remove "Mag" from middle of the name
names(dataset) <- sub("(*.Mag.*)$", "\\1_Magnitude", names(dataset))
names(dataset) <- sub("Mag(.+)", "\\1", names(dataset))
names(dataset)
```
At this point, all our measurement variables contain two underscores in their names separating two aspects of the variable:
- The direction of the measurement (X, Y, Z, Magnitude)
- The statistical measure of the measurement (Mean, Std)

We have already discussed that the direction aspect of the variables will be used later in the analysis. But the type of measure (Mean, Std) will neither be considered as a separate aspect of the variable, nor will be used later in the analysis. So it will be better to remove this separation and make the `Mean` or `Std` an undivided part of the variable name (with capitalization). This can be done with the following two lines of R code.

```{r}
# Remove "_" from in front of "mean" and "std"
names(dataset) <- sub("_mean", "Mean", names(dataset))
names(dataset) <- sub("_std", "Std", names(dataset))
```

Finally, after a few tweeks, our variable names are now meaningful, consistent, and ready for use in later steps of the analysis process.

### Part 5: Create a tidy dataset from the dataset in step 4

So far we've collected our data from different sources and combined them into a single data frame. We've also modified the column values and column names to be meaningful and consistent. But we have not done any modification to the way our data is structured, i.e. we haven't rearranged our data in any way. We will now rearrange our data to comply with the tidy data principles.

As mentioned earlier, we have four separate data columns for most of the variables, which varies in the aspect of the direction of the measurement. This is a violation of the tidy data principles, and the direction of measurement should be used as a separate variable. This will split each row into four individual rows which will each correspond to one single direction of the measurement. But before obtaining that, there is one other issue that should be taken care of.

In our data frame, there is not any variable keeping track of the observation number for an observation. So, if we divide each of our observation rows into four individual ones, we will later be unable to identify which rows belong to the same observation, and thus loose the relationships between them. We have to take care of this issue before tidying our data set.

The steps for tidying our data set are as follows.
- Create a new column named `observation`, giving each row an unique observation id. We will create the variable as a with numeric levels.
- Combine all of the measurement columns (all columns except `ActivityName` and `observation`) into a single column named `collection` and their values in a column named `values` using the `gather()` function of `tidyr`
- Divide the `collection` column into `variable` and `Direction` columns using the `separate()` function of `tidyr`, and convert the `Direction` column into a factor variable.
- At this point, the `variable` column contains all our variable names, free of any directional separation, with their corresponding values in the `values` column. We will now take these variable names (stored as rows) and convert them to variable columns, with their values taken from the corresponding row of the `values` column, using the `pivot_wider()` function of `tidyr`.
- Finally, we will arrange all our rows according to the observation ids in the `observation` column, and assign the resultant data frame into a new variable named `tidyDataset`. This is our final tidy data frame.

The code for these steps are as follows.

```{r}
tidyDataset <- dataset %>%
  mutate(Observation = as.factor(seq_along(ActivityName)), .before = 1) %>%
  gather(collection, values, -c(ActivityName, Observation)) %>%
  separate(collection, into = c("variable", "Direction")) %>%
  mutate(Direction = as.factor(Direction)) %>%
  pivot_wider(names_from = variable, values_from = values) %>%
  arrange(Observation)
```

Now our data frame contains only a single column for each variable, and the directional separation is done using the `Direction` column and individual rows. Also, the different rows of the table can easily be linked with each other using the `observation` variable.

This data frame complies with the tidy data principles.