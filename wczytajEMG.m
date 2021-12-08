Big = 1; % sourse of data (from DB or one file
% close all
folder = '.\dane\';  
if(Big) folder = '.\data\';  fnames = folder; 
    selectPersonNr = [108]; % 66:109 / 55
    selectGestureNr = [ 0 ]; % 0 1 2 11 13
    fnames = folder+...
        "PERSON(" +min(selectPersonNr)+':'+max(selectPersonNr)+...
        ") GESTURE"+mat2str(selectGestureNr);
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
end % Big

dataSource = fullfile(folder, '*.wav'); 
file = dir(dataSource);

rawData = [];      % featVectBion matrix 
labelsVector = []; % Vertical vector gesture numbers

for fileNo = 1:length(file)
    s = file(fileNo).name;
    
    if(Big) % filtration
        tempPersonNumber = str2double(s(3:5));  % personNumber 
        if( length(selectPersonNr) )
            if( selectPersonNr ~= tempPersonNumber ) continue; end 
        end

        tempGestureNumber = str2double(s(1:2)); % gestureNumber 
        if( length(tempGestureNumber))
            if( selectGestureNr ~= tempGestureNumber ) continue; end % pomijaj wy¿sze numery gestu i referencyjny   
        end
        
        labelsVector = [labelsVector; tempGestureNumber];
    end % Big
    
%     labelsVector = [labelsVector; tempGestureNumber];
    s = strcat(file(fileNo).folder,'\');
    s = strcat(s,file(fileNo).name);
    
%     tempData = featvect(s);    
    [tempData fs]= audioread(s);
    
    y = tempData; % do nothing
    
%     for i=1:size(tempData, 2) % normalizacja
%         y(:,i)=tempData(:,i)/max(abs(tempData(:,i)));
%     end
% 
%     yMean = mean(tempData);
%     ySigma = std(tempData);

%     for i = 1:size(tempData, 2) % standaryzacja
%         y(:,i)=(tempData(:,i)-yMean(i))/ySigma(i);
%     end 
    nfig=tempPersonNumber+1; ch = 1;
    figure(nfig); plot(y(:,ch)); hold on; title(strcat(file(fileNo).name, ' Kana³(:,',int2str(ch),')'));
    figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
    movegui(cell2mat( figpos(mod(nfig,length(figpos)-1)+1) ));
%     figure(2*tempGestureNumber+3), plot(audioread(s)); hold on;title(file(fileNo).name);
%     legend; figure(tempPersonNumber);plot(audioread(s));
    rawData = [rawData; y]; %dodanie info o nr gestu
        
end
