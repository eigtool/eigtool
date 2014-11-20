function switch_stop(fig)

% function switch_stop(fig)
%
% Function called when the 'Stop!' button is pressed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% This global variable is checked by the PS computation routines
    global stop_comp;

%% Set this to be the handle of the current figure; that way if 
%% several instances of the GUI are going at once, only this one
%% will be stopped
    stop_comp = fig;
