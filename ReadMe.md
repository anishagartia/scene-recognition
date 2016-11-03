# scene-recognition

This Project involved scene recognition with bag of words for 15 scene categories described in Lazebnik et al. 2006. To improve accuracy, several other Computer Vision techniques have been implemented. They are: GIST descriptor, Fisher Encoding, Spatial Pyramid representation, etc. The classifiers used here are k-nn and linear SVM classifier.
The main code file is proj4.m. In this file, feature descriptor we wish to use is selected by setting the parameter 'FEATURE', and the classifier we wish to use is selected by setting the parameter 'CLASSIFIER'. These parameters can take on of the following values.

FEATURE = 'tiny image';  
FEATURE = 'bag of sift';  
FEATURE = 'bag of spatial sift';  
FEATURE = 'bag of gist';  
FEATURE = 'kernel codebook encoding';  
FEATURE = 'fisher sift';  
FEATURE = 'combined spatial fisher gist';  
CLASSIFIER = 'nearest neighbor';  
CLASSIFIER = 'support vector machine';  

The bag of words requires a vocabulary to be trained. The pre-trained vocabulary is provided as vocab.mat. If the user wishes to train a new vocabulary, vocab.mat must be renamed or removed.

The result is seen as a confusion matrix of true class, and recognised class. The accuracy of the implementation is also displayed on the command window. Results and analysis is presented in a HTML document found here   http://htmlpreview.github.io/?https://github.com/anishagartia/scene-recognition/blob/master/html/index.html.

The platform used is Matlab R2016a.
Pre-requisites are vl-feat library for Matlab which can be found at http://www.vlfeat.org
(See http://www.vlfeat.org/matlab/matlab.html for VLFeat Matlab documentation.) 

