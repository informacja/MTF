%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function DT=jDT(feat,label,nSplit,kfold)
rng('default'); 
% Perform decision tree
Model=fitctree(feat,label,'MaxNumSplits',nSplit);
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
DT.fold=Afold; DT.acc=acc; DT.con=confmat; 
fprintf('\n Classification Accuracy (DT): %g %%',acc);
end

