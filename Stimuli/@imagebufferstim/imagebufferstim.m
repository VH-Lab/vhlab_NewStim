function [pso] = imagebufferstim(PSparams,OLDSTIM)

% NewStim package: imagebufferstim
%
%  THEimagebufferstim = imagebufferstim(PARAMETERS)
%
%  Creates a periodic stimulus, such as a sine-wave grating, saw-tooth grating,
%  etc.  This class is a wrapper to the stimuli in the StimGen package.  Note
%  that this package is gray-scale only, so color values are given between 0-1.
%
%  The PARAMETERS argument can either be a structure containing the parameters
%  or the string 'graphical'(in which case the user is prompted for the values
%  of the parameters), or the string 'default' (in which case default parameter
%  values are assigned). In the graphical case, the following call is available:
%
%  THEimagebufferstim = imagebufferstim('graphical',OLDSTIM)
%
%  in which case the default parameters presented are based on OLDSTIM.  If the
%  values are being passed, then PARAMETERS should be a structure with the
%  following fields (fields are 1x1 unless indicated):
%
%  angle           -   orientation, in degrees, 0 is up
%  distance        -   distance of the monitor from the viewer
%  [1x4] rect      -   The rectangle on the screen where the stimulus will be
%                      displayed:  [ top_x top_y bottom_x bottom_y ]
%  nCycles         -   The number of times the stimulus should be repeated
%  contrast        -   0-1: 0 means no diff from background, 1 is max difference
%  background      -   luminance of the background (0-1 from chromlow to chromhigh)
%  backdrop        -   luminance of area outside of display region
%                       If [1x1] then it is 0-1 from chromlow to chromhigh
%                       If [1x3] then it specifies actual rgb color
%  fixedDur        -   fixed on-duration of squarewave flicker
%  loops           -   Number of back-and-forth loops.  0, the default, means
%                        only forward motion, 1 is a single loop forward and
%                        backward, 2 is forward backward forward, etc.
%  imgnumber       -   Number of images to be displayed
%  Buffer          -   Number of images in buffer
%  pause           -   Length of time in milliseconds for which image is
%                       displayed
%  blankpause      -   Length of pause in milliseconds for which blank
%                       screen is shown between images
%  seed            -   Random seed to drive random permutation of natural image
%                      sequence
%  dir             -   The directory which contains the image files
%  prefix          -   The image file naming convention without the
%                      numbering
%
%  See also:  STIMULUS, STOCHASTICGRIDSTIM, PERIODICSCRIPT

NewStimListAdd('imagebufferstim');

if nargin==0,
    pso = imagebufferstim('default');
    return;
end;

finish = 1;

default_p = struct( ...
    'chromhigh',         255*[1 1 1],       ...
    'chromlow',          [0 0 0],           ...
    'rect',              [0 0 1024 768],   ...
    'contrast',          1,                 ...
    'background',        0.5,               ...
    'loops',             0,                 ...
    'imgnumber',         20,                ...
    'pause',             500,               ...
    'blankpause',        1860,              ...
    'buffer',            10,                ...
    'seed',              1,                 ...
    'prefix',            'frame',           ...
    'dir',               '/Users/vhlab/Documents/depackaged'...
    );
default_p.dispprefs = {};

if nargin==1, oldstim=[]; else oldstim = OLDSTIM; end;

if ischar(PSparams),
    if strcmp(PSparams,'graphical'),
        % load parameters graphically
        p = get_graphical_input(oldstim);
        if isempty(p), finish = 0; else PSparams = p; end;
    elseif strcmp(PSparams,'default'),
        PSparams = default_p;
    else
        error('Unknown string input into imagebufferstim.');
    end;
else   % they are just parameters
    [good, err] = verifyimagebufferstim(PSparams);
    if ~good, error(['Could not create imagebufferstim: ' err]); end;
end;

if finish,
    
    cpustr = computer;
    if (strcmp(cpustr,'MAC2')),  % if we have a Mac
        
        StimWindowGlobals;
        tRes = round( (1/PSparams.tFrequency) * StimWindowRefresh);
        % screen frames / cycle
        
        %compute displayprefs info
        
        fps = StimWindowRefresh;
        
    else  % we're just initializing
        tRes = 5;
        fps = -1;
        
    end;
    
    if isfield(PSparams,'loops'), loops = PSparams.loops; else loops = 0; end;
    
    if isfield(PSparams,'aperature'), PSparams.aperture = PSparams.aperature; % correct steve's bad bad spelling
    elseif isfield(PSparams,'aperture'), PSparams.aperature = PSparams.aperture;  % correct for steve's bad bad spelling
    end;
    
    frames = (1:tRes);
       
    dp={'fps',fps, ...
        'rect',PSparams.rect, ...
        'frames',frames,PSparams.dispprefs{:} };
    s = stimulus(5);
    data = struct('PSparams', PSparams);
    pso = class(data,'imagebufferstim',s);
    pso.stimulus = setdisplayprefs(pso.stimulus,displayprefs(dp));
    
else
    pso = [];
end;

%%% GET_GRAPHICAL_INPUT funciton %%%

    function params = get_graphical_input(oldstim)
        
        if isempty(oldstim),
            rect_str = '[0 0 1024 768]';
            contrast_str = '1'; background_str = '0.5';
            dp_str = '{}';
            chromhigh_str = '[255 255 255]';
            chromlow_str = '[0 0 0]';
            imgno_str = '10';
            buffer_str = '10';
            pause_str = '500';
            blankpause_str = '1860';
            seed_str = '1';
            prefix_str = 'frame';
            dir_str = '/Users/vhlab/Documents/depackaged';
        else,
            oldS = struct(oldstim); PSparams = oldS.PSparams;
            rect_str = mat2str(PSparams.rect);
            chromhigh_str = mat2str(PSparams.chromhigh);
            chromlow_str = mat2str(PSparams.chromlow);
            contrast_str = num2str(PSparams.contrast);
            background_str = num2str(PSparams.background);
            dp_str = wimpcell2str(PSparams.dispprefs);
            imgno_str = num2str(PSparams.imgnumber);
            buffer_str = num2str(PS.params.buffer);
            pause_str = num2str(PSparams.pause);
            blankpause_str = num2str(PSparams.blankpause);
            seed_str = num2str(PSparams.seed);
            dir_str = dir;
            prefix_str = prefix;
        end;
        
        global filedir
        filedir = dir_str;
        
        % make figure layout
        h0 = figure('Color',[0.8 0.8 0.8],'Position',[196 100 415 525]);
        settoolbar(h0,'none'); set(h0,'menubar','none');
        
        % window heading
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',18, ...
            'FontWeight','bold', ...
            'ListboxTop',0, ...
            'Position',[42 476 285 25], ...
            'String','New imagebufferstim object...', ...
            'Style','text', ...
            'Tag','StaticText1');
        
        % entry for any displaypref options
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 445 344 19], ...
            'String','Set any displayprefs options here: example: {''BGpretime'',1}', ...
            'Style','text', ...
            'Tag','StaticText2');
        dp_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 425 365 19], ...
            'String',dp_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % entry for size of stimulus display
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[24 396 225 15], ...
            'String','[1x4] Rect [Pos_x Pos_y Width Height]', ...
            'Style','text', ...
            'Tag','StaticText2');
        rect_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[255 396 135 18], ...
            'String',rect_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % buffer size entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 366 125 19], ...
            'String','Buffer Size', ...
            'Style','text', ...
            'Tag','StaticText2');
        buffer_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 370 40 19], ...
            'String',buffer_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % Image Number entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[230 366 116 19], ...
            'String','[1x1] num images (>1)', ...
            'Style','text', ...
            'Tag','StaticText2');
        imgno_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[350 370 40 19], ...
            'String',imgno_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % contrast value entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[230 336 125 19], ...
            'String','[1x1] contrast [0..1]', ...
            'Style','text', ...
            'Tag','StaticText2');
        contrast_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[350 340 40 19], ...
            'String',contrast_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % background value entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 336 125 19], ...
            'String','[1x1] background [0..1]', ...
            'Style','text', ...
            'Tag','StaticText2');
        background_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 340 40 19], ...
            'String',background_str, ...
            'Style','edit', ...
            'Tag','EditText1');
               
        % Pause Duration entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 306 116 19], ...
            'String','[1x1] time/img', ...
            'Style','text', ...
            'Tag','StaticText2');
        pause_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 310 40 19], ...
            'String',pause_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % Blank Screen Pause Duration entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[230 306 120 19], ...
            'String','[1x1] Blank Time', ...
            'Style','text', ...
            'Tag','StaticText2');
        blankpause_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[350 310 40 19], ...
            'String',blankpause_str, ...
            'Style','edit', ...
            'Tag','EditText1');
                
        % chromaticity of periodic stim
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 276 105 19], ...
            'String','high/low color', ...
            'Style','text', ...
            'Tag','StaticText2');
        chromhighinp = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8]/0.8, ...
            'ListboxTop',0, ...
            'Position',[175 280 100 19], ...
            'String',chromhigh_str,...
            'Style','Edit', ...
            'Tag',''); ...
          chromlowinp = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8]/0.8, ...
            'ListboxTop',0, ...
            'Position',[175 260 100 19], ...
            'String',chromlow_str,...
            'Style','Edit', ...
            'Tag',''); ...
            
        % Seed entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 226 120 19], ...
            'String','[1x1] Random Seed', ...
            'Style','text', ...
            'Tag','StaticText2');
        seed_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 230 40 19], ...
            'String',seed_str, ...
            'Style','edit', ...
            'Tag','EditText1');
        
        % Prefix entry
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 196 120 19], ...
            'String','[1x1] File Name Prefix', ...
            'Style','text', ...
            'Tag','StaticText2');
        prefix_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[1 1 1], ...
            'FontSize',9, ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 200 40 19], ...
            'String',prefix_str, ...
            'Style','edit', ...
            'Tag','EditText1');
            
        % Dir button
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[25 166 120 19], ...
            'String','[1x1] Image Directory', ...
            'Style','text', ...
            'Tag','StaticText2');
        dir_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[175 170 150 19], ...
            'Style','edit',...
            'String', filedir,...
            'UserData', 0,...
            'Tag','editbox');
%         dir_ctl = uicontrol('Parent',h0, ...
%             'Units','pixels', ...
%             'BackgroundColor',[0.7 0.7 0.7], ...
%             'FontWeight','bold', ...
%             'ListboxTop',0, ...
%             'Position',[180 100 150 27.2], ...
%             'String','Directory Selection', ...
%             'Tag','Pushbutton1', ...
%             'Callback', @callback1);
                
        % OK button
        ok_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.7 0.7 0.7], ...
            'FontWeight','bold', ...
            'ListboxTop',0, ...
            'Position',[36 12.8 71.2 27.2], ...
            'String','OK', ...
            'Tag','Pushbutton1', ...
            'Callback', 'set(gcbo,''userdata'',[1]);uiresume(gcf);', ...
            'userdata',0);
        
        % Cancel button
        cancel_ctl = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.7 0.7 0.7], ...
            'FontWeight','bold', ...
            'ListboxTop',0, ...
            'Position',[172.8 11.2 71.2 27.2], ...
            'String','Cancel', ...
            'Tag','Pushbutton1', ...
            'Callback', 'set(gcbo,''userdata'',[1]);uiresume(gcf);', ...
            'userdata',0);
        
        % Help button
        h1 = uicontrol('Parent',h0, ...
            'Units','pixels', ...
            'BackgroundColor',[0.7 0.7 0.7], ...
            'FontWeight','bold', ...
            'ListboxTop',0, ...
            'Position',[304 12 71.2 27.2], ...
            'String','Help', 'Callback',...
            'textbox(''imagebufferstim Help'',help(''imagebufferstim''));',...
            'Tag','Pushbutton1');
        
        error_free = 0;    
        psp = [];
        
        while ~error_free,
            drawnow;
            uiwait(h0);
            
            if get(cancel_ctl,'userdata')==1,
                error_free = 1;
                
            else, % it was OK
                dp_str = get(dp_ctl,'String');
                rect_str = get(rect_ctl,'String');
                chromhigh_str= get(chromhighinp,'String');
                chromlow_str= get(chromlowinp,'String');
                contrast_str = get(contrast_ctl,'String');
                background_str = get(background_ctl,'String');
                pause_str = get(pause_ctl,'String');
                blankpause_str = get(blankpause_ctl,'String');
                imgno_str = get(imgno_ctl,'String');
                buffer_str = get(buffer_ctl,'String');
                seed_str = get(seed_ctl,'String');
                prefix_str = get(prefix_ctl,'String');
                dir_str = get(dir_ctl,'String');
                
                so = 1; % syntax_okay;
                try, dp=eval(dp_str);
                catch, errordlg('Syntax error in displayprefs'); so=0; end;
                try, rect = eval(rect_str);
                catch, errordlg('Syntax error in Rect'); so=0; end;
                try, chromhigh= eval(chromhigh_str);
                catch, errordlg('Syntax error in chromhigh'); so=0; end;
                try, chromlow= eval(chromlow_str);
                catch, errordlg('Syntax error in chromlow'); so=0; end;
                try, contrast = eval(contrast_str);
                catch, errordlg('Syntax error in contrast'); so=0; end;
                try, background = eval(background_str);
                catch, errordlg('Syntax error in background'); so=0; end;
                try, buffer = eval(buffer_str);
                catch, errordlg('Syntax error in buffer.'); so=0;end;
                try, imgno = eval(imgno_str);
                catch, errordlg('Syntax error in imgno.'); so=0;end;
                try, pause = eval(pause_str);
                catch, errordlg('Syntax error in pause.'); so=0;end;
                try, blankpause = eval(blankpause_str);
                catch, errordlg('Syntax error in blankpause.'); so=0;end;
                try, seed = eval(seed_str);
                catch, errordlg('Syntax error in seed.'); so=0;end;
%                 dir_test = exist(dir_str,'file');
%                 if ~dir_test errordlg('No file at specified directory'); so=0;end;
%                 try fileinfo = imfinfo(dir_str);
%                 catch errordlg('Specified file contains no images'); so=0;end;
%                 fileinfo = imfinfo(dir_str);
%                 num_images = numel(fileinfo);
%                 if num_images <= 0 errordlg('No images found in selected file'); so=0;end;
                
                if so,
                    
                    % determine number of cycles from duration and temporal frequency
                    %nCycles = round(durtn * tFrequency);
                    
                    psp = struct(...
                        'chromhigh',chromhigh,'chromlow',chromlow,'rect',rect, ...
                        'contrast',contrast,'background',background,'imgnumber',imgno,...
                        'buffer', buffer, 'pause',pause,'blankpause',blankpause, ...
                        'seed',seed,'dir',dir_str, 'prefix', prefix_str);
                    
                    psp.dispprefs = dp;
                    
                    [good, err] = verifyimagebufferstim(psp);
                    if ~good,
                        errordlg(['Parameter value invalid: ' err]);
                        set(ok_ctl,'userdata',0);
                    else
                        error_free = 1;
                    end;
                    
                else
                    set(ok_ctl,'userdata',0);
                end; % if so
                
                
            end;
            
        end; %while
        
        
        % if everything is ak, return the entered parameters
        if get(ok_ctl,'userdata')==1,
            params = psp;
            
            % otherwise return an empty vector
        else
            params = [];
        end;
        
        delete(h0);



%%% end of GET_GRAPHICAL_INPUT function %%%





%%% WIMPCELL2STR function %%%

function str = wimpcell2str(theCell)
%1-dim uicells only, only chars and matricies
str = '{  ';
for i=1:length(theCell),
    if ischar(theCell{i})
        str = [str '''' theCell{i} ''', '];
    elseif isnumeric(theCell{i}),
        str = [str mat2str(theCell{i}) ', '];
    end;
end;
str = [str(1:end-2) '}'];

    function callback1(hObject,eventdata)
        global filedir
        filedir = uigetdir();


