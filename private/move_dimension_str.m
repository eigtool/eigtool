function move_dimension_str(fig,the_ax)

% function move_dimension_str(fig,the_ax)
%
% Function to move the string showing the dimension of the
% matrix when the axis limits are changed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Move the dimension, if it is on:
  mnu_itm_h = findobj(fig,'Tag','ShowDimension');
  cur_state = get(mnu_itm_h,'checked');
  if strcmp(cur_state,'on'),
%% Move the text
    hdl = findobj(fig,'Tag','DimText');
    set(hdl,'units','pixels');
    set(hdl,'position',[15 15 0]);
  end;
