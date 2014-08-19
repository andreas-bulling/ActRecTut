#A Tutorial on Human Activity Recognition Using Body-worn Inertial Sensors

MATLAB toolbox for the publication

**A Tutorial on Human Activity Recognition Using Body-worn Inertial Sensors**  
Andreas Bulling, Ulf Blanke and Bernt Schiele  
ACM Computing Surveys 46, 3, Article 33 (January 2014), 33 pages  
DOI: [http://dx.doi.org/10.1145/2499621](http://dx.doi.org/10.1145/2499621)

**If you find the toolbox useful for your research please cite the above paper, thanks!**

# HOWTO
Version 1.3, 15 January 2014

## General Notes

- The data should be arranged in a MATLAB matrix with rows denoting the frames (samples) and columns
  denoting the different sensors or axes -> matrix NxM (N: frames, M: sensors/axes)
  IMPORTANT: make sure the matrix does not contain any timestamp columns as often added by data recording
  toolboxes, such as the Context Recognition Network Toolbox (CRNT)

- The ground truth labels should be integers, arranged in a MATLAB vector with rows denoting the frames
  -> vector Nx1 (N: frames)

- The data matrix should be loaded into the variable `data`, the ground truth label vector into
  the variable `labels`

- The NULL class needs to have label 1, the remaining classes labels 2:n 

- If you want to modify the default parameters of the different classifiers
  have a look at `setClassifier.m`

- This toolbox requires the following MATLAB toolboxes:
  - Statistics

- To compile the different third-party libraries have a look at the documentation

## How to reproduce the results from the paper

Execute `run_experiments_paper.m` in MATLAB

## Specific notes on how to create and run your own experiment

1. Have a look at `settings.m`
   This file contains all settings available in the toolbox and their defaults. All settings are
   stored in a MATLAB struct `SETTINGS`. Set the different fields in this struct
   according to the requirements of your planned experiment.

2. Have a look at `Experiments/expTutorial.m` and run the script
   This file contains a (simple) example structure of an experiment. Note how `settings.m` is
   executed first, followed by modifications to the `SETTINGS` fields.

   optional: Install all third-party libraries you plan to use (see list below).
   Archives of all supported libraries are provided in the subdirectory "Libraries".
   The libraries should be installed in the same directory. If you prefer to install the libraries
   in a different path, adapt the library paths in `settings.m` accordingly (line 33 and following)

3. To create your own experiment
  1. Copy `Experiments/expTutorial.m` to `Experiments/expOwn.m`

  2. Write code in `expOwn.m to` modify `SETTINGS` according to your experiment's requirements, in particular:
  ```Matlab
  SETTINGS.CLASSIFIER (default: 'knnVoting')
  SETTINGS.FEATURE_SELECTION (default: 'none')
  SETTINGS.FEATURE_TYPE (default: 'VerySimple')
  SETTINGS.EVALUATION (default: 'pd')
  SETTINGS.SAMPLINGRATE (in Hz, default: 32)
  SETTINGS.SUBJECT (default: 1)
  SETTINGS.SUBJECT_TOTAL (default: 2)
  SETTINGS.DATASET (default: 'gesture')
  SETTINGS.CLASSLABELS (default: {'NULL', 'Open window', 'Drink', 'Water plant',
      'Close window', 'Cut', 'Chop', 'Stir', 'Book', 'Forehand', 'Backhand', 'Smash'})
  SETTINGS.SENSOR_PLACEMENT (default: {'Right hand', 'Right lower arm', 'Right upper arm'})
  SETTINGS.FOLDS (default: 26)
  SETTINGS.SENSORS_AVAILABLE = {'acc_1_x', 'acc_1_y', 'acc_1_z', ...
                              'gyr_1_x', 'gyr_1_y', ...
                              'acc_2_x', 'acc_2_y', 'acc_2_z', ...
                              'gyr_2_x', 'gyr_2_y', ...
                              'acc_3_x', 'acc_3_y', 'acc_3_z', ...
                              'gyr_3_x', 'gyr_3_y'};
  SETTINGS.SENSORS_USED (default: {'acc_1', 'acc_2', 'acc_3', 'gyr_1', 'gyr_2', 'gyr_3'})
  ```

  3. Change the `EXPERIMENT_NAME` and `IDENTIFIER_NAME` variables in `expOwn.m`
        For example, `EXPERIMENT_NAME` could be set to 'kNN' and `IDENTIFIER_NAME` to 'k_5' if your
        experiment involves using a kNN classifier with k fixed to 5.

  4. Put your data files in subdirectories of "Data" named according to the scheme: subjectX_Y
        - X denotes the index of the subject (`1:SETTINGS.SUBJECT_TOTAL`)
        - Y denotes the type of dataset (`SETTINGS.DATASET` plus additional ones)
        For example, the toolbox datasets are stored in the following subdirectories:
        subject1_walk, subject1_gesture, subject2_walk, subject2_gesture
        The data files should be called "data.mat" and should contain both variables `data` and `labels`

  5. Run `expOwn.m` and wait for the script to finish.
        Extracted features will be saved in "Output/features" whereas the experiment output will be saved
        in "Output/experiments/EXPERIMENT_NAME/IDENTIFIER_NAME"

## Optional third-party libraries

* libSVM  
  URL: [http://www.csie.ntu.edu.tw/~cjlin/libsvm/](http://www.csie.ntu.edu.tw/~cjlin/libsvm/)

* liblinear  
  URL: [http://www.csie.ntu.edu.tw/~cjlin/liblinear/](http://www.csie.ntu.edu.tw/~cjlin/liblinear/)

* mRMR  
  URL: [http://penglab.janelia.org/proj/mRMR/](http://penglab.janelia.org/proj/mRMR/)

* SVMlight  
  URL: [http://svmlight.joachims.org/](http://svmlight.joachims.org/)

* jointboosting by Christian Wojek
  URL: none

* HMM Toolbox for MATLAB by Kevin Murphy  
  URL: [http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html](http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html)

* Performance evaluation scripts by Jamie Ward  
  URL: [http://www.jamieward.net/research/performance/](http://www.jamieward.net/research/performance/)
