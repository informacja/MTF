function [Y] = filterButter(data)
%Filtracja pasmowa
FS=2048;
order    =    5;
fcutlow  =   10;
fcuthigh =  500;
 

% onliczone wspÃ³Å‚czynnki filtra
[b1, a1] = butter(order,[fcutlow,fcuthigh]/(FS/2), 'bandpass');
%--------------------------------------------------------------------------
%Charakterystyka projektowanego filtra
% [h,f]=freqz(b1,a1,2048,FS);
% plot(f, 20*log10(abs(h)) );
% set(gca, 'XScale', 'log')
% ylim([-50 5])
% xlim([20 40000])
% grid on
%--------------------------------------------------------------------------
X=zeros(FS, 1);
X(1)=1; %Delta kroneckera
X = data;

% Y jest przefiltrowanym sygnaÅ‚em X
Y = filter(b1, a1, X);    % Bandpass filter
%--------------------------------------------------------------------------
%Charakterystyka rzczywistego filtra na podstawie delty kronecker
% figure
% Y=abs(fft(Y, FS));
% semilogx(2:FS/2, 20*log10(Y(2:FS/2)./max(Y(2:FS/2))),'b');
% xlim([20 40000])
% ylim([-50 0])
% grid on
end
