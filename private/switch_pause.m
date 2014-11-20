function ps_data = switch_pause(fig,ps_data,btn,state)

% function ps_data = switch_pause(fig,ps_data,btn,state)
%
% Function called when the Pause/Resume button is pressed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    if nargin<3, btn = ''; end;
    if nargin<4, state = 'on'; end;
    if nargin<5, no_draw = 0; end;

%% This global variable is checked by the PS computation routines
    global pause_comp;

%% Set fig entry of array to 1/0; that way if 
%% several instances of the GUI are going at once, only this one
%% will be pause/resumed

% PAUSE the computation
    if pause_comp(fig)==0 & ~strcmp(btn,'Pause'),
      pause_comp(fig) = 1;
      toggle_pause_btn(fig,'Resume',state);
      ps_data = update_messagebar(fig,ps_data,36);
      if strcmp(ps_data.comp,'ARPACK'),
        the_handle = findobj(fig,'Tag','ARPACKMenu'); 
        set(the_handle,'Enable','on');
        enable_edit_axes(fig);
      end;
    else

% RESUME the computation
      pause_comp(fig) = 0;
      ps_data = update_messagebar(fig,ps_data,'prev');
      disable_controls(fig);
      toggle_pause_btn(fig,'Pause',state);
      ps_data = toggle_go_btn(fig,'Stop!','on',ps_data);
    end;
