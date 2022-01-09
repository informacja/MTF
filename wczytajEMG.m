% wczytajEMG
data = [];
if(~BigData) 
    folder = "./dane/"; fnames = [];
%     fnames =  [fnames "50Hz.wav"];
%     fnames =  [fnames "spoczynek.wav"];

%     fnames =  [fnames "zginanie.wav"];
%     fnames = [fnames "zginanie2.wav"];    
%     fnames = [fnames "zaciśnięta_pięść_statycznie.wav"];
%     fnames = [fnames "zaciśnięta_pięść_dynamicznie.wav"]; %"../bioniczna/bioniczna/data/01108.wav"
%------------------------------------------------------------------ 7 sekund
fnames = [fnames "updown.wav"];   
% fnames = [fnames "monika/serdeczny2.wav"];  
%     fnames = [fnames "7podnoszeniebranchusradialis.wav"];
%     fnames = [fnames "7kciukwgorę.wav"]; %oderwana elektroda pod koniec 4 kanał
%     fnames = [fnames "7szybkieRuszanienaprzemienne/kciuk.wav"];
%     fnames = [fnames "7szybkieRuszanienaprzemienne/wskazujący.wav"];
%     fnames = [fnames "7szybkieRuszanienaprzemienne/srodkowy.wav"];
%     fnames = [fnames "7szybkieRuszanienaprzemienne/serdeczny.wav"];
%     fnames = [fnames "7szybkieRuszanienaprzemienne/mały.wav"]; %../bioniczna/bioniczna/data/01108.wav"
    fnames = [fnames "serdecznyzgiecieiwyprost.wav"];
%     fnames = [fnames "serdecznyzgiecieiwyprost2.wav"];
%     fnames = [fnames "7szginanie2.wav"]; % zawiera pik
%     fnames = [fnames "edward\zginanie.wav"];    
%     fnames = [fnames "7sZginanie.wav"];  
% 
    fnames = [fnames "krystynka/serdeczny.wav"];
%     fnames = [fnames "krystynka/zginanie.wav"];
%     fnames = [fnames "krystynka/zginanie1.wav"];
%     fnames = [fnames "krystynka/zginanie2.wav"];
%     fnames = [fnames "krystynka/zginanie3.wav"];
%     fnames = [fnames "krystynka/zginanie4.wav"];
%     fnames = [fnames "tomasz/zginanie.wav"];
%     fnames = [fnames "tomasz/serdeczny.wav"];
%     fnames = [fnames "tomasz/thub.wav"];
%  fnames = [fnames "tomasz/viktoria.wav"];
% fnames = [fnames "tomasz/serdeczny2.wav"];  
% fnames = [fnames "tomasz/serdeczny3.wav"]; 
% fnames = [fnames "krzysztof/serdeczny.wav"];
% fnames = [fnames "monika/serdeczny.wav"];   
fnames = [fnames "serdecznyPiotr.wav"];   


nfig=80;
    for (i = 1:length(fnames))
        data = [data audioread(strcat(folder, fnames(i)))];
        figure(nfig+i); plot(data(:,i)); hold on; title(fnames(i));
        figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
        movegui(cell2mat( figpos(mod(nfig+i,length(figpos)-1)+1) ));
    end

%     [data, fs] = audioread( strcat(folder, fnames)); %data = data(:,2);
%     data2 = audioread(strcat(folder, fnames2));
%     data3 = audioread(strcat(folder, fnames3));
%     data4 = audioread(strcat(folder, fnames4));
%     data5 = audioread(strcat(folder, fnames5));
    ch = 8; Y = [];
    if (BSS)
        for (i = 1:length(data(1,:))/ch)
            tau = 2;
            yT = data(:,((i-1)*8+1):ch*i)'; n = length(data);
            Q=yT(:,1:n-tau)*yT(:,tau+1:n)'+yT(:,tau+1:n)*yT(:,1:n-tau)';
            
            [W,D] = eig(yT*yT',Q);    
            S = W'*yT;    
            Y = [ Y S'];
        end
    end
% 
%         yT = data2'; n =length(data2);
%         Q=yT(:,1:n-tau)*yT(:,tau+1:n)'+yT(:,tau+1:n)*yT(:,1:n-tau)';
%         
%         [W,D] = eig(yT*yT',Q);    
%         S = W'*yT;    
%        X = S';

    if (BSS > 0)       data = [Y]; 
    elseif (BSS < 0)   data = [Y data]; 
    else               data = [data];  % default 0
    end   

else folder = ".\data\";  
    selectPersonNr = [108:109]; % 66:109 / 55
    selectGestureNr = [ 2 ]; % 0 1 2 11 13
    fnames = folder+...
        "PERSON(" +min(selectPersonNr)+"do"+max(selectPersonNr)+...
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



dataSource = fullfile(folder, "*.wav"); 
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
    s = strcat(file(fileNo).folder,"\");
    s = strcat(s,file(fileNo).name);
    
%     tempData = featvect(s);    
    [tempData fs]= audioread(s);
    
    if(BSS)
        tau = 2;
        yT = tempData'; n =length(tempData);
        Q=yT(:,1:n-tau)*yT(:,tau+1:n)'+yT(:,tau+1:n)*yT(:,1:n-tau)';
        
        [W,D] = eig(yT*yT',Q);    
        S = W'*yT;    
        tempData = S';
    end

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
    figure(nfig); plot(y(:,ch)); hold on; title(strcat(file(fileNo).name, " Kanał(:,",int2str(ch),")"));
    figpos = {"north","south","east","west","northeast","northwest","southeast","southwest","center","onscreen"};
    movegui(cell2mat( figpos(mod(nfig,length(figpos)-1)+1) ));
%     figure(2*tempGestureNumber+3), plot(audioread(s)); hold on;title(file(fileNo).name);
%     legend; figure(tempPersonNumber);plot(audioread(s));
    data = [data; y]; %dodanie info o nr gestu
        
end
end % BigData