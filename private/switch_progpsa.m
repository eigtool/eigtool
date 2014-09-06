function ps_data = switch_progpsa(fig,cax,this_ver,ps_data)

% function ps_data = switch_progpsa(fig,cax,this_ver,ps_data)
%
% Function called when the 'Show prog using PSA' menu option is
% chosen.

% Version 2.3 (Sat Sep  6 16:27:03 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

      mnu_itm_h = findobj(fig,'Tag','ProgPSA');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'off'),
        set(mnu_itm_h,'checked','on');
      else
        set(mnu_itm_h,'checked','off');
      end;
