%  args:   1  2     3      4     5    6      7     8     9   10    11   12  13    14   15     
function [bf, af, tauhP, MTFd, Fzwc, LpFc, Amp, nA01, WcB, Fzwd, Fzwd2, fi,  Ffc, Ff1, Ff2]=desMTFcButter(nTypZ,Tud,rzad,lT0,fig,txtyt,kolB)
% function [bf, af, tauhP, MTFd, Fzwc, Fzwd, Fzwd2, LpFc, Amp, nA01, WcB, fi,  Ffc, Ff1, Ff2]=desMTFcButter(nTypZ,Tud,rzad,lT0,fig,txtyt,kolB)
....... Argumenty obowiązkowe
% nTypzZ - numer typu MTF - ma być 5 lub 3
% Tud - okresy harmonicznej odcięcia widma MTF (indeks 1.szego min(A(i))
% ....... Dalej argum. opcjonalne:
% rzad rzad filtru Butterwortha, np.: [3 4 5]; UWAGA: gdy rzad=0 lub nargin<3 nie liczymy Butter
% lT0 liczba probek w okresie podstawowym (np 10000); domyślnie lT0=0 tzn. nie liczymy widm
% fig nr rysunku np.1 lub: 0 - nastepny lub brak - bez rysunkow
% kolB tablica kolorow dla Butterwortha, jesli pusty kolB='k' 
% txtyt - tytul, np: sprintf('Porownanie filtrow Butter i MTF dla Tu=%.0f lT0=%d',Tu,lT0), lub sprintf('Wykresy Bodego dla filtrow Butter. rzędu 5 4 3 i Tu=%.2f; lT_0=%d',rzedu,Tu,lT0); 
% ................................... Przykład najprostszy ..............
% [[bf, af, tauhP, MTFd, Fzwc, LpFc]=desMTFcButter(nTypZ,Tud)
% .......................................................................
global ax1 ax2; 
TypyZ=[5 3];
if(nargin<3) rzad=0; end; if(nargin<4) lT0=0; end
if(nargin<5) fig=0; end, bezFf=1; if(fig<0) fig=abs(fig); bezFf=1; end
if(nargin<6) kolB='kbrmgc'; end, lkol=length(kolB); if(lkol<2) kolB='kbrmgc'; lkol=length(kolB); end
if(nargin<6) txtyt=''; end
if(nargin>=5)
    if(length(txtyt)==0)
        txtyt=sprintf('Synteza MTF i Butter rzędu %d',rzad);
    else txtyt=[txtyt sprintf(': Tu_1=%.2f;',Tud(1))]; 
        if(length(Tud)>1) txtyt=[txtyt sprintf(' Tu_2=%.2f; lT_0=%d',Tud(2),lT0)]; else txtyt=[txtyt sprintf(' lT_0=%d',lT0)]; end
    end
end
Lxf=round(lT0/2);
if(rzad>5) rzad=5; end; LpFc(1)=rzad;
if(lT0>0) Om=2*pi*[0:Lxf-1]/lT0; % tablica czestotliwości
    omT=2*pi/Tud(1); %jedn=omT;
    iom1=round((2*pi)/omT); %find(abs(Om/omT-1)<=1.e-2);
else Om=[]; rzad=0; % nie liczymy amplitud;
end
LFd=length(Tud);
tic;
for(nrf=1:LFd)
    Tu=Tud(nrf);
    if(nrf>length(nTypZ)) ntypZ=nTypZ(1); else ntypZ=nTypZ(nrf); end
    nx=find(TypyZ==ntypZ); if(length(nx)==0) ntypZ=TypyZ(1); end
    fname=sprintf('MTFd%d_%d_%d.csv',nrf,ntypZ,round(Tu));
    fp=fopen(fname,'r');
    if(fp>1) fclose(fp); 
        %W=[M lf];  W=[W Fzw']; for(i=1:N1) W=[W F0(:,i)']; end; for(i=1:N2) W=[W Ff(:,i)']; end, 
        dane=csvread(fname); Ff=[]; Fzw=[]; F0=[];
        M=dane(1); lf=dane(2); N1=M-1; N2=N1; ip=2; %N1=dane(3); N2=dane(4); ip=4;
        ip=ip+1; maxFzw=dane(ip); ik=ip+lf; Fzw=dane(ip+1:ik); Fzw=Fzw*maxFzw; ip=ik;
        if(nargout>9 || fig)
            ip=ip+1; maxFf=dane(ip); i0=ip+1; ik=lf+ip; for(i=1:N1) Ff(1:lf,i)=dane(i0:ik); i0=i0+lf; ik=ik+lf; end;  
            Ff=Ff*maxFf; ip=ik-lf;
            F0=Ff(lf:-1:1,N2:-1:1);
        else Ff=[]; F0=[]; 
        end
        %ip=ip+1; maxFf=dane(ip); i0=ip+1; ik=ip+lf; for(i=1:N2) Ff(1:lf,i)=dane(i0:ik); i0=i0+lf; ik=ik+lf; end;  Ff=Ff*maxFf; 
    else
        if(nargout>9 || fig) 
            [M, Fzw, Ff]=MTFdesign(ntypZ, Tu);
            lf=length(Fzw); N2=M-1; N1=N2;
            F0=Ff(lf:-1:1,N2:-1:1);
        else [M, Fzw]=MTFdesign(ntypZ, Tu); F0=[]; Ff=[];
            lf=length(Fzw); N2=M-1; N1=N2;
        end
    end
    N1f=N1+1; nh1=M/Tu;
    MTFd(nrf).ntypZ=ntypZ; MTFd(nrf).Tu=Tu; MTFd(nrf).M=M; MTFd(nrf).F0=F0; MTFd(nrf).Fzw=Fzw;
    MTFd(nrf).Ff=Ff; 
    if(fp<2 && (nargout>9 || fig))
        W=[M lf]; %W=[M lf N1 N2]; 
        maxFzw=max(abs(Fzw)); W=[W maxFzw]; W=[W (Fzw')/maxFzw]; 
        maxFf=max(max(abs(Ff))); W=[W maxFf]; for(i=1:N1) W=[W (Ff(:,i)')/maxFf]; end;
        csvwrite(fname,W); 
    end
    if(nrf==1)
        Fzwd=Fzw; MTud=M; Ffd=Ff; lfd=lf; N2d=M-1; Lzwd=lfd;
        if(LFd==1) Fzwc=Fzwd; Lzwc=lfd; Lzwd=lfd, Ffc=Fd; 
            Ff1=Ffd(:,N2d-N2:N2d); Lfd=lf; tauhp(3)=round(Lzwc/2); LpFc(3)=0, tauhp(4)=0; end, %Ffc=Ff; Ffd=[];
    else Fzwd2=Fzw; MTud2=M; Lzw2=lf; tauF2=round(lf/2);
        if(nargout>12 || fig)
            % ================= Filtr koncowy ==================
            Ff2=Ff(:,N2); Ff1=Ffd(:,N2d-N2:N2d); Nxd=N2+1;
            %n=lfd;
            %w(n-N2:n)=Y(n-lfd+1:n)*Ff1(:,1:Nxd);
            %yz(n)=w(n-N2:n)*Ff2(N2+1:lf,1);
            Ffc=Ff1(:,1:Nxd)*Ff2(N2+1:lf,1); Ff1=Ff1(:,Nxd);
        end
        % ================= Filtr centralny ==================
        fname=sprintf('MTFdc_%d_%d_%d.csv',ntypZ,round(Tud(1)),round(Tud(2)));
        fp=fopen(fname,'r');
        if(fp>1) fclose(fp);
            %W=[Lzwc Lzwd Lzw2 N2d+N2 N2d N2 maxFzwc Fzwc/maxFzwc];
            dane=csvread(fname); Fzwc=[]; 
            Lzwc=dane(1);  Lzwd=dane(2);  Lzw2=dane(3); tauhP=dane(4); N2d=dane(5);  N2=dane(6); ip=6;
            ip=ip+1; maxFzwc=dane(ip); ik=ip+Lzwc; Fzwc=dane(ip+1:ik)'; Fzwc=Fzwc*maxFzwc; ip=ik;
        else
            Lzwc=lf+lfd-1; Fzwc=zeros(Lzwc,1); %Fzwc1=zeros(Lzwc,1);
            for(m=1:Lzwc) % obliczamy filtr Fzwc
                %for(k=1:lf) W=[zeros(k-1,1);Fzwd;zeros(lf-k,1)]; Fzwc1(m)=Fzwc1(m)+W(m)*Fzw(k); end
                for(k=1:lf)
                    j=m-k+1; if(j<1) break; end, if(j>lfd) continue; end,
                    Fzwc(m)=Fzwc(m)+Fzwd(j)*Fzw(k);
                end
            end
            fname=sprintf('MTFdc_%d_%d_%d.csv',ntypZ,round(Tud(1)),round(Tud(2)));
            fp=fopen(fname,'r');
            maxFzwc=max(abs(Fzwc)); W=[Lzwc Lzwd Lzw2 N2d+N2 N2d N2 maxFzwc Fzwc'/maxFzwc];
            csvwrite(fname,W); 
            %nx=[]; %find(abs(Fzwc1-Fzwc)>1.e-8);
            %if(length(nx)==0) Fzwc1=[]; W=[]; w=[]; w1=[]; end, % To znaczy, że jest OK !!
        end
    end
end
tim=toc; fprintf(1,'\nCzas syntezy MTFc: %.g sek.\n',tim);
LpFc(2)=Lzwc; LpFc(3)=Lzwd; LpFc(4)=Lzw2;
tauhP(2)=-(N2d+N2); tauhP(3)=-N2d; tauhP(4)=-N2;
jestButter=0; %lw=length(Om); 
nfpocz=5;
if(length(Fzwd(1,:))>1) Fzwd=Fzwd'; end 
if(length(Fzwd2(1,:))>1) Fzwd2=Fzwd2'; end 
if(length(Fzwc(1,:))>1) Fzwc=Fzwc'; end 
if(lT0==0)
    bf=1; af=1; Amp(1:4,1)=1; fi(1:4,1)=1; WcB=0;
    nA01(1:5)=1000; tauhP(1)=0.2161*tauhP(2); return; end
%if(rzad>0 && nargout<12)
MTF=Fzwc'; lw=round(length(Om)/4); 
for(nf=2:2*LFd)
    if(length(MTF(:,1))>1) MTF=MTF'; end
    A=abs(fft([MTF zeros(1,lT0-length(MTF))])); A=A(1:lw); %Lxf);
    nx=find(A<=1/sqrt(2)); if(~isempty(nx)) nhP(nf)=nx(1); nx=[]; else nhP(nf)=lw; end
    nx=find(A(nhP(nf):lw)<=0.01); if(~isempty(nx)) nA01(nf)=nx(1)+nhP(nf)-1; nx=[]; else nA01(nf)=lw; end
    iA01=nA01(nf); Amp(nf,:)=A;
    if(nf==2) MTF=Fzwd'; else if(nf==3) MTF=Fzwd2'; end; end
end
WcB=nhP(2)/Lxf; %Tud(1)*200); 
 if(rzad>0)
    [bf,af]=butter(rzad,WcB); jestButter=1;
    nf=1; ihP=0; nA01(nf)=lw;
    [AmpF, Phase]=bode(tf(bf,af,1),Om); % Phase w stopniach
    for(i=1:lw)
        fi(nf,i)=(Phase(1,1,i)-Phase(1,1,1))*pi/180;
        Amp(nf,i)=AmpF(1,1,i);
        if(Amp(nf,i)>=Amp(nf,1)/sqrt(2)) nhP(nf)=i; ihP=i; end,
        if(Amp(nf,i)>=0.01) nA01(nf)=i; end,
    end
    tauF(1)=0; tauF(2:lw)=fi(nf,2:lw)./Om(2:lw);
    tauhP(nf)=mean(tauF(2:ihP)); tauA01(nf)=mean(tauF(2:iA01)); tauTu(nf)=mean(tauF(2:iom1(1)));
    tauhP(nf)=round((tauhP(nf)+tauTu(nf))/2); tauA01=round(tauA01(nf)); tauTu=round(tauTu(nf)); 
else bf=1; af=1; tauhP(1)=0; Amp(1)=1; fi(1)=1;  WcB=0; 
end
if(nargout<12 && fig<=0) return; end
if(LFd==2) Lfo=1+LFd+2*LFd; nrPlot=[1 2 3 4 5 6 7]; else Lfo=3; nrPlot=[1 2 3]; end % Butter+ Fzc Ffc + 2*Fzd+2*Ffd
MTF=Fzwc; LpFc(2)=Lzwc; Lo=0;
%if(rzad==0) dnfp=1; Lfo=Lfo-1; else dnf=0; end
%args: 1  2     3      4     5    6      7     8     9   10    11    12  13    14   15     
%    [bf, af, tauhP, MTFd, Fzwc, Fzwd, Fzwd2, LpFc, Amp, fi,  nA01, WcB, Ffc, Ff1, Ff2]
for(nf=nfpocz:Lfo)
    switch(nf)
        %case 2, To jest domyślne dla Fzwc if(nargout>7) MTF=MTF1; else break; end,
        case 3, if(nargout>5 || fig) MTF=Fzwd;  LpFc(nf)=Lzwd; else Lfo=nf-1; break; end,
        case 4, if(nargout>6 || fig) MTF=Fzwd2; LpFc(nf)=Lzw2; else Lfo=nf-1; break; end,
        case 5, if(nargout>12 || fig) MTF=Ffc;  LpFc(nf)=Lzw2; else Lfo=nf-1; break; end,
        case 6, if(nargout>13 || fig) MTF=Ff1;  LpFc(nf)=Lzw2; else Lfo=nf-1; break; end,
        case 7, if(nargout>14 || fig) MTF=Ff2;  LpFc(nf)=Lzw2; else Lfo=nf-1; break; end,
    end
    [lFc lF2]=size(MTF);
    if(lFc==0) nrPlot(nf)=0; continue; end
    Lo=Lo+1; 
    if(lF2==1) MTF=MTF'; lFc=length(MTF); end, % Bode wymaga wierszowej tablicy
    bMTF=MTF(lFc:-1:1); aMTF=1; 
    [AmpF, Phase]=bode(tf(bMTF,aMTF,1),Om); % Phase w stopniach
    ihP=0; lw=round(Tud(1)*200);  lw=round(length(Om)/4);
    for(i=1:lw)
        fi(nf,i)=-(Phase(1,1,i)-Phase(1,1,1))*pi/180;
        Amp(nf,i)=AmpF(1,1,i);
        if(Amp(nf,i)>=Amp(nf,1)/sqrt(2)) nhP(nf)=i; ihP=i; end,
        if(Amp(nf,i)>=0.01) nA01(nf)=i; iA01=i; end,
    end
    tauF(1)=0; tauF(2:lw)=fi(nf,2:lw)./Om(2:lw);
    tauhP(nf)=round(mean(tauF(2:ihP))); tauA01(nf)=round(mean(tauF(2:iA01))); tauTu(nf)=round(mean(tauF(2:iom1(1))));
end

%Lxf=round(lT0/2);
% nhP to indeks odpowiadający tzw. cut-off frequency, tj polowkowemu tlumieniu amplitudy.
% Typowo zadaje sie wspolczynnik odcięcia widma (cut-off frequency) Wc,
%        Wc=nhP*2/lT0, gdzie 2/lT0 to czestość Nyquista 2*pi/(2*Dt), Dt=1/lT0
% Zatem: nhP=Wc*lT0/2;
if(rzad>0 && jestButter==0) 
    WcB=nhP(2)/Lxf; 
    [bf,af]=butter(rzad,WcB);
    nf=1;
    [AmpF, Phase]=bode(tf(bf,af,1),Om); % Phase w stopniach
    for(i=1:lw)
        fi(nf,i)=(Phase(1,1,i)-Phase(1,1,1))*pi/180;
        Amp(nf,i)=AmpF(1,1,i);
        if(Amp(nf,i)>=Amp(nf,1)/sqrt(2)) nhP(nf)=i; ihP=i; end,
        if(Amp(nf,i)>=0.01) nA01(nf)=i; iA01=i; end,
    end
    tauF(1)=0; tauF(2:lw)=fi(nf,2:lw)./Om(2:lw);
    tauhP(nf)=mean(tauF(2:ihP)); tauA01(nf)=mean(tauF(2:iA01)); tauTu(nf)=mean(tauF(2:iom1(1)));
    tauhP(nf)=round((tauhP(nf)+tauTu(nf))/2); tauA01=round(tauA01); tauTu=round(tauTu); 
end
if(fig)
    figure(fig);
    txtau='\tau'; nf=1; 
    txxl=sprintf('\nOpozn.srednie: Butt^%d',rzad);
    txxl=[txxl sprintf(': %s_{hP}=%d %s_{Tu}=%d %s_{A01}=%d',...
            txtau,-tauhP(nf),txtau,-tauTu(nf),txtau,-tauA01(nf))];
    wTuf=Tud(1)/(lT0);lA=nA01(1); x=wTuf*[0:lA-1]; 
    if(rzad==0) nff1=2; else nff1=1; end
    for(nff=nff1:Lfo)
        nf=nrPlot(nff); if(nf==0) continue; end
        % ...... Dokladna prezentacja filtru dolnego MTF:
        if(nf<=lkol) kol=kolB(nf); else dk=nf-lkol; kol=[kolB(lkol-dk) '--']; end
        subplot(2,1,1);
        %if(nf==4 && bezFf) axis('tight'); ax1(2,:)=axis; end
        plot(x,Amp(nf,1:lA),kol); hold on;
        if(nf==4) axis('tight'); ax1(1,:)=axis; end
        if(nf==Lfo && Lfo>4) axis('tight'); ax1(2,:)=axis; end
        subplot(2,1,2);
        if(nf<nfpocz) fi(1)=0; fi(nf,2:lw)=tauhP(nf).*Om(2:lw); end
        plot(x,fi(nf,1:lA),kol); hold on;  
        if(nf==Lfo && Lfo>4) axis('tight'); ax2(2,:)=axis; end
        if(nff==1) axis('tight'); ax2(1,:)=axis; end
    end
    %=round(2*pi/omT); %find(abs(Om/omT-1)<=1/Lxf); om1=om1(1);
    for(nff=nff1:Lfo)
        nf=nrPlot(nff); if(nf==0) continue; end
        if(nf<=lkol) kol=kolB(nf); else dk=nf-lkol; kol=[kolB(lkol-dk) '--']; end
        subplot(2,1,1); %hold on;
        if(nff<3)
            axis('tight'); ax=axis; 
            plot([nhP(nf) nhP(nf)]*wTuf,ax(3:4),['r--'],[1 1],ax(3:4),['g-.'],nhP(nf)*wTuf,1/sqrt(2),[kol(1) '*']); axis('tight');%Amp(nf,nhP(nf)),[kol '*']); axis('tight');
        	x1(1,:)=ax;
            %hold off;
        end
        subplot(2,1,2);
        axis('tight'); ax=axis; 
        xhP=nhP(nf)*wTuf; iA01=nA01(nf);
        if(nff<3)
            plot([xhP xhP],ax(3:4),[kol(1) '--'],[1 1],ax(3:4),['g-.']);
            if(nf==1)
                plot([0 xhP],[0 fi(nf,ihP)],[kol '.:'],Om(1:iA01)/omT,tauhP(nf)*Om(1:iA01),[kol(1) '--']);
                plot([0 1],[0 fi(nf,iom1)],'r.:',Om(1:iA01)/omT,tauTu(nf)*Om(1:iA01),'r--');        
                %hold off;
            end
        end
        if(nf>1)
                if(nf==3 || nf==8) txxl=[txxl sprintf('\nOpozn.:')]; else txxl=[txxl sprintf('; ')]; end
            switch(nff) case 2, tx='Fzwc'; case 3, tx='Ffc'; case 4, tx='Fzwd'; case 5, tx='Fzwd2'; case 6, tx='Ff1'; case 7, tx='Ff2'; end
                txxl=[txxl sprintf('%s: %s_{hP}=%d',tx,txtau,-tauhP(nf))]; %...
            %nf-1,txtau,tauhP(nf)); %,txtau,tauTu(nf),txtau,tauA01(nf))];
        end
    end
    subplot(2,1,1); title(txtyt); hold off; axis('tight'); %ax=axis; ax1(1,:)=ax;
    if(Lfo>4 && length(ax1(:,1))==2) 
        txfig=sprintf('figure(%d); ',abs(fig));
        axis(ax1(2,:)); fprintf(1,'\nMożna przewymiarować: %ssubplot(2,1,1); axis(ax1(1,:)); subplot(2,1,2); axis(ax2(1,:));\n',txfig); 
    end
    %end
    xlabel(sprintf('Czestosc wzfledna f/f_{Tu}: punkt * to A(f_{hp}/f_{Tu})=2^{-1/2}; czest f/f_{Tu}=1 dla Tu')); ylabel('Amplituda');
    subplot(2,1,2); ylabel('Faza [rad]'); xlabel(txxl); hold off; axis('tight'); %ax=axis; ax2(1,:)=ax;
    if(length(ax2(:,1))==2) axis(ax2(2,:)); end
end        
