clear all
close all
clc

warning('off')

setdemorandstream(672880951);

fileImport = 'dataEMGunique5gesture.mat';

% Update/Generate new dataBase


selectFeaturesNr = [1 2 11 13]; 
selectPersonNr   = [ 66:91 ];            % 66 - 91

fileImport = generateMatFile( selectFeaturesNr, selectPersonNr ); 

load(fileImport); 

feat = rawData; label = labelsVector; labelB = labelsMatrix; % Binary

%recognition Machine Learning
recognitionML;

%recognition Neural Network
recognitionNN;
%recognition by Neural Network and export to ONNX
recNN;
