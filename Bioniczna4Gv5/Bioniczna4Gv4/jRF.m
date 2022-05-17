%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function RF=jRF(feat,label,nBag,kfold)
rng('default');
% Divide data into k-folds
fold=cvpartition(label,'kfold',kfold); 
% Pre
pred2=[]; ytest2=[]; Afold=zeros(kfold,1); 
% Random forest start
for i=1:kfold
  % Call index of training & testing sets
	trainIdx=fold.training(i); testIdx=fold.test(i);
  % Call training & testing features and labels
  xtrain=feat(trainIdx,:); ytrain=label(trainIdx);
  xtest=feat(testIdx,:); ytest=label(testIdx);
  % Training the model
  Model=TreeBagger(nBag,xtrain,ytrain,'OOBPred','On',...
    'Method','Classification');
  % Perform testing
  Pred0=predict(Model,xtest); A=size(Pred0,1); pred=zeros(A,1); 
  % Convert format
  for j=1:A
  	pred(j,1)=str2double(Pred0{j,1});
  end
  % Confusion matrix
  con=confusionmat(ytest,pred);
  % Accuracy for each fold
  Afold(i)=100*sum(diag(con))/sum(con(:));  
  % Store temporary
  pred2=[pred2(1:end);pred]; ytest2=[ytest2(1:end);ytest];
end
% Overall confusion matrix
confmat=confusionmat(ytest2,pred2); 
% Average accuracy over k-folds
acc=mean(Afold);
% Store results
RF.fold=Afold; RF.acc=acc; RF.con=confmat; 
fprintf('\n Classification Accuracy (RF): %g %%',acc); 
end

