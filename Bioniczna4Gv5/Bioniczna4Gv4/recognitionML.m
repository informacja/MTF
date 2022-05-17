%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%


% Benchmark data set contains 150 instances and 4 features (three classes)
% load dataEMBgesture.mat;% Matlab also provides this dataset (load fisheriris.mat)
% load nrgesture9.mat

% Call features & labels 
feat=rawData; 
% label=labels;

%---Input------------------------------------------------------------------
% feat:  feature vector (instances x features)
% label: labelling 
% kfold: Number of cross-validation
%---Output-----------------------------------------------------------------
% A struct that contains three results as follows:
% fold: Accuracy for each fold
% acc:  Average accuracy over k-folds
% con:  Confusion matrix
%--------------------------------------------------------------------------

% (1) Perform k-nearest neighbor (KNN)
%kfold=10; k=3; % k-value in KNN5 moze zmienić na liczbę klas  -11 u nas ?
kfold=11; k=3;
KNN=jKNN(feat,label,k,kfold); 

% (2) Perform discriminate analysis (DA)
kfold=11; Disc='l'; % The Discriminate can selected as follows:
% 'l' : linear 
% 'q' : quadratic
% 'pq': pseudoquadratic
% 'pl': pseudolinear
% 'dl': diaglinear
% 'dq': diagquadratic
DA=jDA(feat,label,Disc,kfold); 

% (3) Perform Naive Bayes (NB)
kfold=11; Dist='n'; % The Distribution can selected as follows:
% 'n' : normal distribution 
% 'k' : kernel distribution
NB=jNB(feat,label,Dist,kfold); 

% (4) Perform decision tree (DT)
%kfold=11; nSplit=50; % Number of split in DT
kfold=11; nSplit=5; % Number of split in DT
DT=jDT(feat,label,nSplit,kfold);

% (5) Perform support vector machine (SVM with one versus one)
kfold=11; kernel='r'; % The Kernel can selected as follows:
% 'r' : radial basis function  
% 'l' : linear function 
% 'p' : polynomial function 
% 'g' : gaussian function
SVM=jSVM(feat,label,kernel,kfold);

% (6) Perform random forest (RF)
kfold=11; nBag=50; % Number of bags in RF
RF=jRF(feat,label,nBag,kfold);


