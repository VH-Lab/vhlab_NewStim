function [ws] = wavsound(WSp,OLDSTIM)

% WAVSOUND - A stimulus class for sound in windows wav format
%
%  WS = WAVSOUND(PARAMETERS)
%
%  Creates a wav sound stimulus.
%
%  PARAMETERS can either be the string 'graphical' (which will prompt the user
%  to enter all of the parameter values), the string 'default' (which will use
%  default parameter values), or a structure.  When using 'graphical', one may
%  also use
%
%  WS = WAVSOUND('graphical',OLDWS)
%
%  where OLDWS is a previously created wavsound object.  This will set the
%  default parameter values to those of OLDWS.
%
%  If passing a structure, the structure should have the following fields:
%  (dimensions of parameters are given as [M N]; fields are case-sensitive):
%
%  [1x4] filename       - Filename of wav file
%  [1x3] background     - Background color
% [cell] dispprefs      - Sets displayprefs fields, or use {} for defaults.
%
%  Note:  'graphical' not implemented yet for this stim type.
%  
%  See also:  STIMULUS

NewStimListAdd('wavsound');
if nargin==0,
	ws = wavsound('default');
	return;
end;


   default_p = struct('filename','test','background',[128 128 128]);
   default_p.dispprefs = {};


finish = 1;

if nargin==1, oldstim=[]; else, oldstim = OLDSTIM; end;

if ischar(WSp),
	if strcmp(WSp,'graphical'),
		% load parameters graphically, check values
		if isempty(oldstim), oldstim = wavsound(default_p);end;
		p = get_graphical_input(oldstim);
		if isempty(p), finish = 0; else, WSp = p; end;
	elseif strcmp(WSp,'default'),
		WSp = default_p;
	else,
		error('Unknown string input to wavsound.');
	end;
else, % they are just parameters
	
end;

if finish,
	dp = {'fps',1,'rect',[0 0 1 1],'frames',1,WSp.dispprefs{:}};
	s = stimulus(5);
	ws = class(struct('WSparams',WSp),'wavsound',s);
	ws.stimulus = setdisplayprefs(ws.stimulus,displayprefs(dp));
else,
	ws = [];
end;

function params = get_graphical_input(oldstim)

p = getparameters(oldstim);

params = p;

filenamestr    = mat2str(p.filename);
bgstr          = mat2str(p.background);
dpstr          = wimpcell2str(p.dispprefs);

h0 = figure('Color',[0.8 0.8 0.8], ...
        'PaperPosition',[18 180 576 432], ...
        'PaperUnits','points', ...
        'Position',[396 366 411 530], ...
        'Tag','Fig1', ...
        'MenuBar','none');
		settoolbar(h0,'none');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontSize',18, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[16 475 185 18], ...
        'String','New wavsound stim...', ...
        'Style','text', ...
        'Tag','StaticText1');
backgroundctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[150 312 150 18], ...
        'String',bgstr, ...
        'Style','edit', ...
        'Tag','EditText1');
filebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[180 370 80 18], ...
        'String','Choose file...', ...
        'Tag','EditText1','userdata',0,...
        'Callback','set(gcbo,''userdata'',1);uiresume(gcf);');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[5 307 116 19], ...
        'String','[1x3] background color', ...
        'Style','text', ...
        'Tag','StaticText2');
filenamectl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[150 350 150 18], ...
        'String',filenamestr, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[5 350-2 116 19], ...
        'String','filename', ...
        'Style','text', ...
        'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[27 90 344 16], ...
        'String','Set any displayprefs options here: example: {''BGpretime'',1}', ...
        'Style','text', ...
        'Tag','StaticText2');
dispprefsstrc = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[30 66 343 24], ...
        'String',dpstr, ...
        'Style','edit', ...
        'Tag','EditText1');
okctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 0.7 0.7], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[26 19 76 28], ...
        'String','OK', ...
        'Tag','Pushbutton1','userdata',0,...
        'Callback','set(gcbo,''userdata'',1);uiresume(gcf);');
canctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 0.7 0.7 ], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[160 19 76 28], ...
        'String','Cancel', ...
        'Tag','Pushbutton1','userdata',0,...
        'Callback','set(gcbo,''userdata'',1);uiresume(gcf);');
helpctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 .7 0.7], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[290 19 76 28], ...
        'String','Help', ...
        'Tag','Pushbutton1','Callback',...
        'textbox(''wavsound help'',help(''wavsound''));');
set(h0,'UserData',struct('helpctl',helpctl,'canctl',canctl,'okctl',okctl,...
        'dispprefsstrc',dispprefsstrc,'filenamectl',filenamectl,...
	'backgroundctl',backgroundctl ...
	));

error_free = 0;
while ~error_free,
	drawnow;
	uiwait(h0);

	if get(canctl,'userdata')==1,
		error_free = 1;
	elseif get(filebt,'userdata')==1,
		[f,p]=uigetfile('*.wav','File to choose...');
		if f~=0,
			set(filenamectl,'string',[fixpath(p) f]);
		end;
		set(filebt,'userdata',0);
	else,
		backgroundstr  = get(backgroundctl,'string');
		filename    = get(filenamectl,'String');
		dpstr          = get(dispprefsstrc,'String');

		so=1; % syntax okay
		try, bg=eval(backgroundstr);
		catch,errordlg('Syntax error in background.');so=0;end;
		try, dp = eval(dpstr);
		catch, errordlg('Syntax error in displayprefs.');so=0;end;
		
		if so, % syntax is okay
			lbp = struct('background',bg,'filename',filename);
			lbp.dispprefs = dp;
			good = 1; err = '';
			%[good,err]=verifylightbarstim(lbp);
			if ~good,errordlg(['Parameter value invalid: ' err]);
				set(okctl,'userdata',0);
			else, error_free = 1; end;
		else, set(okctl,'userdata',0); end;
	end;
end;
			
if get(okctl,'userdata')==1, params = lbp; else, params = []; end;
delete(h0);

function str = wimpcell2str(theCell)
 %1-dim cells only, only chars and matricies
str = '{  ';
for i=1:length(theCell),
        if ischar(theCell{i})
                str = [str '''' theCell{i} ''', '];
        elseif isnumeric(theCell{i}),
                str = [str mat2str(theCell{i}) ', '];
        end;
end;
str = [str(1:end-2) '}'];




