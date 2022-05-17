feat=rawData'; 

setdemorandstream(672880951);

YAll = categorical(label);
T=table(feat');
XAll = table2cell(T);
 
dim=size(XAll,1);
 
for i=1:dim
  XAll{i}=XAll{i}';
end
 
%--------------
numObservations = size(XAll,1);
numObservationsTrain = floor(0.85*numObservations);
numObservationsTest = numObservations - numObservationsTrain;

idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxTest = idx(numObservationsTrain+1:end);
 
XtblTrain = XAll(idxTrain,:);
XtblTest = XAll(idxTest,:);

 
 
title("Training Observation 1")
numFeatures = size(XAll,1);
legend("Feature " + string(1:numFeatures),'Location','northeastoutside')


%Define the LSTM network architecture. Specify the input size as 12 (the number of features of the input data). Specify an LSTM layer to have 100 hidden units and to output the last element of the sequence. Finally, specify nine classes by including a fully connected layer of size 9, followed by a softmax layer and a classification layer.

inputSize = size(feat,1); %?

numHiddenUnits = 100;
numClasses = size(labelB,1); %innaczej zdefiniowaæ liczbê klas

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
% Specify the training options. Specify the solver as 'adam' and 'GradientThreshold' as 1. Set the mini-batch size to 27 and set the maximum number of epochs to 100.
% Because the mini-batches are small with short sequences, the CPU is better suited for training. Set 'ExecutionEnvironment' to 'cpu'. To train on a GPU, if available, set 'ExecutionEnvironment' to 'auto' (the default value).
maxEpochs = 100;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','none'); % or 'training-progress' for visibility process
% Train the LSTM network with the specified training options.

YtblTrain= YAll(idxTrain,:);

net = trainNetwork(XtblTrain,YtblTrain,layers,options);
%---------------classification---------------------------------------------
% % Classify the test data. Specify the same mini-batch size used for training.
YPred = classify(net,XtblTest,'MiniBatchSize',miniBatchSize);
% % Calculate the classification accuracy of the predictions.

YtblTest=YTrain(idxTest,:);

accp = sum(YPred == YtblTest)./numel(YtblTest)
%-------------------checking test set-------------------------------------

YPred = classify(net,XtblTrain ,'MiniBatchSize',miniBatchSize);
acct = sum(YPred == YtblTrain )./numel(YtblTrain )

%----------------checking all----------------------------------------------

YPred = classify(net,XAll ,'MiniBatchSize',miniBatchSize);
acct = sum(YPred == YAll )./numel(YAll)

%-- ONNX model for  microcontrollers-----------------------

filename = 'bion.onnx';
exportONNXNetwork(net,filename);



