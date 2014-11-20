function eigtool_switch_fn(the_function, the_fig)

% function eigtool_switch_fn(the_function, the_fig)
%
% This is the switch function used internally by the pseudospectra
% GUI to handle callback functions when buttons are pressed, text
% is edited etc. It is not intended to be called manually by a user.
%
% the_function     a string containing the callback called
% the_fig          the figure it applies to
%
% See also: EIGTOOL

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Entries of datastructure ps_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input_matrix          used to store the user's original matrix
% schur_matrix          used to store the original Schur decomposition
% proj_matrix           the projected matrix, either from Arnoldi or projection
% input_unitary_mtx     unitary matrix entered by user (optional)
% schur_unitary_mtx     unitary matrix from Schur decomposition
% proj_unitary_mtx      unitary matrix from Arnoldi projection
% matrix                pointer to the current working matrix
% unitary_mtx           pointer to the current unitary matrix
% matrix2               Rectangular matrices can give rise to generalised problems
% ews                   the eigenvalues of the matrix
%
% proj_ews              the eigenvalues projected onto during projection
% comp_proj_lev         the projection level used when the projection was performed
% proj_axes             the axes used for the projection
% projection_on         Indicates whether user can change projection level or not
%
% fov                   data for the field of values plot
% show_fov              1/0 - is the field of values currently visible?
%
% AisReal               true if orig mtx was real
% isHessenberg          matrix is rectangular (n+1)xn Hessenberg?
% sparse_direct         use a sparse direct method to avoid Schur factorization
%
% no_waitbar            flag to say whether to use waitbar or not (0/1)
% init_opts             some of the original options input to the GUI
% current_message       pointer to the current message to display in the message bar
%                       (the messages are in the UserData field of MessageFrame)
% last_message          the previous message shown (currently unused)
% mode_markers          list of handles & positions of (pseudo)eigenvalue markers
%
% zoom_pos              pointer to current data location in zoom list
% zoom_list             a list of zooms and associated data (see below for fields)
% zoom_list{}.computed  Was this level computed, or merely zoomed?
% zoom_list{}.npts      the number of points in the pseudospectra grid
% zoom_list{}.levels    the epsilon levels to use
% zoom_list{}.ax        the axis for the figure
% zoom_list{}.Z         Z, array of min sig returned by PSA codes
% zoom_list{}.x         x, vector of grid points returned by PSA codes
% zoom_list{}.y         y, vector of grid points returned by PSA codes
% zoom_list{}.proj_lev  the factor to use for projection (0..Inf)
% zoom_list{}.autolev   automatically select levels (0/1)
% zoom_list{}.dims      dimension of the ORIGINAL matrix (i.e. before any projection)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% If the routine is being called from a callback routine, use that figure
%% as the figure handle. If not, the value should be passed in as a parameter.
if ~isempty(gcbf) & nargin < 2,
  fig=gcbf;
else
  fig = the_fig;
end;
if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me


%% Make sure that these global variables still exist (they might
%% have been cleared by a user typing 'clear all'
global pause_comp;
global stop_comp;
if isempty(pause_comp), pause_comp(fig) = 0; end;
if isempty(stop_comp), stop_comp(fig) = 0; end;

%% Extract the data from the figure
ps_data=get(fig,'UserData');  

%% Get the version for different MATLAB 5/6 things
this_matlab = ver('matlab');
this_ver = str2num(this_matlab.Version);

%% Get a handle to the Main Axes and make them the default.
cax = findobj(fig,'Tag','MainAxes');
set(fig,'CurrentAxes',cax);

%% If the string is to a demo, split it up
if strcmp(the_function(1:4),'Demo'),
  the_demo = the_function(5:end);
  the_function = the_function(1:4);
end;

% Remember the original mode markers here for use at the 
% bottom of the routine
omm = ps_data.mode_markers;

%% This is where things start to happen...
switch the_function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'STOP'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cancel has been pressed - stop computation
    switch_stop(fig);
% Unpause things, so stop will be noticed
  pause_comp(fig) = 0;
  toggle_pause_btn(fig,'Pause','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case {'Pause','Resume'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ps_data = switch_pause(fig,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Redraw'    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Re-compute the contour data
    ps_data = switch_redraw(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'RedrawContour'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Actually draw the contour data etc. on the figure
    ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'PsArea'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Handle mouse clicks in the graphics window
    ps_data = switch_psarea(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EditXmin'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New axis limit entered
    ps_data = switch_editxmin(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EditXmax'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New axis limit entered
    ps_data = switch_editxmax(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EditYmin'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New axis limit entered
    ps_data = switch_editymin(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EditYmax'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New axis limit entered
    ps_data = switch_editymax(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EpsLevMin'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Levels to show changed
    ps_data = switch_epslevmin(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EpsLevPts'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Number of levels to show changed
    ps_data = switch_epslevpts(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EpsLevMax'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Levels to show changed
    ps_data = switch_epslevmax(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ARPACK_k'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Levels to show changed
    ps_data = switch_arpack_k(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'MeshSize'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mesh size changed
    ps_data = switch_meshsize(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Safety'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Safety level changed
    ps_data = switch_safety(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'OrigPlot'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Called when first entering the GUI, or when 'Start Again' chosen.
    ps_data = switch_origplot(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'AutoLev'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The user clicked on 'Smart levels'
    ps_data = switch_autolev(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ScaleEqual'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has changed the 'Scale Equal' option
    ps_data = switch_scaleequal(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ThickLines'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has changed the 'Thick Lines' option
    ps_data = switch_thicklines(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'FOVnpts'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has changed the 'Thick Lines' option
    ps_data = switch_fovnpts(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Print'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Print'
    switch_print(fig,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Print3D'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Print 3D'
    switch_print3d(fig,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ExportEWS'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Export Ews'
    switch_exportews(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ExportMtx'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Export Matrix'
    switch_exportmtx(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ExportSchur'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Export Schur Factor'
    switch_exportschur(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ExportPSA'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Export PSA'
    switch_exportpsa(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Import'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'New Matrix'
    [return_now,new_ps_data] = switch_import(fig,ps_data);
    if return_now, 
      enable_controls(fig,new_ps_data);
      return;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'EwCond'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Eigenvalue condition number'
    ps_data = switch_pseudomode(fig,cax,ps_data,'E');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'RVecResid'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Eigenvalue condition number'
    ps_data = switch_rvecresid(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'PseudoMode'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Display pseudomode'
    ps_data = switch_pseudomode(fig,cax,ps_data,'P');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'FieldOfVals'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected 'Display pseudomode'
    ps_data = switch_fieldofvals(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'CreateCode'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display code' option
    ps_data = switch_createcode(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'UnequalLevels'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Unequal Levels' option
    ps_data = switch_unequallevels(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Colour'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Show Dimension' option
    ps_data = switch_colour(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ShowDimension'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Show Dimension' option
    ps_data = switch_showdimension(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ShowGrid'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Show Grid' option
    ps_data = switch_showgrid(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayEWS'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Eigenvalues' option
    ps_data = switch_display_ews(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayPSA'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Eigenvalues' option
    ps_data = switch_display_psa(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayImagA'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Eigenvalues' option
    ps_data = switch_display_imaga(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayUnitC'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Eigenvalues' option
    ps_data = switch_display_unitc(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayColourbar'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Eigenvalues' option
    ps_data = switch_display_colourbar(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'PrintOnly'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'save data for printing' option
    ps_data = switch_printonly(fig,cax,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'FileSave'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% User has selected the 'save data for printing' option
    ps_data = switch_filesave(fig,ps_data,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'FileSaveAs'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% User has selected the 'save data for printing' option
    ps_data = switch_filesave(fig,ps_data,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Demo'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected a demo option
    ps_data = switch_demo(fig,ps_data,the_demo);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'LargerMatrix'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Larger Matrix' option
    ps_data = switch_largermatrix(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'FinerGrid'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Finer Grid' option
    ps_data = switch_finergrid(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ChooseP'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Max subspace size' option
    ps_data = switch_choosep(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ChooseTol'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Tolerance' option
    ps_data = switch_choosetol(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ChooseMaxit'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Maximum Iterations' option
    ps_data = switch_choosemaxit(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ChooseV0'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Choose V0' option
    ps_data = switch_choosev0(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ARPACK_auto_ax'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'ARPACK Auto. Axes' option
    ps_data = switch_arpack_auto_ax(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ProgRVals'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Finer Grid' option
    ps_data = switch_progrvals(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ProgPSA'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Finer Grid' option
    ps_data = switch_progpsa(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'ProgAllShifts'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Finer Grid' option
    ps_data = switch_progallshifts(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Which'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has changed the 'Which ews' menu
    ps_data = switch_which(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case {'Direct','Iterative'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected one of the radio buttons
    ps_data = switch_method(fig,cax,this_ver,ps_data,the_function);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'MatrixPowers'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ps_data = switch_mtxpowers(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'MatrixExp'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ps_data = switch_mtxexps(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'TransientLB'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ps_data = switch_transientlb(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'TransientBestLB'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ps_data = switch_transientbestlb(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'PSADEMO'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected one of the demos
    switch_psademo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DisplayPoints'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Display Points' option
    ps_data = switch_displaypoints(fig,cax,this_ver,ps_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Quit'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User has selected the 'Quit' option
%% (This is not in a function, since want to stop when figure is closed)
    opts.CreateMode = 'modal';
    opts.Default = 'Yes';
    opts.Interpreter = 'none';
    button = questdlg('Are you sure you want to quit?','Quit?','Yes','No',opts);
    switch button
    case 'Yes'
       set(fig,'CloseRequestFcn','closereq');
       close(fig);
       return;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is there just in case of a bug somewhere!
    errordlg([the_function ': Undefined action! This should not ' ...
             'have happened in the release version. Please contact ' ...
             'tgw@comlab.ox.ac.uk.'],'Error...','modal');

end;  % END OF SWITCH STATEMENT

% Make sure we've seen any updates to the mode markers - compare
% with the original ones (omm, defined at the top of this routine)
% and delete any that have been removed inbetween. Note that we have
% to be careful in the case of transient LB markers, since these can
% be both deleted and recreated in the same pass. Thus we check the 
% position and handles for equality before removing the marker.
  updated_ps_data = get(fig,'userdata');
  umm = updated_ps_data.mode_markers;
  for i=1:min([length(omm),length(umm)]),
    if isempty(umm{i}) & ~isempty(omm{i}) ...
       & all(omm{i}.pos==ps_data.mode_markers{i}.pos) ...
       & omm{i}.h(1)==ps_data.mode_markers{i}.h(1),
      ps_data.mode_markers{i} = [];
    end;
  end;

% Now copy any changes to the data back again
  set(fig,'UserData',ps_data);

%% Make sure anything that we've done has been updated
  drawnow;

%% Make the Main Axes the default again, so the user can use matlab#
%% commands on them.
  set(fig,'CurrentAxes',cax);
