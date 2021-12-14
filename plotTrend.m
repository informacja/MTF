function myPlot(i, L, xN, xX, trendTab)
    Kolor = 'kbrmgcy';
    n = length(trendTab(1,:));
    rys = 16; m = n/rys; % person
    k = i;
    if (mod(i, 2) == 1) % plot nr
        for (z = 1:m) k = round(i / 2); end
        j = mod(k - 1, 8) + 1;
    else
        for (z = 1:m) k = round(i / 2); end
        j = mod(k -9, 8)+9;
    end
    m = ceil(i/16); % person color
    subplot(4, 4, j);
    plot(trendTab(1:L, i), Kolor(m));
    
    ax = axis; hold on;
    axis('tight'); axis([ax(1:2) xN xX]);
end
