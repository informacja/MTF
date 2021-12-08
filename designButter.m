% Filtr Butterwortha 
function [bf, af, Amp, Phase, ihP, iA02, tauhP, tauA02, tauTu]=designButter(Tu,rzad,T0,fig,kolB) 
% Tu - okres harmonicznej odciÄ™cia
% rzad rzad filtru,
% T0 okres podstawowy (np 10000)
% ihP indeks amplitudy polowy mocy Amp(ihP)=1/sqrt(2)
% iA02 ostatni indeks dla Amp(iTA02).0.02
clear Af bf Ampl Phase Am Ph tau WT; 
% =5; nominalny rzad Butterwortha
MbD=[5 4 3 2]; nMbN=find(MbD==rzad); 
MbN=MbD(nMbN); % nominalny rzad
iik=length(MbD);
omT=2*pi/Tu; % Wc=omT/wN;  omT=2*pi/Tu; wN=pi; Wc=2/Tu; 
% dla Mb= 5 4 3 2 1
WtD=[1.6138 1.8182 2.2172 3.3197 3.0092]; %WtD(2)=1.05;
% WtD stosunek cut-off do half-power; Am(cutoff)=0.09; Am(half-power)=1/sqrt(2)=0.707; (to jest parametr projektowy filtru)
if(nargin<4) fig=0; nf1=fig; liczYB=0; else nf1=abs(fig); if(fig<0) liczYB=1; else liczYB=0; end, end
if(nargin<3) Wc=2/Tu/WtD(nMbN); [bf,af]=butter(MbN,Wc); return, % Wc=omT/wN; 
else 
    %if(fig<0) Mb=MbD; WT=WtD; kolB='krmbg'; nf=0; 
    %else
    Mb=MbN; WT=WtD(nMbN); nf=fig; iik=1; if(nargin<5) kolB='k'; end
    %end
end
if(nargin<3) T0=100; Lxf=round(T0/2); Wb=[0:omT/T0: 3.01*omT]; 
else
    Lxf=round(T0/2); 
    Wb=2*pi*[0:Lxf-1]/T0;
end
if(fig<0)  nf2=figure; end
for(iii=1:iik)
 M=Mb(iii); % rzad filtru=rzad
 Wc=2/Tu/WT(iii); [bf,af]=butter(M,Wc); % Wc=omT/wN; 
 if(liczYB) %fig==-2)
    N=1000; Ka=length(af); Kb=length(bf); y=randn(N,1); yf(1:Kb,1)=zeros(Kb,1); for(n=Kb+1:N) yf(n,1)=-af(2:Ka)*yf(n-[1:Ka-1],1)+bf(1:Kb)*y(n-[0:Kb-1],1); end, 
    figure(nf2); plot([6:N],y(6:N),'g',[Kb+1:N],yf(Kb+1:N),'k')
    figure;
    bode(tf(bf,af,1),Wb); 
 end        
 [Ampl, Phase]=bode(tf(bf,af,1),Wb); % Phase w stopniach 
 ihP=0; lw=length(Ampl); 
 for(i=1:lw) 
    Amp(i)=Ampl(1,1,i); Ph(i)=Phase(1,1,i)-Phase(1,1,1); 
    if(Amp(i)>=Amp(1)/sqrt(2)); ihP=i; end, 
    if(Amp(i)>=0.02); iA02=i; end,
 end, 
end
 om=[1:lw]; %Om=2*pi*(om-1); 
 Om=Wb;
 WihP=Wb(ihP); % Om=2pi/Ti; om-1=i/To
 WT=Wb(iA02)/omT; 
 jedn=omT;
 fi=Ph*pi/180; %fi w rad/sec
 clear tau; tau(1)=0; tau(2:lw)=fi(2:lw)./Om(2:lw); %for(i=2:length(fi)) tau(i)=fi(i)/Om(i); if(tau(i)>3) tau(i)=3; end, end; %tau=[0 fi(2:end)./(Om(2:end))]; 
 tau(1)=tau(2); 
 om1=find(abs(Om/jedn-1)<=1.e-2); 
 tauhP=mean(tau(2:ihP)); tauA02=mean(tau(2:iA02)); tauTu=mean(tau(2:om1(1)));
 if(nf1)
    %if(nf>1) figure(nf); else figure(nf1); subplot(2,1,1); end
    om1=find(abs(Om/jedn-1)<1.e-2); om1=om1(1); 
    figure(nf1); subplot(2,1,1); 
    plot(Om(1:iA02)/jedn,Amp(1:iA02),kolB,Om(ihP)/jedn,Amp(ihP),[kolB '*']); 
    axis('tight'); hold on; ax=axis;  
    %plot([Wb(iA02)/jedn Wb(iA02)/jedn], ax(3:4),'r:',[1 1],ax(3:4),'r--'); hold off;
    plot([WihP/jedn WihP/jedn], ax(3:4),[kolB ':'],[1 1],ax(3:4),'r--'); hold off;
    Tau=tau(om);%-tau(om1); 
    Tau1=Tau(om1); shY=4; shY=Tau1*1.1; %Tau1=0;
    xlabel(sprintf('Czestosc wzglêdna f/f_{Tu}: punkt * to A(f_{hp}/f_{Tu})=2^{-1/2}; czest f/f_{Tu}=1 dla Tu')); ylabel('Amplituda');
    title(sprintf('Wykrest Bodego dla filtra Butterwortha rzêdu %d i Tu=%.2f; T_0=%d',rzad,Tu,T0)); 
    subplot(2,1,2);
    plot(Om(1:iA02)/jedn,fi(1:iA02),kolB,Om(ihP)/jedn,fi(ihP),[kolB '.']); 
    axis('tight'); ax=axis; hold on; 
    plot([WihP/jedn WihP/jedn], ax(3:4),[kolB ':'],[1 1],ax(3:4),'r--');
    plot([0 WihP/jedn],[0 fi(ihP)],[kolB '.:'],Om(1:om1)/jedn,tauhP*Om(1:om1),[kolB '--']);
    plot([0 Wb(om1)/jedn],[0 fi(om1)],'r.:',Om(1:om1)/jedn,tauTu*Om(1:om1),'r--');
    plot([0 Wb(iA02)/jedn],[0 fi(iA02)],'g.:',Om(1:iA02)/jedn,tauA02*Om(1:iA02),'g--');
    hold off; 
    txtau='\tau';
    xlabel(sprintf('Czest.wzglêdna f/f_{Tu}; Opoznienie œrednie: %s_{hP}=%.2f %s_{Tu}=%.2f %s_{A02}=%.2f',txtau,tauhP,txtau,tauTu,txtau,tauA02)); 
    ylabel('Faza [rad]');
  end
 return
