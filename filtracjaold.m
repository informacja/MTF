    % =====================================
    if(~exist('MTF','var')) 
        MTF(11,1).M=[]; MTF(11,2).M=[]; MTF(11,3).M=[]; 
        if(LFg==2) MTF(11,4).M=[]; MTF(11,5).M=[]; end; 
    end  % Filtr jest projektowany tylko raz - dla kolejnych szeregów bierzemy ten sam
    if(~exist('MTFd','var')) 
        MTFd(11,1).M=[]; if(LFd==2) MTFd(11,2).M=[]; end, 
    end  % Filtr jest projektowany tylko raz - dla kolejnych szeregów bierzemy ten sam
    fprintf(1,'\nSzereg %d: Czas startu =%.2f s',nrS,toc); tic;
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
    Tu=Tud; ntypZ=typMTF(1);
    for(nrf=1:LFd)
        if(~isempty(MTFd(ntypZ,nrf).M)& MTFd(ntypZ,nrf).Tu~=Tu) MTFd(ntypZ,nrf).M=[]; end
        if(isempty(MTFd(ntypZ,nrf).M))
            [M, F0, Fzw, Ff, Ffshf,ktory]=MTFdesign(ntypZ, Tu);
            [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
            MTFd(ntypZ,nrf).Tu=Tu;MTFd(ntypZ,nrf).M=M; MTFd(ntypZ,nrf).F0=F0; MTFd(ntypZ,nrf).Fzw=Fzw;
            MTFd(ntypZ,nrf).Ff=Ff; MTFd(ntypZ,nrf).Ffshf=Ffshf;
            if(nrf==1) Fzwd=Fzw; MTud=M; else Fzwd2=Fzw; MTud2=M; end
        else
            M=MTFd(ntypZ,nrf).M; F0=MTFd(ntypZ,nrf).F0; Fzw=MTFd(ntypZ,nrf).Fzw; Ff=MTFd(ntypZ,nrf).Ff; Ffshf=MTFd(ntypZ,nrf).Ffshf;
            [lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
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
        yf=Y(1:lf)*F0; % od N1+l do Nakt-N2;
        % ========== Filtracja centralna ========
        n0Fzw=0; npC=Lf+1; nTud1=npC; nTudf=NfC; %=M poczatek segmentu centralnego
        for(n=npC:N-N2)
            n1Fzw=n0Fzw+1;
            yf(n)=Y(n1Fzw:n0Fzw+lf)*Fzw;
            n0Fzw=n1Fzw;
        end;
        % ----- Teraz ruchoma sekcja koncowa -------------------------
        n0Fzw=n0Fzw-1; % wracamy do wartosci koncowej, bo to filtry koncowe
        n1Fzw=n0Fzw+1; ldFzw=lf;
        % --------- liczymy sekcje koncowa  -----------------
        if(Ffzwykly)
            yf(NfC+1:N)=Y(n1Fzw:n0Fzw+ldFzw)*Ff;
        end
        if(LFd==2 && nrf==1) 
            Y=yf(npC:NfC); npC0=npC; NfC0=NfC; N=length(Y); 
            nY1=npC; nYf=NfC;
            Tu=Tud1;
        else nY1=nY1+npC-1; nYf=nYf-N2; yf=yf(npC:NfC); 
        end
    end
    yTr=yf; Nakt=N; nY1Tr=nY1; nYfTr=nYf;
    for(nfg=1:LFg)
        Tu=TuG(nfg); ntypZ=typMTF(nfg+1);
        Nx=Nakt;  fDyf=0;  
        if(nfg==1) 
            if(fDyf) Ysyg=Y(1:Nx);% yTr ca³y sygnal trendu 
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
        n0Fzw=0; npC=Lf+1; %=M poczatek segmentu centralnego
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
            end
        else nY1=nY1+npC-1; nYf=nYf-N2;  nTug1=npC; nTugf=NfC; 
        end
    end