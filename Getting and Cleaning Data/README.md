### Getting and Cleaning Data Course Project

The purpose of the course project was to download and clean data collected from the accelerometers from Samsung Galaxy S smartphones.
The data used in the project was downloaded from the [UCI Machine Learning Repository website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The code in [run_analysis.R](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/run_analysis.R) allow you to download, open, and clean the data. As the code required the R packages stringi and dplyr, those need to be installed first using the following command:

```{r}
install.packages(c("stringi","dplyr"), dependencies = T)
```

After installing the packages you can tun the run_analysis.R. The code will:

1. Download the data in a zip file called data.zip.

2. Unzip the datasets necessary for the analysis and label the data set with descriptive variable names (the new names were assigned after reading the documentation in `features_info.txt` found in the zipped folder). See [Codebook.md](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/Codebook.md) for detailed information.:
  * `X_train.txt`
  * `features.txt`
  * `y_train.txt`
  * `subject_train.txt`
  * `X_test.txt`
  * `y_test.txt`
  * `subject_test.txt`


3. Merge the training and the test sets to create one data set.

4. Extract the measurements on the mean and standard deviation for each measurement.

5. Use descriptive activity names to name the activities in the data set (names were taken from the file `activity_labels.txt`found in the zipped folder). See [Codebook.md](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/Codebook.md) for detailed information.


6. Creates a tidy data set with the average of each variable for each activity and each subject. 

7. Save the newly created dataset in txt format. The dataset, named *MeanAndStdByActivityAndID.txt* can be found [here](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/MeanAndStdByActivityAndID.txt).
	
	
	
