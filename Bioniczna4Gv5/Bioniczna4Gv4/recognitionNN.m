generateMatFile( [1 2 11 13], [66:109])
load('dataEMGunique4gesture.mat');
feat=rawData'; 

setdemorandstream(672880951);

labelB = labelsMatrix;

%net = patternnet(10*size(feat,1));
net = feedforwardnet(20);

view(net);

[ net tr]  = train(net,feat,labelB);

plotperform(tr)

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
fprintf('Percentage Correct All   : %f%%\n', 100*(1-c));

%--------------------------------------------------------------------------
wb = getwb(net);
[b,IW,LW] = separatewb(net,wb)



