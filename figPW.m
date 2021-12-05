% function [outputArg1,outputArg2] = (saveAs, OverwrieProtection)
 function figPW(nrPliku, nrKol, ext, katalog, wariantNazw)
if(nargin<5) wariantNazw=1; end;
if(nargin<4) katalog='figury\'; end;
if(nargin<3) ext ='fig'; end;
if(nargin<2) % jeœli jeden parametr    
    fTitle = '_'; % do zapisywanej nazwy pliku
    nrName = get( get(gcf,'Number'), 'Name' )
    h1=get(gca,'title');
    titre=get(h1,'string')
    if( isempty(titre) )    
        title( datestr(now,'yyyy-mm-dd HH:MM:ss') ); % default timestamp title
    else
        fTitle = ['_' titre '_' ];
    end
% title([{'Dziedzina czasu'},{'Cha-ka skokowa'}]);  
% xlabel('Oœ rzeczywista'); ylabel('Oœ urojona'); 
% legend(str{:}); 
    [path, filename, Fext] = fileparts( mfilename('.')); [~, folderName] = fileparts(pwd());                      % nazwa TEGO *.m-pliku
    print( strcat(folderName, fTitle, nrName, num2str(get(gcf,'Number')), '.png'),'-dpng'); % Zapisz jako tenMPlik_nrOstatniejFigury.png
    return
end 

h=gcf;
set(h,'PaperOrientation','Landscape');
%set(h,'Units','centimeters');
%set(h,'OuterPosition',[1, 1, 29 21]);
% set(h,'Position',2*get(h,'Position'));
nrPliku = 3; 
nrKol =3;
if(wariantNazw==1) % PIG
    filename=sprintf('%sFig_P%dK%d',katalog,nrPliku,nrKol);
end;

if(wariantNazw==2) % 2017
    % tutaj nrPliku jest nazwa
    filename=sprintf('%sFig_%sK%d',katalog,nrPliku,nrKol);
end;
% 
nrKol
fn = nextname(filename, '1D3', ext)
saveas(h,filename,ext);
saveas(h,filename,'png'); 
fprintf(1,'\n\t*Zapisano rysunek "%s.%s"',filename,ext);

%             zapiszFig(nrPliku, nrKol, 'fig');
%             zapiszFig(nrPliku, nrKol, 'pdf');
%             zapiszFig(nrPliku, nrKol, 'emf'); %!
%             zapiszFig(nrPliku, nrKol, 'eps');
%             zapiszFig(nrPliku, nrKol, 'tif');
%             zapiszFig(nrPliku, nrKol, 'pcx');
%             zapiszFig(nrPliku, nrKol, 'jpg');
%             zapiszFig(nrPliku, nrKol, 'pbm');
%             zapiszFig(nrPliku, nrKol, 'pgm');
%             zapiszFig(nrPliku, nrKol, 'png');
%             zapiszFig(nrPliku, nrKol, 'ppm');

% Figure Pretty & Write
%  if(narg  < 1)
%      saveAs
%  end 
 end


 function [name,val] = nextname(bnm,sfx,ext,otp) %#ok<*ISMAT>
% Return the next unused filename, incrementing a numbered suffix if required.
%
% (c) 2017-2021 Stephen Cobeldick
%
%% Examples %%
%
%%% Current directory contains files 'A1.m', 'A2.m', and 'A4.m':
%
% >> nextname('A','1','.m')
% ans = 'A3.m'
%
% >> nextname('A','001','.m')
% ans = 'A003.m'
%
%%% Subdirectory 'HTML' contains folders 'B(1)', 'B(2)', and 'B(4)':
%
% >> nextname('HTML\B','(1)','')
% ans = 'B(3)'
%
% >> nextname('HTML\B','(001)','')
% ans = 'B(003)'
%
% >> nextname('HTML\B','(1)','',false) % default = name only.
% ans = 'B(3)'
% >> nextname('HTML\B','(1)','',true) % prepend same path as the input name.
% ans = 'HTML\B(3)'
%
%% Inputs and Outputs %%
%
%%% Input Arguments (**==default):
% bnm = CharVector or StringScalar giving the base filename or folder name,
%       with an absolute or relative file path if required.
% sfx = CharVector or StringScalar of the suffix to append, contains exactly
%       one integer number (use leading zeros to specify the number of digits).
% ext = CharVector or StringScalar of the file extension, if any. For folder
%       names or files without extensions use ''.
% otp = LogicalScalar, true/false** -> output with same path as input name / name only. 
%
%% Input Wrangling %%
%
bnm = nn1s2c(bnm);
sfx = nn1s2c(sfx);
ext = nn1s2c(ext);
%
msg = 'Input <%s> must be a 1xN char vector or a scalar string.';
assert(ischar(bnm)&&ndims(bnm)==2&&size(bnm,1)==1,'SC.nextname:bnm:NotText',msg,'bnm')
assert(ischar(sfx)&&ndims(sfx)==2&&size(sfx,1)==1,'SC:nextname:sfx:NotText',msg,'sfx')
assert(ischar(ext)&&ndims(ext)==2&&size(ext,1)<=1,'SC:nextname:ext:NotText',msg,'ext')
%
tkn = regexp(sfx,'\d+','match');
val = sscanf(sprintf(' %s',tkn{:}),'%lu'); % faster than STR2DOUBLE.
assert(numel(val)==1,'SC:nextname:sfx:NotOneInteger',...
	'The suffix must contain exactly one integer value (any number of digits).')
wid = numel(tkn{1});
%
%% Get Existing File / Folder Names %%
%
[inpth,fnm,tmp] = fileparts(bnm);
fnm = [fnm,tmp];
%
% Find files/subfolders on that path:
raw = dir(fullfile(inpth,[fnm,regexprep(sfx,'\d+','*'),ext]));
%
% Special case of exactly one matching subfolder (Octave):
if ~all(strncmp({raw.name},fnm,numel(fnm)))
	raw = dir(fullfile(inpth,'*'));
end
%
% Generate regular expression:
rgx = regexprep(regexptranslate('escape',sfx),'\d+','(\\d+)');
rgx = ['^',regexptranslate('escape',fnm),rgx,regexptranslate('escape',ext),'$'];
%
% Extract numbers from names:
tkn = regexpi({raw.name},rgx,'tokens','once');
tkn = [tkn{:}];
%
%% Identify First Unused Name %%
%
if numel(tkn)
	% For speed these values must be converted before the WHILE loop:
	vec = sscanf(sprintf(' %s',tkn{:}),'%lu');  % faster than STR2DOUBLE.
	%
	% Find the first unused name, starting from the provided value:
	while any(val==vec)
		val = val+1;
	end
end
%
name = [fnm,regexprep(sfx,'\d+',sprintf('%0*u',wid,val)),ext];
%
if nargin>3
    assert(islogical(otp)&&isscalar(otp),'SC:nextname:otp:NotLogicalScalar',...
		'Input <otp> must be a scalar logical (i.e. true or false).')
    if otp
        name = fullfile(inpth,name);
    end
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nextname
function arr = nn1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
	arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nn1s2c
 
