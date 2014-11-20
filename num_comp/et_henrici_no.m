function varargout = et_henrici_no(varargin)

% function varargout = et_henrici_no(varargin)
%
% Function to compute Henrici's departure from normality for the 
% matrix from the current EigTool.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If the argument is 'name', return the text to go in the menu and return
  if isstr(varargin{1}) & strcmp(varargin{1},'name')==1,
    varargout{1} = '&Departure from Normality';
    varargout{2} = 'd';
    varargout{3} = 's';
    return;

% If it isn't, we're being passed the data from EigTool - store it
% as ps_data
  else
    ps_data = varargin{1};
  end;

% Must set this for correct operation
  varargout{1} = {};

% Compute (or read) the departure from normality
  if ~isfield(ps_data.numbers,'departure_normality'),
    dep_norm = norm(triu(ps_data.schur_matrix,1),'fro');
    vars.field = 'departure_normality';
    vars.value = dep_norm;
    varargout{1} = {{vars}};
  else
    dep_norm = ps_data.numbers.departure_normality;
  end;

% Ask the user what to do with the answer
    cont = 1;
    while cont==1,

      AddOpts.Resize='on';
      AddOpts.WindowStyle='modal';
      AddOpts.Interpreter='tex';
      s = inputdlg({['Henrici''s departure from normality for this matrix is ', ...
                      num2str(dep_norm,'%15.3g'),'.']}, ...
                     'Variable name...', 1,{'dep_norm'},AddOpts);
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
    assignin('base',var_name,dep_norm);

