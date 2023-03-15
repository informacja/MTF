
% edit(fullfile(userpath,'startup.m'))

% install script version  0.0.0.1
cd(fullfile(userpath));
if ~isfile('figPSW.m')
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPSW.m', 'figPSW.m');
end

if ~isfile('figPW.m')
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPW.m', 'figPW.m');
end

addpath(fullfile(userpath))
savepath
