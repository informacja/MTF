function [fileImportName] = generateMatFile( selectFeaturesNr, selectPersonNr)

% Gestures numeration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x 00 - Reference noise 
% x 01 - Moutz power
% x 02 - A clenched fistZaciœniêta piêœæ, kciuk na zewn¹trz
%   03 - Gest OK
%   04 - Pointing  - palec wskazuj¹cy
% c 05 - Thumbs up - kciuk w górê
%   06 - Call me   - s³uchawka
%   07 - £apwica
%   08 - Otwieranie d³oni
%   09 - Zginanie palców po kolei
%   10 - trzymanie przedmiotu
% z 11 - Victoria - statyczne
%   12 - odlicznie - dynamiczne
% z 13 - Three middle fingers closer - 3 palce œrodkowe  statyczne
%   14 - moc - dynamiczne
%   15 - piêœæ-dynamiczne
%   16 - victoria dynamiczne
%   17 - 3 œrodkowe palce razem - dynamiczne
% c 18 - serdeczny palec w œrodek d³oni (like Spiderman)
%   19 - malypalec

% selectFeaturesNr = []; selectPersonNumber = []; % default all data

folder = './data';  
dataSource = fullfile(folder, '*.wav'); 
file = dir(dataSource);

rawData = [];      % featVectBion matrix 
labelsVector = []; % Vertical vector gesture numbers
labelsMatrix = []; % Binary matrix

for fileNo = 1:length(file)
    s = file(fileNo).name;
    
    tempPersonNumber = str2double(s(3:5));  % personNumber 
    if( length(selectPersonNr) )
        if( selectPersonNr ~= tempPersonNumber ) continue; end 
    end
    
    tempGestureNumber = str2double(s(1:2)); % gestureNumber 
    if( length(tempGestureNumber))
        if( selectFeaturesNr ~= tempGestureNumber ) continue; end % pomijaj wy¿sze numery gestu i referencyjny   
    end
    
    labelsVector = [labelsVector; tempGestureNumber];
    s = strcat(file(fileNo).folder,'/');
    s = strcat(s,file(fileNo).name);    
    
%     tempData = featvect(s);

begin = 2;% seconds
finish = begin +1;
window = 1/50; % parts
fs = 2048;
wLen = int32(window*fs);
tempData2 = [];
wgEnerg = 1;
Ewykl = 2;

        [secondAudio fs] = audioread(s);
        tempData = secondAudio(begin*fs+1:finish*fs,:);
if (0)
    tempData = filterButter(tempData);
else
       Yoryg = tempData;
    if(wgEnerg>1) y0=Yoryg(1); for(n=1:Ldsz) Yoryg(n)=y0*alfa+Yoryg(n); y0=Yoryg(n); end, end 
    meanYoryg=mean(Yoryg); 
    tempData=sign(Yoryg-meanYoryg).*(Yoryg-meanYoryg).^Ewykl;
    tempData = filterButter(tempData);
%     tx=sprintf('Sygnal ENERGII Y=Sygn^%d',Ewykl); txspac=''; 
end
    for k = 1:8;    
        dataW(:,k) = rms(tempData(1:wLen,1));
        for i = 1:wLen
            dataW = [dataW rms(tempData(1+wLen*i, k))];
        end
        tempData2 = [tempData2 dataW];
        dataW = [];
    end

%     figure(tempGestureNumber+1), plot(tempData); hold on; title(file(fileNo).name);
%     figure(2*tempGestureNumber+3), plot(audioread(s)); hold on;title(file(fileNo).name);
%     legend; figure(tempPersonNumber);plot(audioread(s));
    rawData = [rawData; tempData2]; %dodanie info o nr gestu
end

dimX = length(labelsVector);
dimY = length(unique(labelsVector));
labelsMatrix = zeros( dimY, dimX ); 

feature = unique(labelsVector);

for i = 1:dimY    
    for k = 1:dimX
        if ( feature(i) == labelsVector(k) )
            labelsMatrix(i,k) = 1;     
        end
    end
end

featureCountDistribution = histcounts(labelsVector)
if( sum(diff( featureCountDistribution )) ~= 0 )
    warning("Check importData settings. Irregular distribution of features");    
    histogram(labelsVector); title('Imported data by gestureNr distribution');
end
 
clear folder file fileNo s tempGestureNumber tempData tempPersonNumber featureCountDistribution i k dimY dimX
% dataGeneratedAt = datestr(datetime('now'));
fileImportName = sprintf('dataEMGunique%dgesture.mat', length(unique(labelsVector))); % Count of qnique gestures labels
save(fileImportName);

end
