function ps_data = switch_epslevmax(fig,cax,this_ver,ps_data)

% function ps_data = switch_epslevmax(fig,cax,this_ver,ps_data)
%
% Function called when maximum eps level to show changed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    s = get(gcbo,'String');
    n = str2num(s);
    if ~isempty(n) & length(n)==1,
      if n>=ps_data.zoom_list{ps_data.zoom_pos}.levels.first,
        ps_data.zoom_list{ps_data.zoom_pos}.levels.last = n;
%% Now go to even levels
        ps_data.zoom_list{ps_data.zoom_pos}.levels.iseven = 1;
%% If there is already some contour data, replot it
        if isfield(ps_data.zoom_list{ps_data.zoom_pos},'x'),
          ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
        end; 
      else
        errordlg('Maximum epsilon level must be larger than minimum one!', ...
                 'Invalid input','modal');
      end;
    else
      errordlg('Invalid number for maximum epsilon levels', ...
               'Invalid input','modal');
    end;
