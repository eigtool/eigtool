function varargout = eigtool(varargin)

%EIGTOOL  Start EigTool.
%   EIGTOOL starts EigTool, an interactive system for
%       - computation and plotting of eigenvalues, eigenvectors, 
%         pseudospectra and related quantities
%       - graphical interface to EIGS for large sparse eigenvalue
%         calculations.
%
%   EIGTOOL(A) starts EigTool with input matrix A. If A is square, it can be
%   dense or sparse; if it is rectangular, it can only be dense with more rows
%   than columns.
%
%   EIGTOOL(A,OPTS) specifies options:
%   OPTS.npts: number of gridpoints in longer direction [scalar | {default}]
%   OPTS.levels: log10(eps) for desired eps-pseudospectra [vector | {default}]
%   OPTS.ax: axis on which to compute [4-by-1 vector | {default}]
%   OPTS.proj_lev: projection level to use (0..Inf) [scalar | {Inf}]
%   OPTS.color: draw the pseudospectra using colored lines [0 | {1}]
%   OPTS.thick_lines: draw the pseudospectra using thick lines [0 | {1}]
%   OPTS.scale_equal: use `axis equal' on axes [0 | {1}]
%   OPTS.print_plot: only create a plot with pseudospectra (no GUI) [{0} | 1]
%   OPTS.no_graphics: compute singular value data only [{0} | 1]
%   OPTS.no_waitbar: suppress display of waitbar during computations [{0} | 1]
%   OPTS.isreal: is A (complex) similar to a real matrix? [{0} | 1]
%   OPTS.ews: eigenvalues of rectangular/sparse matrices [vector | {[]}]
%   OPTS.dim: display the matrix dimension on the plot [0 | {1}]
%   OPTS.grid: display the grid as dots on the plot [{0} | 1]
%   OPTS.no_ews: suppress display of the eigenvalues [{0} | 1]
%   OPTS.no_psa: suppress display of the pseudospectra [{0} | 1]
%   OPTS.fov: display field of values [{0} | 1]
%   OPTS.unitary_mtx: a unitary transformation to apply to eigenmodes and
%        pseudoeigenmodes [matrix | {[]}]
%   OPTS.imag_axis: highlight the imaginary axis in grey [{0} | 1]
%   OPTS.unit_circle: highlight the unit circle in grey [{0} | 1]
%   OPTS.colourbar: draw the colourbar on the plot [0 | {1}]
%   OPTS.direct: use direct (vs. iterative) method [0 | 1 | {default}]
%
%   The following options relate to iterative eigenvalue computation and
%   are passed to EIGS. See EIGS help for more information.
%   OPTS.k: no. of eigenvalues for EIGS to search for [1..n | {default}]
%   OPTS.p: max. subspace size for EIGS [1..n | {default}]
%   OPTS.which: which eigenvalues for EIGS? [string| {default}]
%   OPTS.tol: tolerance for EIGS to use [scalar | {default}]
%   OPTS.maxit: max. no. iterations for EIGS [1..Inf | {default}]
%   OPTS.v0: starting vector for EIGS [vector | {default}]
%
%   EIGTOOL(A,FIG) starts EigTool in figure number FIG.
%
%   EIGTOOL(A,OPTS,FIG) uses options OPTS and starts EigTool in figure number FIG.
%
%   EIGTOOL(DATA_FILE) loads data saved from EigTool's `Extras' menu in the file
%   DATA_FILE and creates a figure of the pseudospectra.
%
%   [X,Y,SIGS] = EIGTOOL(A) returns vectors X and Y defining a grid on which
%   the singular values SIGS have been computed.
%
%   EIGTOOL(X,Y,SIGS) creates a figure of pseudospectra from grid data X 
%   and Y and singular value data SIGS.
%
%   EIGTOOL(X,Y,SIGS,FIG) creates the pseudospectra in figure number FIG.
%
%   EIGTOOL(X,Y,SIGS,OPTS) uses options OPTS. Note that not all options are applicable
%   here. For example, the axes are determined by X and Y, not OPTS.ax.
%
%   EIGTOOL(X,Y,SIGS,OPTS,FIG) uses options OPTS and creates the pseudospectra in
%   figure number FIG.
%
%   Full documentation for the operation of EigTool can be obtained from the
%   Help menu.
%
%   For more information about pseudospectra, see:
%       http://www.comlab.ox.ac.uk/pseudospectra/
%
%   EigTool was designed and built at Oxford University during 2000-2002 by
%   Thomas G. Wright in collaboration with Mark Embree and Lloyd N. Trefethen. 
%
%   The codes in EigTool for computing pseudospectral abscissae and pseudospectral radii
%   have been provided by Michael Overton and Emre Mengi of New York University:
%       http://www.cs.nyu.edu/faculty/overton/
%
%   Examples:
%      N = 10; c = [1 1 ./ cumprod(1:N)]; A = compan(fliplr(c)); eigtool(A);
%      A = gallery('smoke',64); opts.levels = -8:-1; opts.npts = 20; eigtool(A,opts); 
%
%      Many more examples of pseudospectra are available through the `Demos' menu
%      of EigTool.
%
%   See also: EIG, EIGS, PSADEMO, SET_EIGTOOL_PREFS

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the University of Oxford nor the names of its
%       contributors may be used to endorse or promote products derived from
%       this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


% Possible input arg combinations are:
%   eigtool
%   eigtool(A)
%   eigtool(datafile_name)
%   eigtool(A,opts)
%   eigtool(A,fig_no)
%   eigtool(A,opts,fig_no)
%   eigtool(x,y,Z)
%   eigtool(x,y,Z,opts)
%   eigtool(x,y,Z,fig_no)
%   eigtool(x,y,Z,opts,fig_no)

% One or more arguments, no problem: first is called A if it's a matrix
%                                    or data_file if it's a file name.


  if nargin>=1,
    if isstr(varargin{1}),
      data_file = varargin{1};
    else
      A = varargin{1};
    end;
  end;

% Two arguments: either opts of fig_no
  if nargin==2,
    if isnumeric(varargin{2}),
      fig = varargin{2};
    else
      opts = varargin{2};
    end;
  end;

% Three arguments: either matrix, opts & fig_no, or data to send
%                  to contour plotter
  if nargin==3,
    if isstruct(varargin{2}), % 2nd argument is opts
      opts = varargin{2}; 
      fig = varargin{3};
    else % Must be inputting data to contour plot
      x = varargin{1};
      y = varargin{2};
      Z = varargin{3};
    end;
  end;

% Four arguments: Must be contour data, with either opts or fig_no
  if nargin==4,
    x = varargin{1};
    y = varargin{2};
    Z = varargin{3};
    if isnumeric(varargin{4}),
      fig = varargin{4};
    else
      opts = varargin{4};
    end;
  end;

% Five arguments: data to contour plot, opts and fig_no
  if nargin==5,
    x = varargin{1};
    y = varargin{2};
    Z = varargin{3};
    opts = varargin{4};
    fig = varargin{5};
  end;

%% Create an options data structure in case we don't have one...
  if ~exist('opts','var'), opts.dummy = 1; end;

%% If the first argument is a string, assume it is
%% a data file and setup the printable matrix and finish
  if nargin>0 & exist('data_file','var'),
    load(data_file);

%% Create these variables in case file saved in old versions of GUI
    if ~exist('dim_str','var'), dim_str = ''; end;
    if ~exist('grid_on','var'), grid_on = 0; end;
    if ~exist('fov','var'), fov = []; end;
    if ~exist('no_ews','var'), no_ews = 0; end;
    if ~exist('no_psa','var'), no_psa = 0; end;
    if ~exist('imag_axis','var'), imag_axis = 0; end;
    if ~exist('unit_circle','var'), unit_circle = 0; end;
    if ~exist('colourbar','var'), colourbar = 1; end;

%% Don't display eigenvalues if this is specified
    if no_ews, ews = []; end;

    if exist('ew_estimates','var'), approx_ews = ew_estimates;
    else approx_ews = 0; end;

%% Display the psa depending on menu selection
    if no_psa==1,
      Z = zeros(size(Z));
    end;

%% Setup the figure
    if exist('fig','var'),
      setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
                      thick_lines,scale_equal,dim_str, ...
                      grid_on,fov,approx_ews,imag_axis,unit_circle, ...
                      colourbar,fig);
    else
      setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
                      thick_lines,scale_equal,dim_str, ...
                      grid_on,fov,approx_ews,imag_axis,unit_circle, ...
                      colourbar);
    end;

    if nargout>0,
      varargout{1} = x;
      varargout{2} = y;
      varargout{3} = Z;
    end;

    return;
  end;

%% If we've got data to contour plot
  if exist('x','var') & exist('y','var') & exist('Z','var'),
%% Check that the dimensions are consistent
    x = x(:); y = y(:);
    lx = length(x);
    ly = length(y);
    [zm,zn] = size(Z);
    if lx~=zn | ly~=zm,
      h = errordlg('The dimensions of x, y and Z do not agree: cannot use this data for a contour plot.', ...
                   'Invalid input arguments...','modal');
      waitfor(h);
      return;
    end;

%% Don't need this, so ignore it to prevent error messages
    if isfield(opts,'unitary_mtx'), 
      opts = rmfield(opts,'unitary_mtx');
    end;

%% Check the options which have been input and set the defaults for the rest.
    [npts, levels, ax, proj_lev, colour, thick_lines, scale_equal, print_plot, ...
           no_graphics, no_waitbar, Aisreal, ews, dim, grid, assign_output,fov ...
           unitary_mtx,no_ews,no_psa,k,p,tol,v0,which,maxit,direct, ...
           imag_axis,unit_circle,colourbar] = ...
                  check_opts(opts,10,10,0);

%% Setup the axes (ignore anything from the options)
    ax = reshape([x([1 end]) y([1 end])],1,4);

%% Generate automatic levels if necessary
   if strcmp(levels,'auto'),
     [levels,err] = recalc_lev(Z,ax);
%% If an error occured
     if err~=0,
       if err==-1,
         errordlg('Range too small---no contours to plot. Refine grid or zoom out.','Error...','modal');
       elseif err==-2
         errordlg('Matrix too non-normal---resolvent norm is infinite everywhere. Zoom out!','Error...','modal');
       end;

%% Now leave - nothing more we can do here
       return;
     end;
   end;

%% Don't display eigenvalues if this is specified
   if no_ews, ews = []; end;

    if exist('ew_estimates','var'), approx_ews = ew_estimates;
    else approx_ews = 0; end;

%% Display the psa depending on menu selection
    if no_psa==1,
      Z = zeros(size(Z));
    end;

%% Create the printable plot with these options
    if exist('fig','var'),
      setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
                      thick_lines,scale_equal,'',grid,fov, ...
                      approx_ews,imag_axis,unit_circle,colourbar,fig);
    else
      setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
                      thick_lines,scale_equal,'',grid,fov, ...
                      approx_ews,imag_axis,unit_circle,colourbar);
    end;

%% Assign the output arguments if necessary
    if nargout>0,
      varargout{1} = x;
      varargout{2} = y;
      varargout{3} = Z;
    end;

%% Leave the routine: we're done now
    return;

  end;

%% If print_plot==1, want to put the printable plot in the given figure number,
%% not the GUI, which can go in any number
  if isfield(opts,'print_plot'),
    if  opts.print_plot == 1 ,
      if exist('fig','var') & isnumeric(fig) & length(fig)==1 & ...
                fig>=1 & fig==floor(fig) & isreal(fig),
        fig = figure(fig);
      else
        fig = figure;
      end;
      if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me  
      ps_data.print_plot_num = fig;
%% Want the GUI to assume some other number now
      clear fig;
    end;
  end;

%% Start up the GUI (default to a new figure)
  if ~exist('fig','var'), fig = eigtoolgui(1);
      if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me  


  else % But if a figure number is provided in the options
    if isnumeric(fig) & length(fig)==1 & fig>=1 & fig==floor(fig) & isreal(fig),
% Get the handle to the figure and check that the Tag field
% looks like it belongs to the GUI
      fig = figure(fig);
      if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me
      if ~strcmp('EigTOOL',get(fig,'Tag')) | isempty(findobj(fig,'Tag','MainAxes')),
        clf;
        fig = eigtoolgui(1,-fig);
        if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me
      end;
    else 
      fig = eigtoolgui(1); 
      if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me
    end
  end;

%% Set up the array for pausing computation
  global pause_comp;
  pause_comp(fig) = 0;

%% If the field opts.print_plot or opts.no_graphics is set, 
%% make GUI window invisible
  if isfield(opts,'print_plot'),
    if  opts.print_plot == 1 ,
      set(fig,'Visible','off');
      set(fig,'userdata',ps_data);
    end;
  end;
  if isfield(opts,'no_graphics'),
    if  opts.no_graphics == 1 ,
      set(fig,'Visible','off');
    end;
  end;

%% Get a handle to the main axes
  cax = findobj(fig,'Tag','MainAxes');

%% Make sure the filename is blanked out to ensure that the GUI
%% doesn't get overwritten if the user choses save from the file menu
  set(fig,'FileName','');
  set(fig,'CurrentAxes',cax);

%% Get the version for different MATLAB 5/6 things
  this_matlab = ver('matlab');
  this_ver = str2num(this_matlab.Version);

%% Need this so that check_opts works if no A input
  if nargin==0, A = 1; end;

%% Initialise the first message
  ps_data.current_message = 1;
  ps_data.last_message = 1;
  ps_data.go_btn_state = 'off';
  ps_data.mode_markers = {};

% Store the data
  set(fig,'userdata',ps_data);

%% If we were called with no arguments
if nargin==0,

% Use dummy data for the matrix
  ps_data.matrix = [];

% Store the data
  set(fig,'userdata',ps_data);

%% Disable all the controls, then enable the appropriate ones
  disable_controls(fig);
  enable_controls(fig,ps_data);

% Display some text on the screen as a welcome
  ps_data = update_messagebar(fig,ps_data,30);
  ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

% Store the data
  set(fig,'userdata',ps_data);

%% Otherwise call new_matrix with the options
else

%% Error if no output arguments and no graphics
  if isfield(opts,'no_graphics') & opts.no_graphics==1 & nargout==0,
    h = errordlg('You have requested no graphics and no output arguments!', ...
             'Invalid input arguments...','modal');
    waitfor(h);
    close(fig);
    return;
  end;

%% Set up the GUI for a new matrix
  ps_data = new_matrix(A,fig,opts);

%% Save the data to the figure
  set(fig,'userdata',ps_data);

%% If the user has requested that the output be assigned into the base
%% workspace
  if isfield(opts,'assign_output') & opts.assign_output==1,
    ps_data=get(fig,'userdata');
    assignin('base','psa_output_x',ps_data.zoom_list{ps_data.zoom_pos}.x);
    assignin('base','psa_output_y',ps_data.zoom_list{ps_data.zoom_pos}.y);
    assignin('base','psa_output_Z',ps_data.zoom_list{ps_data.zoom_pos}.Z);
  end;

%% If no graphics, close the GUI
  if isfield(opts,'no_graphics') & opts.no_graphics == 1,
    close(fig);

%% If print_plot is set, close the GUI and leave just the printable plot
  elseif isfield(opts,'print_plot') & opts.print_plot == 1,
    switch_print(fig,ps_data);
    close(fig);
  end;

%% Return the arguments
  if nargout>0,
    varargout{1} = ps_data.zoom_list{ps_data.zoom_pos}.x;
    varargout{2} = ps_data.zoom_list{ps_data.zoom_pos}.y;
    varargout{3} = ps_data.zoom_list{ps_data.zoom_pos}.Z;
  end;

end;
