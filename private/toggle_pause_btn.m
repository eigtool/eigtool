function toggle_pause_btn(fig,state,enable)

% function toggle_pause_btn(fig,state,enable)
%
% Function to toggle the state of the Pause/Resume button
% in the figure pointed to by fig

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  h = findobj(fig,'Tag','Pause');
  str = get(h,'String');

%% If state is set one way or the other, use this to determine
%% which way to change the button. If not, toggle it
  if nargin<2, state = ''; end;
  if strcmp(state,'Resume'),
    to_go = 1;
  elseif strcmp(state,'Pause'),
    to_go = 0;
  else
    if strcmp(str,'Resume'), % Toggle to 'Stop!'
      to_go = 0;
    else 
      to_go = 1;
    end;
  end;


%% What state is it currently in?
  the_messages = get(findobj(fig,'Tag','MessageFrame'),'UserData');
  if to_go==0, % Toggle to Pause
    set(h,'Callback','eigtool_switch_fn(''Pause'');');
    set(h,'String','Pause');
    set(h,'BackgroundColor',[1 .86 .18]);          % mpe addition: keeps button rectangular
  else         % Toggle to Resume
    set(h,'Callback','eigtool_switch_fn(''Resume'');');
    set(h,'String','Resume');
    set(h,'BackgroundColor',[0 0.921 0.38375]);  % mpe addition: keeps button rectangular
  end;

%% Enable the button whatever state it's now in if that was requested
  if nargin>=3 
    set(h,'Enable',enable);
  end;
