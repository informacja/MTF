clear all;  
tStart = tic; 
global ax1 ax2;% szerIndex;
Takcji = 5000; %5*392;
Symul = 0; wgEnerg = 2; Integr = 1; BigData = 0; BSS = 0;  % sourse of data (from DB or one file
% Integr=0 sygna³ pomiarowy bez zsumowania (orygin.); Integr=1 sygna³ pomiarowy zsumowany; 
% wgEnerg=0 synal przetw. wg Integr jest filtrowany i liczony tylko raz; 
% wgEnerg>0 synal przetw. wg Integr jest filtrowany, a potem liczymy Y^2 (liczony dwa razy) 
if(Integr) tauf=40; else tauf=200; end
nowy=1; 
if(Symul)
    Lszer=3; Ldsz=2*4096; ldC=Ldsz; SZEREGI=randn(Ldsz,Lszer); bezLpred=0; 
    Ld0=Takcji/10; Ldf=Ldsz-Ld0; sLd=Ldf/6; x=([1:Ldf])/sLd; f=(x.^2).*exp(-((x-1).^2)/2);f=2*(f-(f(end)-f(1))/(length(x))*x*sLd);
    for(i=1:Lszer) SZEREGI(Ld0+1:Ldsz,i)=SZEREGI(Ld0+1:Ldsz,i)+f'; end
    %xf=[[1:Ld0]/sLd x]; figure(1); plot(xf,SZEREGI(:,1),'c',Ld0/sLd+x,f,'k'); axis('tight')
    nrwykr=1:Lszer; %[1:Ldsz];
    tx=sprintf('Badany sygnal SYMULOWANY Ysyg(%d)',Ldsz);
else
     wczytajEMG;
    [Ldsz Lszer] = size(data); ldC = Ldsz;
    SZEREGI = data;
    bezLpred=0; 
    Ld0=Takcji/10; Ldf=Ldsz-Ld0; sLd=Ldf/6; x=([1:Ldf])/sLd; f=(x.^2).*exp(-((x-1).^2)/2);f=2*(f-(f(end)-f(1))/(length(x))*x*sLd);
    %or(i=1:Lszer) SZEREGI(Ld0+1:Ldsz,i)=SZEREGI(Ld0+1:Ldsz,i)+f'; end
    nrwykr=1:Lszer; %[1:Ldsz];
    alfa=1-1/tauf; %0; %400; %200; 
end
Lk=0; nfig0=2; 
% ====== Parametry MTF ===============
% Tu okres skÅ‚adowej cyklicznej - szerokoÅ›Ä‡ pasma filtru MTF
% Takcji - liczba prÃ³bek w jednej akcji 
LFg=2; LFd=2;
Tud=Takcji/(12); Tud=Takcji/(13); %Tud=Takcji/(10);
Tud1=Tud/1.2; %tuœredniania trendu
TuG=Tud*[1/2 1/3 1/10]; TuG=Tud*[1/10 1/12 1/10]; TuG=Tud*[1/5 1/6 1/10]; TuG=Tud*[1/4 1/5 1/10]; %13.5]; % LFg=2 bÄ™dÄ… dwa filtry Tug
TR=Tud;% Truchu=Takcji/12;
% ................ #Wybor typu filtru .......................
typMTF=[5 5 5 3]; %[3 3 5 3]; % typ filtru: 3 - Z1 - filtr koncowy zwykly; 5 - z3 - trend 3.go rzÄ™du 
typFf=1; % - typ filtru konc.: 0 nowy, 1 zwykly
% =============== Parametry szergu i filtra ==============
LSzeregow=length(nrwykr); % liczba badanych szeregÃ³w
%close all, 
Lk = 0; Losob=Lszer/8; Lgestow=round(LSzeregow/Losob);  %Losob = size(SZEREGI,2)/8; Lgestow = LSzeregow/8;  %LC = LSzeregow;Lgestow = round(LC / 2); Losob = 2;
nfig = nfig0; nFig = nfig0 + 1 + Lgestow; trendTab = []
% ----------- Okreœlenie zakresu lT analizy widm (tak aby dobrze spróbkowaæ widmo)
lTx=Tud*200; lTx=Tud*500; %1000;
nTx=ceil(lTx/4096); lT=nTx*4096; %500; %350; %75; %round(lA/10);
Ewykl=2; 

if(0) % spectrogram
    Nwin = 512; kaiser(128,18);
    fpr = 2048;
    Nfft = fpr/2;
    k    = 16;
    for( person = 1:size(SZEREGI,2)/8 )
        f=figure(19+person); 
        for (ch = 1:8)
            subplot(4,2,ch); spectrogram(SZEREGI(:,ch*person), kaiser(Nwin,k), Nwin - k, Nfft, fpr, 'yaxis');
        end
        set(f,'WindowState','maximized'); sgtitle(fnames(person));
        figPW('kaiser',person,'png','figury/win/');
    end
end % spectrogram

% ============ Synteza filtrów dolnoprzepustowych MTFd i Butter5 ===================
%  Wywo³anie desMTFcButter() z parametrem figF=0 daje wynik bez wykresow charakterystyk Bodego 
%ntypZ=typMTF(nrVar);  % ===== Typ filtru ============= 2 klasyczny, 3 trend lin.; 5 trend 3.rzÄ™du
% -------------- Synteza filtru dolnoprzepustowego ----------
ntypZ=typMTF(1); rzadB=5; 
Ffzwykly=1; % =1 filtr koncowy bez modyfikacji, =0 filtr koncowy skompresowany i dopeln.Regresja
tic;
if(0) % Liczenie z rysowaniem wszystkich charakterystyk
    [bfBd, afBd, tauhPfd, MTFd, Fzwc, LpFc, Amp, nA01, WcB, Fzwd, Fzwd2, fi,  Ffc, Ff1, Ff2]=...
        desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT,figF,'Synteza filtrow MTF (Fzws_b Fzwd_r Fzw2_m Ffc_g Ff1_c Ff2_{c--}) i Butter_k','kbrmgc');
else % Tylko synteza filtrow Fzwc i Butter (szybka wersja)
    nA01=0;
    [bfBd, afBd, tauhPfd, MTFd, Fzwc, LpFc, Amp, nA01, WcB, Fzwd, Fzwd2]=desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT);
    %[bfB, afB, tauhPf, MTFd, Fzwc, LpFc, Amp, nA01, WcB, Fzwd, Fzwd2]=desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT);
end
ihP(1)=WcB*lT/2; 
if(length(nA01)>1)  iA01(1)=nA01(2); AmpB(1,:)=Amp(1,:);  Ampd(1,:)=Amp(2,:); end; 
% -------------- Synteza filtrów dla energii ----------------
if(0) % Liczenie z rysowaniem wszystkich charakterystyk
    figF=2;
    [bfBE, afBE, tauhPfE, MTFE, FzwcE, LpFcE, Amp, nA01E, WcB, FzwdE, Fzwd2E, fi,  Ffc, Ff1, Ff2]=...
        desMTFcButter(ntypZ,[Tud Tud1]/Ewykl,rzadB,lT,figF,'Synteza filtrow MTF (Fzws_b Fzwd_r Fzw2_m Ffc_g Ff1_c Ff2_{c--}) i Butter_k','kbrmgc');
else % Tylko synteza filtrow Fzwc i Butter (szybka wersja)
    [bfBE, afBE, tauhPfE, MTFE, FzwcE, LpFcE, Amp, nA01E, WcB, FzwdE, Fzwd2E]=desMTFcButter(ntypZ,[Tud Tud1]/Ewykl,rzadB,lT);
end
ihP(2)=WcB*lT/2; 
if(length(nA01E)>1)  iA01(2)=nA01E(2); AmpB(2,:)=Amp(1,:); Ampd(2,:)=Amp(2,:); end; 
MTud=MTFd(1).M; 
% ............. Koniec syntezy filtrów dolnoprzepustowych MTFd i Butter5 ............
% ============= Synteza filtrów górnoprzepustowych % ========================   
%[bfx, afx, tauhPfEg, MTFEg, FzwcEg, FzwgE, Fzwg2E, LpFcEg, Amg, nA01g, WcBg]=desMTFcButter(ntypZ,[Tud Tud1]/Ewykl); %,0,lT);
[bfEg, afEg, tauhPfEg, MTFEg, FzwcEg, LpFcEg, Amp, nA01Eg,WcEg, FzwgE, Fzwg2E]=desMTFcButter(ntypZ,TuG(1:2)/Ewykl,rzadB,lT);
ihP(4)=WcEg*lT/2; 
if(length(nA01Eg)>1)  iA01(4)=nA01Eg(2); AmpB(4,:)=Amp(1,:); Ampd(4,:)=Amp(2,:); end; %wPol=2*ihP(2)/lT;
[bfg, afg, tauhPfg, MTFg, Fzwcg, LpFcg, Amp, nA01g, Wcg, Fzwg, Fzwg2]=desMTFcButter(ntypZ,TuG(1:2),rzadB,lT);
ihP(3)=Wcg*lT/2; 
if(length(nA01g)>1)  iA01(3)=nA01g(2); AmpB(3,:)=Amp(1,:);  Ampd(3,:)=Amp(2,:); end, 
% ======= Koniec syntezy - podstawiamy wyniki ==================
nA01=max(iA01); lwAm=nA01; Amp=AmpB(1:4,1:lwAm); AmpB=Amp; Amp=[]; Amp=Ampd(1:4,1:lwAm); Ampd=Amp; Amp=[];  
afB(1,:)=afBd;  bfB(1,:)=bfBd; 
Lzwc=LpFc(2); Lzwd=LpFc(3); Lzw2=LpFc(4); % d³ugoœci filtrów Fzwc, Fzwd i Fzw2
tauhP(1)=-tauhPfd(1); wPol=2*ihP(1)/lT;
% .................................................................
afB(2,:)=afBE; bfB(2,:)=bfBE;
LzwcE=LpFcE(2); LzwdE=LpFcE(3); Lzw2E=LpFcE(4); 
tauhP(2)=-tauhPfE(1); %ihPB(2)=-tauhPfE(1);% ihP(2)=-tauhPfE(2);
% .................................................................
afB(3,:)=afg; bfB(3,:)=bfg;
Lzwcg=LpFcg(2); Lzwdg=LpFcg(3); Lzw2g=LpFcg(4); 
tauhP(3)=-tauhPfg(1); %ihPB(3)=-tauhPfg(1); ihP(3)=-tauhPfg(2);
% .................................................................
afB(4,:)=afEg; bfB(4,:)=bfEg;
LzwcEg=LpFcEg(2); LzwdEg=LpFcEg(3); Lzw2Eg=LpFcEg(4); 
tauhP(4)=-tauhPfEg(1); %ihPB(4)=-tauhPfEg(1); ihP(4)=-tauhPfEg(2);
if(length(nA01Eg)>1)  iA01(4)=nA01Eg(2); end, %AmpB(2,:)=Amp(1,:); end; 
% ================= Synteza filtru wyg³adazaj¹cego MTF ============
lfA=lT/MTud; Tu=Tud/5; lfA=lT/Tud;
Tu=Tud/MTud*lfA; % PrzedziaÅ‚ wygÅ‚adzania widma
for(nfw=1:2)
    [M, Fzw]=MTFdesign(ntypZ, Tu); %[M, Fzw, Ff, F0]=MTFdesign(ntypZ, Tu);
    MTF(nfw).Tu=Tu; MTF(nfw).M=M; MTF(nfw).Fzw=Fzw; MTF(nfw).F0=[]; MTF(nfw).Ff=[];
    Tu=6;
end
[M, Fzwg0]=MTFdesign(ntypZ, TuG(3)); 
fprintf(1,'\nCzas syntezy %.4f sek.',toc);
% ========================================================
%close all;
druktx=sprintf('\nLk=%3d. Nr ostatniej probki szeregu ldC=Nmax=%d',Lk+1,ldC);
Nmax=length(SZEREGI(:,1));
fprintf(1,'%s: ',druktx); fprintf(1,'\nTu_d=%d Tu_g=%d %d Nmax=%d',round(Tud),round(TuG(1)),round(TuG(LFg)),Nmax);
if(wgEnerg>0) LwgE=1; lcol=4; else LwgE=0; lcol=2; end 
Kolor='kbrmgc'; figX = 0.00; figY = -0.00; Xkonc = 0.80; Ykonc = 0.8;
for(nrs=1:Lgestow)  %2:2) % Petla po szeregach
    nowy=1; tKanal=tic;
    nfig=nfig+1;
    if(0)
        figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
        nrfig = figure(nfig);  movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
    else
        figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
        nrfig = figure(nfig);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
        fig=gcf; set(fig,'Units','normalized','Position',[figX figY Xkonc Xkonc]);figX = figX+0.01; figY = figY-0.01;
        nrFig = figure(nFig);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
        Fig=gcf; set(Fig,'Units','normalized','Position',[Lgestow*0.01 -Lgestow*0.01 Xkonc Xkonc]);
    end
    nOs1=1; dno=1; nOsf=Losob;
    for(nosoby=nOs1:dno:nOsf)
        txtyt=[]; %tic;
        nrS=(nosoby-1)*Lgestow+nrwykr(nrs); 
        nrPliku=1; nrKol=nrs;
        if(exist('nazwy')) nplik=nazwy(nrS,:); else nplik=sprintf('Series%d',nrS); end
        txg=sprintf('SZEREG(1:%d,%d) z pliku %s',Ldsz,nrS,fnames(nosoby));
        for(wgEn=0:LwgE)
            nCol=8*(wgEn)+nrs;
            Yorsum=SZEREGI(:,nrS); 
            if(Integr) 
                txY='Sygnal zsumowany'; 
                Yorsum(1)=Yorsum(2); for(n=2:Ldsz) Yorsum(n)=Yorsum(n-1)+Yorsum(n); end
            else txY='Sygnal oryginay'; 
            end
            Yoryg=Yorsum;
            if(wgEn==0)
                y0=Yoryg(1); for(n=1:Ldsz) Yoryg(n)=y0*alfa+Yoryg(n); y0=Yoryg(n); end
                txspac='                                     '; 
                tx=sprintf('Sygnal SKUMULOWANY Y(n)=Y(n-1)*alfa+Sygn(n), alfa=%.4f',alfa);
            else if(wgEn>0) 
                    if(wgEnerg>1) y0=Yoryg(1); for(n=1:Ldsz) Yoryg(n)=y0*alfa+Yoryg(n); y0=Yoryg(n); end, end
                    meanYoryg=mean(Yoryg); 
                    Yoryg=sign(Yoryg-meanYoryg).*(Yoryg-meanYoryg).^Ewykl;
                    tx=sprintf('Sygnal ENERGII Y=Sygn^%d',Ewykl); txspac=''; 
                end
            end
            % ----------------------------------------------------------------------------------  
            filtracja
            Nx=Nakt;
            ncol=wgEn*2+1;
            if(wgEn==0 && nosoby==nOs1)
                figure(nfig); 
                subplot(4,4,1); %subplot(4,lcol,ncol);
                plot(1:Ldsz,SZEREGI(:,nrS),'k'); axis('tight'); ax=axis; hold on;
                plot([nY1Tr nY1Tr],ax(3:4),'r--',[nYfTr nYfTr],ax(3:4),'r--',[nY1 nY1],ax(3:4),'g--',[nYf nYf],ax(3:4),'g--'), 
                title(txg); xlabel(sprintf('Sygnal zmierzony 1:%d',Ldsz));
                hold off;
                subplot(4,4,2); %subplot(4,lcol,ncol);
                plot(1:Ldsz,Yorsum,'k'); axis('tight'); ax=axis; hold on;
                plot([nY1Tr nY1Tr],ax(3:4),'r--',[nYfTr nYfTr],ax(3:4),'r--',[nY1 nY1],ax(3:4),'g--',[nYf nYf],ax(3:4),'g--'), 
                hold off;
                xlabel(sprintf('%s(1:%d)',txY,Ldsz));
            end
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,lcol,lcol+ncol); 
                %plot([nY1Tr:nYfTr],Yoryg(nY1Tr:nYfTr),'k',[nY1Tr:nYfTr],yTr,'g'), axis('tight'); 
                plot([1:Nf],Yoryg,'k',[1:Nf],yTrf,'r'), axis('tight'); 
                ax=axis; hold on;
                plot([nY1 nY1],ax(3:4),'g--',[nYf nYf],ax(3:4),'g--',[nY1Tr nY1Tr],ax(3:4),'r--',[nYfTr nYfTr],ax(3:4),'r--');
                txOs=sprintf('Osoba %d ',nosoby);
                title([txspac txOs tx]); hold off
                xlabel(sprintf('Trend(g) i Yoryg(%d:%d)(k)',nY1Tr,nYfTr));
            end
            if(wgEn)
                yxTr=sign(yTr).*(abs(yTr).^(1/Ewykl))+meanYoryg; yxTrf=sign(yTrf).*(abs(yTrf).^(1/Ewykl))+meanYoryg;
            else yxTr=yTr; yxTrf=yTrf;
            end
            figure(nFig); subplot(4,lcol,nCol); kol=Kolor(nosoby);
            if(nosoby==nOs1) SrYtr(wgEn+1)=mean(yxTr); SigyTr(wgEn+1)=std(yxTr); end
            sygnTr=(yxTr-mean(yxTr))/SigyTr(wgEn+1)+SrYtr(wgEn+1); 
            sygnTrf=(yxTrf-mean(yxTrf))/SigyTr(wgEn+1)+SrYtr(wgEn+1);
            for(nF=1:2)
                if(nowy==0) hold on; end, 
                plot([nY1Tr:nYfTr],sygnTr,kol), axis('tight'); hold on; ax=axis;
                %plot([1:nY1-npC],sygnTrf(1:nY1-npC),'r',[nYf+N2+1:Nf],sygnTrf(nYf+N2+1:Nf),'r');
                if(nowy) 
                    plot([nY1 nY1],ax(3:4),'g--',[nYf nYf],ax(3:4),'g--',[nY1Tr nY1Tr],ax(3:4),'r--',[nYfTr nYfTr],ax(3:4),'r--');
                    xlabel(sprintf('Kanal %d: yTr(%d:%d)',nrwykr(nrs),nY1Tr,nYfTr)); 
                    if(nF==1 && nrs==2) title([tx '  ' txg]); end
                end
                hold off;
                if(nF==1) 
                    if(nosoby~=nOs1) break; end
                    figure(nfig); subplot(4,lcol,2*lcol+ncol); 
                end
            end
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,lcol,3*lcol+ncol); 
                if(nowy) hold off; end,
                if(wgEn) yxf=sign(yf).*(abs(yf).^(1/Ewykl)); else yxf=yf; end 
                plot([nY1-npC+1:nYf+N2],yxf,kol);
                axis('tight'); ax=axis; axis([1 Nf ax(3:4)]); hold on; %plot([N1 N1],ax(3:4),'r--',[Nakt-N2 Nakt-N2],ax(3:4),'r--'); hold off;
                plot([nY1 nY1],ax(3:4),'g--',[nYf nYf],ax(3:4),'g--',[nY1Tr nY1Tr],ax(3:4),'r--',[nYfTr nYfTr],ax(3:4),'r--'); 
                %hold off;
                xlabel(sprintf('Skladowa srodkowoczest. yf(%d:%d)',nY1-npC+1,nYf+N2));
            end
            % ============== Liczymy widmo w segmencie centralnym ====================================
            wAx=1;
            wY=[yf(npC:NfC)]; lw=length(wY); EnYf=mean(yf(npC:NfC).^2);
            wY=[wY zeros(1,lT-lw)]; % Uwaga !!! dopisanie zer nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci !!
            Ay=abs(fft(wY)); %A=abs(fft(Fzw'));
            EnAy=(mean(Ay.^2));
            %lT=length(wY); 
            lA=round(lT/2); Ayf=Ay(1:lA); %/lT; %lA=lA-1;
            % ---------- WygÅ‚adzanie widm filtra Fzw i sygnaÅ‚u Yoryg ----------------------
            % Ayf widmo obliczone sygna³u srednioczêstotliwoœc. yf - po filtracji Afc
            % ================ Filtry dla widma amplit. ===============
            ntypZ=typMTF(1); %Taki sam typ jak dla filtra dolnego Tud;
            lYo=length(Yoryg(nY1:nYf)); EnY=mean(Yoryg(nY1:nYf).*Yoryg(nY1:nYf));
            % Uwaga !!! dopisanie dowolnej liczby zer nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci !!
            bezTrendu=2; jestAyo2=0;
            %if(wgEn) fx=sign(Yoryg).*(abs(Yoryg).^(1/Ewykl))+meanYoryg; else fx=Yoryg; end
            if(bezTrendu)
                jestAyo2=1; Lfw=2;
                AYreszt=abs(fft([(Yoryg(nY1Tr:nYfTr)'-yTr) zeros(1,lT-length(Yoryg(nY1Tr:nYfTr)))]));
                AYor=abs(fft([Yoryg(nY1:nYf)' zeros(1,lT-length(Yoryg(nY1:nYf)))]));
                if(bezTrendu>1) fx=yTr; else fx=yTr(nY1:nYf); end,
                ATr=abs(fft([fx zeros(1,lT-length(fx))]));
            else  Lfw=1; AYor=abs(fft([fx(nY1:nYf)' zeros(1,lT-length(fx(nY1:nYf)))]));
            end % AYor obliczone widmo reszt trendu
            % ================== Pobranie filtru wyg³adzaj¹cego ============
            Nakt=length(Ayf); N1=MTF(1).M-1; N2=N1; Fzw=MTF(1).Fzw; lf=length(Fzw); 
            if(jestAyo2) Yo2=[AYor(N1:-1:2).^2 0 0 AYor(2:end).^2]; else Yo2=[AYor(N1:-1:2) 0 0 AYor(2:end)]; end,
            Y=[Ayf(N1:-1:1) Ayf]; Ll=1; N=length(Y);
            Y2=Y.^2; 
            NfC=Nakt-N2; % koniec segmentu centralnego
            for(nfw=1:Lfw)
                M=MTF(nfw).M; N1=M-1; N2=N1; Fzw=MTF(nfw).Fzw; lf=length(Fzw); 
                Lf=M-1; NfCx=Nakt-N2;
                % ---------- Filtracja w segmencie startowym jest pominieta --------------------------------------
                n0Fzw=0; npC=1; %PnpC=N1+1; %Lf+1; %=M poczatek segmentu centralnego
                for(n=npC:lwAm-N2) %Nakt-N2)
                    n1Fzw=n0Fzw+1;
                    if(nfw==1) Af(n)=Y(n1Fzw:n0Fzw+lf)*Fzw; Af2(n)=Y2(n1Fzw:n0Fzw+lf)*Fzw; end
                    AYo(n)=Yo2(n1Fzw:n0Fzw+lf)*Fzw;
                    n0Fzw=n1Fzw;
                end;
                % Af wyg³adzone widmo Ayf; Af2 wyg³adzone widmo Ayf^2; Ayo wyg³adzone widmo
                % AYor obliczone widmo reszt trendu; % AYo wygladzone widmo Ayor reszt trendu
                % ----- Teraz ruchoma sekcja koncowa -------------------------
                n0Fzw=n0Fzw-1; % wracamy do wartosci koncowej, bo to filtry koncowe
                n1Fzw=n0Fzw+1; ldFzw=lf;
                % --------- Sekcja koncowa jest zbêdna -----------------
                if(nfw==1) nx=find(Af2<0); Af2(nx)=0; Afm=sqrt(Af2); end, 
                nx=find(AYo<0); AYo(nx)=0;
                if(jestAyo2) AYo=sqrt(AYo); end, %if(nfw==1) AYo(1)=AYor(1); else AYo(1)=ATr(1); end
                % ------------------ drugi filtr wygÅ‚adzajÄ…cy -----
                if(nfw==1) AYo(1)=AYor(1); AYog=AYo; else AYo(1)=ATr(1); AYoTr=AYo; end
                AYo=[];
                % Af wyg³adzone widmo Ayf; Af2 wyg³adzone widmo Ayf^2;
                % AYor obliczone widmo reszt trendu; AYog wyg³adzone widmo AYor
                % ATr obliczone widmo trendu; AYoTr wygladzone widmo ATr trendu
                Tu=6; %Tud/20; % MTud*lfA; % PrzedziaÅ‚ wygÅ‚adzania widma trendu
                if(bezTrendu)
                    jestAyo2=0; Lfw=2;
                    if(jestAyo2) Yo2=[ATr(N1:-1:1).^2 ATr.^2]; else Yo2=[ATr(N1:-1:1) ATr]; end,
                    N=length(Yo2);
                    %AYor=abs(fft([(Yoryg(nY1:nYf)'-yTr(nY1:nYf)) zeros(1,lT-lYo)]));
                    %if(bezTrendu>1) fx=yTr; else fx=yTr(nY1:nYf); end,  ATr=abs(fft([fx zeros(1,lT-length(fx))]));
                else break; % Lfw=1; AYor=abs(fft([Yoryg(nY1:nYf)' zeros(1,lT-lYo)]));
                end
            end
            AYo=AYog; %AYog=[];
            %Tu=Tud/MTud*lfA; % Ponownie przedziaÅ‚ wygÅ‚adzania widma reszt trendu
            % Widma amplitudowe filtrÃ³w
            if(nrs==1)
                Afd=abs(fft([Fzwd' zeros(1,lT-length(Fzwd))]));
                if(LFd==2)
                    Afdd=Afd; Afdg=abs(fft([Fzwd2' zeros(1,lT-length(Fzwd2))]));
                    Afd=Afdd.*Afdg;
                end
                Afg=abs(fft([Fzwg' zeros(1,lT-length(Fzwg))]));
                Afc=(Afg(1:round((lT-1)/2))-Afg(1:round((lT-1)/2)).*Afd(1:round((lT-1)/2))); 
                if(LFg==2)
                    Afg2=abs(fft([Fzwg2' zeros(1,lT-length(Fzwg2))]));
                    x=[1:round((lT-1)/2)];
                    Afc=Afc.*Afg2(x); %Afc1=Afc1.*Afg2;
                    %Afg0=abs(fft([Fzwg0' zeros(1,lT-length(Fzwg0))]));
                    %Afg0=Afg0(x);
                 end
                EnAfc=mean(Afc.^2); %(2*sum(Afc.^2)/lT);
                for(i=1:lT) if(Afd(i)>=1/sqrt(2)); ihPx=i; else break; end; end, wPol=2*ihPx/lT; 
                if(0)
                    [Fzwd2, afB, AmpB, Phase,ihP,iA02,tauhP,tauA02,tauTu]=designButter(Tud,5,lT,wPol);
                    % Przyk³ad syntezy z wykresami: 
                    %% designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b Ffd(:,N2d)_m Ffc_{c--}',Fzwd,Fzwc, Ffd(:,length(Ffd(1,:))), Ffc);
                    %  designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b ',Fzwd,Fzwc); %
                end
            end
            % ==== Filtracja Butter ======================
            Ka=length(afB); Kb=length(bfB); 
            yTrB(1:Kb,1)=zeros(Kb,1); NB=length(Yoryg);
            for(n=Kb+1:NB) yTrB(n,1)=-afB(wgEn+1,2:Ka)*yTrB(n-[1:Ka-1],1)+bfB(wgEn+1,1:Kb)*Yoryg(n-[0:Kb-1],1); end, 
            if(0) %wgEn) 
                yTrB=sign(yTrB).*(abs(yTrB).^(1/Ewykl))+meanYoryg;
            end
            ndel=round(abs(tauhP(wgEn+1))); txtau='\tau';
            % ............... Teraz wykresy dla yTrB .....................
            figure(nFig); subplot(4,lcol,nCol); kol=Kolor(nosoby);
            if(wgEn) 
                yTrBx=sign(yTrB).*(abs(yTrB).^(1/Ewykl))+meanYoryg;
            else yTrBx=yTrB; 
            end
            sygnTrB=(yTrBx-mean(yTrBx))/SigyTr(wgEn+1)+SrYtr(wgEn+1); 
            for(nF=1:2)
                hold on; plot([nY1Tr:nYfTr]-ndel,sygnTrB(nY1Tr:nYfTr),[kol '--']);
                if(nF==2) plot([nY1Tr:nYfTr],sygnTrB(nY1Tr:nYfTr),[kol '-.']), end
                plot([1:nY1Tr-ndel],sygnTrB(ndel+1:nY1Tr),'g',[nYfTr+1:Nf]-ndel,sygnTrB(nYfTr+1:NB),'g');
                axis('tight'); 
                if(nowy) 
                    hold on; ax=axis; plot([Nf-ndel Nf-ndel],ax(3:4),'k--'); hold off;
                    txl=sprintf('Kan.%d: yTr_{MTF}(%c) yTr_B(%c--)',nrwykr(nrs),kol,kol);
                    if(nF==2) txl=[txl sprintf(' %s_B=%d',txtau,ndel)]; end
                    xlabel(txl); 
                end
                hold off;
                if(nF==1)
                    if(nosoby~=nOs1) break; end,%figure(nfig); break; end
                    figure(nfig); subplot(4,lcol,2*lcol+ncol); kol=Kolor(nosoby);
                end
            end
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,lcol,lcol+ncol); kol=Kolor(nosoby);
                hold on; plot([1:Nf],yTrBx,'g'); %plot([nY1Tr:nYfTr],yTrB(nY1Tr:nYfTr),'g'); 
                hold off;
                % ============================================
                figure(nfig); ncol=2*(wgEn+1); 
                lAx=lA; m=find(Af==max(Af)); nx=find(Af(m(1):end)<max(Af)/50); lAx=nx(1);
                if(lAx<lA/20) lAx=round(lA/20); end; nx=[];
                if(LFg==2 && lAx<round(1.05*lT/(TuG(2)))) lAx=round(1.05*lT/(TuG(2))); end,
                wTx=TuG(1)/(lT); wTuf=Tud/(lT);
                x=wTuf*[0:lAx-1]; lAf=lAx;
                nx=find(Af<0); Af(nx)=0;
                subplot(4,lcol,lcol+ncol); %subplot(2,2,2); %hold on;
                plot(x,AYor(1:lAf),'b',x,AYog(1:lAf),'r'); axis('tight'); xlabel('Widmo Ampl.sygnalu badanego');
                ax=axis; hold on;
                plot(wTuf*[Lf-1 Lf-1],ax(3:4),'k:',[1 1],ax(3:4),'b-.',Tud/TuG(1)*[1 1],ax(3:4),'r-.');
                if(LFg==2) plot(Tud/TuG(2)*[1 1],ax(3:4),'b-.'); end
                hold off;
            end
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,4,3); 
                wo=wgEn*Ewykl+1; kol1='k'; kol2='r'; wTud=[1 1];
                TudG=TuG(1)/Tud;
                if(wgEn>0) hold on;  kol1='b'; kol2='m'; end
                for(m=1:2:3)
                    lAa=iA01(wgEn+m); if(lAa>length(x)) lAa=length(x); end, %xo=wTuf*wo*[0:lAa-1]; 
                    %plot(x(1:lAa)*wo,Afd(1:lAa),'k',ihP(wgEn+1)*wTuf*wo,Afd(ihP(wgEn+1)),'k.',x(1:lAa)*wo,AmpB(wgEn+1,1:lAa),'r',ihP(wgEn+1)*wTuf*wo,AmpB(wgEn+1,ihP(wgEn+1)),'r.'); %hold off; %,x,Afc1(1:lAf),'g');
                    plot(x(1:lAa),Ampd(wgEn+m,1:lAa),kol1,ihP(wgEn+m)*wTuf,Ampd(wgEn+m,ihP(wgEn+m)),[kol1 '*'],...
                        x(1:lAa),AmpB(wgEn+m,1:lAa),kol2,ihP(wgEn+m)*wTuf,AmpB(wgEn+m,ihP(wgEn+m)),[kol2 '*']); hold on;
                end
                axis('tight'); ax=axis; xo=[]; wTud=[1 1]; hold on;
                for(m=1:2:3) if(m==3) wTud=Tud/TuG(1)*[1 1]; end, plot(wTud*(wgEn+1),ax(3:4),[kol1 '--']); end
                hold off;
                txx=sprintf('Filtry dolne: k,b-MTF, r,m-Butter^%d; A(T_d/T) T_d=%.0f',rzadB,Tud);
                xlabel(txx); ylabel('Amplituda'); %title(tx);
                if(wgEn==0)
                    subplot(4,4,4); %subplot(4,lcol,ncol); %subplot(2,2,2); %hold on;
                    if(LFg==2) plot(x,Afg2(1:lAf),'b-.'); hold on; end,%,x,Afg0(1:lAf),'g-.'); hold on; end
                    if(LFd==2) plot(x,Afdd(1:lAf),'r--',x,Afdg(1:lAf),'m:'); hold on; end
                    plot(x,Afd(1:lAf),'r',x,Afg(1:lAf),'b--',x,Afc(1:lAf),'k'); hold off; %,x,Afc1(1:lAf),'g');
                    axis('tight'); ax=axis; hold on;
                    plot([1 1],ax(3:4),'b-.',TudG*[1 1],ax(3:4),'r-.');
                    if(LFg==2) plot(Tud/TuG(2)*[1 1],ax(3:4),'b-.'); end, hold off;
                    txx=sprintf('Ch.Ampl: f/f_g=T_g/T; T_d=%.0f T_g=%.0f',Tud,TuG(1));
                    if(LFg==2) txx=[txx sprintf(' T_{g2}=%.0f',TuG(2))]; end
                    xlabel(txx); ylabel('Amplituda'); %title(tx);
                end
            end
            % ---------------- Przeliczenie skali widma --------------------------
            EnAy=mean(Ay.^2); EnwY=sum(wY.*wY); % EnAy=EnwY+1.4e-13; EnAfm/EnAyf=1.0058 % sprawdzone !!!!!!
            AfcY=AYor(1:length(Afc)).*Afc; wxx=EnwY/EnY; % Nie uzywane !!!
            EnAfm=mean(Afm.^2); EnAyf=mean(Ayf.^2); %*2/EnAy-1,%[((mean(Afm.^2)/lT)/lT)/-1]
            % UWAGA !!! dopisanie dowolnej liczby zer dla transformowanego szeregu nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci widma !!
            % WspÃ³Å‚czynnik przeliczenia widma - wA=sqrt(energia sygnaÅ‚u orygin.), wA=wYr+eps
            % ZaleÅ¼noÅ›Ä‡: abs(FY)=abs((ar+j*ai)*(br+j*bi))=(A*B);
            wA=AYog(1:lAf); AYo=Afc(1:lAf).*wA;
            if(bezTrendu) AYTr=AYo+AYoTr(1:lAf).*Afc(1:lAf); AfTr=ATr(1:lAf).*Afc(1:lAf); end
            % AYoTr wygladzone widmo ATr trendu
            % ........................................................................
            % Ayf(c) widmo obliczone sygna³u srednioczêstotliwoœc. yf - po filtracji Afc
            % Afm(r) - wygladzone widmo mocy obliczonej Ayf (z zachowaniem mocy lacznej, ale z niewielkÄ… odchyÅ‚kÄ… Å›redniÄ…);
            % Af(m) wyg³adzone widmo Ayf - wygladzone widmo mocy obliczonej Ayf (z zachowaniem mocy lacznej, ale z niewielkÄ… odchyÅ‚kÄ… Å›redniÄ…);;
            % Af2 wyg³adzone widmo Ayf^2; nie uzywane
            % AYor obliczone widmo sygna³u Yoryg(nY1:nYf); (tylko do obliczeñ)
            % AYo(k) widmo skl.srenioczêst.: wyg³adzone widmo AYor pomno¿one przez filtr pasmowy Afc,
            % AfTr(g) inaczej policz. widmo ATr: ATr*Afc
            % AYTr(b) widmo ca³ego sygn.u¿yt. AYo+Afc*AYoTr (inaczej oblicz. widmo AYo;
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,lcol,3*lcol+ncol); %subplot(2,2,4);
                plot(x,Ayf(1:lAx),'c',x,Af(1:lAx),'k'); %,x,Afm(1:lAx),'r',x,AYo(1:lAf),'k'),%x,Afc(1:lAf)*wd,'m:');
                axis('tight'); ax=axis; hold on;
                if(bezTrendu && 0) plot(x,AfTr(1:lAx),'g',x,AYTr(1:lAx),'b'); end
                plot(wTuf*[Lf-1 Lf-1],ax(3:4),'k:',[1 1],ax(3:4),'b-.',TudG*[1 1],ax(3:4),'r-.');
                if(LFg==2) plot(Tud/TuG(2)*[1 1],ax(3:4),'b-.'); end
                xlabel(txx); ylabel('Amplituda'); xlabel('Widmo amplit.sklad.srednioczest. Ayf(f/f_g)');
                hold off;
                subplot(4,lcol,2*lcol+ncol); lATr=round(wTuf*lAx*10);
                % ATr(r) obliczone widmo trendu;
                % AYoTr(k) wygladzone widmo ATr trendu (tylko do obliczeñ)
                lwA=min(length(AYog),length(Afd));
                AmpTr=AYog(1:lwA).*Afd(1:lwA);
                nM=find(AmpTr==max(AmpTr)); n0=find(AmpTr(nM(1):end)<AmpTr(nM(1))/50)+nM(1);
                xx=[1:n0(1)]; %xx=[1:round(length(AYoTr)/700)];
                %plot(wTuf*xx,AYoTr(xx),'k',wTuf*xx,ATr(xx),'r'); axis('tight');
                plot(wTuf*xx,AmpTr(xx),'k',wTuf*xx,ATr(xx),'r'); axis('tight');
                if(max(wTuf*xx)>=1) %TudG(1)/Tud)
                    ax=axis; hold on;
                    plot([1 1],ax(3:4),'b-.');
                    hold off;
                end
                ylabel('Amplituda'); xlabel('Widmo amplit.trendu ATr(f/f_g)');
%                                 subplot(4, 4, 4); %subplot(4,lcol,ncol); %subplot(2,2,2); %hold on;
%                 y = SZEREGI(:, nosoby)'; z = Yorsum'; w = [y z];
%                 wMean = mean(w); wSigma = std(w);
% 
%                 for (i = 1:length(y))
%                     y(i) = (y(i) - wMean) / wSigma;
%                     z(i) = (z(i) - wMean) / wSigma;
%                 end
% 
%                 %                 sum(x(0:N-1).^2)=N*mean(x)^2+N/2*sum(Apm^2(1:N/2))=mean(Af^2(1:N))=2*mean((Amp*N/2)^2(1:N/2)); Amp=Af*2/N
%                 N = Ldsz; K = 1; %y=50+100*(sin(2*pi/200*t)+sin(2*pi/10*t));
%                 Afs = abs(fft([y zeros(1, (K - 1) * N)])); As = Afs * 2 / (N); Afn = abs(fft([z zeros(1, (K - 1) * N)])); Asn = Afn * 2 / (N);
%                 Afs = abs(fft(y)); As = Afs * 2 / (N); Afn = abs(fft(z)); Asn = Afn * 2 / (N);
%                 x1 = [0:round((N - 1) / 2)]; xn = [0:round((K * N - 1) / 2)];
%                 plot(xn * 2048 / (K * N - 1), Asn(xn + 1), 'r', x1 * 2048 / (K * N - 1), As(x1 + 1), 'k'); xlabel(sprintf('Spectrum: zmierzony(%d)_k,\n %s(%d)_r [Hz]', nosoby, txY, nrS)); axis('tight');

            end
%             trendTab = [ trendTab; sygnTr ];
            dTr=[0 diff(yTr)];
            dTr=[0 diff(yTr)];ldTr=length(dTr);  nx=find(dTr(2:ldTr).*dTr(1:ldTr-1)<0); length(nx); figure(21); plot([1:ldTr],yTr,'k',nx,yTr(nx),'r*')

            wmaxTr=yTr(nx)/mean(yTr);
         end  % wersja Y^2 Y
        nowy=0; 
    end  %Losob
   fprintf(1,'\nSzereg %d. Czas obliczeñ: %.2f',nrs,toc(tKanal));
end %Lgestow

figure(14); %% skala trendendów

% plotTrendStaticAxis(Lszer, Ldsz, trendTab); 

%TESTY DTW
figure; dtwe = dtw(trendTab(:,1),trendTab(:,17));
figure; dtws = dtw(trendTab(:,1),trendTab(:,17), 'squared');

%% ================= Sprawdzenie filtracji Fzwdc: yTrc wg Fzwdc, yTr - metod¹ dwuetapow¹ Fzwd i Fzw2 ============  
m=1; yTrc=[];for(n=LzwcE:Nf) yTrc(m)=Yoryg(n-LzwcE+1:n)'*FzwcE; m=m+1; end
nYTr1=(LzwcE-1)/2; nYTrf=nYTr1+length(yTrc); nYTr1=nYTr1+1;
if(wgEn) yTrc=sign(yTrc).*(abs(yTrc).^(1/Ewykl))+meanYoryg; yTr=sign(yTr).*(abs(yTr).^(1/Ewykl))+meanYoryg; end
figure(2); subplot(1,1,1); plot(nYTr1:nYTrf, yTrc,'r',nY1Tr:nYfTr, yTr,'k'); axis('tight');
nx=find(abs(yTrc(1:length(yTr))-yTr)>1.e-8); mm=length(nx),
% ...... Dokladna prezentacja filtru dolnego MTF:
figure(2);lA=round(0.3*lAx); x=wTuf*[0:lA-1]; plot(x,Afdd(1:lA),'r--',x,Afdg(1:lA),'m--',x,Afd(1:lA),'r'); axis('tight'); ax=axis; hold on; plot([1 1],ax(3:4),'b--'); hold off;
c=1; %% ========================================================================================================= 
% sgtitle(sprintf('Trendy ')); %z Blind Source Separation /nCzerwony zaporowy/n szerokoprzepustowy/n poprawka
fprintf('\nCzas wykonywania obliczeñ i rysowania: %gs', toc(tStart));

[path, filename, Fext] = fileparts(fnames(1));
figLetter = char(65+2^0*BSS+2^1*wgEnerg+2^2*Integr+2^3*BigData+2^4*Symul); char(65+figLetter); % figure countig num
nFig = 11; set(figure(nFig),'WindowState','maximized');pause(.1); figPW(sprintf('%s_%s_S%dE%dI%dB%dfig', figLetter, filename, Symul, wgEnerg, Integr, BSS));
nFig = 14; set(figure(nFig),'WindowState','maximized');pause(.1); figPW(sprintf('%s_%s_S%dE%dI%dB%dfig', figLetter, filename, Symul, wgEnerg, Integr, BSS), nFig, 'fig', 'figury/', 2);

% zapiszFig('3');
% Test widma: Tw.Parsevala - energia sygnaÅ‚u=Å›rednia(widma mocy): 
% sum(x(0:N-1).^2)=N*mean(x)^2+N/2*sum(Apm^2(i=1:N/2))=mean(Af^2(1:N))=2*mean((Amp*N/2)^2(1:N/2)); Amp=Af*2/N   
% N=408000; t=0:N-1; y=50+100*(sin(2*pi/200*t)+sin(2*pi/10*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=2; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(K*N);
% x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*200/(N-1),As(x+1),'b',xn*200/(K*N-1),Asn(xn+1));
%m=20/(200/(K*N-1)); [Asn([round(m/10)+[-3:3]]+1); Asn([round(m)+[-3:3]]+1)]

%T0=50; T1=5; N=10*T0; t=0:N-1; y=50+100*(sin(2*pi/T0*t)+sin(2*pi/T1*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=200; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(N);
%x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*T0/(N-1),As(x+1),'b',xn*T0/(K*N-1),Asn(xn+1));

%sigyA=sqrt(mean(Afs.^2)/N/N); sigy=std(y); % Mamy rÃ³wnoÅ›Ä‡ mean(Afs.^2)=2*mean(Afs(x+1).^2)