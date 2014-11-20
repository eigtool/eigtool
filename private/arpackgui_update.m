% This script is called from within the aeigs routine to output display
% of the current status

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  fig = opts.eigtool;
  return_now = 0;

  cur_fig = get(0,'currentfigure');

% Create this variable the first time through
  if ~exist('all_shifts','var'), all_shifts = []; end;

% Don't do anything the first time, since the data is funny (all 0)
  if ~exist('done_one_already','var'), 
    done_one_already=1;
    return;
  end;

% Take the shifts as the unwanted eigenvalues
  if isrealprob
    if issymA
      dispvec = [workl(double(ipntr(6))+(0:p-1))];
      if isequal(whch,'BE')
        % roughly k Large eigenvalues and k Small eigenvalues
        the_ews = dispvec(end-2*k+1:end);
        the_shifts = dispvec(1:end-2*k);
      else
        % k eigenvalues
        the_ews = dispvec(end-k+1:end);
        the_shifts = dispvec(1:end-k);
      end;
    else
      dispvec = [complex(workl(double(ipntr(6))+(0:p-1)), ...
                         workl(double(ipntr(7))+(0:p-1)))];
      % k+1 eigenvalues (keep complex conjugate pairs together)
      the_ews = dispvec(end-k:end);
      the_shifts = dispvec(1:end-k-1);
    end
  else
    dispvec = [complex(workl(2*double(ipntr(6))-1+(0:2:2*(p-1))), ...
                       workl(2*double(ipntr(6))+(0:2:2*(p-1))))];
    the_ews = dispvec(end-k+1:end);
    the_shifts = dispvec(1:end-k);
  end
  all_shifts = [all_shifts; the_shifts];

% Want to use the PREVIOUS H for PSA/RVec computation, since the current
% one is after the implicit restart, while the R Vals & shifts are from
% BEFORE the I. Restart.
  prevH = [];
  prevthev = [];
  if exist('H','var'), prevH = H; end;
  if exist('thev','var'), prevthev = thev; end;
  extract_mtx;
% Make sure we keep a COPY of this variable
  thev(end) = thev(end)*(1+eps); 

% Check to see whether we're supposed to be paused; if so, wait
% for resume to be chosen.
  global pause_comp
  if pause_comp(fig)==1, 

% Store the orthonormal matrix & proj matrix in case user
% wants to do Rvec/resid computations:
    proj_data.H = prevH;
    proj_data.V = prevthev;
%    proj_data.H = prevH(1:k+1,1:k);
%    proj_data.V = prevthev(:,1:k);
%    proj_data.V = the_prev_v(:,1:k);


%    proj_data.H = the_prev_H3(1:k+1,1:k);
%    proj_data.V = the_prev_v3(:,1:k);
%    proj_data.H = the_prev_H4;
%    proj_data.V = the_prev_v4;
%    proj_data.H = H(1:k+1,1:k);
%    proj_data.V = thev(:,1:k);

    set(findobj(fig,'Tag','EwCond'),'userdata',proj_data);

% Allow user to select a ritz value to compute residual of
% THIS FEATURE IS NOT YET WORKING
%    toggle_mode_btn(fig,'RVec','on');

    hdl = findobj(fig,'Tag','Pause');
    waitfor(hdl,'Callback');

%    toggle_mode_btn(fig,'RVec','off');
  end;

% Get the userdata field. THIS MUST BE AFTER THE PAUSE SECTION,
% SINCE OTHERWISE DATA COULD GET OUT OF SYNC IF CHANGED IN PAUSE
% ROUTINE
  ps_data = get(fig,'userdata');

  cax = findobj(fig,'Tag','MainAxes');
  set(fig,'CurrentAxes',cax);

  set(cax,'nextplot','replacechildren');

  global stop_comp
  if stop_comp==fig, 
    return_now = 1;
    return;
  end;

  mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
  cur_state = get(mnu_itm_h,'checked');

% If using auto axes, work out what they are
  if strcmp(cur_state,'on'),
%% Define the axes based on the position of the eigenvalues
    ca = [min(real(dispvec)) max(real(dispvec)) ...
          min(imag(dispvec)) max(imag(dispvec))];
%% Make sure the axes have some height and width to start with
    if ca(1)==ca(2),
      ca = [ca(1)-0.5 ca(2)+0.5 ca(3) ca(4)];
    end;
    if ca(3)==ca(4),
      ca = [ca(1) ca(2) ca(3)-0.5 ca(4)+0.5];
    end;
%% Now extend that box a bit
    widtha=ca(2)-ca(1);
    lengtha=ca(4)-ca(3);
    ext = max(widtha,lengtha);
    ax =  [ca(1)-ext/3 ca(2)+ext/3 ca(3)-ext/3 ca(4)+ext/3];
  
% Only allow the axes to grow (otherwise get annoying flickering)
% The first time, just set the variable, don't use axes
    if ~exist('old_ax','var'),
      old_ax = axis(cax);
    else
      old_ax = axis(cax);
      ax(1) = min(ax(1),old_ax(1));
      ax(3) = min(ax(3),old_ax(3));
      ax(2) = max(ax(2),old_ax(2));
      ax(4) = max(ax(4),old_ax(4));
    end;

%% Tidy up the axis limits
    [ax(1),ax(2)] = tidy_axes(ax(1),ax(2),0.02);
    [ax(3),ax(4)] = tidy_axes(ax(3),ax(4),0.02);
    ps_data.zoom_list{ps_data.zoom_pos}.ax = ax;
  else
    ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
  end;


% Leave if we're not monitoring anything
  mnu_itm_h = findobj(fig,'Tag','ProgRVals');
  mnu_itm_h2 = findobj(fig,'Tag','ProgAllShifts');
  mnu_itm_h3 = findobj(fig,'Tag','ProgPSA');
  cur_state = get(mnu_itm_h,'checked');
  cur_state2 = get(mnu_itm_h2,'checked');
  cur_state3 = get(mnu_itm_h3,'checked');
  if ~strcmp(cur_state,'on') & ~strcmp(cur_state2,'on') & ~strcmp(cur_state3,'on'),
    drawnow;
    return;
  end;

% Compute the pseudospectra too?
  if strcmp(cur_state3,'on') & ~isempty(prevH),

    popts.ax = ax;
    popts.fig = fig;
    popts.no_waitbar = 1;
    popts.npts = 20;

% Get the Hessenberg matrix, stored in variable H
    [svs, xx, yy, levels, err] = psa_computation(prevH, 1, dispvec, popts);
    if err~=0, warning(['Error after psa_computation: ',num2str(err)]); end;

    set(cax,'clim',[levels(1)-1e-14 levels(end)]);
    grow_main_axes(fig,0);
    
    mnu_itm_h = findobj(fig,'Tag','Colour');
    cur_state = get(mnu_itm_h,'checked');
    set(0,'currentfigure',fig);
    if strcmp(cur_state,'on'),
      [con,con_hdl] = contour(xx,yy,log10(svs),levels);                % mpe edit
      mycolourbar(fig,levels,con,1);
    else
      [con,con_hdl] = contour(xx,yy,log10(svs),levels,'k');            % mpe edit
      mycolourbar(fig,levels,con,0);
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
% This code adjusts for MATLAB 7's new "contourgroup" object.          % mpe new
% EigTool 2.04 used MATLAB 6 "patch" objects.                          % mpe new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
        this_matlab = ver('matlab');                                   % mpe new, from new_matrix.m
        this_ver = str2num(this_matlab.Version);                       % mpe new, from new_matrix.m
        if (this_ver>=7)                                               % mpe new
           mnu_itm_thick = findobj(fig,'Tag','ThickLines');            % mpe new   
           cur_state_thicklines = get(mnu_itm_thick,'checked');        % mpe new
           if strcmp(cur_state_thicklines,'on')                        % mpe new
              set(con_hdl,'linewidth',2);                              % mpe new
           else                                                        % mpe new
              set(con_hdl,'linewidth',1);                              % mpe new
           end                                                         % mpe new
        end                                                            % mpe new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
    set(cax,'nextplot','add');
    set_edit_text(fig,ax,comp_lev(levels),popts.npts);
  else
    set_edit_text(fig,ax);
  end;

% Plot the shifts the user wants to see
  cur_state = get(mnu_itm_h2,'checked');
  set(0,'currentfigure',fig);
  if strcmp(cur_state,'on'),
    plot(real(all_shifts),imag(all_shifts),'r+');
  else
    plot(real(the_shifts),imag(the_shifts),'r+');
  end;
  set(cax,'nextplot','add');

% Plot the Ritz values
  plot(real(the_ews),imag(the_ews),'k.');

  axis(ax);

% Add the iteration number to the plot
  the_str = ['dim = ',num2str(length(ps_data.input_matrix)),'   iteration ',num2str(iter)];
%  xl = get(cax,'xlim');
%  yl = get(cax,'ylim');
%  wid = diff(xl);
%  hei = diff(yl);
%  offset = max(wid,hei)/30;
%  h = text(xl(1)+offset,yl(2)-offset-hei/40,the_str,'fontsize',12,'fontweight','bold');
  h = text(0,0,the_str,'fontsize',12,'fontweight','bold');
  set(h,'units','pixels');
  set(h,'position',[15 15 0]);

  set(cax,'nextplot','replacechildren');
  drawnow;

% Get the data again to prevent pressing of pause separating the two
% commands. Make sure all changes above are copied to ps_data2...
  ps_data2 = get(fig,'userdata');
  ps_data2.zoom_list = ps_data.zoom_list;
  set(fig,'userdata',ps_data2);

  set(0,'currentfigure',cur_fig);

