function set_edit_text(fig,fig_axes,ps_epslev,ps_npts,ps_proj)

% function set_edit_text(fig,fig_axes,ps_epslev,ps_npts,ps_proj)
%
% Function to set the text in the GUI text boxes correctly

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Now set up the edit text boxes in the gui with the current values:

if nargin>1,
  the_handle = findobj(fig,'Tag','xmin');
  set(the_handle,'String',num2str(fig_axes(1)));
  the_handle = findobj(fig,'Tag','xmax');
  set(the_handle,'String',num2str(fig_axes(2)));
  the_handle = findobj(fig,'Tag','ymin');
  set(the_handle,'String',num2str(fig_axes(3)));
  the_handle = findobj(fig,'Tag','ymax');
  set(the_handle,'String',num2str(fig_axes(4)));
end;

if nargin>2,
  the_handle = findobj(fig,'Tag','firstlev');
  set(the_handle,'String',num2str(ps_epslev.first));
  the_handle = findobj(fig,'Tag','lastlev');
  set(the_handle,'String',num2str(ps_epslev.last));
  the_handle = findobj(fig,'Tag','nolev');
  set(the_handle,'String',num2str(ps_epslev.step));
end;

if nargin>3,
  the_handle = findobj(fig,'Tag','meshsize');
  set(the_handle,'String',num2str(ps_npts));
end;

% Reset the text in the ARPACK k box (to eliminate spaces etc.)
  the_handle = findobj(fig,'Tag','ARPACK_k');
  set(the_handle,'String',num2str(get(the_handle,'String')));

