### Project Codebook

#### The Data

The original data were downloaded from the [UCI Machine Learning Repository website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The data were collected from the accelerometers of Samsung Galaxy S smartphones.
Specifically, 30 volunteers performed each 6 activities (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 3-axial linear acceleration and 3-axial angular velocity measures were collected. 
The obtained data were randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The original dataset included the following:

- `README.txt`
- `features_info.txt`: variables used on the feature vector.
- `features.txt`: list of all features.
- `activity_labels.txt`: activities name.
- `train/X_train.txt`: training set.
- `train/y_train.txt`: training labels.
- `test/X_test.txt`: test set.
- `test/y_test.txt`: test labels.
- `train/subject_train.txt`: rows identify the subject who performed the activity. Its range is from 1 to 30. 
- `train/Inertial Signals/total_acc_x_train.txt`: the acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- `train/Inertial Signals/body_acc_x_train.txt`: the body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- `train/Inertial Signals/body_gyro_x_train.txt`: the angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
- `test/subject_test.txt`: rows identify the subject who performed the activity. Its range is from 1 to 30. 
- `test/Inertial Signals/total_acc_x_test.txt`: the acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- `test/Inertial Signals/body_acc_x_test.txt`: the body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- `test/Inertial Signals/body_gyro_x_test.txt`: the angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

#### Data Cleaning

The dataset used in the analysis are:

- `X_train.txt`
- `y_train.txt`
- `subject_train.txt`
- `X_test.txt`
- `y_test.txt`
- `subject_test.txt`
- `features.txt`

We merged the train and the test set, and filter the data in order to retain only the measurements on the mean and standard deviation for each measurement. This was done using the following code:

`grep("(mean|std)\\(\\)", names(datMerge)) `

this lead to 66 features extracted from the original dataset. Combining the data with subject identifier (*SubjectID*) and activity (*Activity*) resulted in a dataset with 68 variables.

Original variables names were modified as follows:

* t became Time
* Acc became Acceleration
* mean() was transformed in Mean and std() in STD
* f became Frequency
* underscores were eliminated
* BodyBody was rewrittes as Body
* Mag became Magnitude
* Jerk was rewritten as JerkSignal

For instance, following the aformentioned rules, the variable *tBodyAcc-mean()-X* became *TimeBodyAccelerationMeanX* while *fBodyAcc-mean()-X* became *FrequencyBodyAccelerationMeanX*.




