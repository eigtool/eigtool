function ps_data = switch_redraw(fig,cax,this_ver,ps_data)

% function ps_data = switch_redraw(fig,cax,this_ver,ps_data)
%
% Function to recompute the pseudospectra data

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  global pause_comp
  global stop_comp;

%% Disable the controls and clear the axis.
  disable_controls(fig);

%% If we're using direct methods or already have a valid computed projection
  if get(findobj(fig,'Tag','Direct'),'Value')==1 | (isfield(ps_data,'proj_valid') & ps_data.proj_valid),

    ps_data = update_messagebar(fig,ps_data,38);

%% In some situations, we reach this point when essentially we have no information yet.  % mpe
%% For example, EigTool is called with a sparse matrix, and then user selects "Direct".  % mpe
%% We need to compute a Schur factorization, get an axis, etc.                           % mpe
%% The substance of this code is lifted from new_matrix.m                                % mpe
                                                                                         % mpe 
   [n m] = size(ps_data.matrix);                                                         % mpe
   plot_eigs = 0;                                                                        % mpe
   if (n==m)&(get(findobj(fig,'Tag','Direct'),'Value')==1)& ...                          % mpe
         (~isfield(ps_data,'schur_matrix'))&(~isfield(ps_data,'sparse_direct'))          % mpe
% Determine if sparse-direct or perform perform a Schur factorization                    % mpe
      button = 'Convert to Full';                                                        % mpe
      if issparse(ps_data.matrix)&(n>1600)                                               % mpe
         dopts.CreateMode = 'modal';                                                     % mpe
         dopts.Default = 'Convert to Full';                                              % mpe
         dopts.Interpreter = 'none';                                                     % mpe
         button = questdlg(['The matrix you have input is large and sparse, and you wish to use a direct method.  To continue, specify whether to convert to a full matrix (Schur decomposition), or use sparse direct methods.'],'Large matrix...','Convert to Full','Sparse Direct','Convert to Full');                              % mpe
      end                                                                                % mpe
      if strcmp(button,'Convert to Full')                                                % mpe
         [ps_data.schur_unitary_mtx,ps_data.schur_matrix,ps_data.ews] ...                % mpe
              = fact(full(ps_data.matrix),ps_data.no_waitbar);                           % mpe
         ps_data.matrix = ps_data.schur_matrix;                                          % mpe
         ps_data.unitary_mtx = ps_data.schur_unitary_mtx;                                % mpe
         ps_data.unitary_mtx = ps_data.input_unitary_mtx*ps_data.unitary_mtx;            % mpe
         ps_data.projection_on = 1;                                                      % mpe
         ps_data.orig_ews = ps_data.ews;                                                 % mpe
         ps_data.ew_estimates = 0;                                                       % mpe
         if isempty(ps_data.zoom_list{ps_data.zoom_pos}.ax)                              % mpe
            ps_data = switch_origplot(fig,cax,this_ver,ps_data,1);                       % mpe (gets the axis)
         end                                                                             % mpe
         plot_eigs = 1;                                                                  % mpe
      else                                                                               % mpe
         ps_data.sparse_direct = 1;                                                      % mpe 
         if isempty(ps_data.zoom_list{ps_data.zoom_pos}.ax)                              % mpe
            ax_prompt = {'min real: ', 'max real: ', 'min imag: ', 'max imag:'};         % mpe
            ax_title = 'Axis limits';                                                    % mpe
            ax_default = {'-1','1','-1','1'};                                            % mpe
            ax_opts.WindowStyle='modal';                                                 % mpe
            h = inputdlg(ax_prompt,ax_title,1,ax_default,ax_opts);                       % mpe
            ax = [str2num(h{1}) str2num(h{2}) str2num(h{3}) str2num(h{4})];              % mpe
            ps_data.zoom_list{ps_data.zoom_pos}.ax = ax;                                 % mpe
         end                                                                             % mpe
      end                                                                                % mpe
   end                                                                                   % mpe
 
%% If there is nothing in the plot already (or there is the welcome text)
    if isempty(get(cax,'children')) | ~isempty(findobj(fig,'Tag','ETwelcome')) | plot_eigs,
%% Plot the eigenvalues. They are plotted to give the user something to look
%% at while the PS is being computed.
      mnu_itm_h = findobj(fig,'Tag','DisplayEWS');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'on'),
        if ps_data.ew_estimates==1, ew_col = 0*0.5*[1 0 1];
        else ew_col = [0 0 0]; end;
        set(cax,'NextPlot','ReplaceChildren');
        plot(real(ps_data.ews),imag(ps_data.ews),'.','Parent',cax,'color',ew_col); 
% Ensure that the main axis is visible
        set(cax,'visible','on');
      end;
     
%% Set the axes correctly
      if this_ver<6,
        set(fig,'CurrentAxes',cax);
        axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
      else
        axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
      end;
      drawnow;
    end;

    set_edit_text(fig,ps_data.zoom_list{ps_data.zoom_pos}.ax, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);

%% Restore the original Schur decomposition, if projection no longer valid
    if isfield(ps_data,'proj_axes'),
      if ps_data.zoom_list{ps_data.zoom_pos}.proj_lev>=0,
        p_ax = ps_data.proj_axes;
        c_ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
        if ~(c_ax(1)>=p_ax(1) & c_ax(2)<=p_ax(2) & c_ax(3)>=p_ax(3) & c_ax(4)<=p_ax(4)) ...
             | ps_data.comp_proj_lev < ps_data.zoom_list{ps_data.zoom_pos}.proj_lev, 
          ps_data.matrix = ps_data.schur_matrix;
          ps_data.proj_ews = ps_data.ews;
        end;
      elseif ps_data.zoom_list{ps_data.zoom_pos}.proj_lev < ps_data.comp_proj_lev,
          ps_data.matrix = ps_data.schur_matrix;
          ps_data.proj_ews = ps_data.ews;
      end;
    end;

%% Setup the options for the contour plots
    ss = size(ps_data.matrix);
    opts.npts = ps_data.zoom_list{ps_data.zoom_pos}.npts;
    opts.levels = exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels);
    opts.ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
%% Plot as black lines if 'Colour' is not selected:
    mnu_itm_h = findobj(fig,'Tag','Colour');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      colour = 1;
    else
      colour = 0;
    end;
    if colour~=1, opts.plotopt='k'; end;
    opts.ploteig = 0;
%% Work out whether we need to automatically calculate the levels
    if ps_data.zoom_list{ps_data.zoom_pos}.autolev == 1, opts.re_calc_lev = 1;
    else opts.re_calc_lev = 0; end;
    opts.Aisreal = ps_data.AisReal;
    opts.proj_lev = ps_data.zoom_list{ps_data.zoom_pos}.proj_lev;
    opts.scale_equal = get(findobj(fig,'Tag','ScaleEqual'),'Value');
    opts.axis_handle = cax;
    opts.no_waitbar = ps_data.no_waitbar;
    opts.fig = fig;

%% If we have eigenvalues from a projection, use them rather than the 
%% full set of eigenvalues
    if isfield(ps_data,'proj_ews'),
      the_ews = ps_data.proj_ews;
    else
      the_ews = ps_data.ews;
    end;

%% Enable the STOP button
    ps_data = toggle_go_btn(fig,'Stop!','on',ps_data);
    toggle_pause_btn(fig,'Pause','on');

%% Store the matrices in variables for convenience
    A = ps_data.matrix;
    if isfield(ps_data,'matrix2'), B = ps_data.matrix2;
    else B = 1; end;

% Record the fact that an ARPACK computation is taking place
    ps_data.comp = 'PSA';
    ps_data.comp_stopped = '';
    set(fig,'userdata',ps_data);

%% Save the data over the pseudospectra mesh with the figure so that the
%% contours can be easily changed (that's why we have all the output arguments).
    [ps_data.zoom_list{ps_data.zoom_pos}.Z, ...
     ps_data.zoom_list{ps_data.zoom_pos}.x, ...
     ps_data.zoom_list{ps_data.zoom_pos}.y, ...
     t_levels, ...
     err,output_mtx,output_ews] = psa_computation(A,B,the_ews,opts);

     ps_data.comp = '';

%% Check to see whether some projection has happened
     [om,on] = size(output_mtx);
     if om~=ss(1) | on~=ss(2),

%% Store the projected matrix and data used in the projection, point working
%% matrix to this one
       ps_data.proj_matrix = output_mtx;
       ps_data.matrix = ps_data.proj_matrix;
       ps_data.proj_valid = 1;

       ps_data.proj_ews = output_ews;
       ps_data.comp_proj_lev = ps_data.zoom_list{ps_data.zoom_pos}.proj_lev;
%% Save the axes so we can check if we've zoomed out (which requires re-projection)
       ps_data.proj_axes = ps_data.zoom_list{ps_data.zoom_pos}.ax;
     end;

     ps_data.zoom_list{ps_data.zoom_pos}.levels = comp_lev(t_levels);

%% If there was some internal error, enable the buttons again
%% and leave the routine
    if err~=0,
%      cla(cax); % Clear the axes
      ps_data.comp_stopped = 'PSA';
      enable_controls(fig,ps_data);
      ps_data.zoom_list{ps_data.zoom_pos}.computed = 0;
      ps_data.zoom_list{ps_data.zoom_pos}.x = [];
      ps_data.zoom_list{ps_data.zoom_pos}.y = [];
      ps_data.zoom_list{ps_data.zoom_pos}.Z = [];

%% Disable the STOP button (set go button on)
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      toggle_pause_btn(fig,'Pause','off');

    else % No error
      ps_data.comp_stopped = '';

%% Now manual levels (don't want levels automatically selected at each zoom)
      ps_data.zoom_list{ps_data.zoom_pos}.autolev = 0;

%% Enable the controls and make sure the text in the message box is right
      enable_controls(fig,ps_data);
      ps_data = update_messagebar(fig,ps_data,1);

%% Disable the 'Go!' button unless there's a reason for it
%% (e.g. user changes grid size or axis etc.)
      ps_data = toggle_go_btn(fig,'Go!','off',ps_data);
      toggle_pause_btn(fig,'Pause','off');

%% This level was computed
      ps_data.zoom_list{ps_data.zoom_pos}.computed = 1;
      ps_data.zoom_list{ps_data.zoom_pos}.dims = size(ps_data.matrix);

%% If this is the first time anything has been computed,
%% save the values in the initial data bit.
%      if ~isfield(ps_data.init_opts,'Z'),
%        ps_data.init_opts.levels = ps_data.zoom_list{ps_data.zoom_pos}.levels;
%        ps_data.init_opts.Z = ps_data.zoom_list{ps_data.zoom_pos}.Z;
%        ps_data.init_opts.x = ps_data.zoom_list{ps_data.zoom_pos}.x;
%        ps_data.init_opts.y = ps_data.zoom_list{ps_data.zoom_pos}.y;
%        ps_data.init_opts.computed = 1;
%        ps_data.init_opts.dims = ps_data.zoom_list{ps_data.zoom_pos}.dims;
%        ps_data.init_opts.autolev = 0;
%      end;

    end; % If error

%% Now actually plot the contour data
    ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

  else % We're using iterative methods

% Use the ORIGINAL MATRIX INPUT to eigtool
    ps_data.matrix = ps_data.input_matrix;

%% Store the original matrix here
    [m,n] = size(ps_data.matrix);

% How many eigenvalues do we want?
    k = str2num(get(findobj(fig,'Tag','ARPACK_k'),'String'));

% Which ones are they?
    which = ps_data.ARPACK_which;

    eopts.eigtool = fig;
    if isfield(ps_data,'ARPACK_p') & ~strcmp(ps_data.ARPACK_p,'auto'),
         eopts.p = ps_data.ARPACK_p; end;
    if isfield(ps_data,'ARPACK_tol') & ~strcmp(ps_data.ARPACK_tol,'auto'),
         eopts.tol = ps_data.ARPACK_tol; end;
    if isfield(ps_data,'ARPACK_maxit') & ~strcmp(ps_data.ARPACK_maxit,'auto'),
         eopts.maxit = ps_data.ARPACK_maxit; end;
    if isfield(ps_data,'ARPACK_v0') & ~strcmp(ps_data.ARPACK_v0,'auto'),
      ss = size(ps_data.ARPACK_v0);
      if ss(1)~=m | ss(2)~=1,
        warning('v0 no longer valid: using default.');
      else
        eopts.v0 = ps_data.ARPACK_v0;
      end; 
    end;

%% Enable the STOP and Pause buttons
    ps_data = toggle_go_btn(fig,'Stop!','on',ps_data);
    toggle_pause_btn(fig,'Pause','on');

% Now actually run eigs
    stop_comp = 0;

    switch_ARPACK_opts(fig);

% Record the fact that an ARPACK computation is taking place
    ps_data.comp = 'ARPACK';
    ps_data.comp_stopped = '';

% Change the message in the message bar
    ps_data = update_messagebar(fig,ps_data,35);

    set(fig,'userdata',ps_data);

% Ensure we use auto axes to start with
    mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
    set(mnu_itm_h,'checked','on');

% Change the text on the button, but leave it dimmed
    toggle_mode_btn(fig,'RVec','off');

% Don't display ew estimates during eigs computation
    eopts.disp = 0;

% Need to be able to tell if the axes didn't change during the
% computation (for example if ARPACK converges in one iteration,
% we never get a plot of Ritz values) so that we can use default
% axes in this case. To do this we plot a white dot on the axes,
% and check whether it's still there later - if it is, no drawing
% has taken place
    ax = axis(cax);
    save_hdl = plot(ax(1)-10,ax(3)-10,'.','color',[1 1 1]);

% Remove the colourbar for now, but turn the axis ticks back on
    grow_main_axes(fig,1);
    set(cax,'ytickmode','auto');
    set(cax,'xtickmode','auto');

    try
% Call eigs to do the computation
      if this_ver<6.5,
        ews = aeigs60(ps_data.matrix,k,which,eopts);
      elseif this_ver<7.0
        ews = aeigs65(ps_data.matrix,k,which,eopts);
      else 
        ews = aeigs12a(ps_data.matrix,k,which,eopts);
      end;
    catch
      h = errordlg(lasterr,'Error in eigs...','modal');
      waitfor(h);
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      toggle_pause_btn(fig,'Pause','off');
      toggle_mode_btn(fig,'Mode','off');
% Unpause things
      pause_comp(fig) = 0;
      ps_data.comp_stopped = 'ARPACK';
      ps_data = update_messagebar(fig,ps_data,'prev');
      enable_controls(fig,ps_data);
% Don't allow user selection in the window
      the_handle = findobj(fig,'Tag','MainAxes');
      set(the_handle,'HitTest','off');
      set(fig,'WindowButtonDownFcn','');
      return;
    end;

% If ews == 'stopped' it's because the computation was cancelled 
    if strcmp(ews,'stopped'),
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      toggle_pause_btn(fig,'Pause','off');
      toggle_mode_btn(fig,'Mode','off');
% Unpause things
      pause_comp(fig) = 0;
      ps_data.comp_stopped = 'ARPACK';
      ps_data = update_messagebar(fig,ps_data,'prev');
      enable_controls(fig,ps_data);
% Don't allow user selection in the window
      the_handle = findobj(fig,'Tag','MainAxes');
      set(the_handle,'HitTest','off');
      set(fig,'WindowButtonDownFcn','');
      return;
    end;

% No computation is taking place
    ps_data.comp = '';
    ps_data.comp_stopped = '';

% These are estimates, so should be plotted in a different colour
    ps_data.ew_estimates = 1;

% Unpause the computation and turn the Ritz vec button back to ew mode
    pause_comp(fig) = 0;
    toggle_mode_btn(fig,'Mode','off');

% Get the latest ps_data - this will now contain the projected matrix
% and the orthogonal basis (recovered at the end of eigs)
    proj_ps_data = get(fig,'userdata');

% Make sure field of values is off
    set(findobj(fig,'Tag','FieldOfVals'),'value',0);
    ps_data.show_fov = 0;

%% Now we want to work with the projected matrix (at least as far as
%% pseudospectra go)
    ps_data.proj_matrix = proj_ps_data.proj_matrix;
    ps_data.matrix = ps_data.proj_matrix;
    ps_data.isHessenberg = 1;
    ps_data.proj_unitary_mtx = ps_data.input_unitary_mtx*proj_ps_data.proj_unitary_mtx;
    ps_data.unitary_mtx = ps_data.proj_unitary_mtx;

% Reset the zoom list
    ps_data.zoom_list = {ps_data.zoom_list{ps_data.zoom_pos}};
    ps_data.zoom_pos = 1;

% Remove any markers from the plot - they are no longer valid
    ps_data.mode_markers = {};

% We have computed a valid projection now, which we will continue to use
% until any ARPACK parameters change
    ps_data.proj_valid = 1;
    ps_data.ews = ews;

% Use the axes from opts.ax if they were defined, otherwise just use
% what is left after the eigs computation.
    if ~isempty(ps_data.init_opts.ax) & ~ps_data.init_opts.direct,
      ps_data.zoom_list{ps_data.zoom_pos}.ax = ps_data.init_opts.ax;
    elseif ~ishandle(save_hdl)
      ps_data.zoom_list{ps_data.zoom_pos}.ax = axis(cax);
    else % Determine them in switch_origplot
      ps_data.zoom_list{ps_data.zoom_pos}.ax = [];
    end;

% Remove the temporary mark used above
    if ishandle(save_hdl), delete(save_hdl); end;

% Choose the levels automatically if they were not defined in opts.levels
    ps_data.zoom_list{ps_data.zoom_pos}.autolev = ps_data.init_opts.autolev;
    ps_data.zoom_list{ps_data.zoom_pos}.levels = ps_data.init_opts.levels;

% Reset projection (if it was on before)
    ps_data.zoom_list{ps_data.zoom_pos}.proj_lev = inf;
    if isfield(ps_data,'proj_axes'),
      ps_data = rmfield(ps_data,'proj_axes');
      ps_data = rmfield(ps_data,'comp_proj_lev');
    end;

% Now compute the pseudospectra of the projected matrix
    ps_data = switch_origplot(fig,cax,this_ver,ps_data);

    enable_controls(fig,ps_data);
    if ~strcmp('PSA',ps_data.comp_stopped),
      ps_data = toggle_go_btn(fig,'Go!','off',ps_data);
      ps_data = update_messagebar(fig,ps_data,1);
    else
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      ps_data = update_messagebar(fig,ps_data,39);
    end;
    toggle_pause_btn(fig,'Pause','off');
  end;

% Unpause things, in case pause pressed at the last minute
  pause_comp(fig) = 0;

function switch_ARPACK_opts(fig)

   the_handle = findobj(fig,'Tag','ChooseP'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','ChooseTol'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','ChooseMaxit'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','ChooseV0'); 
   set(the_handle,'Enable','off');
