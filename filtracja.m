        % =====================================
        %fprintf(1,'\nSzereg %d: Czas startu =%.2f s',nrS,toc); 
        tic;
        F0=[]; Fzw=[]; Ff=[]; Ffshf=[];
        Y=Yoryg'; Ll=1; N=length(Y);
        if(wgEn>0) N2=MTFE(1).M-1; else N2=MTFd(1).M-1; end
        Nakt=N; nY1=1; nYf=N;
        NfC=Nakt-N2; NfCd=NfC; % koniec segmentu centralnego
        Tu=Tud; 
        % =========== Filtracja dolnoprzepustowa -----------------------
        for(nrf=1:LFd)
            if(wgEn>0)
                M=MTFE(nrf).M; Fzw=MTFE(nrf).Fzw;
                F0=MTFE(nrf).F0; Ff=MTFE(nrf).Ff;
                %[lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
            else
                M=MTFd(nrf).M; Fzw=MTFd(nrf).Fzw;
                F0=MTFd(nrf).F0; Ff=MTFd(nrf).Ff;
                %[lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/Tu;
            end
            if(nrf==1) MTud=M; else MTud2=M; end
                % Ffshf=MTFd(nrf).Ffshf;
                %ktory=MTFd(nrf).ktory; nh1=MTFd(nrf).nh1; N1=MTFd(nrf).N1; N2=MTFd(nrf).N2; lf=MTFd(nrf).lf;
            if(length(Fzw(1,:))>1) Fzw=Fzw'; end
            lf=length(Fzw); N1=M-1; N2=N1; 
            Lf=N2; 
            Lf=M-1; NfC=N-N2;
            % ---------- Filtracja -----------------------
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
        % =============== Filtracja gornoprzepustowa ==================
        yTr=yf; if(LFd==2) yTrf=yff; else  yTrf=yf; end
%         if(0) %wgEn) 
%             yTr=sign(yTr).*(abs(yTr).^(1/Ewykl))+meanYoryg; 
%             yTrf=sign(yTrf).*(abs(yTrf).^(1/Ewykl))+meanYoryg; 
%         end
        Nakt=N; nY1Tr=nY1; nYfTr=nYf;
        Nx=Nakt;  fDyf=0;
        for(nfg=1:LFg)
            %Tu=TuG(nfg); ntypZ=typMTF(nfg+1);
            %M=MTFg(nfg).M; Fzw=MTFg(nfg).Fzw; Ff=MTFg(nfg).Ff; F0=MTFg(nfg).F0; 
            %[M, Fzw, Ff, F0]=MTFdesign(ntypZ, Tu);
            if(nfg==1)
                if(fDyf) Ysyg=Y(1:Nx);% yTr caĹ‚y sygnal trendu
                else Ysyg=Yoryg(nY1:nYf)'-yf; Nakt=length(Ysyg); Nx=Nakt;% Ysyg sygnal bez trendu do konca segmentu centralnego
                end,
            else Ysyg=yf(nTug1:nTugf); Nakt=length(Ysyg);
            end
            if(wgEn>0)
                M=MTFEg(nfg).M; Fzw=MTFEg(nfg).Fzw; 
                Ff=MTFEg(nfg).Ff; F0=MTFEg(nfg).F0; 
                %if(length(Fzw(1,:))>1) Fzw=Fzw'; end
                %[lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; 
            else
                M=MTFg(nfg).M; Fzw=MTFg(nfg).Fzw;
                %[M, Fzw, Ff, F0]=MTFdesign(ntypZ, Tu);
               %Fzw=MTF(nfig).Fzw; M=MTF(nfig).M;
               F0=MTFg(nfg).F0; Ff=MTFg(nfg).Ff;
            end
            %if(nfg==1) Fzwg=Fzw; else if(nfg==2) Fzwg2=Fzw; else Fzwg0=Fzw; end, end
            if(length(Fzw(1,:))>1) Fzw=Fzw'; end
            N1=M-1; N2=N1; lf=length(Fzw); 
            %[lf,N1]=size(F0); [lf,N2]=size(Ff); N1f=N1+1; nh1=M/MTF(nrf).Tu;
            %  Ffshf=MTF(nfig).Ffshf;
            %ktory=MTF(2).ktory; nh1=MTF(2).nh1; N1=MTF(2).N1; N2=MTF(2).N2; lf=MTF(2).lf;
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