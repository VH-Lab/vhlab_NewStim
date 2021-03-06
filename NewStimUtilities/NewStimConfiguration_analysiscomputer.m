function NewStimCalibrate

% NewStimCalibrate.m
%
%  A user-specific configuration file which contains calibration code
%  for a specific machine and monitor.  Read each line of code and its comments
%  in order to set each parameter.
%

NewStimGlobals;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RemoteCommunication settings, part 1 of 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remotecommglobals;
%  Is this a remote (slave, or, in other words, a stimulus) machine?
Remote_Comm_isremote = 0;

Remote_Comm_enable = 1;  % enable remote communication?

Remote_Comm_eol = '\r';  % End of line, '\r' for MacOS9, '\n' for unix
Remote_Comm_method = 'filesystem';  % 'sockets' or 'filesystem'

% settings for Remote_Comm_method = 'filesystem'
Remote_Comm_dir = '/Users/vanhoosr/remote/';   % the local directory in which to write
                                               % files for the remote computer
                                               % should end with filesep ('/' or '\')

% settings for Remote_Comm_method = 'sockets'
Remote_Comm_host = '152.16.225.216';
Remote_Comm_port = 1205;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RemoteCommunication settings, part 2 of 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if you are communicating with a remote computer via a filesystem,
% this section is important
% if this computer IS the remote computer, then this section is unimportant

Remote_Comm_remotearchitecture = 'unix'; % options are 'PC', 'Mac' (MacOS9), or 'unix' (Linux, MacOSX)
 % the computer type of the remote machine you are talking to (not of THIS computer, necessarily)

Remote_Comm_localprefix = '/Users/vanhoosr/remote/'; % for example, 'Z:\remote\', 'z:\remote\', '/Users/Shared/myexperimentdir/'
 % the prefix to the shared directory on THIS computer; should end in file separator ('/' or '\')

Remote_Comm_remoteprefix = '/Volumes/VHLabRig2/';
Remote_Comm_remoteprefix = '/Volumes/remote/';  % should end in file separator ('/' or '\')
 % the prefix to the same directory as viewed by the OTHER computer

 % Example, suppose your "master" computer is a PC running Windows, and you 
 % want to use the directory 'C:\Users\VHLabRig2\remote'.  You share the 'C' drive
 % (say with the "share" name 'VHLabRig2', and mount it on your stimulus computer
 % (say this computer is a MacOSX computer).  When the MacOSX stimulus computer
 % mounts the drive from your "master" computer, it will probably see it as 
 % '/Volumes/VHLabRig2/Users/VHLabRig2/remote'.
 % So, on your master computer (the PC) you would set
 % Remote_Comm_remotearchitecture = 'MacOSX';
 % Remote_Comm_localprefix = 'C:';
 % Remote_Comm_remoteprefix = '/Volumes/VHLabRig2';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Monitor setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StimWindowGlobals;
StimWindowMonitor = 0;  % use the given monitor, 0 is first
StimComputer = 0;       % is this a stimulus computer?

StimWindowUseCLUTMapping = 0; % most users will say 0
NewStimPeriodicStimUseDrawTexture = 1; % most users will say 1
StimWindowFlip = 0; % most users will say 0
StimWindowFlipHorizontal = 1; % only enabled if StimWindowFlip is 1
StimWindowFlipVertical = 1;   % only enabled if StimWindowFlip is 1


MonitorWindowGlobals;
MonitorWindowMonitor = 0;  % use the given monitor, 0 is first
MonitorComputer = 0;       % does this computer have a monitor window?


if StimComputer&haspsychtbox==2,  % set up timing and monitor settings
	%screen('Preference','SecondsMultiplier',1.000230644770116);
	screen('Preference','SecondsMultiplier',1.0);
	screen('Preference','Backgrounding',1); % we'll try this
else,                          % set the current monitor dimensions for remote comm
	StimWindowRefresh = 120;
	StimWindowDepth = 8;
	StimWindowRect = [ 0 0 800 600 ];
end;

 % pixels_per_cm of the monitor in use
%pixels_per_cm = 17.49;  % from 2002-08-01 to 2003-01-27
%pixels_per_cm = 18.0832; % from 2003-01-27 - 
pixels_per_cm = 200/9.5; % other monitor 2008-05-14

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Gamma correction settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GammaCorrectionTableGlobals;
GammaCorrectionEnable = 0;
%LoadGammaCorrectionTable('Macintosh HD:Users:fitz_lab:FitzStim4:MonitorCalibrations:sony_rm430_121404LUT.txt');
%LoadGammaCorrectionTable('Macintosh HD:Users:fitz_lab:FitzStim4:MonitorCalibrations:SONYCalib012207_LUT.txt');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Triggering/stimulus reporting settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  There are two options that can be used independently or simultaneously
%        * serial port triggering, via StimSerial (see "help StimSerial")
%            the start of a stimscript is indicated by a trigger on one serial port
%            the start of each stimulus is indicated by a trigger on another serial port
%        * stimulus reporting via parallel port using National Instruments PCI-DIO-96
%            the stimulus number is reported on the parallel port according
%                to Fitzpatrick lab protocol

% StimSerial, for sending messages over serial port in Mac OS9.
% Use portlist = serial('Ports') for a list of ports on your Mac.

StimSerialGlobals; % see help file for description
StimSerialSerialPort = 0;          % do you want to enable this feature?
StimSerialScriptIn = '.Bin';       % NewStim flips DTR on this port when trial starts
StimSerialScriptOut = '.Bout';     % same
StimSerialStimIn = '.keyU2X02in';  % NewStim flips DTR on this this port when individual stimuli start
StimSerialStimOut = '.keyU2X02out';% same

% Display preferences
NSUseInitialSerialTrigger = 0;
NSUseStimSerialTrigger = 0;
NSUsePCIDIO96Trigger = 1;
NSUsePCIDIO96InputTrigger = 0;

% PCIDIO96 card option
StimPCIDIO96Globals;
UseStimPCIDIO96 = 0;                 % Use the PCIDIO96 card and interface?  Mac OS 9 only

StimDisplayOrderRemote = 0;


StimTriggerClear

%fitzTrigParams.triggerStimOnset = 1; % 0 means trigger BGpre instead of stim onset
%StimTriggerAdd('FitzTrig',fitzTrigParams);

%StimTriggerAdd('VHTrig',[]); % add Van Hooser lab triggering


  % Display based on triggered input?  Not by default

NewStimTriggeredStimPresentation = 0;
NewStimTriggeredStimPresentation_Sign = 1; % low to high
NewStimTriggeredStimPresentation_timeout = 30; % timeout in 30 seconds

NewStimUseRushForDisplay = 1;


