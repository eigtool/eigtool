function enable_edit_axes(fig)

% function enable_edit_axes(fig)
%
% Function to turn on the edit text boxes for the axes

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  the_handle = findobj(fig,'Tag','MainAxes');
  set(the_handle,'HitTest','on');
  set(fig,'WindowButtonDownFcn','eigtool_switch_fn(''PsArea'');');

  the_handle = findobj(fig,'Tag','xmin');
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','xmax');
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','ymin');
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','ymax');
  set(the_handle,'Enable','on');
  the_handle = findobj(fig,'Tag','ScaleEqual');
  set(the_handle,'Enable','on');

