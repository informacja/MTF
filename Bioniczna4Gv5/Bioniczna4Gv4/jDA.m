%-------------------------------------------------------------------------%
%  Machine learning algorithms source codes demo version                  %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function DA=jDA(feat,label,Disc,kfold)
switch Disc
  case'l' ; Disc='linear'; 
  case'pq'; Disc='pseudoquadratic';
  case'q' ; Disc='quadratic';    
  case'dl'; Disc='diaglinear';
  case'pl'; Disc='pseudolinear'; 
  case'dq'; Disc='diagquadratic';
end
rng('default'); 
% Perform discriminate analysis classifier
Model=fitcdiscr(feat,label,'DiscrimType',Disc); 
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
DA.fold=Afold; DA.acc=acc; DA.con=confmat;
fprintf('\n Classification Accuracy (DA): %g %%',acc);
end



