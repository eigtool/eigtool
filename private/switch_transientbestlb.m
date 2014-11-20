function ps_data = switch_transientbestlb(fig,cax,this_ver,ps_data)

% function ps_data = switch_transientbestlb(fig,cax,this_ver,ps_data)
%
% Function that is called when the user presses the Transient menu's
% Lower Bound option.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues


   A = ps_data.matrix;

%% Actually do the plotting (restricting A to the upper nn by nn section
%% so we can approximate pseudomodes for matrices from the Arnoldi factorisation)

% Get the current state of the Go button (for later
  the_handle = findobj(fig,'Tag','RedrawPlot');
  go_state = get(the_handle,'Enable');
  set(the_handle,'Enable','off');

  disable_controls(fig);

% Get the type of transient we're currently dealing with
  [tfig,cax1,cax2,ftype] = find_trans_figure(fig,'A',1);

% Extract the variables for ease
  x = ps_data.zoom_list{ps_data.zoom_pos}.x;
  y = ps_data.zoom_list{ps_data.zoom_pos}.y;
  Z = ps_data.zoom_list{ps_data.zoom_pos}.Z;
  
  sel_pt = [];

  if strcmp(ftype,'E'),
    R = 1./Z;
    [X,Y] = meshgrid(x,y);
   %[i,j] = find(X<=0);   %%% EIGTOOL
    [i,j] = find(X<=.5*max(eig(A+A')));   %%% REVISION
% Remove the points inside the unit circle
    X(i,j) = NaN;

% Check that there's still some valid points
    if all(isnan(X(:))),
      h = errordlg('No points are outside the unit disk: please zoom out and recompute the pseudospectra', ...
                   'Error...','modal');
      waitfor(h);
      enable_controls(fig,ps_data);
      the_handle = findobj(fig,'Tag','RedrawPlot');
      set(the_handle,'Enable',go_state);
      return;
    end;

    t_range = get(cax1,'xlim');
    t_pts = t_range(1):ps_data.transient_step:t_range(end);
    pos = 1;
    bnd = zeros(size(t_range));
    for t = t_pts,
      eat = exp(X*t);
     %bnds = eat./(1+(eat-1)./(X.*R));   % EIGTOOL
      aA = .5*max(eig(A+A')); bnds=eat-(eat-exp(aA*t))./((X-aA).*R);  % REVISION

      [m,i] = max(bnds);
      [bnd(pos),j] = max(m);
      sel_pt = [sel_pt; x(j) y(i(j))];
      pos = pos+1;
    end;    
    data_pts = t_pts;
  elseif strcmp(ftype,'P'),
    R = 1./Z;
    [X,Y] = meshgrid(x,y);
    pts = abs(X+1i*Y);
   %[i,j] = find(pts<=1);  %EIGTOOL
    [i,j] = find(pts<=norm(A));  %REVISION
% Remove the points inside the unit circle
    pts(i,j) = NaN;

% Check that there's still some valid points
    if all(isnan(pts(:))),
      h = errordlg('No points are outside the unit disk: please zoom out and recompute the pseudospectra', ...
                   'Error...','modal');
      waitfor(h);
      enable_controls(fig,ps_data);
      the_handle = findobj(fig,'Tag','RedrawPlot');
      set(the_handle,'Enable',go_state);
      return;
    end;

    k_range = get(cax1,'xlim');
    pos = 1;
    bnd = zeros(k_range(end)-k_range(1)+1,1);
    for k = k_range(1):k_range(end),
      pk = pts.^k;
     %bnds = pk ./ (1+(pk-1)./((pts-1).*(pts.*R-1)));  %%% EIGTOOL
      nA = norm(A); bnds = pk-(pk-nA.^k)./((pts-nA).*R);                %%% REVISION
      [m,i] = max(bnds);
      [bnd(pos),j] = max(m);
      sel_pt = [sel_pt; x(j) y(i(j))];
      pos = pos+1;
    end;    
    data_pts = k_range(1):k_range(end);
  end;

  [tfig,marker_h] = draw_trans_lb(A,sel_pt,fig,ps_data,bnd,data_pts);

  enable_controls(fig,ps_data);

%% If there was an error

%% Store data so the markers can be redrawn/deleted
  marker_info.h = marker_h;
  marker_info.pos = complex(sel_pt(:,1),sel_pt(:,2));
  marker_info.type = 'B';
  ps_data.mode_markers{tfig} = marker_info;

%% Reset the state of the Go button
  the_handle = findobj(fig,'Tag','RedrawPlot');
  set(the_handle,'Enable',go_state);
