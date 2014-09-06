function ps_data = switch_colour(fig,cax,this_ver,ps_data)

% function ps_data = switch_colour(fig,cax,this_ver,ps_data)
%
% Function called when the 'Colour' menu option
% is chosen

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

      mnu_itm_h = findobj(fig,'Tag','Colour');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'off'),
        set(mnu_itm_h,'checked','on');
      else
        set(mnu_itm_h,'checked','off');
      end;

      ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
