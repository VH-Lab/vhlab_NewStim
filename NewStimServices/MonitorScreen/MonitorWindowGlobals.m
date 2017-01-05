%% MonitorWindowGlobals%% This script declares all of the MonitorWindow global variables%%  MonitorWindowMonitor - The ID of the monitor monitor (e.g., 0 for main screen)%%  MonitorComputer      - 0/1 is this a monitor computer?%%  The following variables can be read by user programs but should not be set:%%  MonitorWindowDepth   - The pixel depth of the monitor window.  The only%                      supported depth at present is 8.%%  MonitorWindow        - The window pointer of the monitor window, which covers%                      the full screen.  If it does not exist, this variable is%                      empty.%  MonitorWindowRefresh - The refresh rate for the monitor window.  Only%                      computed _after_ the window is open.%%%  See also:  SHOWMONITORSCREEN, CLOSEMONITORSCREEN%global MonitorWindow MonitorWindowMonitor MonitorWindowDepth MonitorWindowRefresh MonitorWindowRect MonitorComputer MonitorScreenBG