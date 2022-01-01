% Plik MTFbionNewFast.m Widmo mocy, porownywane rendow% suma kwadratow roznic
clear all; 
global ax1 ax2;
Takcji=5000; %5*392; 
Symul=0; wgEnerg=2;  Integr=1; 
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
    fnames = 'dane/spoczynek.wav';    
    fnames1 = 'dane/zginanie.wav';     
    fnames2 = 'dane/zginanie2.wav'; 
    
    %fnames = 'dane/zaciœniêta_piêœæ_statycznie.wav'; 
    %fnames = 'dane/zaciœniêta_piêœæ_dynamicznie.wav'; %'../bioniczna/bioniczna/data/01108.wav'
    [data, fs] = audioread(fnames1); %data = data(:,2);
     data2 = audioread(fnames2); 
     data=[data data2]; 
     %wczytajEMG; data = rawData; 
    [Ldsz Lszer] = size(data); ldC=Ldsz; 
    SZEREGI = data;
    if(0)
        % Blind source separation ============
        tau = 2;
        yT = data'; n =Ldsz;
        Q=yT(:,1:n-tau)*yT(:,tau+1:n)'+yT(:,tau+1:n)*yT(:,1:n-tau)';
        
        [W,D] = eig(yT*yT',Q);    
        S = W'*yT;    
        Y = S'; K=Y'*Y; 
        %SZER = [Y data ];
    end
    bezLpred=0; 
    Ld0=Takcji/10; Ldf=Ldsz-Ld0; sLd=Ldf/6; x=([1:Ldf])/sLd; f=(x.^2).*exp(-((x-1).^2)/2);f=2*(f-(f(end)-f(1))/(length(x))*x*sLd);
    %or(i=1:Lszer) SZEREGI(Ld0+1:Ldsz,i)=SZEREGI(Ld0+1:Ldsz,i)+f'; end
    nrwykr=1:Lszer; %[1:Ldsz];
    alfa=1-1/tauf; %0; %400; %200; 
end
Lk=0; nfig0=2; txtau='\tau';
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
Lk=0; LC=LSzeregow; Lgestow=round(LC/2); Losob=2;
nfig=nfig0; nFig=nfig0+1+Lgestow;
% ----------- Okreœlenie zakresu lT analizy widm (tak aby dobrze spróbkowaæ widmo)
lTx=Tud*200; lTx=Tud*500; %1000;
nTx=ceil(lTx/4096); lT=nTx*4096; %500; %350; %75; %round(lA/10);
Ewykl=2; 
% ============ Synteza filtrów dolnoprzepustowych MTFd i Butter5 ===================
%  Wywo³anie desMTFcButter() z parametrem figF=0 daje wynik bez wykresow charakterystyk Bodego 
%ntypZ=typMTF(nrVar);  % ===== Typ filtru ============= 2 klasyczny, 3 trend lin.; 5 trend 3.rzÄ™du
% -------------- Synteza filtru dolnoprzepustowego ----------
ntypZ=typMTF(1); rzadB=5; 
Ffzwykly=1; % =1 filtr koncowy bez modyfikacji, =0 filtr koncowy skompresowany i dopeln.Regresja
tSynt=tic;
if(0) figF=1; % Liczenie z rysowaniem wszystkich charakterystyk
    %[bfBd, afBd, tauhPfd, MTFd, Fzwc, LpFc, Amp, nA01, WcB, Fzwd, Fzwd2, fi,  Ffc, Ff1, Ff2]=...
    [bfBd, afBd, tauhPfd, MTFd, Fzwc, LpFc, Amp, nA01, WcB]=...
        desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT,figF,'Synteza filtrow MTF (Fzws_b Fzwd_r Fzw2_m Ffc_g Ff1_c Ff2_{c--}) i Butter_k','kbrmgc');
    Fzwd=[]; Fzwd2=[]; fi=[];  Ffc=[]; Ff1=[]; Ff2=[];
else % Tylko synteza filtrow Fzwc i Butter (szybka wersja)
    nA01=0;
    [bfBd, afBd, tauhPfd, MTFd, Fzwc, LpFc, Amp, nA01, WcB]=desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT);
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
    [bfBE, afBE, tauhPfE, MTFE, FzwcE, LpFcE, Amp, nA01E, WcB]=desMTFcButter(ntypZ,[Tud Tud1]/Ewykl,rzadB,lT);
end
ihP(2)=WcB*lT/2; 
if(length(nA01E)>1)  iA01(2)=nA01E(2); AmpB(2,:)=Amp(1,:); Ampd(2,:)=Amp(2,:); end; 
MTud=MTFd(1).M; 
% ............. Koniec syntezy filtrów dolnoprzepustowych MTFd i Butter5 ............
% ============= Synteza filtrów górnoprzepustowych % ========================   
%[bfx, afx, tauhPfEg, MTFEg, FzwcEg, FzwgE, Fzwg2E, LpFcEg, Amg, nA01g, WcBg]=desMTFcButter(ntypZ,[Tud Tud1]/Ewykl); %,0,lT);
[bfEg, afEg, tauhPfEg, MTFEg, FzwcEg, LpFcEg, Amp, nA01Eg,WcEg]=desMTFcButter(ntypZ,TuG(1:2)/Ewykl,rzadB,lT);
ihP(4)=WcEg*lT/2; TuGg(2)=TuG(2)/Ewykl;
if(length(nA01Eg)>1)  iA01(4)=nA01Eg(2); AmpB(4,:)=Amp(1,:); Ampd(4,:)=Amp(2,:); end; %wPol=2*ihP(2)/lT;
[bfg, afg, tauhPfg, MTFg, Fzwcg, LpFcg, Amp, nA01g, Wcg]=desMTFcButter(ntypZ,TuG(1:2),rzadB,lT);
ihP(3)=Wcg*lT/2; TuGg(1)=TuG(2);
if(length(nA01g)>1)  iA01(3)=nA01g(2); AmpB(3,:)=Amp(1,:);  Ampd(3,:)=Amp(2,:); end, 
% ======= Koniec syntezy - podstawiamy wyniki ==================
nA01=max(iA01); lwAm=nA01; Amp=AmpB(1:4,1:lwAm); AmpB=Amp; Amp=[]; Amp=Ampd(1:4,1:lwAm); Ampd=Amp; Amp=[]; 
% ======================================================================
afB(1,:)=afBd;  bfB(1,:)=bfBd; 
Lzwc(1)=LpFc(2); Lzwd=LpFc(3); Lzw2=LpFc(4); % d³ugoœci filtrów Fzwc, Fzwd i Fzw2
tauhP(1)=-tauhPfd(1); wPol=2*ihP(1)/lT;
% .................................................................
afB(2,:)=afBE; bfB(2,:)=bfBE;
Lzwc(2)=LpFcE(2); LzwdE=LpFcE(3); Lzw2E=LpFcE(4); 
tauhP(2)=-tauhPfE(1); %ihPB(2)=-tauhPfE(1);% ihP(2)=-tauhPfE(2);
% .................................................................
afB(3,:)=afg; bfB(3,:)=bfg;
Lzwc(3)=LpFcg(2); Lzwdg=LpFcg(3); Lzw2g=LpFcg(4); 
tauhP(3)=-tauhPfg(1); %ihPB(3)=-tauhPfg(1); ihP(3)=-tauhPfg(2);
% .................................................................
afB(4,:)=afEg; bfB(4,:)=bfEg;
Lzwc(4)=LpFcEg(2); LzwdEg=LpFcEg(3); Lzw2Eg=LpFcEg(4); 
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
fprintf(1,'\nCzas syntezy %.4f sek.',toc(tSynt));
% ========================================================
%close all;
druktx=sprintf('\nLk=%3d. Nr ostatniej probki szeregu ldC=Nmax=%d',Lk+1,ldC);
Nmax=length(SZEREGI(:,1));
fprintf(1,'%s: ',druktx); fprintf(1,'\nTu_d=%d Tu_g=%d %d Nmax=%d',round(Tud),round(TuG(1)),round(TuG(LFg)),Nmax);
if(wgEnerg>0) LwgE=1; lcol=4; else LwgE=0; lcol=2; end 
Kolor='kbrmgc'; 
figX = 0.00; figY = -0.00; Xkonc = 0.80; Ykonc = 0.8;
if(0)
    nrfig = figure(100);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
    fig=gcf; set(fig,'Units','normalized','Position',[0.11 0.04 0.8 0.82]);
    nrFig = figure(nFig);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
    Fig=gcf; set(Fig,'Units','normalized','Position',[0.09 0.015 0.8 0.815]);
end
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
        nrfig = figure(100);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
        fig=gcf; set(fig,'Units','normalized','Position',[0.11 0.04 0.8 0.82]);
        nrFig = figure(nFig);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
        Fig=gcf; set(Fig,'Units','normalized','Position',[0.09 0.015 0.8 0.815]);
        %         nrFig = figure(nFig);  %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
%         Fig=gcf; set(Fig,'Units','normalized','Position',[Lgestow*0.01 -Lgestow*0.01 Xkonc Xkonc]);
    end
    nOs1=1; dno=1; nOsf=Losob;
    for(nosoby=nOs1:dno:nOsf)
        yTrc=zeros(4,Nmax); 
        nYTr1=zeros(1,4); nYTrf=zeros(1,4); nYTrE1=zeros(1,4); nYTrEf=zeros(1,4);
        txtyt=[]; %tic;
        nrS=(nosoby-1)*Lgestow+nrwykr(nrs); nrGest=nrwykr(nrs);
        nrPliku=1; nrKol=nrs;
        if(exist('nazwy')) nplik=nazwy(nrS,:); else nplik=sprintf('Series%d',nrS); end
        txg=sprintf('SZEREG(1:%d,%d) z pliku %s',Ldsz,nrS,fnames);
        for(wgEn=0:LwgE)
            typS=wgEn+1; typS2=typS+2;
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
            % ----------------- Filtracja ----------------------------------------------
            Nf=length(Yoryg);
            %% ================= Filtracja MTFd, MTFg (Fzwdc,g) i Butterd, Butterg ============ 
        %for(typS=1:2)
            typS2=typS+2;
            nYTr1(typS)=(Lzwc(typS)-1)/2;        m=nYTr1(typS);
            nYTr1(typS2)=(Lzwc(typS2)-1)/2+m;   mg=nYTr1(typS2); %Lzwc(typS); 
            yTrc(typS2,Nf)=0; yTrc(typS,Nf)=0;
            Lzw=Lzwc(typS); Lzw1=Lzw-1;
            Lzwg=Lzwc(typS2); Lzwg1=Lzwg-1; Lzwg=Lzwg+nYTr1(typS);
            nYTr1(typS)=nYTr1(typS)+1; nYTr1(typS2)=nYTr1(typS2)+1;
            if(typS==1)
                Nd=MTFd(1).M-1; Ng=MTFg(1).M-1; 
                for(n=Lzw:Nf) m=m+1; yTrc(typS,m)=Yoryg(n-Lzw1:n)'*Fzwc; end
                Yreszt=Yoryg-yTrc(typS,:)';
                for(n=Lzwg:m) mg=mg+1; yTrc(typS2,mg)=Yreszt(n-Lzwg1:n)'*Fzwcg; end
            else
                Nd=MTFE(1).M-1; Ng=MTFEg(1).M-1; 
                for(n=Lzw:Nf) m=m+1; yTrc(typS,m)=Yoryg(n-Lzw1:n)'*FzwcE; end
                Yreszt=Yoryg-yTrc(typS,:)';
                for(n=Lzwg:m) mg=mg+1; yTrc(typS2,mg)=Yreszt(n-Lzwg1:n)'*FzwcEg; end
            end
            nYTrf(typS)=m; nYTrf(typS2)=mg;
            % ==== Filtracja Butter ======================
            for(tS=typS:2:typS2)
                Ka=length(afB(tS,:)); Kb=length(bfB(tS,:));
                yTrB(tS,1:Nf)=zeros(1,Nf);
                if(tS==typS)
                    for(n=Kb+1:Nf)
                        yTrB(typS,n)=-afB(typS,2:Ka)*yTrB(typS,n-[1:Ka-1])'+bfB(typS,1:Kb)*Yoryg(n-[0:Kb-1],1);
                    end,
                    ndel(tS)=round(abs(tauhP(tS)));
                else
                    Yreszt=Yoryg(1:Nf-ndel(typS))-yTrB(typS,ndel(typS)+1:Nf)'; Nr=length(Yreszt);
                    Kb1=Kb+1+length(bfB(typS,:))+ndel(typS);
                    for(n=Kb1:Nr)
                        yTrB(typS2,n)=-afB(typS2,2:Ka)*yTrB(typS2,n-[1:Ka-1])'+bfB(typS2,1:Kb)*Yreszt(n-[0:Kb-1],1);
                    end,
                    ndel(tS)=ndel(typS)+round(abs(tauhP(tS)));
                end
            end
         %end
            %typS=wgEn+1;
            if(typS==2 && nrs==1) 
                figure(2); 
                for(ntS=1:4) subplot(2,2,ntS); plot([1:Nf],yTrc(ntS,:),'k',[1:Nf-ndel(ntS)],yTrB(ntS,ndel(ntS)+1:end),'r'); axis('tight'); end;
            end
            typS=wgEn+1; 
            Nx=Nf;
            ncol=wgEn*2+1;
            if(wgEn==0 && nosoby==nOs1)
                figure(nfig); 
                subplot(4,4,1); %subplot(4,lcol,ncol);
                plot(1:Ldsz,SZEREGI(:,nrS),'k'); axis('tight'); ax=axis; hold on;
                plot([nYTr1(1) nYTr1(1)],ax(3:4),'r--',[nYTrf(1) nYTrf(1)],ax(3:4),'r--',[nYTr1(3) nYTr1(3)],ax(3:4),'g--',[nYTrf(3) nYTrf(3)],ax(3:4),'g--'), 
                title(txg); xlabel(sprintf('Sygnal zmierzony 1:%d',Ldsz));
                hold off;
                subplot(4,4,2); %subplot(4,lcol,ncol);
                plot(1:Ldsz,Yorsum,'k'); axis('tight'); ax=axis; hold on;
                plot([nYTr1(1) nYTr1(1)],ax(3:4),'r--',[nYTrf(1) nYTrf(1)],ax(3:4),'r--',[nYTr1(3) nYTr1(3)],ax(3:4),'g--',[nYTrf(3) nYTrf(3)],ax(3:4),'g--'), 
                hold off;
                xlabel(sprintf('%s(1:%d)',txY,Ldsz));
            end
            if(nosoby==nOs1)
                figure(nfig); 
                subplot(4,lcol,lcol+ncol); 
                %plot([nY1Tr:nYfTr],Yoryg(nY1Tr:nYfTr),'k',[nY1Tr:nYfTr],yTr,'g'), axis('tight'); 
                plot([1:Nf],Yoryg,'k',[1:Nf],yTrc(typS,:),'r'), axis('tight'); 
                ax=axis; hold on;
                plot([nYTr1(typS2) nYTr1(typS2)],ax(3:4),'g--',[nYTrf(typS2) nYTrf(typS2)],ax(3:4),'g--',[nYTr1(typS) nYTr1(typS)],ax(3:4),'r--',[nYTrf(typS) nYTrf(typS)],ax(3:4),'r--');
                txOs=sprintf('Osoba %d ',nosoby);
                title([txspac txOs tx]); hold off
                xlabel(sprintf('Trend(g) i Yoryg(%d:%d)(k)',nYTr1(typS),nYTrf(typS)));
            end
            if(wgEn)
                yxTr=sign(yTrc(typS,:)).*(abs(yTrc(typS,:)).^(1/Ewykl))+meanYoryg; 
            else yxTr=yTrc(typS,:); 
            end
            figure(nFig); 
            subplot(4,lcol,nCol); kol=Kolor(nosoby);
            if(nosoby==nOs1) 
                SrYtr(typS)=mean(yxTr); SigyTr(typS)=std(yxTr); 
                STrd(nrGest,nosoby).SrYtr(typS)=SrYtr(typS); STrd(nrGest,nosoby).SigyTr(typS)=SigyTr(typS);
            end
            sygnTr=(yxTr-mean(yxTr))/SigyTr(typS)+SrYtr(typS); 
            if(wgEn) 
                yTrBx=sign(yTrB(typS,:)).*(abs(yTrB(typS,:)).^(1/Ewykl))+meanYoryg;
            else yTrBx=yTrB(typS,:); 
            end
            sygnTrB=(yTrBx-mean(yTrBx))/SigyTr(typS)+SrYtr(typS); 
            for(nF=1:2) % Rysujemy na nFig=11 i na nfig
                if(nowy==0) hold on; end, 
                %plot([nYTr1(typS):nYTrf(typS)],sygnTr(nYTr1(typS):nYTrf(typS)),kol), axis('tight'); hold on; ax=axis;
                plot(1:Nf,sygnTr,kol,[1:Nf-ndel(typS)],sygnTrB(ndel(typS)+1:Nf),[kol '--'],...
                    [1:Nf],sygnTrB,[kol ':']), 
                axis('tight'); hold on; ax=axis;
                if(nowy) 
                    plot([nYTr1(typS2) nYTr1(typS2)],ax(3:4),'g--',[nYTrf(typS2) nYTrf(typS2)],ax(3:4),'g--',[nYTr1(typS) nYTr1(typS)],ax(3:4),'r--',[nYTrf(typS) nYTrf(typS)],ax(3:4),'r--');
                    xlabel(sprintf('Kanal %d: yTr(%d:%d)',nrwykr(nrs),nYTr1(typS),nYTrf(typS))); 
                    if(nF==1 && nrs==2) title([tx '  ' txg]); end
                    txl=sprintf('Kan.%d: yTr_{MTF}(%c) yTr_B(%c--)',nrwykr(nrs),kol,kol); 
                    if(nF==2) txl=[txl sprintf(' %s_B=%d',txtau,ndel(typS))]; end
                    xlabel(txl); 
                end
                hold off;
                if(nF==1) 
                    % ========= Zapisujemy szeregi w strukturze STrd =====
                    STrd(nrGest,nosoby).yTrc(typS,:)=sygnTr; STrd(nrGest,nosoby).yTrB(typS,:)=sygnTrB; 
                    STrd(nrGest,nosoby).ndel(typS)=ndel(typS); 
                    STrd(nrGest,nosoby).nYTr1(typS)=nYTr1(typS); STrd(nrGest,nosoby).nYTrf(typS)=nYTrf(typS);
                    % ====================================================
                    if(nosoby~=nOs1) break; end
                    figure(nfig); subplot(4,lcol,2*lcol+ncol); 
                end
            end
            if(nosoby==nOs1)
                npC=Nd+1; 
                figure(nfig); 
                subplot(4,lcol,3*lcol+ncol); 
                if(nowy) hold off; end,
                if(wgEn) yxf=sign(yTrc(typS2,:)).*(abs(yTrc(typS2,:)).^(1/Ewykl)); else yxf=yTrc(typS2,:); end 
                plot([1:Nf],yxf,kol); %plot([nY1-npC+1:nYf+N2],yxf,kol);
                axis('tight'); ax=axis; axis([1 Nf ax(3:4)]); hold on; 
                plot([nYTr1(typS2) nYTr1(typS2)],ax(3:4),'g--',[nYTrf(typS2) nYTrf(typS2)],ax(3:4),'g--',[nYTr1(typS) nYTr1(typS)],ax(3:4),'r--',[nYTrf(typS) nYTrf(typS)],ax(3:4),'r--'); 
                %hold off;
                xlabel(sprintf('Skladowa srodkowoczest. yTrc/B(3/4,%d:%d)',nYTr1(typS2)-Nd,nYTrf(typS2)+Nd));
                figure(nfig);
                subplot(4,lcol,lcol+ncol); kol=Kolor(nosoby);
                hold on; plot([1:Nf],yTrBx,'g'); %plot([nY1Tr:nYfTr],yTrB(nY1Tr:nYfTr),'g');
                hold off;
            end
            % ============== Liczymy widmo w segmencie centralnym ====================================
            Afc=(Ampd(typS2,:)-Ampd(typS2,:).*Ampd(typS,:)); %Widmo amplitudowe filtru œrodkowoprzepustowego
            wAx=1;
            wY=yTrc(typS2,nYTr1(typS2):nYTrf(typS2)); lw=length(wY);
            wY=[wY zeros(1,lT-lw)]; % Uwaga !!! dopisanie zer nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci !!
            Ay=abs(fft(wY)); 
            %EnAy=(mean(Ay.^2));
            lA=lwAm; Ayf=Ay(1:lA); Ay=[]; %/lT; %lA=lA-1;
            % ---------- WygÅ‚adzanie widm filtra Fzw i sygnaÅ‚u Yoryg ----------------------
            % Ayf widmo obliczone sygna³u srednioczêstotliwoœc. yf - po filtracji Afc
            % ================ Filtry dla widma amplit. ===============
            lYo=length(Yoryg(nYTr1(typS2):nYTrf(typS2))); 
            % Uwaga !!! dopisanie dowolnej liczby zer nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci !!
            bezTrendu=2; jestAyo2=0;
            %if(bezTrendu)
            jestAyo2=1; Lfw=2;
            %AYreszt=abs(fft([(Yoryg(nY1Tr:nYfTr)'-yTr) zeros(1,lT-length(Yoryg(nY1Tr:nYfTr)))]));
            AYor=abs(fft([Yoryg(nYTr1(typS2):nYTrf(typS2))' zeros(1,lT-lYo)]));
            %if(bezTrendu>1) fx=yTrc(typS,nYTrf(typS):nYTrf(typS)); else fx=yTr(nY1:nYf); end,
            fx=yTrc(typS,nYTr1(typS):nYTrf(typS)); 
            ATr=abs(fft([fx zeros(1,lT-length(fx))]));
            %else  Lfw=1; AYor=abs(fft([fx(nY1:nYf)' zeros(1,lT-length(fx(nY1:nYf)))]));
            %end % AYor obliczone widmo sygna³u
            % ================== Pobranie filtru wyg³adzaj¹cego ============
            Nakt=length(Ayf); N1=MTF(1).M-1; N2=N1; Fzw=MTF(1).Fzw; lf=length(Fzw); 
            if(jestAyo2) Yo2=[AYor(N1:-1:2).^2 0 0 AYor(2:end).^2]; else Yo2=[AYor(N1:-1:2) 0 0 AYor(2:end)]; end,
            Y=[Ayf(N1:-1:1) Ayf]; Ll=1; N=length(Y); % najpierw wyg³adzamy widmo œrodkowoprzepustowe
            Y2=Y.^2; Af(lwAm-N2)=0;
            NfC=Nakt-N2; % koniec segmentu centralnego
            for(nfw=1:Lfw)
                M=MTF(nfw).M; N1=M-1; N2=N1; Fzw=MTF(nfw).Fzw; lf=length(Fzw); 
                Lf=M-1; NfCx=Nakt-N2;
                % ---------- Filtracja w segmencie startowym jest pominieta --------------------------------------
                n0Fzw=0;  %PnpC=N1+1; %Lf+1; %=M poczatek segmentu centralnego
                for(n=1:lwAm-N2) %Nakt-N2)
                    n1Fzw=n0Fzw+1;
                    if(nfw==1) Af(n)=Y(n1Fzw:n0Fzw+lf)*Fzw; Af2(n)=Y2(n1Fzw:n0Fzw+lf)*Fzw; end
                    AYo(n)=Yo2(n1Fzw:n0Fzw+lf)*Fzw;
                    n0Fzw=n1Fzw;
                end;
                % Af wyg³adzone widmo Ayf; Af2 wyg³adzone widmo Ayf^2; Ayo wyg³adzone widmo
                ldFzw=lf;
                % --------- Sekcja koncowa jest zbêdna -----------------
                if(nfw==1) nx=find(Af2<0); Af2(nx)=0; Afm=sqrt(Af2); end, 
                nx=find(AYo<0); AYo(nx)=0;
                if(jestAyo2) AYo=sqrt(AYo); end, %if(nfw==1) AYo(1)=AYor(1); else AYo(1)=ATr(1); end
                % ------------------ drugi filtr wygladzajacy dla -----
                if(nfw==1) AYo(1)=AYor(1); AYog=AYo; else AYo(1)=ATr(1); AYoTr=AYo; end
                AYo=[];
                % Af wyg³adzone widmo Ayf; Af2 wyg³adzone widmo Ayf^2;
                % AYog wyg³adzone widmo AYor
                % ATr obliczone widmo trendu; AYoTr wygladzone widmo ATr trendu
                Tu=6; %Tud/20; % MTud*lfA; % PrzedziaÅ‚ wygÅ‚adzania widma trendu
                if(bezTrendu)
                    jestAyo2=0; Lfw=2;
                    Yo2=[ATr(N1:-1:1) ATr]; 
                    N=length(Yo2);
                end
            end
            AYo=AYog; %AYog=[];
            if(nosoby==nOs1)
                % ============================================
                figure(nfig); ncol=2*(typS); 
                lAx=lwAm-N2; m=find(Af==max(Af)); nx=find(Af(m(1):end)<max(Af)/50); if(~isempty(nx)) lAx=nx(1)+m(1)-1; end
                if(lAx<lA/20) lAx=round(lA/20); end; nx=[];
                if(LFg==2 && lAx<round(1.05*lT/(TuG(2)))) lAx=round(1.05*lT/(TuG(2))); end,
                if(lAx>length(AYog)) lAx=length(AYog); end
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
                    %plot(x(1:lAa)*wo,Afd(1:lAa),'k',ihP(typS)*wTuf*wo,Afd(ihP(typS)),'k.',x(1:lAa)*wo,AmpB(typS,1:lAa),'r',ihP(typS)*wTuf*wo,AmpB(typS,ihP(typS)),'r.'); %hold off; %,x,Afc1(1:lAf),'g');
                    plot(x(1:lAa),Ampd(wgEn+m,1:lAa),kol1,ihP(wgEn+m)*wTuf,Ampd(wgEn+m,ihP(wgEn+m)),[kol1 '*'],...
                        x(1:lAa),AmpB(wgEn+m,1:lAa),kol2,ihP(wgEn+m)*wTuf,AmpB(wgEn+m,ihP(wgEn+m)),[kol2 '*']); hold on;
                end
                axis('tight'); ax=axis; xo=[]; wTud=[1 1]; hold on;
                for(m=1:2:3) if(m==3) wTud=Tud/TuG(1)*[1 1]; end, plot(wTud*(typS),ax(3:4),[kol1 '--']); end
                hold off;
                txx=sprintf('Filtry dolne: k,b-MTF, r,m-Butter^%d; A(T_d/T) T_d=%.0f',rzadB,Tud);
                xlabel(txx); ylabel('Amplituda'); %title(tx);
                if(typS==1)
                    subplot(4,4,4); %subplot(4,lcol,ncol); %subplot(2,2,2); %hold on;
                    plot(x(1:lAf),Ampd(typS,1:lAf),'r',x(1:lAf),Ampd(typS2,1:lAf),'b',x,Afc(1:lAf),'k'); hold off; %,x,Afc1(1:lAf),'g');
                    axis('tight'); ax=axis; hold on;
                    plot([1 1],ax(3:4),'b-.',TudG*[1 1],ax(3:4),'r-.');
                    plot(Tud/TuG(2)*[1 1],ax(3:4),'b-.'); hold off; axis([0 Tud/TuG(2)*1.05 ax(3:4)]);
                    txx=sprintf('A(f/f_g=T_g/T); T_d=%.0f T_g=%.0f',Tud,TuG(1));
                    if(LFg==2) txx=[txx sprintf(' T_{g2}=%.0f',TuG(2))]; end
                    xlabel(txx); ylabel('Amplituda'); %title(tx);
                end
            end
            % ---------------- Przeliczenie widma wyjsc --------------------------
            AfcY=AYor(1:length(Afc)).*Afc; 
            % UWAGA !!! dopisanie dowolnej liczby zer dla transformowanego szeregu nie zmienia energii sygnaÅ‚u, a zagÄ™szcza obliczane czÄ™stoÅ›ci widma !!
            % WspÃ³Å‚czynnik przeliczenia widma - wA=sqrt(energia sygnaÅ‚u orygin.), wA=wYr+eps
            % ZaleÅ¼noÅ›Ä‡: abs(FY)=abs((ar+j*ai)*(br+j*bi))=(A*B);
            wA=AYog(1:lAf); AYo=Afc(1:lAf).*wA;
            if(bezTrendu) AYTr=AYo+AYoTr(1:lAf).*Afc(1:lAf); AfTr=ATr(1:lAf).*Afc(1:lAf); end
            % AYoTr wygladzone widmo ATr trendu
            % ........................................................................
            % Ayf(c) widmo obliczone sygna³u srednioczêstotliwoœc. yTrc(3:4,:) - po filtracji Afc
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
                %if(bezTrendu && 0) plot(x,AfTr(1:lAx),'g',x,AYTr(1:lAx),'b'); end
                plot(wTuf*[Lf-1 Lf-1],ax(3:4),'k:',[1 1],ax(3:4),'b-.',TudG*[1 1],ax(3:4),'r-.');
                if(LFg==2) plot(Tud/TuG(2)*[1 1],ax(3:4),'b-.'); axis([0 Tud/TuGg(wgEn+1)*1.05 ax(3:4)]); end
                xlabel(txx); ylabel('Amplituda'); xlabel('Widmo amplit.sklad.srednioczest. Ayf(f/f_g)');
                hold off;
                subplot(4,lcol,2*lcol+ncol); lATr=round(wTuf*lAx*10);
                % ATr(r) obliczone widmo trendu;
                % AYoTr(k) wygladzone widmo ATr trendu (tylko do obliczeñ)
                lwA=min(length(AYog),length(Ampd(typS,:)));
                AmpTr=AYog(1:lwA).*Ampd(typS,1:lwA);
                nM=find(AmpTr==max(AmpTr)); n0=find(AmpTr(nM(1):end)<AmpTr(nM(1))/50)+nM(1);
                if(~isempty(n0)) n0(1)=n0(1)+nM(1)-1; else n0(1)=lwA; end, 
                xx=[1:n0(1)]; 
                plot(wTuf*xx,AmpTr(xx),'k',wTuf*xx,ATr(xx),'r'); axis('tight');
                if(max(wTuf*xx)>=1) %TudG(1)/Tud)
                    ax=axis; hold on;
                    plot([1 1],ax(3:4),'b-.');
                    hold off;
                end
                ylabel('Amplituda'); xlabel('Widmo amplit.trendu ATr(f/f_g)');
            end
            %fprintf(1,'\nSzereg %d. Czas obliczeñ: %.2f ',nrs,toc); 
        end  % wersja Y^2 Y
        nowy=0; 
    end  %Losob
    figure(100); 
    nY1=STrd(nrGest,1).nYTr1(1); nYf=STrd(nrGest,1).nYTrf(1); 
    nYE1=STrd(nrGest,1).nYTr1(2); nYEf=STrd(nrGest,1).nYTrf(2); 
    subplot(4,4,nrs); del=STrd(nrGest,1).ndel;
    plot(1:Nf,STrd(nrGest,1).yTrc(1,:),'b',1:Nf,STrd(nrGest,1).yTrc(2,:),'k',...
        [1:Nf-del(1)],STrd(nrGest,1).yTrB(1,del(1)+1:end),'m',...
        [1:Nf-del(2)],STrd(nrGest,1).yTrB(2,del(2)+1:end),'r'); axis('tight');
    ax=axis; hold on; 
    plot([nY1 nY1],ax(3:4),'g--',[nYE1 nYE1],ax(3:4),'r--',[nYf nYf],ax(3:4),'g--',[nYEf nYEf],ax(3:4),'r--'); 
    hold off; 
    xlabel(sprintf('Kan.%d %s_{MTF}=[%d %d]; %s_B=[%d %d]',nrGest,txtau,nY1-1,nYE1-1,txtau,del(1),del(2))); 
    subplot(4,4,2); title('Zestawienie estymat trendu wolnego: yTrc(Y)_b, yTrc(Y^2)_k, yTrB(Y)_m, yTrB(Y^2)_r');
    subplot(4,4,8+nrs); 
    dTr(Nf)=0;  dTr(nY1:nYf)=STrd(nrGest,1).yTrc(2,nY1:nYf)-STrd(nrGest,1).yTrc(1,nY1:nYf); 
    dTrB(Nf)=0; dTrB(nYE1:nYEf)=STrd(nrGest,1).yTrc(2,nYE1:nYEf)-STrd(nrGest,1).yTrB(2,[nYE1:nYEf]+del(2));
    plot(1:Nf,dTr,'k',1:Nf,dTrB,'r'); axis('tight');% dTr/STrd(1,1).SigyTr(2))
    xlabel(sprintf('Kan.%d: [yTr2-yTr1]_k i [yTr2-yTrB2(+%s_B)]_r',nrGest,txtau)); 
    ax=axis; hold on; 
    plot([nY1 nY1],ax(3:4),'g--',[nYE1 nYE1],ax(3:4),'r--',[nYf nYf],ax(3:4),'g--',[nYEf nYEf],ax(3:4),'r--'); 
    hold off; 
    fprintf(1,'\nSzereg %d. Czas obliczeñ: %.2f sek.',nrs,toc(tKanal));
 end %Lgestow
return
%% ================= Sprawdzenie filtracji Fzwdc: yTrc wg Fzwdc, yTr - metod¹ dwuetapow¹ Fzwd i Fzw2 ============  
m=1; yTrc=[];for(n=LzwcE:Nf) yTrc(m)=Yoryg(n-LzwcE+1:n)'*FzwcE; m=m+1; end
nYTr1=(LzwcE-1)/2; nYTrf=nYTr1+length(yTrc); nYTr1=nYTr1+1;
if(wgEn) yTrc=sign(yTrc).*(abs(yTrc).^(1/Ewykl))+meanYoryg; yTr=sign(yTr).*(abs(yTr).^(1/Ewykl))+meanYoryg; end
figure(2); subplot(1,1,1); plot(nYTr1:nYTrf, yTrc,'r',nY1Tr:nYfTr, yTr,'k'); axis('tight');
nx=find(abs(yTrc(1:length(yTr))-yTr)>1.e-8); mm=length(nx),
% ...... Dokladna prezentacja filtru dolnego MTF:
figure(2);lA=round(0.3*lAx); x=wTuf*[0:lA-1]; plot(x,Afdd(1:lA),'r--',x,Afdg(1:lA),'m--',x,Afd(1:lA),'r'); axis('tight'); ax=axis; hold on; plot([1 1],ax(3:4),'b--'); hold off;
c=1; %% ========================================================================================================= 
sgtitle(sprintf('Takcji=%d', Takcji));%/nCzerwony zaporowy/n szerokoprzepustowy/n poprawka
sgtitle(sprintf('Surowe Dane'));%/nCzerwony zaporowy/n szerokoprzepustowy/n poprawka
figPW;
% zapiszFig('3');
% Test widma: Tw.Parsevala - energia sygnaÅ‚u=Å›rednia(widma mocy): 
% sum(x(0:N-1).^2)=N*mean(x)^2+N/2*sum(Apm^2(i=1:N/2))=mean(Af^2(1:N))=2*mean((Amp*N/2)^2(1:N/2)); Amp=Af*2/N   
% N=408000; t=0:N-1; y=50+100*(sin(2*pi/200*t)+sin(2*pi/10*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=2; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(K*N);
% x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*200/(N-1),As(x+1),'b',xn*200/(K*N-1),Asn(xn+1));
%m=20/(200/(K*N-1)); [Asn([round(m/10)+[-3:3]]+1); Asn([round(m)+[-3:3]]+1)]

%T0=50; T1=5; N=10*T0; t=0:N-1; y=50+100*(sin(2*pi/T0*t)+sin(2*pi/T1*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=200; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(N);
%x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*T0/(N-1),As(x+1),'b',xn*T0/(K*N-1),Asn(xn+1));

%sigyA=sqrt(mean(Afs.^2)/N/N); sigy=std(y); % Mamy rÃ³wnoÅ›Ä‡ mean(Afs.^2)=2*mean(Afs(x+1).^2)
%[Fzwd2, afB, AmpB, Phase,ihP,iA02,tauhP,tauA02,tauTu]=designButter(Tud,5,lT,wPol);
% Przyk³ad syntezy z wykresami:
%% designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b Ffd(:,N2d)_m Ffc_{c--}',Fzwd,Fzwc, Ffd(:,length(Ffd(1,:))), Ffc);
%  designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b ',Fzwd,Fzwc); %