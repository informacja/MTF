        % =====================================
        if(~exist('MTF','var'))
            MTF(11,1).M=[]; MTF(11,2).M=[]; MTF(11,3).M=[];
            if(LFg==2) MTF(11,4).M=[]; MTF(11,5).M=[]; end;
        end  % Filtr jest projektowany tylko raz - dla kolejnych szeregĂłw bierzemy ten sam
        if(~exist('MTFd','var'))
            MTFd(11,1).M=[]; if(LFd==2) MTFd(11,2).M=[]; end,
        end  % Filtr jest projektowany tylko raz - dla kolejnych szeregĂłw bierzemy ten sam
        fprintf(1,'\nSzereg %d: Czas startu =%.2f s',nrS,toc); tic; szerIndex = [szerIndex nrS];
        F0=[]; Fzw=[]; Ff=[]; Ffshf=[];
        for(nfg=1:LFg+1)
            Tu=TuG(nfg); ntypZ=typMTF(nfg+1);
            ntypZg=ntypZ;
            if(~isempty(MTF(ntypZ,1+nfg).M)& MTF(ntypZ,1+nfg).Tu~=Tu) MTF(ntypZ,1+nfg).M=[]; end
            if(isempty(MTF(ntypZ,1+nfg).M))
                [M, F0, Fzw, Ff, Ffshf,ktory]=MTFdesign(ntypZ, Tu);
                [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
                if(nfg<=LFg)
                    MTF(ntypZ,1+nfg).Tu=Tu;MTF(ntypZ,1+nfg).M=M; MTF(ntypZ,1+nfg).F0=F0;
                    MTF(ntypZ,1+nfg).Fzw=Fzw; MTF(ntypZ,1+nfg).Ff=Ff; MTF(ntypZ,1+nfg).Ffshf=Ffshf;
                    %MTF(ntypZ,1+nfg).ktory=ktory; MTF(ntypZ,1+nfg).nh1=nh1;
                    %MTF(ntypZ,1+nfg).N1=N1; MTF(ntypZ,1+nfg).N2=N2; MTF(ntypZ,1+nfg).lf=lf;
                end
                if(nfg==1) Fzwg=Fzw; else if(nfg==2) Fzwg2=Fzw; else Fzwg0=Fzw; end, end
            end
        end
        F0=[]; Fzw=[]; Ff=[]; Ffshf=[];
        Y=Yoryg'; Ll=1; N=length(Y);
        Nakt=N; nY1=1; nYf=N;
        NfC=Nakt-N2; NfCd=NfC; % koniec segmentu centralnego
        Tu=Tud; 
        % ============ Synteza filtrów dolnoprzepustowych MTFd i Butter5 ===================
        %  Wywołanie desMTFcButter() z parametrem figF=0 daje wynik bez wykresow charakterystyk Bodego 
        figF=111; % numer rysunku z wykresami Bodego 
        ntypZ=typMTF(1); rzadB=5;
        if(~isempty(MTFd(ntypZ,1).M)& MTFd(ntypZ,1).Tu~=Tu) MTFd(ntypZ,1).M=[]; end
        if(isempty(MTFd(ntypZ,1).M))
            if(0) % Liczenie z rysowaniem wszystkich charakterystyk
                [bfB, afB, tauhPf, MTFd, Fzwc, Ffc, LpFc, Amp, fi,  nA01, WcB, Fzwd, Fzwd2 Ff1 Ff2]=...
                    desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT,figF,'Synteza filtrow MTF (Fzws_b Ffc_r Fzwd_m Fzw2_g Ff1_c Ff2_{c--}) i Butter_k','kbrmgc');
            else % Tylko synteza filtrow Fzwc i Butter (szybka wersja)
                fname=sprintf('MTFd%d_%d_%d.mat',ntypZ,round(Tu), rzadB);
                fp=fopen(fname,'r');
                if(fp>1) fclose(fp);
                    load(fname);
                else
                    [bfB, afB, tauhPf, MTFd, Fzwc, Ffc, LpFc, Amp, fi,  nA01, WcB, Fzwd, Fzwd2]=desMTFcButter(ntypZ,[Tud Tud1],rzadB,lT); 
                    save(fname,'bfB', 'afB', 'tauhPf', 'MTFd', 'Fzwc', 'Ffc', 'LpFc', 'Amp', 'fi',  'nA01', 'WcB', 'Fzwd', 'Fzwd2');
                end
            end
            AmpB=Amp(1,:);
            Lzwc=LpFc(2); Lzwd=LpFc(4); Lzw2=LpFc(5); % długości filtrów Fzwc, Fzwd i Fzw2
            tauhP=-tauhPf(1); ihPB=-tauhPf(1); ihP=-tauhPf(2); iA01=nA01(2); wPol=2*ihP/lT;
        end
        % ............. Koniec syntezy filtrów dolnoprzepustowych MTFd i Butter5 ............  
        for(nrf=1:LFd)
            %if(~isempty(MTFd(ntypZ,nrf).M)& MTFd(ntypZ,nrf).Tu~=Tu) MTFd(ntypZ,nrf).M=[]; end
            if(0) %isempty(MTFd(ntypZ,nrf).M))
                [M, F0, Fzw, Ff, Ffshf,ktory]=MTFdesign(ntypZ, Tu);
                [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
                MTFd(ntypZ,nrf).Tu=Tu;MTFd(ntypZ,nrf).M=M; MTFd(ntypZ,nrf).F0=F0; MTFd(ntypZ,nrf).Fzw=Fzw;
                MTFd(ntypZ,nrf).Ff=Ff; MTFd(ntypZ,nrf).Ffshf=Ffshf;
                if(nrf==1) Fzwd=Fzw; MTud=M; Ffd=Ff; lfd=lf; N2d=length(Ffd(1,:));
                    if(LFd==1) Ffc=Ff; Ffd=[]; Fzwc=Fzwd; Lzwc=lfd; end
                else Fzwd2=Fzw; MTud2=M; 
                    % ================= Filtr koncowy ==================
                    Ff2=Ff(:,N2); Ff1=Ffd(:,N2d-N2:N2d); Nxd=N2+1;
                    %n=lfd; 
                    %w(n-N2:n)=Y(n-lfd+1:n)*Ff1(:,1:Nxd);
                    %yz(n)=w(n-N2:n)*Ff2(N2+1:lf,1);
                    Ffc=Ff1(:,1:Nxd)*Ff2(N2+1:lf,1); Ff1=[];
                    % ================= Filtr centralny ==================
                    if(0)
                        n=lfd+lf+20; w=[]; w1=[];
                        for(k=1:lf) w(n-lf+k:n)=Y(n-(lf+lfd)+k+1:n-lf+k)*Fzwd; end
                        for(k=1:lf) w1(n-lf+k:n)=Y(n-(lf+lfd)+2:n)*[zeros(k-1,1);Fzwd;zeros(lf-k,1)]; end
                        %yz(n)=w(n-lf+1:n)*Fzw(1:lf,1);
                    end
                    Lzwc=lf+lfd-1; Fzwc=zeros(Lzwc,1); %Fzwc1=zeros(Lzwc,1);  
                    for(m=1:lf+lfd-1) % obliczamy filtr Fzwc
                        %for(k=1:lf) W=[zeros(k-1,1);Fzwd;zeros(lf-k,1)]; Fzwc1(m)=Fzwc1(m)+W(m)*Fzw(k); end
                        for(k=1:lf) 
                            j=m-k+1; if(j<1) break; end, if(j>lfd) continue; end, 
                            Fzwc(m)=Fzwc(m)+Fzwd(j)*Fzw(k); 
                        end
                    end
                    nx=[]; %find(abs(Fzwc1-Fzwc)>1.e-8); 
                    if(length(nx)==0) Fzwc1=[]; W=[]; w=[]; w1=[]; end, % To znaczy, że jest OK !!
                end
            else
                M=MTFd(ntypZ,nrf).M; F0=MTFd(ntypZ,nrf).F0; Fzw=MTFd(ntypZ,nrf).Fzw; Ff=MTFd(ntypZ,nrf).Ff; Ffshf=MTFd(ntypZ,nrf).Ffshf;
                [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
                if(nrf==1) MTud=M; else MTud2=M; end
                %ktory=MTFd(ntypZ,nrf).ktory; nh1=MTFd(ntypZ,nrf).nh1; N1=MTFd(ntypZ,nrf).N1; N2=MTFd(ntypZ,nrf).N2; lf=MTFd(ntypZ,nrf).lf;
            end
            fprintf(1,'\nCzas syntezy =%.2f s',toc); tic;
            Lf=N2; lR=Lf-length(Ffshf(1,:))+1;
            Lf=M-1; NfC=N-N2;
            % ---------- Filtracja -----------------------
            nR=floor((N-2*N2)/TR);   % nR Liczba akcji w przedziale danych
            dnf=N-2*N2-round(nR*TR); % dnf - liczba danych, ktore opuszczamy z lewej do analizy harmonicznej, aby miec calkowita wielokr.Tu
            nR=floor((N-2*N2)/TR); Nr=nR*TR; n1=dnf+M; nf=round(n1+Nr-1);
            dnf=N-2*N2-round(nR*TR);
            nhR=floor((N-2*N2)/TR); Nr=nhR*TR; n1r=n1; nfr=nf;
            if(nfr~=NfC) fprintf(1,'\nNiezgodnosc nfr=%d NfC=%d',nfr,NfC); nfr=NfC; nf=NfC; end
            Tobl=(nfr-n1r+1)/nhR;
            % ---------- Filtracja w segmencie startowym ---------------------------------------------
            yf=Y(1:lf)*F0; if(nrf==2) yff=Yf(1:lf)*F0; end, % od N1+l do Nakt-N2;
            % ========== Filtracja centralna ========
            n0Fzw=0; npC=N1+1; %Lf+1;
            nTud1=npC; nTudf=NfC; %=M poczatek segmentu centralnego
            for(n=npC:N-N2)
                n1Fzw=n0Fzw+1;
                yf(n)=Y(n1Fzw:n0Fzw+lf)*Fzw; 
                n0Fzw=n1Fzw;
            end;
            if(nrf==2) 
                n0Fzwf=0; Nf=length(Yf); NfCf=Nf-N2;
                for(n=npC:Nf-N2)
                    n1Fzwf=n0Fzwf+1;
                    yff(n)=Yf(n1Fzwf:n0Fzwf+lf)*Fzw; 
                    n0Fzwf=n1Fzwf;
                end
                n0Fzwf=n0Fzwf-1; % wracamy do wartosci koncowej, bo to filtry koncowe
                n1Fzwf=n0Fzwf+1; 
            end;
            % ----- Teraz ruchoma sekcja koncowa -------------------------
            n0Fzw=n0Fzw-1; % wracamy do wartosci koncowej, bo to filtry koncowe
            n1Fzw=n0Fzw+1; ldFzw=lf;
            % --------- liczymy sekcje koncowa  -----------------
            if(Ffzwykly)
                yf(NfC+1:N)=Y(n1Fzw:n0Fzw+ldFzw)*Ff;
                n1Fzw=n0Fzw+lf;
                if(nrf==2) 
                    yff(NfCf+1:Nf)=Yf(n1Fzwf:n0Fzwf+ldFzw)*Ff;
                end
            end
            if(LFd==2 && nrf==1)
                Y=yf(npC:NfC); npC0=npC; NfC0=NfC; N=length(Y);
                nY1=npC; nYf=NfC;
                Tu=Tud1; 
            else nY1=nY1+npC-1; nYf=nYf-N2; yf=yf(npC:NfC);
            end
            if(nrf==1) Yf=yf; Nf=length(Yf); end
        end
        yTr=yf; if(LFd==2) yTrf=yff; else  yTrf=yf; end
        Nakt=N; nY1Tr=nY1; nYfTr=nYf;
        for(nfg=1:LFg)
            Tu=TuG(nfg); ntypZ=typMTF(nfg+1);
            Nx=Nakt;  fDyf=0;
            if(nfg==1)
                if(fDyf) Ysyg=Y(1:Nx);% yTr caĹ‚y sygnal trendu
                else Ysyg=Yoryg(nY1:nYf)'-yf; Nakt=length(Ysyg); Nx=Nakt;% Ysyg sygnal bez trendu do konca segmentu centralnego
                end,
            else Ysyg=yf(nTug1:nTugf); Nakt=length(Ysyg);
            end
            F0=MTF(ntypZ,1+nfg).F0; Fzw=MTF(ntypZ,1+nfg).Fzw; Ff=MTF(ntypZ,1+nfg).Ff; Ffshf=MTF(ntypZ,1+nfg).Ffshf;
            M=MTF(ntypZ,1+nfg).M;
            [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
            %ktory=MTF(ntypZ,2).ktory; nh1=MTF(ntypZ,2).nh1; N1=MTF(ntypZ,2).N1; N2=MTF(ntypZ,2).N2; lf=MTF(ntypZ,2).lf;
            NfC=Nakt-N2; % koniec segmentu centralnego
            % ---------- Filtracja w segmencie startowym ---------------------------------------------
            yf=Ysyg(1:lf)*F0;
            % ========== Filtracja centralna ========
            n0Fzw=0; npC=N1+1; %Lf+1; %=M poczatek segmentu centralnego
            for(n=npC:Nakt-N2)
                n1Fzw=n0Fzw+1;
                yf(n)=Ysyg(n1Fzw:n0Fzw+lf)*Fzw;
                n0Fzw=n1Fzw;
            end;
            % ----- Teraz ruchoma sekcja koncowa -------------------------
            n0Fzw=n0Fzw-1; % wracamy do wartosci koncowej, bo to filtry koncowe
            n1Fzw=n0Fzw+1; ldFzw=lf;
            % --------- liczymy sekcje koncowa  -----------------
            if(Ffzwykly)
                yf(NfC+1:Nakt)=Ysyg(n1Fzw:n0Fzw+ldFzw)*Ff;
            end
            if(nfg==1)
                if(fDyf) yf=yf-yTr; NfCg=NfC; nTug1=nTud1; nTugf=nTudf; nY1=nTud1; nYf=nTudf;
                else nTug1=npC; nTugf=Nakt-N2; nY1=nTud1+npC-1; nYf=nTudf-N2; %npC:Nakt-N2;
                    nY1=nY1Tr+npC-1; nYf=nYfTr-N2;
                end
            else nY1=nY1+npC-1; nYf=nYf-N2;  nTug1=npC; nTugf=NfC;
            end
        end