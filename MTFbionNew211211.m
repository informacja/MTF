% widmo mocy, porownywane rendow% suma kwadratow roznic
clear all;  tStart = tic;
Takcji = 5000; %5*392;
Symul = 0; wgEnerg = 1; Integr = 1; BigData = 0; BSS = 0;  % sourse of data (from DB or one file
% Integr=0 sygnał pomiarowy bez zsumowania (orygin.); Integr=1 sygnał pomiarowy zsumowany;
% wgEnerg=0 synal przetw. wg Integr jest filtrowany i liczony tylko raz;
% wgEnerg>0 synal przetw. wg Integr jest filtrowany, a potem liczymy Y^2 (liczony dwa razy)
if (Integr) tauf = 40; else tauf = 200; end
nowy = 1;

if (Symul)
    Lszer = 3; Ldsz = 2 * 4096; ldC = Ldsz; SZEREGI = randn(Ldsz, Lszer); bezLpred = 0;
    Ld0 = Takcji / 10; Ldf = Ldsz - Ld0; sLd = Ldf / 6; x = ([1:Ldf]) / sLd; f = (x.^2) .* exp(- ((x - 1).^2) / 2); f = 2 * (f - (f(end) - f(1)) / (length(x)) * x * sLd);
    for (i = 1:Lszer) SZEREGI(Ld0 + 1:Ldsz, i) = SZEREGI(Ld0 + 1:Ldsz, i) + f'; end
    %xf=[[1:Ld0]/sLd x]; figure(1); plot(xf,SZEREGI(:,1),'c',Ld0/sLd+x,f,'k'); axis('tight')
    nrwykr = 1:Lszer; %[1:Ldsz];
    tx = sprintf('Badany sygnal SYMULOWANY Ysyg(%d)', Ldsz);
else
    wczytajEMG;
    [Ldsz Lszer] = size(data); ldC = Ldsz;
    SZEREGI = data;
    bezLpred = 0;
    Ld0 = Takcji / 10; Ldf = Ldsz - Ld0; sLd = Ldf / 6; x = ([1:Ldf]) / sLd; f = (x.^2) .* exp(- ((x - 1).^2) / 2); f = 2 * (f - (f(end) - f(1)) / (length(x)) * x * sLd);
    %or(i=1:Lszer) SZEREGI(Ld0+1:Ldsz,i)=SZEREGI(Ld0+1:Ldsz,i)+f'; end
    nrwykr = 1:Lszer; %[1:Ldsz];
    alfa = 1 - 1 / tauf; %0; %400; %200;
end

Lk = 0; nfig0 = 2;
% ====== Parametry MTF ===============
% Tu okres skĹ‚adowej cyklicznej - szerokoĹ›Ä‡ pasma filtru MTF
% Takcji - liczba prĂłbek w jednej akcji
LFg = 2; LFd = 2;
Tud = Takcji / (12); Tud = Takcji / (13); %Tud=Takcji/(10);
Tud1 = Tud / 1.2; %tu średniania trendu
TuG = Tud * [1/2 1/3 1/10]; TuG = Tud * [1/10 1/12 1/10]; TuG = Tud * [1/5 1/6 1/10]; TuG = Tud * [1/4 1/5 1/10]; %13.5]; % LFg=2 bÄ™dÄ… dwa filtry Tug
TR = Tud; % Truchu=Takcji/12;
% ................ #Wybor typu filtru .......................
typMTF = [5 5 5 3]; % typ filtru: 3 - Z1 - filtr koncowy zwykly; 5 - z3 - trend 3.go rzÄ™du
typFf = 1; % - typ filtru konc.: 0 nowy, 1 zwykly
% =============== Parametry szergu i filtra ==============
LSzeregow = length(nrwykr); % liczba badanych szeregĂłw
Lk = 0; Lgestow=round(LSzeregow/2*2); Losob=1; %Losob = size(SZEREGI,2)/8; Lgestow = LSzeregow/8;  %LC = LSzeregow;Lgestow = round(LC / 2); Losob = 2;
nfig = nfig0; nFig = nfig0 + 1 + Lgestow;
% ========================================================
%ntypZ=typMTF(nrVar);  % ===== Typ filtru ============= 2 klasyczny, 3 trend lin.; 5 trend 3.rzÄ™du
Ffzwykly = 1; % =1 filtr koncowy bez modyfikacji, =0 filtr koncowy skompresowany i dopeln.Regresja
% =============================================
close all;
druktx = sprintf('\nLk=%3d. Nr ostatniej probki szeregu ldC=Nmax=%d', Lk + 1, ldC);
Nmax = length(SZEREGI(:, 1));
fprintf(1, '%s: ', druktx); fprintf(1, '\nTu_d=%d Tu_g=%d %d Nmax=%d', round(Tud), round(TuG(1)), round(TuG(LFg)), Nmax);
if (wgEnerg > 0) LwgE = 1; lcol = 4; else LwgE = 0; lcol = 2; end
Kolor = 'kbrmgc'; figX = 0.00; figY = -0.00; Xkonc = 0.80; Ykonc = 0.8; trendTab = [];

Nwin = 512; kaiser(128,18);
fpr = 2048;
Nfft = fpr/2;
k    = 16;
for( person = 1:size(SZEREGI,2)/8 )
    f=figure(19+person); 
    for (ch = 1:8)
        subplot(4,2,ch); spectrogram(SZEREGI(:,ch*person), kaiser(Nwin,k), Nwin - k, Nfft, fpr, 'yaxis');
    end
    set(f,'WindowState','maximized'); if(person==1) sgtitle(fnames); else sgtitle(fnames2); end
    figPW('kaiser',person,'png','figury/win/');
end

for (nrs = 1:Lgestow) %2:2) % Petla po szeregach
    nowy = 1;
    nfig = nfig + 1;

    if (0)
        figpos = {'north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest', 'center', 'onscreen'};
        nrfig = figure(nfig); movegui(cell2mat(figpos(mod(nfig, length(figpos) - 1) + 1)));
    else
        figpos = {'north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest', 'center', 'onscreen'};
        nrfig = figure(nfig); %movegui( cell2mat(figpos(mod(nfig,length(figpos)-1)+1)) );
        fig = gcf; set(fig, 'Units', 'normalized', 'Position', [figX figY Xkonc Xkonc]); figX = figX + 0.01; figY = figY - 0.01;
%         nrfig = figure(nfig); %m
%         Fig = gcf; set(Fig, 'Units', 'normalized', 'Position', [Lgestow * 0.01 -Lgestow * 0.01 Xkonc Xkonc]);
    end

    nOs1 = 1; dno = 1; nOsf = Losob;

    for (nosoby = nOs1:dno:nOsf)
        txtyt = []; tic;
        nrS = (nosoby - 1) * Lgestow + nrwykr(nrs);
        nrPliku = 1; nrKol = nrs;
        if (exist('nazwy')) nplik = nazwy(nrS, :); else nplik = sprintf('Series%d', nrS); end
        %hf=figure(nfig); set(hf, 'Position',[388 122 1273 804]); %[163 153 1273 804]);%[184 39 1682 1071]); %[184 106 1584 1004]); %[184 63 1112 1047]);
        txg = sprintf('SZEREG(1:%d,%d) z pliku %s', Ldsz, nrS, fnames);

        for (wgEn = 0:LwgE)
            nCol = 8 * (wgEn) + nrs;
            Yorsum = SZEREGI(:, nrS);

            if (Integr)
                txY = 'Sygnal zsumowany';
                Yorsum(1) = Yorsum(2); for(n = 2:Ldsz) Yorsum(n) = Yorsum(n - 1) + Yorsum(n); end
            else txY = 'Sygnal oryginay';
            end

            Yoryg = Yorsum;

            if (wgEn == 0)
                y0 = Yoryg(1); for(n = 1:Ldsz) Yoryg(n) = y0 * alfa + Yoryg(n); y0 = Yoryg(n); end
                txspac = '                                     ';
                tx = sprintf('Sygnal SKUMULOWANY Y(n)=Y(n-1)*alfa+Sygn(n), alfa=%.4f', alfa);
            else if(wgEn > 0)
                    if (wgEnerg > 1) y0 = Yoryg(1); for(n = 1:Ldsz) Yoryg(n) = y0 * alfa + Yoryg(n); y0 = Yoryg(n); end, end
                    Yoryg = Yoryg.^2;
                    tx = sprintf('Sygnal ENERGII Y=Sygn^2'); txspac = '';
            end

            end

              % ----------- Określenie zakresu lT analizy widm (tak aby dobrze spróbkować widmo) 
            lTx=Tud*200; lTx=Tud*500; %1000;
            nTx=ceil(lTx/4096); lT=nTx*4096%*4096; %500; %350; %75; %round(lA/10);
            % ----------------------------------------------------------------------------------  
            
            filtracja
            %nTug1=npC; nTugf=NfC; nY1=npC; nTugf=NfC;
            Nx = Nakt;
            %figure(nfig);
            ncol = wgEn * 2 + 1;

            if (wgEn == 0 && nosoby == nOs1)
                figure(nfig);
                subplot(4, 4, 1); %subplot(4,lcol,ncol);
                plot(1:Ldsz, SZEREGI(:, nrS), 'k'); axis('tight'); ax = axis; hold on;
                plot([nY1Tr nY1Tr], ax(3:4), 'r--', [nYfTr nYfTr], ax(3:4), 'r--', [nY1 nY1], ax(3:4), 'g--', [nYf nYf], ax(3:4), 'g--'),
                title(txg); xlabel(sprintf('Sygnal zmierzony 1:%d', Ldsz));
                hold off;
                subplot(4, 4, 2); %subplot(4,lcol,ncol);
                plot(1:Ldsz, Yorsum, 'k'); axis('tight'); ax = axis; hold on;
                plot([nY1Tr nY1Tr], ax(3:4), 'r--', [nYfTr nYfTr], ax(3:4), 'r--', [nY1 nY1], ax(3:4), 'g--', [nYf nYf], ax(3:4), 'g--'),
                hold off;
                xlabel(sprintf('%s(1:%d)', txY, Ldsz));
            end

            if (nosoby == nOs1)
                figure(nfig);
                subplot(4, lcol, lcol + ncol);
                %plot([nY1Tr:nYfTr],Yoryg(nY1Tr:nYfTr),'k',[nY1Tr:nYfTr],yTr,'g'), axis('tight');
                plot([1:Nf], Yoryg, 'k', [1:Nf], yTrf, 'r'), axis('tight');
                ax = axis; hold on;
                plot([nY1 nY1], ax(3:4), 'g--', [nYf nYf], ax(3:4), 'g--', [nY1Tr nY1Tr], ax(3:4), 'r--', [nYfTr nYfTr], ax(3:4), 'r--');
                txOs = sprintf('Osoba %d ', nosoby);
                title([txspac txOs tx]); hold off
                xlabel(sprintf('Trend(g) i Yoryg(%d:%d)(k)', nY1Tr, nYfTr));
            end

            figure(nFig); subplot(4, lcol, nCol); kol = Kolor(nosoby);
            if (nosoby == nOs1) SrYtr(wgEn + 1) = mean(yTr); SigyTr(wgEn + 1) = std(yTr); end
            sygnTr = (yTr - mean(yTr)) / SigyTr(wgEn + 1) + SrYtr(wgEn + 1);
            sygnTrf = (yTrf - mean(yTrf)) / SigyTr(wgEn + 1) + SrYtr(wgEn + 1);

            for (nF = 1:2)

                if (nowy == 0) hold on; end,
                plot([nY1Tr:nYfTr], sygnTr, kol), axis('tight'); hold on; ax = axis;
                plot([1:nY1 - npC], sygnTrf(1:nY1 - npC), 'r', [nYf + N2 + 1:Nf], sygnTrf(nYf + N2 + 1:Nf), 'r');
               
                if (nowy)
                    plot([nY1 nY1], ax(3:4), 'g--', [nYf nYf], ax(3:4), 'g--', [nY1Tr nY1Tr], ax(3:4), 'r--', [nYfTr nYfTr], ax(3:4), 'r--');
                    xlabel(sprintf('Kanal %d: yTr(%d:%d)', nrwykr(nrs), nY1Tr, nYfTr));
                    if (nF == 1 && nrs == 2) title([tx '  ' txg]); end
                end

                hold off;

                if (nF == 1)
                    if (nosoby ~= nOs1) break; end
                    figure(nfig); subplot(4, lcol, 2 * lcol + ncol);
                    sygnTr = yTr; sygnTrf = yTrf;
                    %else if(nosoby~=nOs1) break; end 
                    trendTab = [ trendTab; [sygnTrf(1:nY1 - npC) sygnTr sygnTrf(nYf + N2 + 1:Nf)]];
                end

            end

            sygnTrf = [];

            if (nosoby == nOs1)
                figure(nfig);
                subplot(4, lcol, 3 * lcol + ncol);

                if (nowy) hold off; end,
                plot([nY1 - npC + 1:nYf + N2], yf, kol);
                axis('tight'); ax = axis; axis([1 Nf ax(3:4)]); hold on; %plot([N1 N1],ax(3:4),'r--', [Nakt - N2 Nakt - N2], ax(3:4), 'r--'); hold off;
                plot([nY1 nY1], ax(3:4), 'g--', [nYf nYf], ax(3:4), 'g--', [nY1Tr nY1Tr], ax(3:4), 'r--', [nYfTr nYfTr], ax(3:4), 'r--');
                %hold off;
                xlabel(sprintf('Skladowa srodkowoczest. yf(%d:%d)', nY1 - npC + 1, nYf + N2));
            end

            % ============== Liczymy widmo w segmencie centralnym ====================================
            if(0) % To juz zrobione przed filtracja;
                lTx=Tu*200; lTx=Tu*500; %1000;
                nTx=ceil(lTx/4096); lT=nTx*4096; %500; %350; %75; %round(lA/10);
            end
            lfA = lT / MTud; Tu = Tud / 5; lfA = lT / Tud;
            Tu = Tud / MTud * lfA; % PrzedziaĹ‚ wygĹ‚adzania widma
            wAx = 1;
            wY = [yf(npC:NfC)]; lw = length(wY); EnYf = mean(yf(npC:NfC).^2);
            wY = [wY zeros(1, lT - lw)]; % Uwaga !!! dopisanie zer nie zmienia energii sygnaĹ‚u, a zagÄ™szcza obliczane czÄ™stoĹ›ci !!
            Ay = abs(fft(wY)); %A=abs(fft(Fzw'));
            EnAy = (mean(Ay.^2));
            lT = length(wY); lA = round(lT / 2); Ayf = Ay(1:lA); %/lT; %lA=lA-1;
            % ---------- WygĹ‚adzanie widm filtra Fzw i sygnaĹ‚u Yoryg ----------------------
            % Ayf widmo obliczone sygnału srednioczęstotliwośc. yf - po filtracji Afc
            % ================ Synteza filtra dla widma amplit. ===============
            ntypZ = typMTF(1); %Taki sam typ jak dla filtra dolnego Tud;
            lYo = length(Yoryg(nY1:nYf)); EnY = mean(Yoryg(nY1:nYf) .* Yoryg(nY1:nYf));
            % Uwaga !!! dopisanie dowolnej liczby zer nie zmienia energii sygnaĹ‚u, a zagÄ™szcza obliczane czÄ™stoĹ›ci !!
            bezTrendu = 2; jestAyo2 = 0;

            if (bezTrendu)
                jestAyo2 = 1; Lfw = 2;
                AYreszt = abs(fft([(Yoryg(nY1Tr:nYfTr)' - yTr) zeros(1, lT - lYo)]));
                AYor = abs(fft([Yoryg(nY1:nYf)' zeros(1, lT - lYo)]));

                if (bezTrendu > 1) fx = yTr; else fx = yTr(nY1:nYf); end,
                ATr = abs(fft([fx zeros(1, lT - length(fx))]));
            else Lfw = 1; AYor = abs(fft([Yoryg(nY1:nYf)' zeros(1, lT - lYo)]));
            end % AYor obliczone widmo reszt trendu

            if (jestAyo2) Yo2 = [0 AYor(2:end).^2]; else Yo2 = [0 AYor(2:end)]; end,
            Y = Ayf; Ll = 1; N = length(Y);
            Y2 = Ayf.^2; Nakt = N;
            NfC = Nakt - N2; % koniec segmentu centralnego

            for (nfw = 1:Lfw)
                if (~isempty(MTF(ntypZ, LFg + 1 + nfw).M) & MTF(ntypZ, LFg + 1 + nfw).Tu ~= Tu) MTF(ntypZ, LFg + 1 + nfw).M = []; end

                if (isempty(MTF(ntypZ, LFg + 1 + nfw).M))
                    [M, F0, Fzw, Ff, Ffshf, ktory] = MTFdesign(ntypZ, Tu);
                    [lf, N1] = size(F0); [lf, N2] = size(Ff); N1f = N1 + 1; nh1 = M / Tu;
                    MTF(ntypZ, LFg + 1 + nfw).Tu = Tu; MTF(ntypZ, LFg + 1 + nfw).M = M; MTF(ntypZ, LFg + 1 + nfw).F0 = F0; MTF(ntypZ, LFg + 1 + nfw).Fzw = Fzw; MTF(ntypZ, LFg + 1 + nfw).Ff = Ff; MTF(ntypZ, LFg + 1 + nfw).Ffshf = Ffshf;
                    %MTF(ntypZ,LFg+1+nfw).ktory=ktory; MTF(ntypZ,LFg+1+nfw).nh1=nh1;
                    %MTF(ntypZ,LFg+1+nfw).N1=N1; MTF(ntypZ,LFg+1+nfw).N2=N2; MTF(ntypZ,LFg+1+nfw).lf=lf;
                else
                    M = MTF(ntypZ, LFg + 1 + nfw).M; F0 = MTF(ntypZ, LFg + 1 + nfw).F0; Fzw = MTF(ntypZ, LFg + 1 + nfw).Fzw; Ff = MTF(ntypZ, LFg + 1 + nfw).Ff; Ffshf = MTF(ntypZ, LFg + 1 + nfw).Ffshf;
                    %ktory=MTF(ntypZ,LFg+1+nfw).ktory; nh1=MTF(ntypZ,LFg+1+nfw).nh1; N1=MTF(ntypZ,LFg+1+nfw).N1; N2=MTF(ntypZ,LFg+1+nfw).N2; lf=MTF(ntypZ,LFg+1+nfw).lf;
                    [lf, N1] = size(F0); [lf, N2] = size(Ff); N1f = N1 + 1; nh1 = M / Tu;
                end

                fprintf(1, '\nCzas syntezy =%.2f s', toc); tic;
                Lf = M - 1; NfCx = Nakt - N2;
                % ---------- Filtracja w segmencie startowym ---------------------------------------------
                AYo = Yo2(1:lf) * F0;

                if (nfw == 1)
                    Af = Y(1:lf) * F0; Af(1) = 0; fA = Af;
                    Af2 = Y2(1:lf) * F0; Af2(1) = 0; fA2 = Af2; %Y(1);
                    fAYo = AYo;

                    for (n = N1:-1:1)
                        m = N1 - n; i = n + floor(0.15 * m);

                        if (i - n > 1)

                            for (k = n + 1:i)

                                if (nfw == 1)
                                    Af(k) = fA(n) + (Af(i + 1) - fA(n)) / (i + 1 - n) * (k - n);
                                    Af2(k) = fA2(n) + (Af2(i + 1) - fA2(n)) / (i + 1 - n) * (k - n);
                                end

                                AYo(k) = fAYo(n) + (AYo(i + 1) - fAYo(n)) / (i + 1 - n) * (k - n);
                            end,
                        else if(nfw == 1) Af(i) = fA(n); Af2(i) = fA2(n); end, AYo(i) = fAYo(n);
                        end,
                    end, if(nfw == 2) figure(1); plot([1:N1], fAYo, 'r', [1:N1], AYo, 'k'); end
                    % ========== Filtracja centralna ========
                end

                n0Fzw = 0; npC = N1 + 1; %Lf+1; %=M poczatek segmentu centralnego

                for (n = npC:Nakt - N2)
                    n1Fzw = n0Fzw + 1;
                    if (nfw == 1) Af(n) = Y(n1Fzw:n0Fzw + lf) * Fzw; Af2(n) = Y2(n1Fzw:n0Fzw + lf) * Fzw; end
                    AYo(n) = Yo2(n1Fzw:n0Fzw + lf) * Fzw;
                    n0Fzw = n1Fzw;
                end;

                % Af wygładzone widmo Ayf; Af2 wygładzone widmo Ayf^2; Ayo wygładzone widmo
                % AYor obliczone widmo reszt trendu; % AYo wygladzone widmo Ayor reszt trendu
                % ----- Teraz ruchoma sekcja koncowa -------------------------
                n0Fzw = n0Fzw - 1; % wracamy do wartosci koncowej, bo to filtry koncowe
                n1Fzw = n0Fzw + 1; ldFzw = lf;
                % --------- liczymy sekcje koncowa skompresowana -----------------
                if (Ffzwykly)

                    if (nfw == 1)
                        Af(NfCx + 1:Nakt) = Y(n1Fzw:n0Fzw + ldFzw) * Ff;
                        Af2(NfCx + 1:Nakt) = Y2(n1Fzw:n0Fzw + ldFzw) * Ff;
                    end

                    AYo(NfCx + 1:Nakt) = Yo2(n1Fzw:n0Fzw + ldFzw) * Ff;
                end

                if (nfw == 1) nx = find(Af2 < 0); Af2(nx) = 0; Afm = sqrt(Af2); end, nx = find(AYo < 0); AYo(nx) = 0;
                if (jestAyo2) AYo = sqrt(AYo); end, %if(nfw==1) AYo(1)=AYor(1); else AYo(1)=ATr(1); end
                % ------------------ drugi filtr wygĹ‚adzajÄ…cy -----
                if (nfw == 1) AYo(1) = AYor(1); AYog = AYo; else AYo(1) = ATr(1); AYoTr = AYo; end
                AYo = [];
                % Af wygładzone widmo Ayf; Af2 wygładzone widmo Ayf^2;
                % AYor obliczone widmo reszt trendu; AYog wygładzone widmo AYor
                % ATr obliczone widmo trendu; AYoTr wygladzone widmo ATr trendu
                Tu = 6; %Tud/20; % MTud*lfA; % Przedział‚ wygładzania widma trendu

                if (bezTrendu)
                    jestAyo2 = 0; Lfw = 2;

                    if (jestAyo2) Yo2 = ATr.^2; else Yo2 = ATr; end,
                    N = length(Yo2);
                    %AYor=abs(fft([(Yoryg(nY1:nYf)'-yTr(nY1:nYf)) zeros(1,lT-lYo)]));
                    %if(bezTrendu>1) fx=yTr; else fx=yTr(nY1:nYf); end,  ATr=abs(fft([fx zeros(1,lT-length(fx))]));
                else break; % Lfw=1; AYor=abs(fft([Yoryg(nY1:nYf)' zeros(1,lT-lYo)]));
                end

            end

            AYo = AYog; %AYog=[];
            Tu = Tud / MTud * lfA; % Ponownie przedziaĹ‚ wygĹ‚adzania widma reszt trendu
            % Widma amplitudowe filtrĂłw
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
                    Afg0=abs(fft([Fzwg0' zeros(1,lT-length(Fzwg2))]));
                    Afg0=Afg0(x);
                 end
                EnAfc=mean(Afc.^2); %(2*sum(Afc.^2)/lT);
                for(i=1:lT) if(Afd(i)>=1/sqrt(2)); ihP=i; else break; end; end, wPol=2*ihP/lT; 
                if(0)
                    [bfB, afB, AmpB, Phase,ihPB,iA02,tauhP,tauA02,tauTu]=designButter(Tud,5,lT,wPol);
                    % Przykład syntezy z wykresami: 
                    %% designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b Ffd(:,N2d)_m Ffc_{c--}',Fzwd,Fzwc, Ffd(:,length(Ffd(1,:))), Ffc);
                    %  designButter(Tud,[3 4 5],lT,wPol,1,'cgkrbm','Charakt.Bodego dla filtrow Butter(3 4 5)_{cgk} i MTF: Fzwd_r Fzwc_b ',Fzwd,Fzwc); %
                end
            end
            % ==== Filtracja Butter ======================
            Ka=length(afB); Kb=length(bfB); 
            yTrB(1:Kb,1)=zeros(Kb,1); NB=length(Yoryg);
            for(n=Kb+1:NB) yTrB(n,1)=-afB(2:Ka)*yTrB(n-[1:Ka-1],1)+bfB(1:Kb)*Yoryg(n-[0:Kb-1],1); end, 
            ndel=round(tauhP); txtau='\tau';
            % ............... Teraz wykresy dla yTrB .....................
            figure(nFig); subplot(4,lcol,nCol); kol=Kolor(nosoby);
            sygnTr=(yTrB-mean(yTrB))/SigyTr(wgEn+1)+SrYtr(wgEn+1); 
            for(nF=1:2)
                %if(nowy) hold off; end, 
                hold on; plot([nY1Tr:nYfTr]-ndel,sygnTr(nY1Tr:nYfTr),[kol '--']);
                if(nF==2) plot([nY1Tr:nYfTr],sygnTr(nY1Tr:nYfTr),[kol '-.']), end
                plot([1:nY1Tr-ndel],sygnTr(ndel+1:nY1Tr),'g',[nYfTr+1:Nf]-ndel,sygnTr(nYfTr+1:NB),'g');
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
                    sygnTr=yTrB;
                %else if(nosoby~=nOs1) break; end
                end

            end

            if (nosoby == nOs1)
                figure(nfig);
                  subplot(4,lcol,lcol+ncol); kol=Kolor(nosoby);
                hold on; plot([1:Nf],yTrB,'g'); %plot([nY1Tr:nYfTr],yTrB(nY1Tr:nYfTr),'g'); 
                hold off;
                % ============================================
                figure(nfig); ncol=2*(wgEn+1); 
                lAx=lA; m=find(Af==max(Af)); nx=find(Af(m:end)<max(Af)/50); lAx=nx(1);
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

            if (wgEn == 0 && nosoby == nOs1)
                figure(nfig);
                subplot(4, 4, 3); %subplot(4,lcol,ncol); %subplot(2,2,2); %hold on;
                lAfd = floor(lAf / 7);
                plot(x(1:lAfd), Afd(1:lAfd), 'k', ihP * wTuf, Afd(ihP), 'k.', x(1:lAfd), AmpB(1:lAfd), 'r', ihPB * wTuf, AmpB(ihPB), 'r.'); %hold off; %,x,Afc1(1:lAf),'g');
                axis('tight'); ax = axis; hold on;
                TudG = TuG(1) / Tud;
                plot([1 1], ax(3:4), 'r--');
                hold off;
                txx = sprintf('Filtr dolny: k-MTF, r-Butter^5; A(T_d/T) T_d=%.0f', Tud);
                %if(LFg==2) txx=[txx sprintf(' T_{g2}=%.0f',TuG(2))]; end
                xlabel(txx); ylabel('Amplituda'); %title(tx);
                subplot(4, 4, 4); %subplot(4,lcol,ncol); %subplot(2,2,2); %hold on;
                y = SZEREGI(:, nosoby)'; z = Yorsum'; w = [y z];
                wMean = mean(w); wSigma = std(w);

                for (i = 1:length(y))
                    y(i) = (y(i) - wMean) / wSigma;
                    z(i) = (z(i) - wMean) / wSigma;
                end

                %                 sum(x(0:N-1).^2)=N*mean(x)^2+N/2*sum(Apm^2(1:N/2))=mean(Af^2(1:N))=2*mean((Amp*N/2)^2(1:N/2)); Amp=Af*2/N
                N = Ldsz; K = 1; %y=50+100*(sin(2*pi/200*t)+sin(2*pi/10*t));
                Afs = abs(fft([y zeros(1, (K - 1) * N)])); As = Afs * 2 / (N); Afn = abs(fft([z zeros(1, (K - 1) * N)])); Asn = Afn * 2 / (N);
                Afs = abs(fft(y)); As = Afs * 2 / (N); Afn = abs(fft(z)); Asn = Afn * 2 / (N);
                x1 = [0:round((N - 1) / 2)]; xn = [0:round((K * N - 1) / 2)];
                plot(xn * 2048 / (K * N - 1), Asn(xn + 1), 'r', x1 * 2048 / (K * N - 1), As(x1 + 1), 'k'); xlabel(sprintf('Spectrum: zmierzony(%d)_k,\n %s(%d)_r [Hz]', nosoby, txY, nrS)); axis('tight');

                %                 m=20/(2048/(K*N-1)); z = [Asn([round(m/10)+[-3:3]]+1); Asn([round(m)+[-3:3]]+1)];
                %                 N=10*T0;
                %                 T0=50; T1=5;  t=0:N-1; y=SZEREGI(:, 1)';  Afs=abs(fft(y)); As=Afs*2/(N); K=2048; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(N);
                %                 x1=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(12);
                %                 plot(xn*T0/(K*N-1),Asn(xn+1),'m', x1*T0/(N-1),As(x1+1),'b');

                %                 sigyA=sqrt(mean(Afs.^2)/N/N); sigy=std(y); % Mamy równoĹ›Ä‡ mean(Afs.^2)=2*mean(Afs(x+1).^2)
                %

                if (nrs == 1)
                    figure(18);
                    if (LFg == 2) plot(x, Afg2(1:lAf), 'b-.', x, Afg0(1:lAf), 'g-.'); hold on; end
                    if (LFd == 2) plot(x, Afdd(1:lAf), 'r--', x, Afdg(1:lAf), 'm:'); hold on; end
                    plot(x, Afd(1:lAf), 'r', x, Afg(1:lAf), 'b--', x, Afc(1:lAf), 'k'); hold off; %,x,Afc1(1:lAf),'g');
                    axis('tight'); ax = axis; hold on;
                    plot([1 1], ax(3:4), 'b-.', TudG * [1 1], ax(3:4), 'r-.');

                    if (LFg == 2) plot(Tud / TuG(2) * [1 1], ax(3:4), 'b-.'); end, hold off;
                    txx = sprintf('Ch.Ampl: f/f_d=T_g/T; T_d=%.0f T_g=%.0f', Tud, TuG(1));
                    if (LFg == 2) txx = [txx sprintf(' T_{g2}=%.0f', TuG(2))]; end
                    xlabel(txx); ylabel('Amplituda'); title('Synteza filtru');
                    legend('Afg2', 'Afg0', 'Afdd Lowpass1', 'Afdg korekta LP2', ...
                        'Afd złożenie dolnoprzepustowych', 'Afg HP', 'Afc właściwy')
                end
            end

            % ---------------- Przeliczenie skali widma --------------------------
            EnAy = mean(Ay.^2); EnwY = sum(wY .* wY); % EnAy=EnwY+1.4e-13; EnAfm/EnAyf=1.0058 % sprawdzone !!!!!!
            AfcY = AYor(1:length(Afc)) .* Afc; wxx = EnwY / EnY; % Nie uzywane !!!
            EnAfm = mean(Afm.^2); EnAyf = mean(Ayf.^2); %*2/EnAy-1, %[((mean(Afm.^2)/lT)/lT)/-1]
            % Generujemy wzorcowy/referencyjny sygnaĹ‚ wejĹ›ciowy i jego widmo AYr
            % AYr=abs(fft([ones(1,lw) zeros(1,lT-lw)])); wYr=sqrt(mean(AYr.^2));
            % UWAGA !!! dopisanie dowolnej liczby zer dla transformowanego szeregu nie zmienia energii sygnaĹ‚u, a zagÄ™szcza obliczane czÄ™stoĹ›ci widma !!
            % WspĂłĹ‚czynnik przeliczenia widma - wA=sqrt(energia sygnaĹ‚u orygin.), wA=wYr+eps
            % ZaleĹĽnoĹ›Ä‡: abs(FY)=abs((ar+j*ai)*(br+j*bi))=(A*B);
            wA = AYog(1:lAf); AYo = Afc(1:lAf) .* wA;
            if (bezTrendu) AYTr = AYo + AYoTr(1:lAf) .* Afc(1:lAf); AfTr = ATr(1:lAf) .* Afc(1:lAf); end
            % AYoTr wygladzone widmo ATr trendu
            % ........................................................................
            % Ayf(c) widmo obliczone sygnału srednioczęstotliwośc. yf - po filtracji Afc
            % Afm(r) - wygladzone widmo mocy obliczonej Ayf (z zachowaniem mocy lacznej, ale z niewielkÄ… odchyĹ‚kÄ… Ĺ›redniÄ…);
            % Af(m) wygładzone widmo Ayf - wygladzone widmo mocy obliczonej Ayf (z zachowaniem mocy lacznej, ale z niewielkÄ… odchyĹ‚kÄ… Ĺ›redniÄ…);;
            % Af2 wygładzone widmo Ayf^2; nie uzywane
            % AYor obliczone widmo sygnału Yoryg(nY1:nYf); (tylko do obliczeń)
            % AYo(k) widmo skl.srenioczęst.: wygładzone widmo AYor pomnożone przez filtr pasmowy Afc,
            % AfTr(g) inaczej policz. widmo ATr: ATr*Afc
            % AYTr(b) widmo całego sygn.użyt. AYo+Afc*AYoTr (inaczej oblicz. widmo AYo;
            if (nosoby == nOs1)
                figure(nfig);
                subplot(4, lcol, 3 * lcol + ncol); %subplot(2,2,4);
                plot(x, Ayf(1:lAx), 'c', x, Af(1:lAx), 'm--', x, Afm(1:lAx), 'r', x, AYo(1:lAf), 'k'), %x,Afc(1:lAf)*wd,'m:');
                axis('tight'); ax = axis; hold on;
                if (bezTrendu && 0) plot(x, AfTr(1:lAx), 'g', x, AYTr(1:lAx), 'b'); end
                plot(wTuf * [Lf - 1 Lf - 1], ax(3:4), 'k:', [1 1], ax(3:4), 'b-.', TudG * [1 1], ax(3:4), 'r-.');
                if (LFg == 2) plot(Tud / TuG(2) * [1 1], ax(3:4), 'b-.'); end
                xlabel(txx); ylabel('Amplituda'); xlabel('Widmo amlit.sklad.srednioczest. Ayf(f/f_g)');
                hold off;
                subplot(4, lcol, 2 * lcol + ncol); lATr = round(wTuf * lAx * 10);
                % ATr(r) obliczone widmo trendu;
                % AYoTr(k) wygladzone widmo ATr trendu (tylko do obliczeń)
                nM = find(AYoTr == max(AYoTr)); n0 = find(AYoTr(nM:end) < AYoTr(nM) / 50) + nM;
                xx = [1:n0(1)]; %xx=[1:round(length(AYoTr)/700)];
                %plot(wTuf*xx,AYoTr(xx),'k',wTuf*xx,ATr(xx),'r'); axis('tight');
                plot(wTuf * xx, AYog(xx) .* Afd(xx), 'k', wTuf * xx, ATr(xx), 'r'); axis('tight');

                if (max(wTuf * xx) >= 1) %TudG(1)/Tud)
                    ax = axis; hold on;
                    plot([1 1], ax(3:4), 'b-.');
                    hold off;
                end

                ylabel('Amplituda'); xlabel('Widmo amlit.trendu ATr(f/f_g)');
            end

            fprintf(1, '\nCzas obliczeń: %.2f', toc);
        end % wersja Y^2 Y

        nowy = 0;
    end %Losob

end %Lgestow

%% skala trendendów
trendTab;
figure(14); sgtitle(fnames);
% xX = max(max(trendTab));
% xN = min(min(trendTab));
nieparzyste =  1:2:length(trendTab(:,1))-1;
parzyste = 2:2:length(trendTab(:,1));
xIn = min(min(trendTab(nieparzyste,:))); xAn = max(max(trendTab(nieparzyste,:)));
xIp = min(min(trendTab(parzyste,:))); xAp = max(max(trendTab(parzyste,:)));
for( i = nieparzyste ) 
    myPlot(i, length(SZEREGI(:,1)), xIn, xAn ,trendTab)    ;
    if(i==1 || i==3) title('Skumulowany');
end

for( i = parzyste ) 
    myPlot(i, length(SZEREGI(:,1)), xIp, xAp,trendTab)    ;
    if(i==2 || i==4) title('Moc');
end 


%% ================= Sprawdzenie filtracji Fzwdc: yTrc wg Fzwdc, yTr - metodą dwuetapową Fzwd i Fzw2 ============
m = 1; yTrc = []; for(n = Lzwc:Nf) yTrc(m) = Yoryg(n - Lzwc + 1:n)' * Fzwc; m = m + 1; end
figure(1); subplot(1, 1, 1); plot(nY1Tr:nYfTr, yTrc, 'r', nY1Tr:nYfTr, yTr, 'k'); axis('tight');
nx = find(abs(yTrc(1:length(yTr)) - yTr) > 1.e-8); mm = length(nx); title('Sprawdzenie filtracji Fzwdc: ');
% ...... Dokladna prezentacja filtru dolnego MTF:
figure(2);lA=round(0.3*lAx); x=wTuf*[0:lA-1]; plot(x,Afdd(1:lA),'r--',x,Afdg(1:lA),'m--',x,Afd(1:lA),'r'); axis('tight'); ax=axis; hold on; plot([1 1],ax(3:4),'b--'); hold off;
c=1; %% ========================================================================================================= 
% sgtitle(sprintf('Trendy ')); %z Blind Source Separation /nCzerwony zaporowy/n szerokoprzepustowy/n poprawka
fprintf('\nCzas wykonywania obliczeń i rysowania: %gs', toc(tStart));

[path, filename, Fext] = fileparts(fnames);
figLetter = char(65+2^0*BSS+2^1*wgEnerg+2^2*Integr+2^3*BigData+2^4*Symul); char(65+figLetter); % figure countig num
figure(nFig); figPW(sprintf('%s_%s_S%dE%dI%dB%dfig', figLetter, filename, Symul, wgEnerg, Integr, BSS));
figure(11); figPW(sprintf('%s_%s_S%dE%dI%dB%dfig', figLetter, filename, Symul, wgEnerg, Integr, BSS), 11, 'fig', 'figury/', 2);

function myPlot( i, L, xN, xX,trendTab)
    if( i > 16 )
         figure(15); sgtitle(fnames2);
         i = i - 16;
    end
  subplot(4, 4, i);
    plot(trendTab(i,1:L)); axis('tight'); ax = axis;
    axis([ax(1:2) xN xX])
end
% zapiszFig('3');
% Test widma: Tw.Parsevala - energia sygnaĹ‚u=Ĺ›rednia(widma mocy):
% sum(x(0:N-1).^2)=N*mean(x)^2+N/2*sum(Apm^2(i=1:N/2))=mean(Af^2(1:N))=2*mean((Amp*N/2)^2(1:N/2)); Amp=Af*2/N
% N=408000; t=0:N-1; y=50+100*(sin(2*pi/200*t)+sin(2*pi/10*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=2; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(K*N);
% x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*200/(N-1),As(x+1),'b',xn*200/(K*N-1),Asn(xn+1));
%m=20/(200/(K*N-1)); [Asn([round(m/10)+[-3:3]]+1); Asn([round(m)+[-3:3]]+1)]

%T0=50; T1=5; N=10*T0; t=0:N-1; y=50+100*(sin(2*pi/T0*t)+sin(2*pi/T1*t)); Afs=abs(fft(y)); As=Afs*2/(N); K=200; Afn=abs(fft([y zeros(1,(K-1)*N)])); Asn=Afn*2/(N);
%x=[0:round((N-1)/2)]; xn=[0:round((K*N-1)/2)]; figure(1); plot(x*T0/(N-1),As(x+1),'b',xn*T0/(K*N-1),Asn(xn+1));

%sigyA=sqrt(mean(Afs.^2)/N/N); sigy=std(y); % Mamy rĂłwnoĹ›Ä‡ mean(Afs.^2)=2*mean(Afs(x+1).^2)
