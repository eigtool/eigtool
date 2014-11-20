function ps_data = switch_displaypoints(fig,cax,this_ver,ps_data)

% function ps_data = switch_displaypoints(fig,cax,this_ver,ps_data)
%
% Function called when the 'Display Points' menu option
% is chosen

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

      mnu_itm_h = findobj(fig,'Tag','DisplayPoints');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'off'),
        set(mnu_itm_h,'checked','on');
      else
% Uncheck all the items in the Numbers menu
        hdl = findobj(fig,'Tag','NumbersMenu');
        hdls = get(hdl,'children');
        for i=1:length(hdls),
          set(hdls(i),'checked','off');
        end;

% Make all the markers invisible
        for i=1:length(ps_data.numbers.markers),
          ps_data.numbers.markers{i}.visible = 'off';
        end;
      end;

      ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
