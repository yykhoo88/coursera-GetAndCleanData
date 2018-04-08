# Getting and Cleaning Data Course Project - UCI HAR Dataset cleanup

The last course project is to clean up the UCI HAR Dataset. In this git, an R script run_analysis.R is added to do the following:

1. Download the dataset from cloudfront, if it's not there already. Then extract the zip file.
2. Load the corresponding activity and feature lables.
3. Load both the training and test dataset, only for the "mean and standard deviation" data.
4. Clean up the data by adding corresponding (activity,subject) labels on it.
5. Merge both dataset
6. Convert (activity, subject) into factor, then take average of each variable
7. Export result into text file.