function ps_data = switch_autolev(fig,cax,this_ver,ps_data)

% function ps_data = switch_autolev(fig,cax,this_ver,ps_data)
%
% Function to handle the 'Smart levels' operation

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% In case the current plot is zoomed but not calculated, want to
%% limit the singular values considered below to those in the current
%% axes.
    if isfield(ps_data.zoom_list{ps_data.zoom_pos},'x'),
      x = ps_data.zoom_list{ps_data.zoom_pos}.x;
    else %% This not yet initialised (could happen when user clicks cancel on first go)
      errordlg('No data to plot yet!','Error...','modal');
      return;
    end;
    if isfield(ps_data.zoom_list{ps_data.zoom_pos},'y'),
      y = ps_data.zoom_list{ps_data.zoom_pos}.y;
    else %% This not yet initialised (could happen when user clicks cancel on first go)
      errordlg('No data to plot yet!','Error...','modal');
      return;
    end;
    ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
    xvals = find(x>ax(1) & x<ax(2));
    yvals = find(y>ax(3) & y<ax(4));

%% If there's just not enough data
    min_len = min(4,ps_data.zoom_list{ps_data.zoom_pos}.npts);
    if length(xvals)<min_len,

%% The defecit
      ex = min_len-length(xvals);

%% Extend at left and right right
      l = floor(ex/2); r = ceil(ex/2);

%% If we're too close to the left edge, extend in the other direction
      while xvals(1)-l<1, l = l-1; r = r+1; end;
%% If we're too close to the right edge, extend in the other direction
      while xvals(end)+r>ps_data.zoom_list{ps_data.zoom_pos}.npts, l = l+1; r = r-1; end;

%% Now extend the values
      xvals = xvals(1)-l:xvals(end)+r;

    end;

%% Repeat for the y values
    if length(yvals)<min_len,

%% The defecit
      ex = min_len-length(yvals);

%% Extend at left and right right
      l = floor(ex/2); r = ceil(ex/2);

%% If we're too close to the left edge, extend in the other direction
      while yvals(1)-l<1, l = l-1; r = r+1; end;
%% If we're too close to the right edge, extend in the other direction
      while yvals(end)+r>ps_data.zoom_list{ps_data.zoom_pos}.npts, l = l+1; r = r-1; end;

%% Now extend the values
      yvals = yvals(1)-l:yvals(end)+r;

    end;

%% Recalculate the levels...
    [t_levels,err] = ... 
                  recalc_lev(ps_data.zoom_list{ps_data.zoom_pos}.Z(yvals,xvals), ...
                             ps_data.zoom_list{ps_data.zoom_pos}.ax);

    ps_data.zoom_list{ps_data.zoom_pos}.levels = comp_lev(t_levels);

%% If an error occured
    if err~=0,
      contours=[];
      if err==-1,
        errordlg('Range too small---no contours to plot. Refine grid or zoom out.','Error...','modal');
      elseif err==-2
        errordlg('Matrix too non-normal---resolvent norm is infinite everywhere. Zoom out!','Error...','modal');
      end;

%% Now leave - nothing more we can do here
      return;
    end;


%% Make sure the main axes are active, so that the 
%% axis call in the parameter list to set_edit_text
%% is valid
    if this_ver<6,
      set(fig,'CurrentAxes',cax);
      the_ax = axis;
    else
      the_ax = axis(cax);
    end;
    set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                  ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);

%% Now redraw the contours
    ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
