function varargout = et_spectral_radius(varargin)

% function varargout = et_spectral_radius(varargin)
%
% Function to compute the spectral radius of the current matrix
% in EigTool.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If the argument is 'name', return the text to go in the menu and return
  if isstr(varargin{1}) & strcmp(varargin{1},'name')==1,
    varargout{1} = 'Spectral Radius';
    varargout{2} = 'd';
    varargout{3} = 's';
    return;

% If it isn't, we're being passed the data from EigTool - store it
% as ps_data
  else
    ps_data = varargin{1};
  end;

% Compute the spectral radius
  [spec_rad,ind] = max(abs(ps_data.ews));
  markers{1}.pos = ps_data.ews(ind(1));
  markers{1}.style = 'co';
  markers{1}.size = 12;
  if ps_data.AisReal & ~isreal(ps_data.ews(ind(1))),
    markers{2}.pos = conj(ps_data.ews(ind(1)));
    markers{2}.style = 'co';
    markers{2}.size = 12;
  end;
  varargout{1} = {{},markers};

% Ask the user what to do with the answer
    cont = 1;
    while cont==1,

      AddOpts.Resize='on';
      AddOpts.WindowStyle='modal';
      AddOpts.Interpreter='tex';
      s = inputdlg({['The value of the spectral radius is ',num2str(spec_rad,'%10.5e'),'. ' ...
                     'If you would like to save this number to the MATLAB workspace, ' ...
                     'please enter the variable name below.' ]}, ...
                     'Variable name...', 1,{'spec_rad'},AddOpts);
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, error (will be trapped below)
        var_name = '';
      else
        var_name = s{1};
      end;

% Check the value we've got
      if length(var_name)>=1,
        if isstr(var_name),
          cont = 0;
        else
          h = errordlg('Variable name must be a string','Invalid input','modal');
          waitfor(h);
        end;
      else
        h = errordlg('Invalid value for variable name','Invalid input','modal');
        waitfor(h);
      end;

    end;

% Save the result
    assignin('base',var_name,spec_rad);
