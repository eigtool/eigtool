function ps_data = switch_rvecresid(fig,cax,ps_data)

% function ps_data = switch_rvecresid(fig,cax,ps_data)
%
% Function that is called when the user presses the Rvec+resid
% button.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Get the current state of the Go button (for later
  go_btn_hdl = findobj(fig,'Tag','RedrawPlot');
  set(go_btn_hdl,'Enable','off');
  pause_btn_hdl = findobj(fig,'Tag','Pause');
  set(pause_btn_hdl,'Enable','off');
  disable_controls(fig);

  ps_data = update_messagebar(fig,ps_data,5);

%% Get the point and work out which eigenvalue is closest
  the_pt = ginput_eigtool(1,'crosshair');
  sel_pt = the_pt(1)+1i*the_pt(2);

% Get the Hessenberg + orthogonal matrices
  proj_data = get(findobj(fig,'Tag','EwCond'),'userdata');
  H =  proj_data.H;
  thev =  proj_data.V;
  [m,n] = size(H);
  [VV,DD] = eig(H(1:n,1:n));
  dd = diag(DD);

% Now work out which eigenvalue the user clicked on
  [ew,pos] = min(abs(dd-sel_pt));
  ew = dd(pos);

%% Plot the point in blue to indicate which ew is being used
  set(cax,'nextplot','add');
  marker_h=plot(real(ew),imag(ew), ...
         'bo','markersize',12,'linewidth',5);
  drawnow;

  rvec = thev*VV(:,pos);
  rvec = rvec/norm(rvec);

  resid = ps_data.input_matrix*rvec-ew*rvec;
%  the_norm = norm(resid);
  the_norm = H(end)*abs(VV(end,pos))/norm(H(1:n,1:n));

% Get a plot to put the results in
  pmfig = find_plot_figure(fig,'R');
  set(0,'CurrentFigure',pmfig);

% Use the specific x values if they are defined in the base workspace,
% or otherwise just use the index number
  x = evalin('base','psmode_x_points_','1:length(rvec)');

% Plot the results
  subplot(2,1,1); hold off; plot(x,real(rvec),'b'); hold on; 
                  plot(x,abs(rvec),'k'); plot(x,-abs(rvec),'k');
  full_title_str = ['Absolute value (black) and real part (coloured) of ', ...
                   'Ritz vector: \lambda=',num2str(ew)];
  title(full_title_str);
% Set the correct axis limits
  set(gca,'xlim',x([1 end]));

% Add the value of the norm of the residual
  the_str = ['||Av-\lambda v|| = ',num2str(the_norm,'%15.2e')];
  ax = axis;
  the_d = diff(ax);
  l = ax(1);
  t = ax(3);
  text(l+the_d(1)/40,t+the_d(3)/10,the_str,'fontsize',12,'fontweight','bold');

% Plot the absolute value on a log scale in the second plot
  subplot(2,1,2); hold off; semilogy(x,abs(rvec),'k'); hold on;
  set(gca,'xlim',x([1 end]));

%% Revert the message string
  ps_data = update_messagebar(fig,ps_data,'prev');

%% If there was an error
  if pmfig<1, 
    delete(marker_h); return;
  end;

%% Delete the old marker if the figure was already there
  if length(ps_data.mode_markers)>=pmfig & ~isempty(ps_data.mode_markers{pmfig}) ...
    & ishandle(ps_data.mode_markers{pmfig}.h),
    delete(ps_data.mode_markers{pmfig}.h);
  end;

%% Store data so the marker can be redrawn/deleted
  marker_info.h = marker_h;
  marker_info.pos = ew;
  marker_info.type = 'E';
  ps_data.mode_markers{pmfig} = marker_info;

%% Reset the state of the Go and Pause buttons
  set(go_btn_hdl,'Enable','on');
  set(pause_btn_hdl,'Enable','on');
  go_btn_hdl = findobj(fig,'Tag','EwCond');
  set(go_btn_hdl,'Enable','on');
  set(fig,'WindowButtonDownFcn','eigtool_switch_fn(''PsArea'');');
