h2 = findall(groot,'Type','figure');
h3 = findobj('Type','figure');

if ~isfile('figPW.m') && ~isfile(fullfile(userpath)+"/figPW.m")
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPW.m', 'figPW.m');
end

figpos = {'north','south','east','west','northeast','northwest','southeast','southwest','center','onscreen'};
for i = 1:length(h2)
    H = figure(h2(i));
    a = get(H,'Position');
    H.WindowState = 'maximized';    
    figPW;
    set(H,'Position',a);
    movegui(cell2mat( figpos(mod(i,length(figpos)-1)+1) ));
end
