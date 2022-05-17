%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function KNN=jKNN(feat,label,k,kfold)
rng('default'); 
% Perform k-nearest neighbor classifier with Euclidean distance
Model=fitcknn(feat,label,'NumNeighbors',k,'Distance','euclidean');
% Perform cross-validation
C=crossval(Model,'KFold',kfold);
% Prediction
Pred=kfoldPredict(C); 
% Confusion matrix
confmat=confusionmat(label,Pred);
% Accuracy for each fold
Afold=100*(1-kfoldLoss(C,'mode','individual'));
% Average accuracy
acc=mean(Afold); 
% Store results
KNN.fold=Afold; KNN.acc=acc; KNN.con=confmat; 
fprintf('\n Classification Accuracy (KNN): %g %%',acc); 
end


