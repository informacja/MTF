function [bf, af, Amp, fi, nhP, nA02, tauhP, tauA02, tauTu]=designButter(Tu,Rzad,lT0,fig,kolB,txtyt,MTF1,MTF2,MTF3,MTF4) 
% function [bf, af, Amp, fi, ihP, iA02, tauhP, tauA02, tauTu]=designButter(Tu,Rzad,lT0,fig,kolB,txtyt,,MTF1,MTF2,MTF3,MTF4) 
% ....... Argumenty obowiązkowe
% Tu - okres harmonicznej odcięcia
% Rzad tablica rzedow filtru Butterwortha, np.: [3 4 5] 
% ....... Dalej argum. opcjonalne:
% lT0 liczba probek w okresie podstawowym (np 10000); domyślnie lT0=100
% fig nr rysunku np.1 lub: 0 - nastepny lub brak - bez rysunkow
% kolB tablica kolorow dla Butterwortha, jesli pusty kolB='k' 
% txtyt - tytul, np: sprintf('Porownanie filtrow Butter i MTF dla Tu=%.0f lT0=%d',Tu,lT0), lub sprintf('Wykresy Bodego dla filtrow Butter. rzędu 5 4 3 i Tu=%.2f; lT_0=%d',rzedu,Tu,lT0); 
% MTF1,MTF2,MTF3,MTF4 - tablice wierszowe filtrow MTF (od 1.geo do czterech) do porównania z Butter i z sobą 
% ======= Wyjscia: 
% bf, af - wspolczynniki wielomianow Liczn. i Mian. ostatniego badanego
%          filtru Butter: y(n)=-af(1)*y(n-1)+... +bf(1)*w(n)+bf(2)*w(n-1)+ ....
% Amp, fi - amplit. i fazy [rad] wszystkich badanych filtrow w wierszach o wym. round(lT0/2) 
% nhP indeks amplitudy polowy mocy Amp(ihP)=1/sqrt(2) wszystkich badanych filtrow
% iA02 ostatni indeks dla Amp(iA02)=0.02 wszystkich badanych filtrow
% tauhP, tauA02, tauTu - opoznienia zastępcze wszystkich badanych filtrow 
% =====================================================================
clear Af bf Ampl Phase Am Ph tau     WT; 
Rzedy=[5 4 3 2]; % nominalne rzedy Butterwortha
LfB=length(Rzad); if(LfB>length(Rzedy)) LfB=length(Rzedy); end
omT=2*pi/Tu; % Wc=omT/wN;  omT=2*pi/Tu; wN=pi; Wc=2/Tu; 
% dla rzedow= 5 4 3 2 1 wspolczynnik WtD wynosi:
WtD=[1.6138 1.8182 2.2172 3.3197 3.0092]; %WtD(2)=1.05;
% WtD stosunek cut-off do half-power; Am(cutoff)=0.09; Am(half-power)=1/sqrt(2)=0.707; (to jest parametr projektowy filtru)
if(nargin<4) fig=0; nf1=fig; liczYB=0; else nf1=abs(fig); if(fig<0) liczYB=1; else liczYB=0; end, end
if(nargin<3) 
    nRzad=find(Rzedy==Rzad(1)); 
    if(length(nRzad)==0) fprintf(1,'\nNiewlasciwy rzad Butter: rzad=%d moze byc rzad=%d',Rzad(1),Rzedy(1)); return; end
    rzad=Rzedy(nRzad); % wybrany rzad
    Wc=2/Tu/WtD(nRzad); [bf,af]=butter(rzad,Wc); 
    Amp=[]; Phase=[]; ihP=[]; iA02=[]; tauhP=[]; tauA02=[]; tauTu=[]; 
    return, % Wc=omT/wN; 
end 
nf=fig; if(nargin<5) kolB='k'; end
if(length(kolB)<LfB) kolB='kbrmgc'; end
lkol=length(kolB); 
if(nargin<3) lT0=100; Lxf=round(lT0/2); Wb=[0:omT/lT0: 3.01*omT]; 
else 
    Lxf=round(lT0/2); 
    Wb=2*pi*[0:Lxf-1]/lT0;
end
lw=length(Wb);
%if(fig==0)  nf2=figure; end
om=[1:lw]; %Om=2*pi*(om-1); 
Om=Wb;  jedn=omT;
if(nargin<6) txtyt=''; end
if(nargin>5)
    if(length(txtyt)==0)
        txtyt=sprintf('Wykrest Bodego dla filtra Butterwortha rzędu %d i Tu=%.2f; T_0=%d',Rzad(1),Tu,lT0);
    else txtyt=[txtyt sprintf(': Tu=%.2f; lT_0=%d',Tu,lT0)];
    end
end
for(nfB=1:LfB)
    nRzad=find(Rzedy==Rzad(nfB)); if(length(nRzad)==0) continue; end
    rzad=Rzedy(nRzad); % wybrany rzad
    WT=WtD(nRzad); % wspolczynnik przeliczenia Tu na cut-off frequency
    Wc=2/Tu/WT;
    % --------------- Synteza filtru Butterwortha -----------------------
    [bf,af]=butter(rzad,Wc); % Wc=omT/wN;
    if(liczYB) %fig==-2)
        N=1000; Ka=length(af); Kb=length(bf); y=randn(N,1); yf(1:Kb,1)=zeros(Kb,1); for(n=Kb+1:N) yf(n,1)=-af(2:Ka)*yf(n-[1:Ka-1],1)+bf(1:Kb)*y(n-[0:Kb-1],1); end,
        figure(nf2); if(nfB>1) hold on; end; 
        plot([6:N],y(6:N),'g',[Kb+1:N],yf(Kb+1:N),'k'); hold off;
        figure; if(nfB>1) hold on; end;
        bode(tf(bf,af,1),Wb); hold off;
    end
    [Ampl, Phase]=bode(tf(bf,af,1),Wb); % Phase w stopniach
    ihP=0; lw=length(Ampl);
    for(i=1:lw)
        Amp(nfB,i)=Ampl(1,1,i); Ph(i)=Phase(1,1,i)-Phase(1,1,1);
        if(Amp(nfB,i)>=Amp(nfB,1)/sqrt(2)); nhP(nfB)=i; end,
        if(Amp(nfB,i)>=0.02); nA02(nfB)=i; end,
    end,
    if(nfB==LfB) iA02=nA02(nfB); ihP=nhP(nfB); end,

    % ------------------------------------------------------------------
    fi(nfB,:)=Ph*pi/180; %fi w rad/sec
end    
WihP=Wb(ihP); % Om=2pi/Ti; om-1=i/To
WT=Wb(iA02)/omT;
for(nfB=1:LfB)
    tau=[]; tau(1)=0; tau(2:lw)=fi(nfB,2:lw)./Om(2:lw); 
    tau(1)=tau(2);
    om1=find(abs(Om/jedn-1)<=1.e-2);
    tauhP(nfB)=mean(tau(2:ihP)); tauA02(nfB)=mean(tau(2:iA02)); tauTu(nfB)=mean(tau(2:om1(1)));
    if(nf1)
        kolb=kolB(nfB);
        om1=find(abs(Om/jedn-1)<1.e-2); om1=om1(1);
        figure(nf1); subplot(2,1,1);
        if(nfB>1) hold on; end;
        plot(Om(1:iA02)/jedn,Amp(nfB,1:iA02),kolb,Om(ihP)/jedn,Amp(nfB,ihP),[kolb '*']);
        axis('tight'); hold on; ax=axis;
        plot([WihP/jedn WihP/jedn], ax(3:4),[kolb ':'],[1 1],ax(3:4),'r--'); hold off;
        Tau=tau(om);%-tau(om1);
        Tau1=Tau(om1); shY=4; shY=Tau1*1.1; %Tau1=0;
        xlabel(sprintf('Czestosc wzfledna f/f_{Tu}: punkt * to A(f_{hp}/f_{Tu})=2^{-1/2}; czest f/f_{Tu}=1 dla Tu')); ylabel('Amplituda');
        subplot(2,1,2);
        if(nfB>1) hold on; end;
        plot(Om(1:iA02)/jedn,fi(nfB,1:iA02),kolb,Om(ihP)/jedn,fi(nfB,ihP),[kolb '.']);
        axis('tight'); ax=axis; hold on;
        plot([WihP/jedn WihP/jedn], ax(3:4),[kolb ':'],[1 1],ax(3:4),'r--');
        plot([0 WihP/jedn],[0 fi(nfB,ihP)],[kolb '.:'],Om(1:om1)/jedn,tauhP(nfB)*Om(1:om1),[kolb '--']);
        plot([0 Wb(om1)/jedn],[0 fi(nfB,om1)],'r.:',Om(1:om1)/jedn,tauTu(nfB)*Om(1:om1),'r--');
        plot([0 Wb(iA02)/jedn],[0 fi(nfB,iA02)],'g.:',Om(1:iA02)/jedn,tauA02(nfB)*Om(1:iA02),'g--');
        hold off;
        if(nfB==LfB)
            txtau='\tau';
            txxl=sprintf('Czest.wzfledna f/f_{Tu}; Opoznienie srednie f_B.%d: %s_{hP}=%.2f %s_{Tu}=%.2f %s_{A02}=%.2f',...
                LfB,txtau,tauhP(LfB),txtau,tauTu(LfB),txtau,tauA02(LfB));
            %xlabel(txxl); 
            ylabel('Faza [rad]');
        end
    end
end
if(nargin>6) % Analiza filtrow MTF
    Lf=LfB+4; nfF=0;
    for(nf=LfB+1:Lf)
        nfF=nfF+1;
        switch(nfF) 
            case 1, if(nargin>6) MTF=MTF1; else break; end, 
            case 2, if(nargin>7) MTF=MTF2; else break; end, 
            case 3, if(nargin>8) MTF=MTF3; else break; end, 
            case 4, if(nargin>9) MTF=MTF1; else break; end, 
        end
        [lFc lF2]=size(MTF);
        if(lFc==0) break; end
        if(lF2==1) MTF=MTF'; lFc=length(MTF); end, % Bode wymaga wierszowej tablicy 
        if(nf<=lkol) kol=kolB(nf); else dk=nf-lkol; kol=[kolB(dk) '--']; end
        [AmpF, Phase]=bode(tf(MTF(lFc:-1:1),1,1),Wb); % Phase w stopniach
        for(i=1:lw) 
            fi(nf,i)=-(Phase(1,1,i)-Phase(1,1,1))*pi/180; 
            Amp(nf,i)=AmpF(1,1,i); 
            if(Amp(nf,i)>=Amp(nf,1)/sqrt(2)); nhP(nf)=i; end,
            if(Amp(nf,i)>=0.02); nA02(nf)=i; end,
        end
        tauF(1)=0; tauF(2:lw)=fi(nf,2:lw)./Om(2:lw);
        tauhP(nf)=mean(tauF(2:ihP)); tauA02(nf)=mean(tauF(2:iA02)); tauTu(nf)=mean(tauF(2:om1(1)));
        subplot(2,1,1);
        hold on; plot(Om(1:iA02)/jedn,Amp(nf,1:iA02),kol,Om(ihP)/jedn,Amp(nf,ihP),[kol(1) '*']);
        axis('tight'); ax=axis; %hold on;
        plot([WihP/jedn WihP/jedn], ax(3:4),[kolb ':'],[1 1],ax(3:4),'r--');
        %plot([0 WihP/jedn],[0 fi(nfB,ihP)],[kolb '.:'],Om(1:om1)/jedn,tauhP(nfB)*Om(1:om1),[kolb '--']);
        %plot([0 Wb(om1)/jedn],[0 fi(nfB,om1)],'r.:',Om(1:om1)/jedn,tauTu(nfB)*Om(1:om1),'r--');
        %plot([0 Wb(iA02)/jedn],[0 fi(nfB,iA02)],'g.:',Om(1:iA02)/jedn,tauA02(nfB)*Om(1:iA02),'g--');
        hold off;
        subplot(2,1,2);
        hold on; %plot(Om(1:iA02)/jedn,fi(nf,1:iA02),kol,Om(ihP)/jedn,fi(nf,ihP),[kol(1) '.']);
        plot(Om(1:om1)/jedn,fi(nf,1:om1),kol,Om(ihP)/jedn,fi(nf,ihP),[kol(1) '.']);
        axis('tight'); ax=axis; %hold on;
        plot([WihP/jedn WihP/jedn], ax(3:4),[kolb ':'],[1 1],ax(3:4),'r--');
        plot([0 WihP/jedn],[0 fi(nfB,ihP)],[kolb '.:'],Om(1:om1)/jedn,tauhP(nfB)*Om(1:om1),[kolb '--']);
        plot([0 Wb(om1)/jedn],[0 fi(nfB,om1)],'r.:',Om(1:om1)/jedn,tauTu(nfB)*Om(1:om1),'r--');
        plot([0 Wb(iA02)/jedn],[0 fi(nfB,iA02)],'g.:',Om(1:iA02)/jedn,tauA02(nfB)*Om(1:iA02),'g--');
        hold off;
        if(nfF-2*round((nfF-1)/2)>0) txxl=[txxl sprintf('\nOpozn.srednie:')]; else txxl=[txxl sprintf('; ')]; end
        txxl=[txxl sprintf('MTF%d: %s_{hP}=%.2f %s_{Tu}=%.2f %s_{A02}=%.2f',...
            nfF,txtau,tauhP(nf),txtau,tauTu(nf),txtau,tauA02(nf))];
        %txtyt=[txtyt txxl];
    end
end
if(nf1)
    subplot(2,1,1); title(txtyt);
    subplot(2,1,2); xlabel(txxl);
end
return
