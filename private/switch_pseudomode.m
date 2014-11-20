function ps_data = switch_pseudomode(fig,cax,ps_data,mtype)

% function ps_data = switch_pseudomode(fig,cax,ps_data,mtype)
%
% Function that is called when the user presses the Psmode
% button.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Get the current state of the Go button (for later
  the_handle = findobj(fig,'Tag','RedrawPlot');
  go_state = get(the_handle,'Enable');
  set(the_handle,'Enable','off');

  disable_controls(fig);
  switch mtype
  case 'P', ps_data = update_messagebar(fig,ps_data,29);
  case 'E', ps_data = update_messagebar(fig,ps_data,5);
  end;

%% Get the point and work out which eigenvalue is closest
  the_pt = ginput_eigtool(1,'crosshair');
  sel_pt = the_pt(1)+1i*the_pt(2);

  if strcmp(mtype,'E') & ~isempty(ps_data.ews),
    [ew,pos] = min(abs(ps_data.ews-sel_pt));

%% Plot the point in cyan to indicate which ew is being used
    marker_h=plot(real(ps_data.ews(pos)),imag(ps_data.ews(pos)), ...
           'co','markersize',12,'linewidth',5);
    sel_pt = ps_data.ews(pos);
  else
%% Plot the point in cyan to indicate which ew is being used
    marker_h=plot(the_pt(1),the_pt(2), ...
           'mo','markersize',12,'linewidth',5);
  end;

  drawnow;

% Are we now using a direct method?
  direct_method = get(findobj(fig,'Tag','Direct'),'value');

% If we have a Schur decomposition, use that.
  if direct_method & isfield(ps_data,'schur_matrix'),
    A = ps_data.schur_matrix;
    unitary_mtx = ps_data.schur_unitary_mtx;

% If there is a projected matrix, but it's square, must be from Schur
% projection (not Arnoldi), so use orig matrices
  elseif ~direct_method & isfield(ps_data,'proj_matrix') ...
       & size(ps_data.proj_matrix,1)==size(ps_data.proj_matrix,2),
    A = ps_data.schur_matrix;
    unitary_mtx = ps_data.schur_unitary_mtx;

% If not, if we have a proj_matrix from Arnoldi, use that 
  elseif isfield(ps_data,'proj_matrix') ...
       & size(ps_data.proj_matrix,1)==size(ps_data.proj_matrix,2)+1 ... 
       & direct_method==0
    A = ps_data.proj_matrix;
    unitary_mtx = ps_data.proj_unitary_mtx;

% If we're now using a direct method, must have a sparse matrix to get
% here (no Schur), so use that
  elseif direct_method==1 & issparse(ps_data.input_matrix),
    A = ps_data.input_matrix;
    unitary_mtx = ps_data.input_unitary_mtx;

% If all else fails, just use the current working matrix (for example if
% computed using dense, then iterative selected but not computed)
  else
    A = ps_data.matrix;
    unitary_mtx = ps_data.unitary_mtx;
  end;

%% Actually do the plotting (restricting A to the upper nn by nn section
%% so we can approximate pseudomodes for matrices from the Arnoldi factorisation)
  [mm,nn] = size(A); A = A(1:nn,1:nn); 
  pmfig = plot_psmode(fig,sel_pt,A,unitary_mtx,mtype,ps_data.no_waitbar,mm==nn+1);

%% Revert the message string
  ps_data = update_messagebar(fig,ps_data,'prev');

  enable_controls(fig,ps_data);

%% If there was an error
  if pmfig<1, 
    delete(marker_h); return;
  end;

%% Delete the old marker if the figure was already there
  if length(ps_data.mode_markers)>=pmfig & ~isempty(ps_data.mode_markers{pmfig}),
    delete(ps_data.mode_markers{pmfig}.h);
  end;

%% Store data so the marker can be redrawn/deleted
  marker_info.h = marker_h;
  marker_info.pos = sel_pt;
  marker_info.type = mtype;
  ps_data.mode_markers{pmfig} = marker_info;

%% Reset the state of the Go button
  the_handle = findobj(fig,'Tag','RedrawPlot');
  set(the_handle,'Enable',go_state);
