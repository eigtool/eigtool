function [npts, levels, ax, proj_lev, colour, ...
          thick_lines, scale_equal, print_plot, ...
          no_graphics, no_waitbar, Aisreal, ews, ...
          dim, grid,assign_output,fov, ...
          unitary_mtx,no_ews,no_psa,k,p,tol,v0,which,maxit,direct, ...
          imag_axis,unit_circle,colourbar] = ...
                  check_opts(opts,m,n,iscomplex)

% function [npts, levels, ax, proj_lev, colour, ...
%           thick_lines, scale_equal, print_plot, ...
%           no_graphics, no_waitbar, Aisreal, ews, ...
%           dim, grid,assign_output,fov, ...
%           unitary_mtx,no_ews,no_psa,k,p,tol,v0,which,maxit,direct] = ...
%                   check_opts(opts,m,n,iscomplex)
% This function takes the options supplied to the GUI checks that the values
% are valid and returns the contents. If a value is not supplied or is invalid,
% the default value is returned.
%
% opts         The options structre
% m,n          dimension of the problem (for calculating npts_default & unitary_mtx)
% iscomplex    is the matrix complex (for calculating npts_default)
%
% npts            The number of gridpoints in each direction
% levels          The contour levels to plot
% ax              The axes to use
% proj_lev        The amount of projection to use
% colour          Draw the lines in colour?
% thick_lines     Draw with thick lines?
% scale_equal     Have axis equal set?
% print_plot      Create a printable plot only?
% no_graphics     Don't display any graphics, just compute singular value data (if 1)
% no_waitbar      Don't display any waitbars
% Aisreal         Set to 1 if the input matrix is real (and hence psa is symmetric)
% ews             Set to eigenvalues of input matrix if rectangular or sparse
% dim             Set to 1 to display the matrix dimensions on the plot
% grid            Set to 1 to display the grid on the plot
% assign_output   Set to 1 to create variables psa_output_x, psa_output_y and
%                 psa_output_Z containing the computed data in the base workspace
% fov             display the field of values
% unitary_mtx     Unitary transformation used for example when matrix is from 
%                 Arnoldi projection
% no_ews          Set to 1 to avoid display of eigenvalues
% no_psa          Set to 1 to avoid display of pseudospectra
% k               Number of eigenvalues for eigs to search for
% p               Maximum subspace size for eigs
% tol             Tolerance for eigs to use
% v0              Starting vector for eigs
% which           Which eigenvalues should eigs look for (e.g., 'LR')
% maxit           Maximum number of eigs iterations
% direct          Use a direct method (1) or iterative method (0)
% imag_axis       display the imaginary axis as a grey line
% unit_circle     display the unit circle in grey
% colourbar       display the colourbar?

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Define the default values for each of the options in case
%% they are needed

%% This relation determined by experiment...
%% 300/x^(5/6) gives approx the number of points to use. Then use max 100, min 24.
%% Default to a fast grid whose size is determined by this relation.
npts_default = setgridsize(n,24,80,iscomplex);
Aisreal_default = 1-iscomplex;

levels_default = getpref('EigTool','levels_default');
ax_default = getpref('EigTool','ax_default');
proj_lev_default = getpref('EigTool','proj_lev_default');
colour_default = getpref('EigTool','colour_default');
thick_lines_default = getpref('EigTool','thick_lines_default');
scale_equal_default = getpref('EigTool','scale_equal_default');
print_plot_default = getpref('EigTool','print_plot_default');
no_graphics_default = getpref('EigTool','no_graphics_default');
no_waitbar_default = getpref('EigTool','no_waitbar_default');

% Currently, don't seem to be able to have empty vector in prefs...
%ews_default = getpref('EigTool','ews_default');
ews_default = [];

dim_default = getpref('EigTool','dim_default');
grid_default = getpref('EigTool','grid_default');
assign_output_default = getpref('EigTool','assign_output_default');
fov_default = getpref('EigTool','fov_default');
unitary_mtx_default = getpref('EigTool','unitary_mtx_default');
no_ews_default = getpref('EigTool','no_ews_default');
no_psa_default = getpref('EigTool','no_psa_default');
imag_axis_default = getpref('EigTool','imag_axis_default');
unit_circle_default = getpref('EigTool','unit_circle_default');
colourbar_default = getpref('EigTool','colourbar_default');

% EigTool eigs options defaults
p_default = getpref('EigTool','p_default');
tol_default = getpref('EigTool','tol_default');
v0_default = getpref('EigTool','v0_default');
which_default = getpref('EigTool','which_default');
maxit_default = getpref('EigTool','maxit_default');
direct_default = getpref('EigTool','direct_default');

% Set the default k value - must be <m-1, but at this point there
% might be no matrix, so just make it the default.
k_default = min(m-2,6);
if k_default<1, k_default = 6; end;

%% Make sure user finds out about this
warning_state = warning;
warning on

%% Now actually check all the options which may (or may not) have been entered

%% Check the number of gridpoints
if isfield(opts,'npts'),
  if isnumeric(opts.npts) & length(opts.npts)==1 & opts.npts>4,
    npts = opts.npts;
  else
    warning('Invalid option: npts contains invalid data; using default value.');
    npts = npts_default;
  end;
else
  npts = npts_default;
end;


%% Check the levels
if isfield(opts,'levels'),
  if isnumeric(opts.levels),
    if length(opts.levels)>1,
      levels = sort(opts.levels);
    elseif length(opts.levels)==1,
      levels = opts.levels*[1, 1];
    end;
  else
    warning('Invalid option: levels contains invalid data; using default value.');
    levels = levels_default;
  end;
else
  levels = levels_default;
end;


%% Check the axis range
if isfield(opts,'ax'),
  if isnumeric(opts.ax) & length(opts.ax)==4 & opts.ax(2)>opts.ax(1) & opts.ax(4)>opts.ax(3),
    ax = opts.ax;
  else
    warning('Invalid option: ax contains invalid data; using default value.');
    ax = ax_default;
  end;
else
  ax = ax_default;
end;


%% Check the projection level
if isfield(opts,'proj_lev'),
  if isnumeric(opts.proj_lev) & length(opts.proj_lev)==1,
    proj_lev = opts.proj_lev;
  else
    warning('Invalid option: proj_lev contains invalid data; using default value.');
    proj_lev = proj_lev_default;
  end;
else
  proj_lev = proj_lev_default;
end;


%% Check the colour setting (allowing for both English and American spelling)
if isfield(opts,'color'),
  opts.colour = opts.color;
end;

if isfield(opts,'colour'),
  if isnumeric(opts.colour) & length(opts.colour)==1 ...
     & (opts.colour==0 | opts.colour==1),
    colour = opts.colour;
  else
    warning('Invalid option: colour contains invalid data; using default value.');
    colour = colour_default;
  end;
else
  colour = colour_default;
end;


%% Check the thick lines setting
if isfield(opts,'thick_lines'),
  if isnumeric(opts.thick_lines) & length(opts.thick_lines)==1 & opts.thick_lines>=0,
    thick_lines = opts.thick_lines;
  else
    warning('Invalid option: thick_lines contains invalid data; using default value.');
    thick_lines = thick_lines_default;
  end;
else
  thick_lines = thick_lines_default;
end;


%% Check the scale-equal setting
if isfield(opts,'scale_equal'),
  if isnumeric(opts.scale_equal) & length(opts.scale_equal)==1 ...
     & (opts.scale_equal==0 | opts.scale_equal==1),
    scale_equal = opts.scale_equal;
  else
    warning('Invalid option: scale_equal contains invalid data; using default value.');
    scale_equal = scale_equal_default;
  end;
else
  scale_equal = scale_equal_default;
end;


%% Check the printable plot only setting
if isfield(opts,'print_plot'),
  if isnumeric(opts.print_plot) & length(opts.print_plot)==1 ...
     & (opts.print_plot==0 | opts.print_plot==1),
    print_plot = opts.print_plot;
  else
    warning('Invalid option: print_plot contains invalid data; using default value.');
    print_plot = print_plot_default;
  end;
else
  print_plot = print_plot_default;
end;

%% Check the no graphics setting
if isfield(opts,'no_graphics'),
  if isnumeric(opts.no_graphics) & length(opts.no_graphics)==1 ...
     & (opts.no_graphics==0 | opts.no_graphics==1),
    no_graphics = opts.no_graphics;
  else
    warning('Invalid option: no_graphics contains invalid data; using default value.');
    no_graphics = no_graphics_default;
  end;
else
  no_graphics = no_graphics_default;
end;


%% Check the no waitbar setting
if isfield(opts,'no_waitbar'),
  if isnumeric(opts.no_waitbar) & length(opts.no_waitbar)==1 ...
     & (opts.no_waitbar==0 | opts.no_waitbar==1),
    no_waitbar = opts.no_waitbar;
  else
    warning('Invalid option: no_waitbar contains invalid data; using default value.');
    no_waitbar = no_waitbar_default;
  end;
else
  no_waitbar = no_waitbar_default;
end;

%% Check the isreal setting
if isfield(opts,'isreal'),
  if isnumeric(opts.isreal) & length(opts.isreal)==1 ...
     & (opts.isreal==0 | opts.isreal==1),
    Aisreal = opts.isreal;
  else
    warning('Invalid option: isreal contains invalid data; using default value.');
    Aisreal = Aisreal_default;
  end;
else
  Aisreal = Aisreal_default;
end;


%% Check the ews setting
if isfield(opts,'ews'),
  if isnumeric(opts.ews),
    ews = opts.ews(:);
  else
    warning('Invalid option: ews contains invalid data; using default value.');
    ews = ews_default;
  end;
else
  ews = ews_default;
end;

%% Check the dim setting
if isfield(opts,'dim'),
  if isnumeric(opts.dim) & length(opts.dim)==1 ...
     & (opts.dim==0 | opts.dim==1),
    dim = opts.dim;
  else
    warning('Invalid option: dim contains invalid data; using default value.');
    dim = dim_default;
  end;
else
  dim = dim_default;
end;

%% Check the grid setting
if isfield(opts,'grid'),
  if isnumeric(opts.grid) & length(opts.grid)==1 ...
     & (opts.grid==0 | opts.grid==1),
    grid = opts.grid;
  else
    warning('Invalid option: grid contains invalid data; using default value.');
    grid = grid_default;
  end;
else
  grid = grid_default;
end;

%% Check the assign_output setting
if isfield(opts,'assign_output'),
  if isnumeric(opts.assign_output) & length(opts.assign_output)==1 ...
     & (opts.assign_output==0 | opts.assign_output==1),
    assign_output = opts.assign_output;
  else
    warning('Invalid option: assign_output contains invalid data; using default value.');
    assign_output = assign_output_default;
  end;
else
  assign_output = assign_output_default;
end;

%%% Check the fov setting
if isfield(opts,'fov'),
  if isnumeric(opts.fov) & length(opts.fov)==1 ...
     & (opts.fov==0 | opts.fov==1),
    fov = opts.fov;
  else
    warning('Invalid option: fov contains invalid data; using default value.');
    fov = fov_default;
  end;
else
  fov = fov_default;
end;

%%% Check the unitary_mtx setting
%%% Allow for orig mtx to be rect n+1 by n since nxn square will be used for
%%% pseudomode computations.
if isfield(opts,'unitary_mtx'),
  if isnumeric(opts.unitary_mtx) & ... 
           (size(opts.unitary_mtx,2)==m | size(opts.unitary_mtx,2)==m-1) ,
    unitary_mtx = opts.unitary_mtx;
  else
    warning('Invalid option: unitary_mtx contains invalid data; using default value.');
    unitary_mtx = unitary_mtx_default;
  end;
else
  unitary_mtx = unitary_mtx_default;
end;

%%% Check the no_ews setting
if isfield(opts,'no_ews'),
  if isnumeric(opts.no_ews) & length(opts.no_ews)==1 ...
     & (opts.no_ews==0 | opts.no_ews==1),
    no_ews = opts.no_ews;
  else
    warning('Invalid option: no_ews contains invalid data; using default value.');
    no_ews = no_ews_default;
  end;
else
  no_ews = no_ews_default;
end;

%%% Check the no_psa setting
if isfield(opts,'no_psa'),
  if isnumeric(opts.no_psa) & length(opts.no_psa)==1 ...
     & (opts.no_psa==0 | opts.no_psa==1),
    no_psa = opts.no_psa;
  else
    warning('Invalid option: no_psa contains invalid data; using default value.');
    no_psa = no_psa_default;
  end;
else
  no_psa = no_psa_default;
end;

%% Check the ARPACK k parameter
if isfield(opts,'k'),
  if isnumeric(opts.k) & length(opts.k)==1 & opts.k>0 & opts.k<m-1,
    k = opts.k;
  else
    warning('Invalid option: k contains invalid data; using default value.');
    k = k_default;
  end;
else
  k = k_default;
end;

%% Check the ARPACK p parameter
if isfield(opts,'p'),
  if isnumeric(opts.p) & length(opts.p)==1 & opts.p>0 & opts.p<=m,
    p = opts.p;
  else
    warning('Invalid option: p contains invalid data; using default value.');
    p = p_default;
  end;
else
  p = p_default;
end;

%% Check the ARPACK tol parameter
if isfield(opts,'tol'),
  if isnumeric(opts.tol) & length(opts.tol)==1 & opts.tol>=0,
    tol = opts.tol;
  else
    warning('Invalid option: tol contains invalid data; using default value.');
    tol = tol_default;
  end;
else
  tol = tol_default;
end;

%% Check the ARPACK v0 parameter
if isfield(opts,'v0'),
  if isnumeric(opts.v0) & size(opts.v0,1)==m & size(opts.v0,2)==1,
    v0 = opts.v0;
  else
    warning('Invalid option: v0 contains invalid data; using default value.');
    v0 = v0_default;
  end;
else
  v0 = v0_default;
end;

%% Check the ARPACK which parameter
if isfield(opts,'which'),
  if ischar(opts.which) & length(opts.which)==2,
    which = upper(opts.which);
  else
    warning('Invalid option: which contains invalid data; using default value.');
    which = which_default;
  end;
else
  which = which_default;
end;

%% Check the ARPACK maxit parameter
if isfield(opts,'maxit'),
  if isnumeric(opts.maxit) & length(opts.maxit)==1 & opts.maxit>0,
    maxit = opts.maxit;
  else
    warning('Invalid option: maxit contains invalid data; using default value.');
    maxit = maxit_default;
  end;
else
  maxit = maxit_default;
end;

%% Check the direct parameter
if isfield(opts,'direct'),
  if isnumeric(opts.direct) & length(opts.direct)==1 ...
     & (opts.direct==0 | opts.direct==1),
    direct = opts.direct;
  else
    warning('Invalid option: direct contains invalid data; using default value.');
    direct = direct_default;
  end;
else
  direct = direct_default;
end;

%%% Check the imag_axis setting
if isfield(opts,'imag_axis'),
  if isnumeric(opts.imag_axis) & length(opts.imag_axis)==1 ...
     & (opts.imag_axis==0 | opts.imag_axis==1),
    imag_axis = opts.imag_axis;
  else
    warning('Invalid option: imag_axis contains invalid data; using default value.');
    imag_axis = imag_axis_default;
  end;
else
  imag_axis = imag_axis_default;
end;

%% Check the unit_circle setting
if isfield(opts,'unit_circle'),
  if isnumeric(opts.unit_circle) & length(opts.unit_circle)==1 ...
     & (opts.unit_circle==0 | opts.unit_circle==1),
    unit_circle = opts.unit_circle;
  else
    warning('Invalid option: unit_circle contains invalid data; using default value.');
    unit_circle = unit_circle_default;
  end;
else
  unit_circle = unit_circle_default;
end;

%%% Check the colourbar setting
if isfield(opts,'colourbar'),
  if isnumeric(opts.colourbar) & length(opts.colourbar)==1 ...
     & (opts.colourbar==0 | opts.colourbar==1),
    colourbar = opts.colourbar;
  else
    warning('Invalid option: colourbar contains invalid data; using default value.');
    colourbar = colourbar_default;
  end;
else
  colourbar = colourbar_default;
end;

% Now reset the warning state
warning(warning_state);

