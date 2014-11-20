function ps_data = switch_safety(fig,cax,this_ver,ps_data)

% function ps_data = switch_safety(fig,cax,this_ver,ps_data)
%
% Function called when the safety level is changed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    if isfield(ps_data.zoom_list{ps_data.zoom_pos},'proj_lev'),
      default_val = num2str(ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
    else
      default_val = '';
    end;

    cont = 1;

    while cont==1,

      s = inputdlg({['Please enter the projection level to use ' ...
                     '(blank or Inf for none). Note that this value will only ' ...
                     'be valid for this zoom level (and subsequent zooming in), ' ...
                     'NOT for previous zoom levels.']}, ...
                     'Projection Level...', 1,{default_val});
      if isempty(s), % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, default to inf
        ps_data.zoom_list{ps_data.zoom_pos}.proj_lev=inf;
        return;
      else
        n = str2num(s{1});
      end;

      if length(n)==1,
        if isnumeric(n),

          ps_data.zoom_list{ps_data.zoom_pos}.proj_lev=n;
          ps_data = update_messagebar(fig,ps_data,4);

%% Enable the 'Go!' button now we've changed the projection level
          ps_data = toggle_go_btn(fig,'Go!','on',ps_data);

          cont = 0;

        else
          h=errordlg('Projection level must be non-negative','Invalid input','modal');
          waitfor(h);
        end;
      else
        h=errordlg('Invalid number for projection level','Invalid input','modal');
        waitfor(h);
      end;

    end;


