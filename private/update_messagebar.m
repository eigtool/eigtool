function ps_data = update_messagebar(fig,ps_data,new_message,no_drawnow)

% function prev_message = update_messagebar(new_message)
%
% Function to change the message on display in the message bar. 
% It returns the current message so that it can be returned
% to at a later date if necessary.
%
% fig         Handle to the current EIGTOOL figure
% ps_data     The data for the current EIGTOOL
% new_message A message number to switch to, or 
%                'prev' to use the previous one
% no_drawnow  (optional) set to 1 to prevent drawnow
% 
% ps_data     The changed EIGTOOL data

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Use the previous message if requested
    if strcmp(new_message,'prev'),
      new_message = ps_data.last_message;
    end;

% Return the current message so it can be returned to later
    ps_data.last_message = ps_data.current_message;

    text_handle = findobj(fig,'Tag','MessageText');
    msgs = get(findobj(fig,'Tag','MessageFrame'),'UserData');

% Set the new message
    ps_data.current_message = new_message;
    set(text_handle,'String', msgs{ps_data.current_message});

% Make sure it's displayed, if requested
    if nargin<4 | no_drawnow==0,
      drawnow;
    end;
