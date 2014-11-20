function ps_data = switch_choosemaxit(fig,cax,this_ver,ps_data)

% function ps_data = switch_choosemaxit(fig,cax,this_ver,ps_data)
%
% Function called when the 'Choose Maxit' menu option is
% chosen.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    if isfield(ps_data,'ARPACK_maxit') & ~strcmp(ps_data.ARPACK_maxit,'auto'),
      default_val = num2str(ps_data.ARPACK_maxit);
    else
      default_val = '';
    end;

    cont = 1;

    while cont==1,

      s = inputdlg({['Please enter the maximum number of implicit restarts ' ...
                   'that should be used (leave blank for the default of ' ...
                   'max{300,2*n/p}).']}, ...
                   'Maximum number restarts...', 1,{default_val});
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, remove the field to use default val.
        if isfield(ps_data,'ARPACK_maxit'),
          ps_data = rmfield(ps_data,'ARPACK_maxit');
        end;
        return;
      else
        maxit = str2num(s{1});
      end;

      if length(maxit)==1,
        if maxit>=0

          ps_data.ARPACK_maxit = maxit;
          ps_data = update_messagebar(fig,ps_data,31);

%% Enable the 'Go!' button now we've changed the parameters
          ps_data = toggle_go_btn(fig,'Go!','on',ps_data);

%% The current projection is no longer valid
          ps_data.proj_valid = 0;

          cont = 0;

        else
          h = errordlg('Max no. restarts must be non-negative','Invalid input','modal');
          waitfor(h);
        end;
      else
        h = errordlg('Invalid number for max restarts','Invalid input','modal');
        waitfor(h);
      end;

    end;
