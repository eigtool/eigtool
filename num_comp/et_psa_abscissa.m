function varargout = et_psa_abscissa(varargin)

% function varargout = et_psa_abscissa(varargin)
%
% Function to call Mengi & Overton's code for computing the
% pseudospectral abscissa of the current matrix.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If the argument is 'name', return the text to go in the menu and return
  if isstr(varargin{1}) & strcmp(varargin{1},'name')==1,
    varargout{1} = 'Pseudospectral &Abscissa';
    varargout{2} = 'd';
    varargout{3} = 's';
    return;

% If it isn't, we're being passed the data from EigTool - store it
% as ps_data
  else
    ps_data = varargin{1};
  end;

%% Must set this for correct operation
  varargout{1} = {};

% Add the necessary directories to the path
  addpath([et_get_file_location('eigtool'),'num_comp/pseudo_abscissa']);

% Ask the user for the epsilon level to compute with
    cont = 1;
    while cont==1,

      s = inputdlg({['Please enter the value of epslion to compute the ' ...
                     'pseudospectra abscissa for.']}, ...
                   'Epsilon value...', 1,{''});
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, error (will be trapped below)
        epsln = 'error';
      else
        epsln = str2num(s{1});
      end;

% Check the value we've got
      if length(epsln)==1,
        if epsln>=0
          cont = 0;
        else
          h = errordlg('Value of epsilon must be non-negative','Invalid input','modal');
          waitfor(h);
        end;
      else
        h = errordlg('Invalid value for epsilon','Invalid input','modal');
        waitfor(h);
      end;

    end;

    already_computed = 0;
    if isfield(ps_data.numbers,'pseudospectral_abscissa'),
      pa = ps_data.numbers.pseudospectral_abscissa;
      for i=1:length(pa),
        if pa{i}.eps==epsln,
          already_computed = i;
          break;
        end; 
      end;
    end;

    if ~isfield(ps_data.numbers,'pseudospectral_abscissa') ...
      | already_computed==0,

% Now actually do the computation, using the user's *original* matrix
      [f, z] = pspa_2way(ps_data.input_matrix, epsln, 0, 0, 0);
% Setup the data to go back to EigTool
      vars.field = 'pseudospectral_abscissa';
      if isfield(ps_data.numbers,'pseudospectral_abscissa'),
        psa_abs = ps_data.numbers.pseudospectral_abscissa;
      else
        psa_abs = {};
      end;
      pos = length(psa_abs)+1;
      psa_abs{pos}.eps = epsln;
      psa_abs{pos}.value = f;
      psa_abs{pos}.global_opts = z;
      vars.value = psa_abs;
      for i=1:length(z),
        markers{i}.pos = z(i);
        markers{i}.style = 'mo';
        markers{i}.size = 12;
      end;
      varargout{1} = {{vars},markers};

    else
      f = ps_data.numbers.pseudospectral_abscissa{already_computed}.value;
      z = ps_data.numbers.pseudospectral_abscissa{already_computed}.global_opts;

% Recreate the marker information here, as any previous markers
% will be deleted on completion of this routine.
      for i=1:length(z),
        markers{i}.pos = z(i);
        markers{i}.style = 'mo';
        markers{i}.size = 12;
      end;
      varargout{1} = {{},markers};
    end;

% Ask the user what to do with the answer
    cont = 1;
    while cont==1,

      AddOpts.Resize='on';
      AddOpts.WindowStyle='modal';
      AddOpts.Interpreter='tex';
      s = inputdlg({['The value of the pseudospectral abscissa for \epsilon = ' ...
                     num2str(epsln,'%7.2e'),' is ',num2str(f,'%10.5e'),'. ' ...
                     'If you would like to save this number to the MATLAB workspace, ' ...
                     'please enter the variable name below:'],['Enter a name for a variable ' ...
                     'to store the location at which the pseudospectral abscissa is attained:']}, ...
                     'Variable name...', [1;1],{'psa_abs','loc_abs'},AddOpts);
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      else
        psa_abs = s{1};
        global_opts = s{2};
      end;

% Check the value we've got
      if length(psa_abs)>=1 & length(global_opts)>=1,
        if isstr(psa_abs) & isstr(global_opts),
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
    assignin('base',psa_abs,f);
    assignin('base',global_opts,z);
