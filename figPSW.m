h2 = findall(groot,'Type','figure');
h3 = findobj('Type','figure');

if ~isfile('figPW.m')
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPW.m', 'figPW.m');
end

for i = 1:length(h2)
    figure(h2(i))
    figPW;
end
