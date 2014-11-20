function ps_data = switch_choosep(fig,cax,this_ver,ps_data)

% function ps_data = switch_choosep(fig,cax,this_ver,ps_data)
%
% Function called when the 'Choose P' menu option is
% chosen.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    if isfield(ps_data,'ARPACK_p') & ~strcmp(ps_data.ARPACK_p,'auto'),
      default_val = num2str(ps_data.ARPACK_p);
    else
      default_val = '';
    end;

    cont = 1;

    while cont==1,

      s = inputdlg({['Please enter the maximum size of the Arnoldi ' ...
                   'basis to use, or leave blank for the default (approximately ' ...
                   'twice the number of requested eigenvalues (k).']}, ...
                   'Maximum subaspace size...', 1,{default_val});
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, remove the field to use default val.
        if isfield(ps_data,'ARPACK_p'),
          ps_data = rmfield(ps_data,'ARPACK_p');
        end;
        return;
      else
        p = str2num(s{1});
      end;

      if length(p)==1,
        if p>=0 & p<=length(ps_data.input_matrix),

          ps_data.ARPACK_p = p;
          ps_data = update_messagebar(fig,ps_data,31);

%% Enable the 'Go!' button now we've changed the parameters
          ps_data = toggle_go_btn(fig,'Go!','on',ps_data);

%% The current projection is no longer valid
          ps_data.proj_valid = 0;

          cont = 0;

        else
          h = errordlg('Max subspace size must be non-negative and <= n','Invalid input','modal');
          waitfor(h);
        end;
      else
        h = errordlg('Invalid number for max subspace size','Invalid input','modal');
        waitfor(h);
      end;

    end;
