RMS = 1; FButter = 0; znakowanaMoc = 0;
generateMatFile( [1 2 11 13], [66:109], RMS, FButter, znakowanaMoc)
load('dataEMGunique4gesture.mat');
feat=rawData'; 

setdemorandstream(672880951);

labelB = labelsMatrix;

%net = patternnet(10*size(feat,1));
net = feedforwardnet(20);

view(net);

[ net tr]  = train(net,feat,labelB);

testX = feat(:,tr.testInd);
testT = labelB(:,tr.testInd);

testY = net(testX);
testClasses = testY > 0.5

plotconfusion(testT,testY)

[c,cm] = confusion(testT,testY);

fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);
plotroc(testT,testY)
plotconfusion(testT,testY)

testall = net(feat);
[c cm] =confusion(testall,labelB);
cm
str = sprintf('Percentage Correct All   : %f%% RMS: %i, Butter: %i, Signum: %i\n', 100*(1-c),RMS,FButter,znakowanaMoc);

plotperform(tr)
sgtitle(str);
figPW( int2str(RMS^1+ FButter^2+znakowanaMoc^3),0, 'png', 'Dawid', 1, 0,3)

%--------------------------------------------------------------------------
wb = getwb(net);
[b,IW,LW] = separatewb(net,wb)



