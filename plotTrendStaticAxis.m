function plotTrendStaticAxis( Lszer, L, trendTab)
% Lszer - liczba szeregów
% L - liczba kanałów
% trendTab - macierz trendów
    Kolor = 'kbrmgckbrmgc'; global szerIndex;   
    n = length(trendTab(1,:)); 
    if (Lszer == n) kolumn = 2; else kolumn = 4; end %enrgia
    rys = 4*kolumn; p = n/rys; % person
%     index = mod(szerIndex(i)-1, kolumn*2)+1;
% 
% dla n = lszer    
%     for r = 1:p
%     plot( nrRysunku + 8 )
% 
%     k = i;
% k * s = length trendTab
% 
nieparzyste =  1:2:length(trendTab(1,:))-1;
parzyste = 2:2:length(trendTab(1,:));

%  MAX = max(xAn,xAp); MIN = min(xIn,xIp);
xIn = min(min(trendTab(:,nieparzyste))); xAn = max(max(trendTab(:,nieparzyste))); % works
xIp = min(min(trendTab(:,parzyste))); xAp = max(max(trendTab(:,parzyste)));

% xmin = min(min(trendTab(:))); xmax = max(max(trendTab(:)));
% 
% szerIndex(ls)
%     for s = 1:p
%         COLOR(S)
    licznik2 = 0;
    plotNr = 1;
    title('skumulowany')
    for i = parzyste
        licznik2 = licznik2 +1;
        subplot(4,kolumn,plotNr);
        plot(trendTab(:,i), Kolor(mod(licznik2-1, p)+1) ); hold on; axis('tight');ax = axis; axis([ax(1:2) xIp xAp]); xlabel(sprintf('Kan: %d', plotNr));
        if (mod(licznik2, p) == 0) % modulo liczba osób
            plotNr = plotNr+1; 
        end; 
    end
    subplot(4,kolumn,1);title('Sygnał skumulowany trendu')

    for i = nieparzyste
        licznik2 = licznik2 +1;
        subplot(4,kolumn,plotNr); 
        plot(trendTab(:,i), Kolor(mod(licznik2-1, p)+1) ); hold on; axis('tight');ax = axis; axis([ax(1:2) xIn xAn]); xlabel(sprintf('Kan: %d', plotNr-8));
        if (mod(licznik2, p) == 0) % modulo liczba osób
            plotNr = plotNr+1; 
        end; 
    end

    if (Lszer < size(trendTab,2)) subplot(4,kolumn,9); title('Energia'); end
return
    ls = 0;
    for m = nieparzyste % energia
            ls = ls+1;
            b = mod(ls-1,3)+1;
%         for 3
            a = ceil(m/8)
%             i = m*(k-1)+s
            subplot(4, kolumn, a); 
%             [ls k s (szerIndex(ls))]
            plot(trendTab(:, m), Kolor(b)); hold on;
            ax = axis; axis([ax(1:2) xIn xAn]);
%         end
    end
        return
    for i = 1:kolumn/2 % skumul |& ener  
        for s = 1:p % liczba szeregow
          for k = 1:8% liczba kanałów lub liczba rys. energi i skumoulwania
                      
               %axis('tight'); 
    %             ax = axis; axis([ax(1:2) xmin xmax]);
                i * k 
                ls = ls +1;
                if ( mod (ls,2) == 0 )                   
                    subplot(4, kolumn, k); 
                    [ls k s (szerIndex(ls))]
                    plot(trendTab(:, szerIndex(ls)), Kolor(s)); hold on;
                    ax = axis; axis([ax(1:2) xIp xAp]);
                else
                    subplot(4, kolumn, k+8); 
                    [ls k+8 s (szerIndex(ls))]
                    plot(trendTab(:, szerIndex(ls)), Kolor(s)); hold on;
                    ax = axis; axis([ax(1:2) xIn xAn]);
                end
            end
        end
    end
    [xAn xAp]
return
if(i==1) title('Skumulowany'); end; if (i == 3) sgtitle(append(fnames));end
%     if (mod(i, 2) == 1) % plot nr
%         for (z = 1:p) k = round(i / 2); end
%         
%         j = mod(k - 1, 8) + 1;
%     else
%         x = mod(i,rys);
% %         y = floor(i/rys);
% %         for (z = 1:y) k = round(i / 2); end
%         k = round(x / 2);
%         if(kolumn ==2)
%             j = mod(k -1, 8)+1;
%         else
%             j = mod(k -9, 8)+9;
%         end
%         
%     end
    m = ceil(i/rys); % person color
    subplot(4, kolumn, index);
    plot(trendTab(1:L, szerIndex(i)), Kolor(m)); hold on;
    axis('tight'); ax = axis; axis([ax(1:2) xN xX]);
%     histcounts(o);
end
