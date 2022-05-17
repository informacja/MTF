%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function SVM=jSVM(feat,label,kernel,kfold)
switch kernel
	case'l'; kernel='linear';     
  case'r'; kernel='rbf'; 
  case'p'; kernel='polynomial';   
  case'g'; kernel='gaussian';
end
rng('default'); 
% Set up template 
Temp=templateSVM('KernelFunction',kernel,'KernelScale','auto');
% Perform support vector machine
Model=fitcecoc(feat,label,'Learners',Temp);
% Perform cross-validation
C=crossval(Model,'kfold',kfold);
% Prediction
pred=kfoldPredict(C);
% Confusion matrix
confmat=confusionmat(label,pred); 
% Accuracy for each fold
Afold=100*(1-kfoldLoss(C,'mode','individual')); 
% Average accuracy
acc=mean(Afold); 
% Store results
SVM.fold=Afold; SVM.acc=acc; SVM.con=confmat; 
fprintf('\n Classification Accuracy (SVM): %g %%',acc); 
end

