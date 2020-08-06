---
title: Codebook
author: Tariqul Islam
date: 8/6/2020
output: html_document
---

## Introduction
The final output of this project was two individual data frames named `dataset` and `tidyDataset`. The variables used in these data frames are explained below for each data frame.


### 1. **`dataset`**
This data frame is just a collection of all the mean and standard deviation values from the training set and test set data, merged into one single data frame, with the activities appropriately labeled for each observation. The structure and representation of the data were kept untouched. The variable names were cleaned and renamed, in some cases, for making them meaningful.


#### **`ActivityName`:**
- Name of the Activity performed during the observation.
- The `ActivityLabel` from the original collected data was replaced by corresponding `ActivityName`
- Categorical variable with 6 Levels.
  + Walking
  + Walking Upstairs
  + Walking Downstairs
  + Sitting
  + Standing
  + Laying

#### **`tBodyAccMean_X`, `tBodyAccMean_Y`, `tBodyAccMean_Z`:**
- Mean Body acceleration in X, Y & Z axes.
- Numeric Variable

#### **`tBodyAccStd_X`, `tBodyAccStd_Y`, `tBodyAccStd_Z`:**
- Standard Deviation of Body acceleration in X, Y & Z axes.
- Numeric Variable

#### **`tGravityAccMean_X`, `tGravityAccMean_Y`, `tGravityAccMean_Z`:**
- Mean Gravity acceleration in X, Y & Z axes.
- Numeric Variable

#### **`tGravityAccStd_X`, `tGravityAccStd_Y`, `tGravityAccStd_Z`:**
- Standard Deviation of Gravity acceleration in X, Y & Z axes.
- Numeric Variable

#### **`tBodyAccJerkMean_X`, `tBodyAccJerkMean_Y`, `tBodyAccJerkMean_Z`:**
- Mean Body acceleration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`tBodyAccJerkStd_X`, `tBodyAccJerkStd_Y`, `tBodyAccJerkStd_Z`:**
- Standard Deviation of Body acceleration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`tBodyGyroMean_X`, `tBodyGyroMean_Y`, `tBodyGyroMean_Z`:**
- Mean Body Gyration in X, Y & Z axes.
- Numeric Variable

#### **`tBodyGyroStd_X`, `tBodyGyroStd_Y`, `tBodyGyroStd_Z`:**
- Standard Deviation of Body Gyration in X, Y & Z axes.
- Numeric Variable

#### **`tBodyGyroJerkMean_X`, `tBodyGyroJerkMean_Y`, `tBodyGyroJerkMean_Z`:**
- Mean Body Gyration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`tBodyGyroJerkStd_X`, `tBodyGyroJerkStd_Y`, `tBodyGyroJerkStd_Z`:**
- Standard Deviation of Body Gyration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`tBodyAccMean_Magnitude`, `tBodyAccStd_Magnitude`:**
- Magnitudes of Mean and Standard Deviation of Body Acceleration
- Numeric Variable

#### **`tGravityAccMean_Magnitude`, `tGravityAccStd_Magnitude`:**
- Magnitudes of Mean and Standard Deviation of Gravity Acceleration
- Numeric Variable

#### **`tBodyAccJerkMean_Magnitude`, `tBodyAccJerkStd_Magnitude`:**
- Magnitudes of Mean and Standard Deviation of Body Acceleration Jerk
- Numeric Variable

#### **`tBodyGyroMean_Magnitude`, `tBodyGyroStd_Magnitude`:**
- Magnitudes of Mean and Standard Deviation of Body Gyration
- Numeric Variable

#### **`tBodyGyroJerkMean_Magnitude`, `tBodyGyroJerkStd_Magnitude`:**
- Magnitudes of Mean and Standard Deviation of Body Gyration Jerk
- Numeric Variable

#### **`fBodyAccMean_X`, `fBodyAccMean_Y`, `fBodyAccMean_Z`:**
- Fast Fourier Transform (FFT) of Mean Body Acceleration in X, Y & Z axes.
- Numeric Variable

#### **`fBodyAccStd_X`, `fBodyAccStd_Y`, `fBodyAccStd_Z`:**
- Fast Fourier Transform (FFT) of Standard Deviation of Body Acceleration in X, Y & Z axes.
- Numeric Variable

#### **`fBodyAccJerkMean_X`, `fBodyAccJerkMean_Y`, `fBodyAccJerkMean_Z`:**
- Fast Fourier Transform (FFT) of Mean Body Acceleration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`fBodyAccJerkStd_X`, `fBodyAccJerkStd_Y`, `fBodyAccJerkStd_Z`:**
- Fast Fourier Transform (FFT) of Standard Deviation of Body Acceleration Jerk in X, Y & Z axes.
- Numeric Variable

#### **`fBodyGyroMean_X`, `fBodyGyroMean_Y`, `fBodyGyroMean_Z`:**
- Fast Fourier Transform (FFT) of Mean Body Gyration in X, Y & Z axes.
- Numeric Variable

#### **`fBodyGyroStd_X`, `fBodyGyroStd_Y`, `fBodyGyroStd_Z`:**
- Fast Fourier Transform (FFT) of Standard Deviation of Body Gyration in X, Y & Z axes.
- Numeric Variable

#### **`fBodyAccMean_Magnitude`, `fBodyAccStd_Magnitude`:**
- Fast Fourier Transform (FFT) of Magnitude of Mean and Standard Deviation of Body Acceleration.
- Numeric Variable

#### **`fBodyAccJerkMean_Magnitude`, `fBodyAccJerkStd_Magnitude`:**
- Fast Fourier Transform (FFT) of Magnitude of Mean and Standard Deviation of Body Acceleration Jerk.
- Numeric Variable

#### **`fBodyGyroMean_Magnitude`, `fBodyGyroStd_Magnitude`:**
- Fast Fourier Transform (FFT) of Magnitude of Mean and Standard Deviation of Body Gyration.
- Numeric Variable

#### **`fBodyGyroJerkMean_Magnitude`, `fBodyGyroJerkStd_Magnitude`:**
- Fast Fourier Transform (FFT) of Magnitude of Mean and Standard Deviation of Body Gyration Jerk.
- Numeric Variable


### 2. **`tidyDataset`**
This data frame is a modified version of the previous data frame. The `dataset` data frame was modified and re-organized to follow the principles of a tidy data set. The modifications to each variable are mentioned below with their appropriate descriptions. The key modifications performed to obtain this dataframe are as follows.

- Creation of an `observation` variable to indicate the observation ID.
- Creation of a `Direction` variable to indicate the direction of the measurements as an individual single variable rather than breaking up a single variable into multiple ones to represent different directions.

#### **`Observation`:**
- The observation ID for each data row.
- There are multiple data rows resulting from the same observation. The `observation` column links these rows together.
- Factor variable with levels "1" through "10299", the total number of independent observations.

#### **`ActivityName`:**
- The name of the activity performed during a particular observation.
- Directly imported from the previous data frame without any modifications.
- Categorical variable with 6 Levels.
  + Walking
  + Walking Upstairs
  + Walking Downstairs
  + Sitting
  + Standing
  + Laying
  
#### **`Direction`:**
- Indicated the direction of the values that each variable in the particular row corresponds to.
- Categorical variable with 4 Levels.
  + X: The data values correspond to the measurement along the X-axis
  + Y: The data values correspond to the measurement along the Y-axis
  + Z: The data values correspond to the measurement along the Z-axis
  + Magnitude: : The data values correspond to the magnitude of the measurements.
  
#### **`tBodyAccMean`, `tBodyAccStd`:**
- Mean and Standard deviation of Body Acceleration

#### **`tGravityAccMean`, `tGravityAccStd`:**
- Mean and Standard deviation of Gravity Acceleration

#### **`tBodyAccJerkMean`, `tBodyAccJerkStd`:**
- Mean and Standard deviation of Body Acceleration Jerk

#### **`tBodyGyroMean`, `tBodyGyroStd`:**
- Mean and Standard deviation of Body Gyration

#### **`tBodyGyroJerkMean`, `tBodyGyroJerkStd`:**
- Mean and Standard deviation of Body Gyration Jerk

#### **`fBodyAccMean`, `fBodyAccStd`:**
- Fast Fourier Transform (FFT) of the Mean and Standard deviation of Body Acceleration

#### **`fBodyAccJerkMean`, `fBodyAccJerkStd`:**
- Fast Fourier Transform (FFT) of the Mean and Standard deviation of Body Acceleration Jerk

#### **`fBodyGyroMean`, `fBodyGyroStd`:**
- Fast Fourier Transform (FFT) of the Mean and Standard deviation of Body Gyration

#### **`fBodyGyroJerkMean`, `fBodyGyroJerkStd`:**
- Fast Fourier Transform (FFT) of the Mean and Standard deviation of Body Gyration Jerk