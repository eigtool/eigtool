function ps_data = switch_arpack_k(fig,cax,ps_data)

% function ps_data = switch_arpack_k(fig,cax,ps_data)
%
% Function called when the ARPACK parameter k is changed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    s = get(gcbo,'String');
    k = str2num(s);

% This should remove any spaces before/after the number
    set(gcbo,'String',num2str(k));

    if ~isempty(k) & length(k)==1,
      if k>0 & k<=length(ps_data.input_matrix)-2,
        ps_data = update_messagebar(fig,ps_data,31);

%% Enable the 'Go!' button now we've changed the mesh size
        ps_data = toggle_go_btn(fig,'Go!','on',ps_data);

%% The current projection is no longer valid
        ps_data.proj_valid = 0;

      else
        errordlg('ARPACK parameter k must be greater than 0 and <= n-2','Invalid input','modal');
      end;
    else
      errordlg('Invalid number for ARPACK parameter k','Invalid input','modal');
    end;
