%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function NB=jNB(feat,label,Dist,kfold)
switch Dist
	case'n'; Dist='normal';
	case'k'; Dist='kernel';
end
rng('default'); 
% Perform Naive Bayes
Model=fitcnb(feat,label,'Distribution',Dist);
% Perform cross-validation
C=crossval(Model,'kfold',kfold);
% Prediction
Pred=kfoldPredict(C); 
% Confusion matrix
confmat=confusionmat(label,Pred); 
% Accuracy for each fold
Afold=100*(1-kfoldLoss(C,'mode','individual')); 
% Average accuracy
acc=mean(Afold); 
% Store results
NB.fold=Afold; NB.acc=acc; NB.con=confmat; 
fprintf('\n Classification Accuracy (NB): %g %%',acc); 
end

