function set_eigtool_prefs(op)

%SET_EIGTOOL_PREFS - Reset or update EigTool's preferences.
%   SET_EIGTOOL_PREFS will update EigTool's preferences to ensure that
%   all of the preferences for the current version are set.
%
%   SET_EIGTOOL_PREFS(OP) allows all of the preferences to be reset
%   to their default values. OP is one of 'default' or 'update'.
%
%   See also: EIGTOOL

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Don't force the prefs back to default unless specifically asked to
  if nargin<1, op = 'update'; end;

% Create a variable for ease of coding
  if strcmp(op,'default'),
    def = 1;
  else 
    def = 0;
  end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now add the preferences %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Which version of EigTool are these prefs for? Always set this preference
  setpref('EigTool','version',2.04);

%% ONLY SET THE FOLLOWING PREFS if we're asking for default, or they don't
%% already exist

% Create a smaller Figure for laptop users
  if def | ~ispref('EigTool','SMALL_GUI'), setpref('EigTool','SMALL_GUI',0); end;

% Colourmap
  if def | ~ispref('EigTool',''), setpref('EigTool','colormap',eigtool_colourmap); end;

% EigTool options defaults
  if def | ~ispref('EigTool','levels_default'), setpref('EigTool','levels_default','auto'); end;
  if def | ~ispref('EigTool','ax_default'), setpref('EigTool','ax_default','auto'); end;
  if def | ~ispref('EigTool','proj_lev_default'), setpref('EigTool','proj_lev_default',Inf); end;
  if def | ~ispref('EigTool','colour_default'), setpref('EigTool','colour_default',1); end;
  if def | ~ispref('EigTool','thick_lines_default'), setpref('EigTool','thick_lines_default',1); end;
  if def | ~ispref('EigTool','scale_equal_default'), setpref('EigTool','scale_equal_default',1); end;
  if def | ~ispref('EigTool','print_plot_default'), setpref('EigTool','print_plot_default',0); end;
  if def | ~ispref('EigTool','no_graphics_default'), setpref('EigTool','no_graphics_default',0); end;
  if def | ~ispref('EigTool','no_waitbar_default'), setpref('EigTool','no_waitbar_default',0); end;
%  if def | ~ispref('EigTool','ews_default'), setpref('EigTool','ews_default',[]); end;
  if def | ~ispref('EigTool','dim_default'), setpref('EigTool','dim_default',1); end;
  if def | ~ispref('EigTool','grid_default'), setpref('EigTool','grid_default',0); end;
  if def | ~ispref('EigTool','assign_output_default'), setpref('EigTool','assign_output_default',0); end;
  if def | ~ispref('EigTool','fov_default'), setpref('EigTool','fov_default',0); end;
  if def | ~ispref('EigTool','unitary_mtx_default'), setpref('EigTool','unitary_mtx_default',1); end;
  if def | ~ispref('EigTool','no_ews_default'), setpref('EigTool','no_ews_default',0); end;
  if def | ~ispref('EigTool','no_psa_default'), setpref('EigTool','no_psa_default',0); end;
  if def | ~ispref('EigTool','imag_axis_default'), setpref('EigTool','imag_axis_default',0); end;
  if def | ~ispref('EigTool','unit_circle_default'), setpref('EigTool','unit_circle_default',0); end;
  if def | ~ispref('EigTool','colourbar_default'), setpref('EigTool','colourbar_default',1); end;
  if def | ~ispref('EigTool','disp_pts_default'), setpref('EigTool','disp_pts_default','on'); end;

% EigTool eigs options defaults
  if def | ~ispref('EigTool','p_default'), setpref('EigTool','p_default','auto'); end;
  if def | ~ispref('EigTool','tol_default'), setpref('EigTool','tol_default','auto'); end;
  if def | ~ispref('EigTool','v0_default'), setpref('EigTool','v0_default','auto'); end;
  if def | ~ispref('EigTool','which_default'), setpref('EigTool','which_default','LM'); end;
  if def | ~ispref('EigTool','maxit_default'), setpref('EigTool','maxit_default','auto'); end;
  if def | ~ispref('EigTool','direct_default'), setpref('EigTool','direct_default','auto'); end;

% Other defaults
  if def | ~ispref('EigTool','print_ew_size'), setpref('EigTool','print_ew_size',16); end;
  if def | ~ispref('EigTool','usage_count'), setpref('EigTool','usage_count',0); end;
