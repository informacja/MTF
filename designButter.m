% Filtr Butterwortha 
function [bf, af, Amp, Phase, Wco, iT]=designButter(Tu,rzad,Lxf,fig,kolorB) 
% Tu - okres harmonicznej odcięcia
% rzad rzad filtru,
% Lxf rozmiar tablicy harmonicznych do obliczenia Bodego: xf=[0:Lxf-1],
% Wco indeks amplitudy polowy mocy Amp(Wco)=1/sqrt(2)
% iT ostatni indeks dla Amp(iT).0.09
clear Af bf Ampl Phase Am Ph tau WT; 
% =5; nominalny rzad Butterwortha
MbD=[5 4 3 2]; nMbN=find(MbD==rzad); 
MbN=MbD(nMbN); % nominalny rzad
iik=length(MbD);
omT=2*pi/Tu; % Wc=omT/wN;  omT=2*pi/Tu; wN=pi; Wc=2/Tu; 
% dla Mb= 5 4 3 2 1
WtD=[1.6138 1.8182 2.2172 3.3197 3.0092]; %WtD(2)=1.05;
% WtD stosunek cut-off do half-power; Am(cutoff)=0.09; Am(half-power)=1/sqrt(2)=0.707; (to jest parametr projektowy filtru)
if(nargin<4) fig=1; liczYB=0; else liczYB=1; end
if(nargin<3) Wc=2/Tu/WtD(nMbN); [bf,af]=butter(MbN,Wc); return, % Wc=omT/wN; 
else 
    if(fig<=0) Mb=MbD; WT=WtD; kolorB='krmbg'; nf=0; 
    else Mb=MbN; WT=WtD(nMbN); nf=fig; iik=1; if(nargin<5) kolorB='k'; end
    end
end
if(nargin<3) Wb=[0:omT/100: 3.01*omT]; 
else Wb=2*pi*[0:Lxf-1]/(2*Lxf);
end
if(fig<=0)  nf1=figure; end
for(iii=1:iik)
 M=Mb(iii); % rzad filtru=rzad
 Wc=2/Tu/WT(iii); [bf,af]=butter(M,Wc); % Wc=omT/wN; 
 if(liczYB) %fig==-2)
    N=1000; Ka=length(af); Kb=length(bf); y=randn(N,1); yf(1:Kb,1)=zeros(Kb,1); for(n=Kb+1:N) yf(n,1)=-af(2:Ka)*yf(n-[1:Ka-1],1)+bf(1:Kb)*y(n-[0:Kb-1],1); end, 
    figure; plot([6:N],y(6:N),'g',[Kb+1:N],yf(Kb+1:N),'k')
    figure
    bode(tf(bf,af,1),Wb); 
 end        
 [Ampl, Phase]=bode(tf(bf,af,1),Wb); % Phase w stopniach 
 Wco=0; lw=length(Ampl); 
 for(i=1:lw) 
    Amp(i)=Ampl(1,1,i); Ph(i)=Phase(1,1,i); 
    if(Amp(i)>=Amp(1)/sqrt(2)); Wco=i; end, 
    if(Amp(i)>=0.09); iT=i; end,
 end, 
end
return
 