% wczytajEMG
if(~BigData) 
    folder = './dane/';  
    fnames = 'dane/50Hz.wav';
    fnames = 'spoczynek.wav';
    fnames = 'zginanie.wav';
    fnames = 'dane/zginanie2.wav';    
    fnames = 'zaciśnięta_pięść_statycznie.wav';
    fnames = 'zaciśnięta_pięść_dynamicznie.wav'; %'../bioniczna/bioniczna/data/01108.wav'

    fnames = '7sZginanie.wav';
    fnames = '7podnoszeniebranchusradialis.wav';
    fnames = '7kciukwgorę.wav';
    fnames3 = '7szybkieRuszanienaprzemienne/kciuk.wav';
    fnames = '7szybkieRuszanienaprzemienne/wskazujący.wav';
    fnames2 = '7szybkieRuszanienaprzemienne/srodkowy.wav';
    fnames = '7szybkieRuszanienaprzemienne/serdeczny.wav';
    fnames = '7szybkieRuszanienaprzemienne/mały.wav'; %../bioniczna/bioniczna/data/01108.wav'
    [data, fs] = audioread( strcat(folder, fnames)); %data = data(:,2);
    data2 = audioread(strcat(folder, fnames));
    data3 = audioread(strcat(folder, fnames));
        tau = 2;
        yT = data'; n =length(data);
        Q=yT(:,1:n-tau)*yT(:,tau+1:n)'+yT(:,tau+1:n)*yT(:,1:n-tau)';
        
        [W,D] = eig(yT*yT',Q);    
        S = W'*yT;    
        Y = S';

    if (BSSfirst > 0)       data = [Y data]; 
    elseif (BSSfirst < 0)   data = [data Y]; 
    else                    data = [data]; 
    end   

else folder = '.\data\';  fnames = folder; 
    selectPersonNr = [108]; % 66:109 / 55
    selectGestureNr = [ 2 ]; % 0 1 2 11 13
    fnames = folder+...
        "PERSON(" +min(selectPersonNr)+'do'+max(selectPersonNr)+...
        ") GESTURE"+mat2str(selectGestureNr);
% Gestures numeration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x 00 - Reference noise 
% x 01 - Moutz power
% x 02 - A clenched fistZaciśnięta pięść, kciuk na zewnątrz
%   03 - Gest OK
%   04 - Pointing  - palec wskazujący
% c 05 - Thumbs up - kciuk w górę
%   06 - Call me   - słuchawka
%   07 - Łapwica
%   08 - Otwieranie dłoni
%   09 - Zginanie palców po kolei
%   10 - trzymanie przedmiotu
% z 11 - Victoria - statyczne
%   12 - odlicznie - dynamiczne
% z 13 - Three middle fingers closer - 3 palce środkowe  statyczne
%   14 - moc - dynamiczne
%   15 - pięść-dynamiczne
%   16 - victoria dynamiczne
%   17 - 3 środkowe palce razem - dynamiczne
% c 18 - serdeczny palec w środek dłoni (like Spiderman)
%   19 - malypalec



dataSource = fullfile(folder, '*.wav'); 
file = dir(dataSource);

data = [];      % featVectBion matrix 
labelsVector = []; % Vertical vector gesture numbers

for fileNo = 1:length(file)
    s = file(fileNo).name;
    
    if(BigData) % filtration
        tempPersonNumber = str2double(s(3:5));  % personNumber 
        if( length(selectPersonNr) )
            if( selectPersonNr ~= tempPersonNumber ) continue; end 
        end

        tempGestureNumber = str2double(s(1:2)); % gestureNumber 
        if( length(tempGestureNumber))
            if( selectGestureNr ~= tempGestureNumber ) continue; end % pomijaj wyższe numery gestu i referencyjny   
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
    figure(nfig); plot(y(:,ch)); hold on; title(strcat(file(fileNo).name, ' Kanał(:,',int2str(ch),')'));
    figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
    movegui(cell2mat( figpos(mod(nfig,length(figpos)-1)+1) ));
%     figure(2*tempGestureNumber+3), plot(audioread(s)); hold on;title(file(fileNo).name);
%     legend; figure(tempPersonNumber);plot(audioread(s));
    data = [data; y]; %dodanie info o nr gestu
        
end
end % BigData