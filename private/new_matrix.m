function ps_data = new_matrix(A,fig,opts)

% function ps_data = new_matrix(A,fig,opts)
%
% Function called when a new matrix is input. It checks that
% the matrix is valid, asks relevant questions about the
% computation and sets things up.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  disable_controls(fig);
  drawnow    % mpe: this fixes a strange button problem...

  if nargin<3, opts.dummy = 1; end;

%% Get the version for different MATLAB 5/6 things
  this_matlab = ver('matlab');
  this_ver = str2num(this_matlab.Version);

%% Check the options which have been input and set the defaults for the rest.
  [npts, levels, ax, proj_lev, colour, thick_lines, scale_equal, ...
       print_plot, no_graphics, no_waitbar, Aisreal, ews, dim, grid, ...
       assign_output,fov,unitary_mtx,no_ews,no_psa, ...
       k,p,tol,v0,which,maxit,direct, ...
       imag_axis,unit_circle,colourbar] = ...
               check_opts(opts,size(A,1),size(A,2),1-isreal(A));

%% Test to see whether we have the mex-file computation module. If not, give
%% a message.
%  if exist('psacore','file')==2,
%    disp(' ');
%    disp('********************************************************************');
%    disp('Using the m-file version of psacore.');
%    disp('For maximum performance, please download the more efficient compiled');
%    disp('mex-file version for your system from the EigTool website.');
%    disp('********************************************************************');
%    disp(' ');
%  end;

%% Get a handle to the main axes
  cax = findobj(fig,'Tag','MainAxes');

% Save the important fields from before
  old_ps_data = get(fig,'userdata');
  if isfield(old_ps_data,'print_line_thickness'),
    ps_data.print_line_thickness = old_ps_data.print_line_thickness;
  end;

%% Initialise the first message
  ps_data.current_message = 1;
  ps_data.last_message = 1;

  if isfield(old_ps_data,'ARPACK_p'),
    ps_data.ARPACK_p = old_ps_data.ARPACK_p;
  end;
  if isfield(old_ps_data,'ARPACK_tol'),
    ps_data.ARPACK_tol = old_ps_data.ARPACK_tol;
  end;
  if isfield(old_ps_data,'ARPACK_maxit'),
    ps_data.ARPACK_maxit = old_ps_data.ARPACK_maxit;
  end;
  if isfield(old_ps_data,'ARPACK_v0'),
    ps_data.ARPACK_v0 = old_ps_data.ARPACK_v0;
  end;
  if isfield(old_ps_data,'ARPACK_v0_cmd'),
    ps_data.ARPACK_v0_cmd = old_ps_data.ARPACK_v0_cmd;
  end;
  if isfield(old_ps_data,'ARPACK_which'),
    ps_data.ARPACK_which = old_ps_data.ARPACK_which;
  end;
  if isfield(old_ps_data,'proj_valid'),
    ps_data.proj_valid = old_ps_data.proj_valid;
  end;
  if isfield(old_ps_data,'print_plot_num'),
    ps_data.print_plot_num = old_ps_data.print_plot_num;
  end;

%% If this field is specified, set the colour options
  hdl = findobj(fig,'Tag','Colour');
  if colour==1,
    set(hdl,'checked','on');
  else
    set(hdl,'checked','off');
  end;

%% Set the default line thickness if not already specified
  hdl = findobj(fig,'Tag','ThickLines');
  if thick_lines==0,
    set(hdl,'checked','off');
  elseif thick_lines==1,
    set(hdl,'checked','on');
  else
    ps_data.print_line_thickness = thick_lines;
    set(fig,'UserData',ps_data);
    set(hdl,'checked','on');
  end;
  cur_state = get(hdl,'checked');
  if strcmp(cur_state,'on'),
    set(fig,'defaultpatchlinewidth',2);
    set(fig,'defaultlinelinewidth',2);
  else
    set(fig,'defaultpatchlinewidth',1);
    set(fig,'defaultlinelinewidth',1);
  end;

%% Set the value for the dimension display setting if necessary
  if dim==1,
    set(findobj(fig,'Tag','ShowDimension'),'Checked','on');
  else
    set(findobj(fig,'Tag','ShowDimension'),'Checked','off');
  end;

%%% Set the value for the grid display setting if necessary
  if grid==1,
    set(findobj(fig,'Tag','ShowGrid'),'Checked','on');
  else
    set(findobj(fig,'Tag','ShowGrid'),'Checked','off');
  end;

%%% Set the value for the eigenvalue display setting if necessary
  if no_ews==0,
    set(findobj(fig,'Tag','DisplayEWS'),'Checked','on');
  else
    set(findobj(fig,'Tag','DisplayEWS'),'Checked','off');
  end;

  if no_psa==0,
    set(findobj(fig,'Tag','DisplayPSA'),'Checked','on');
  else
    set(findobj(fig,'Tag','DisplayPSA'),'Checked','off');
  end;

%%% Set the defaults for the imaginary axis/unit circle display
  if imag_axis==1,
    set(findobj(fig,'Tag','DisplayImagA'),'Checked','on');
  else
    set(findobj(fig,'Tag','DisplayImagA'),'Checked','off');
  end;
  if unit_circle==1,
    set(findobj(fig,'Tag','DisplayUnitC'),'Checked','on');
  else
    set(findobj(fig,'Tag','DisplayUnitC'),'Checked','off');
  end;

%% Show colourbar?
  if colourbar==1,
    set(findobj(fig,'Tag','DisplayColourbar'),'Checked','on');
  else
    set(findobj(fig,'Tag','DisplayColourbar'),'Checked','off');
  end;

% Start with axis equal?
  set(findobj(fig,'Tag','ScaleEqual'),'Value',scale_equal);
  if scale_equal==0,
    set(cax,'DataAspectRatioMode','auto');
  else
    set(cax,'DataAspectRatioMode','manual');
    set(cax,'DataAspectRatio',[1 1 1]);
  end;

% Use the old value (i.e. the one set in eigtool, which comes from user's
% original opts) if possible
  if isfield(old_ps_data,'no_waitbar'),
    ps_data.no_waitbar = old_ps_data.no_waitbar;
  else
    ps_data.no_waitbar = no_waitbar;
  end;

% Store the input matrix for possible later use, before anything's been
% done to it
  ps_data.input_matrix = A;

% Uncheck all the items in the Numbers menu (except the last one, which should
% be checked according to the preferences - the 'Display Points' item)
  hdl = findobj(fig,'Tag','NumbersMenu');
  hdls = get(hdl,'children');
  for i=1:length(hdls),
    set(hdls(i),'checked','off');
  end;
  hdl = findobj(fig,'Tag','DisplayPoints');
  set(hdl,'checked',getpref('EigTool','disp_pts_default'));

  ps_data.numbers = [];
  ps_data.numbers.markers = {};
  ps_data.mode_markers = {};
  ps_data.proj_valid = 0;
  ps_data.comp = '';

%% Check the matrix itself - ask for another one if there are problems (by 
%% pretending that the button was pressed).
%% Note that at this point the new ps_data hasn't been written to the GUI,
%% so cancel will still allow the user to return to what they were doing before.
  [A,ierr,ps_data.isHessenberg] = matrix_check(A,opts);
  if ierr~=0,
    ps_data.matrix = [];
    ps_data.input_matrix = [];
    enable_controls(fig,ps_data);
% Display some text on the screen as a welcome
    ps_data = update_messagebar(fig,ps_data,30);
    ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
    set(fig,'userdata',ps_data);
    return;
  end;

  [m,n] = size(A);

  if isfield(opts,'print_plot'),
    print_plot_only = opts.print_plot;
  else
    print_plot_only = 0;
  end;

if strcmp(direct,'auto'),
%% The default for direct/ARPACK is determined by whether A is stored  % mpe
%% as a dense or sparse matrix.  If the dimension is large, GUI users  % mpe
%% will be prompted to choose a default; if opts.print_plot = 1, a     % mpe
%% warning message will be printed to the console window.  This is a   % mpe
%% modification of the default logic used in EigTool 2.04.             % mpe
  if ~issparse(A)
     button='Direct';
     if n>1600
        if print_plot_only
           fprintf('\nWarning: The matrix you have input is large.\n');
           fprintf('Warning: Since it is dense, EigTool will default to a direct technique.\n');
           fprintf('Warning: Consider using ARPACK for faster operation (set opts.dense=0).\n');
           fprintf('Warning: You can set ARPACK/eigs parameters via "opts"; see "help eigtool".\n\n');
        else
           dopts.CreateMode = 'modal';
           dopts.Default = 'ARPACK/eigs';
           dopts.Interpreter = 'none';
           button = questdlg(['The matrix you have input is large; it is recommended that you use an iterative method. Please select either a direct method or ARPACK/eigs (this choice can be changed later).'],'Large matrix...','Direct','ARPACK/eigs',dopts);
       end
     end
  else  % A is sparse
     button = 'ARPACK/eigs';
     if (n<=200)&(print_plot_only)
           fprintf('\nWarning: The matrix you have input is sparse but relatively small.\n');
           fprintf('Warning: Since it is sparse, EigTool will default to a sparse technique (ARPACK/eigs).\n');
           fprintf('Warning: Consider using a direct method for this problem (set opts.dense=1).\n\n');
     elseif (n>1600)&(print_plot_only)
           fprintf('\nWarning: The matrix you have input is large and sparse.\n');
           fprintf('Warning: Since it is sparse, EigTool will default to a sparse technique (ARPACK/eigs).\n');
           fprintf('Warning: You can set ARPACK/eigs parameters via "opts"; see "help eigtool".\n');
           fprintf('Warning: If you prefer to use a sparse direct method, set opts.dense=1.\n');
           fprintf('Warning: To use a dense direct method, use "full" to convert to dense, then call EigTool.\n\n');
     elseif (n>1600)&(~print_plot_only)
           dopts.CreateMode = 'modal';
           dopts.Default = 'ARPACK/eigs';
           dopts.Interpreter = 'none';
           button = questdlg(['The matrix you have input is sparse; it is recommended that you use an iterative method or convert it to a full matrix before continuing.'],'Large matrix...','Sparse Direct','Convert to Full','ARPACK/eigs',dopts);
     end
  end
  if strcmp(button,'Sparse Direct')  % mpe
     ps_data.sparse_direct = 1;      % mpe
  end                                % mpe
  if strcmp(button,'Direct') | strcmp(button,'Sparse Direct') 
     direct_method = 1;
  elseif strcmp(button,'Convert to Full') 
     direct_method = 1;
     A = full(A);
  else
     direct_method = 0;
  end;
% Have a default input through the options, so don't need to ask questions
else
  direct_method = direct;
end;

% Set up the 'Which ews' menu properly
  ps_data.ARPACK_which = '';
  which_hdl = findobj(fig,'Tag','Which');
  which_vals = get(which_hdl,'userdata');
  wm = ismember(which_vals,which);
  if ~any(wm),
    warning('Invalid option: which contains invalid data; using default value.');
  end;
  set(which_hdl,'Value',find(wm));  
  ps_data = switch_which(fig,cax,this_ver,ps_data,1);

% Set the ARPACK k parameter
  hdl = findobj(fig,'Tag','ARPACK_k');
  set(hdl,'String',k);

% Set the other ARPACK parameters
  ps_data.ARPACK_p = p;
  ps_data.ARPACK_tol = tol;
  ps_data.ARPACK_maxit = maxit;
  ps_data.ARPACK_v0 = v0;
  if ~strcmp(ps_data.ARPACK_v0,'auto'),
    ps_data.ARPACK_v0_cmd = '<Set using input options>';
  end;  

%% Remember whether A is real or not
  ps_data.AisReal = Aisreal;

%% Initialise the data-structure for the figure info
  ps_data.zoom_list = {};
  ps_data.zoom_pos = 1;

  ps_data.zoom_list{ps_data.zoom_pos}.npts=npts;

% Store the input unitary matrix - we want to accumulate this with all
% other unitary transformations used within the computation
  ps_data.input_unitary_mtx = unitary_mtx;

%% ps_data.matrix contains the matrix to compute pseudospectra of
%% ps_data.ews contains the eigenvalues
  if m==n & ~issparse(A) & direct_method,
    ps_data = update_messagebar(fig,ps_data,38);
    [ps_data.schur_unitary_mtx,ps_data.schur_matrix,actual_ews] = ...
                fact(A,ps_data.no_waitbar);

% The working matrix should be the Schur factor at this point
    ps_data.matrix = ps_data.schur_matrix;
    ps_data.unitary_mtx = ps_data.schur_unitary_mtx;

%% Use the computed eigenvalues if there were no supplied values
    if isempty(ews), ps_data.ews = actual_ews;
    else ps_data.ews = ews; end;

%% Update the unitary matrix to include one input via options
    ps_data.unitary_mtx = ps_data.input_unitary_mtx*ps_data.unitary_mtx;

    ps_data.projection_on = 1;
  elseif issparse(A) | ps_data.isHessenberg | direct_method==0,
    ps_data.matrix = A;
    ps_data.unitary_mtx = ps_data.input_unitary_mtx;
    ps_data.matrix2 = 1;
    ps_data.ews = ews;
    ps_data.projection_on = 0;
    proj_lev = inf;
  else
    ps_data = update_messagebar(fig,ps_data,38);
    [ps_data.matrix,ps_data.matrix2] = rect_fact(A);
    ps_data.unitary_mtx = ps_data.input_unitary_mtx;
    ps_data.ews = ews;
    ps_data.projection_on = 0;
    proj_lev = inf;
  end;

% Store these as the original eigenvalues to return to later
  ps_data.orig_ews = ps_data.ews;

% Assume that these eigenvalues are exact, so don't colour them differently
  ps_data.ew_estimates = 0;

  if ~ps_data.isHessenberg, 
%% This is not checked in check_opts: if matrix is not Hessenberg, unitary
%% matrix dimensions could be incorrect. Dimensions will be incorrect for 
%% Hess. matrices since only the upper nxn square is used for pseudomode
%% computations.
%% This code allows the possibility that ps_data.unitary_mtx == 1 or a
%% matrix which is of a compatible dimension
    if size(ps_data.unitary_mtx,2)~=m & size(ps_data.unitary_mtx,2)~=1,
      ps_data.unitary_mtx = 1;
    end;
  end;

%% If no axes were input
  if strcmp(ax,'auto'),
    ax = [];  %% Default axes based on eigenvalue locations will be used
  end;

%% Set the axis variables
  ps_data.zoom_list{ps_data.zoom_pos}.ax = ax;
  ps_data.init_opts.ax = ax;

%% ps_data.zoom_list{ps_data.zoom_pos}.levels contains the epsilon levels to plot
  if strcmp(levels,'auto'),
    ps_data.zoom_list{ps_data.zoom_pos}.levels=comp_lev([-3:-1]);
                           %% Overwritten by automatic level creation
                           %% But must have values...
    ps_data.zoom_list{ps_data.zoom_pos}.autolev = 1;
  else 
%% ... and say what the levels are
    ps_data.zoom_list{ps_data.zoom_pos}.levels=comp_lev(levels);
    ps_data.zoom_list{ps_data.zoom_pos}.autolev = 0;
  end;

  ps_data.zoom_list{ps_data.zoom_pos}.proj_lev=proj_lev;
  ps_data.zoom_list{ps_data.zoom_pos}.dims = size(ps_data.matrix);

%% Save the initial values for use when returning to initial plot
  ps_data.init_opts.npts = ps_data.zoom_list{ps_data.zoom_pos}.npts;
  ps_data.init_opts.levels = ps_data.zoom_list{ps_data.zoom_pos}.levels;
  ps_data.init_opts.autolev = ps_data.zoom_list{ps_data.zoom_pos}.autolev ;
  ps_data.init_opts.proj_lev = ps_data.zoom_list{ps_data.zoom_pos}.proj_lev;
  ps_data.init_opts.direct = direct;

  set(fig,'UserData',ps_data);

% If there is a transient figure associated with this GUI, remove its Tag so
% that a new one must be computed before lower bound etc. can be used.
  tfig = find_trans_figure(fig,'A',1);
  if tfig~=-1,
    set(tfig,'Tag','');
  end;

% If a direct method should be used
  if direct_method,

% Shrink/grow (depending on colourbar) the axes and make them visible
    grow_main_axes(fig,1-colourbar);

%% Ask for axes if the matrix is rectangular or sparse and no axis limits input
    if ((m~=n & ~isfield(opts,'ax')) ...
      | (issparse(A) & ~isfield(opts,'ax'))) & isempty(ews),
      mouse_fn = get(fig,'WindowButtonDownFcn');
      set(fig,'WindowButtonDownFcn','');
      set(fig,'CurrentAxes',cax);
      set(cax,'Visible','on');
%% The "axlimdlg" option has been removed from MATLAB, so we need a kludge.  % mpe
      ax_prompt = {'min real: ', 'max real: ', 'min imag: ', 'max imag:'};   % mpe
      ax_title = 'Axis limits';                                              % mpe
      ax_default = {'-1','1','-1','1'};                                      % mpe
      ax_opts.WindowStyle='modal';                                           % mpe
      h = inputdlg(ax_prompt,ax_title,1,ax_default,ax_opts);                 % mpe
%%    h = axlimdlg('Please define axis limits...');
      axis([str2num(h{1}) str2num(h{2}) str2num(h{3}) str2num(h{4})]);       % mpe
      set(fig,'WindowButtonDownFcn',mouse_fn);

      if this_ver<6,
        ax = axis;
      else
        ax = axis(cax);
      end;
      ps_data.zoom_list{ps_data.zoom_pos}.ax = ax;
    end;

%% Set the GUI for direct method (computation will begin immediately)
    ps_data = switch_method(fig,cax,this_ver,ps_data,'Direct',1);
    set(fig,'userdata',ps_data);

%% And automatically launch into computation
    if isempty(ax),
%% Use the default area
      ps_data = switch_origplot(fig,cax,this_ver,ps_data);
    else
%% Pretend the 'Redraw' button has been pressed - we now have our area sorted.
      ps_data = switch_redraw(fig,cax,this_ver,ps_data);
    end
%% Compute the field of values if necessary
    if fov==1 & m==n & ~issparse(A),
      set(findobj(fig,'Tag','FieldOfVals'),'value',1); % Set the state
      ps_data = switch_fieldofvals(fig,cax,this_ver,ps_data);
    else
      set(findobj(fig,'Tag','FieldOfVals'),'value',0); % Set the state
    end;
  else

% The ARPACK computation is currently stopped
    ps_data.comp_stopped = 'ARPACK';

% Clear the axes now we have a new matrix
    cla(cax);

%% Set the GUI for iterative method (user will be able to change parameters)
    ps_data = switch_method(fig,cax,this_ver,ps_data,'Indirect',1);
    it_handle = findobj(fig,'Tag','Iterative');
    set(it_handle,'Enable','on');
    the_handle = findobj(fig,'Tag','Direct');
    set(the_handle,'Enable','on');

    set(fig,'userdata',ps_data);

% Grow the axes and make them visible
    grow_main_axes(fig,1);

% If iterative was selected via options, just proceed with computation
% Do the same if iterative was selected via a default, but print_plot==1. % mpe
    if direct==0|((direct_method==0)&(print_plot==1)),                    % mpe

%% Pretend the 'Redraw' button has been pressed - we now have our area sorted.
      ps_data = switch_redraw(fig,cax,this_ver,ps_data);

% If it was determined by questions above, just allow user to continue when
% ready.
    else
%% Enable the Go! button and allow the user to change parameters
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      ps_data = update_messagebar(fig,ps_data,37);

%% Make sure that the edit text boxes say the right thing
      if this_ver<6,
        set(fig,'CurrentAxes',cax);
        the_ax = axis;
      else
        the_ax = axis(cax);
      end;
      set_edit_text(fig,the_ax, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
    end;
  end;

  enable_controls(fig,ps_data);
