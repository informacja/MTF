function [features] = featvect(filename)
format long

if nargin < 1
    disp('usage: featvect(filename)');
    return;
end


normalise=1;

[y, Fs] = audioread(filename);  %Fs -Sampling frequency
yraw=y; %for 

[siglength n] = size(y);   


yTransposed = y';
%------------------BSS-----------------------------------------------------
tau= 2;
Q=yTransposed(:,1:n-tau)*yTransposed(:,tau+1:n)'+yTransposed(:,tau+1:n)*yTransposed(:,1:n-tau)';

[W,D] = eig(yTransposed*yTransposed',Q);    
S = W'*yTransposed;    
Y = S';
audiowrite('out.wav', Y, Fs);
[y, Fs] = audioread('out.wav');
%---------------------------------------------------------------------------



len=512; 
part=siglength/len;  %divide signal to 250 ms parts


%-----------------channels normalisation----------------------------------
if normalise
    for i=1:n
        y(:,i)=y(:,i)/max(abs(y(:,i)));
    end
end

%--------------1 feature - time domain RMS -------------------------------
j=0;

 for i=1:n
    for p=1:part 
        j=j+1;
        
        yn=y((p-1)*len+1:p*len,i); 
        x1 = filloutliers(yn, 'linear');
        x2 = smooth(x1, 5);
        yn=x2;

        rmsFeature(j)=rms(yn);
        
    end
end


%---------------------2 feature frequency domain ----------------------------------------------------


Fn = Fs/2;                                        % Nyquist Frequency
Fv = linspace(0, 1, fix(len/2))*Fn;               % Frequency Vector Fv = linspace(0, 1, fix(siglength/2))*Fn;              % Frequency Vector
Iv = 1:size(Fv,2);

win = hann(len); % window Hann's

for ch = 1:n % n - number of emg channels

   for p=1:part

    yn=y((p-1)*len+1:p*len,ch).*win;%    set channel to fft + Hanna windows
    Yn=fft(yn);
    Ylen=length(Yn)/2;
    Y(1:Ylen,ch) = abs(Yn(1:Ylen))/(Ylen/2); % (/2) corection for Hanna window

    Fr = linspace(0, Fs/2, Ylen);


    data=Y(Iv,ch)*2;


    [Medianfreq((ch-1)*part+p) ] = medfreq(data,Fs);

   end


end
%-------------------3 time- frequency domain ---HHT------------------------
% % y=yraw;
% Ts = 1/Fs; %frequency
% 
% kn=1; %numbers of  IMF channel
% 
% newch=0;
% for ch = [1 2 6 7 8] %1:1:1 %n- number of channel
%     newch=newch+1;
%     yn=y(:,ch);
%     
%     %smooth signal
%     
%     x1 = filloutliers(yn, 'linear');
%     x2 = smooth(x1, 10);
%     yn=x2;
%     
%     
%     imf = emd(yn);
%     for k = 1:1:kn %n- numbers of IMF
%         
%         %EMAV((newch-1)*kn+k)=jEMAV(imf{k});
%         %STD((newch-1)*kn+k)=jSTD(imf{k});
%        % ENT((newch-1)*kn+k)=jENT(imf{k});
%         RMS((newch-1)*kn+k)=jRMS(imf{k});
%         %DIFF((newch-1)*kn+k)=jDIFF(imf{k});
%         %ENE((newch-1)*kn+k)=jENE(imf{k});
%     end
%     
% end


features=[rmsFeature  Medianfreq  ] 
end












