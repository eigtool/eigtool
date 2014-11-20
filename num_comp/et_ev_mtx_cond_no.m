function varargout = et_ev_mtx_cond_no(varargin)

% function varargout = et_ev_mtx_cond_no(varargin)
%
% Function to compute the condition number of the matrix of
% eigenvectors from the current EigTool.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If the argument is 'name', return the text to go in the menu and return
  if isstr(varargin{1}) & strcmp(varargin{1},'name')==1,
    varargout{1} = '&Eigenvector Matrix Cond. No.';
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

  if ~isfield(ps_data.numbers,'ev_mtx_cond_no'),

% Compute the condition number of the user's original matrix
    [V,D] = eig(ps_data.input_matrix);
    cond_no = cond(V);
    vars.field = 'ev_mtx_cond_no';
    vars.value = cond_no;
  else
    cond_no = ps_data.numbers.ev_mtx_cond_no;
  end;

% Ask the user what to do with the answer
    cont = 1;
    while cont==1,

      AddOpts.Resize='on';
      AddOpts.WindowStyle='modal';
      AddOpts.Interpreter='tex';
      s = inputdlg({['The value of the condition number of the eigenvector matrix is ', ...
                      num2str(cond_no,'%10.5e'),'. ' ...
                     'If you would like to save this number to the MATLAB workspace, ' ...
                     'please enter the variable name below.' ]}, ...
                     'Variable name...', 1,{'cond_no'},AddOpts);
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
    assignin('base',var_name,cond_no);
