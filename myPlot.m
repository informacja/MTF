function myPlot( i, L, xN, xX,trendTab)
    if( i > 16 )
         figure(15);
         i = i - 16;
    end
  subplot(4, 4, i);
    plot(trendTab(i,1:L)); axis('tight'); ax = axis;
    axis([ax(1:2) xN xX])
end