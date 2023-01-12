h2 = findall(groot,'Type','figure');
h3 = findobj('Type','figure');

if ~isfile('figPW.m')
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPW.m', 'figPW.m');
end

figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
for i = 1:length(h2)
    figure(h2(i))
    movegui(cell2mat( figpos(mod(i,length(figpos)-1)+1) ));
    figPW;
end
