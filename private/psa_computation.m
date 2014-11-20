function [Z, x, y, levels, err, T, eigA] = psa_computation(T, S, eigA, opts)

% function [Z, x, y, levels, err, T, eigA] = psa_computation(T, S, eigA, opts)
%
% Compute pseudospectra using modified version of LNT's "psa" code
% (Acta Numerica 1999). The matrix must be upper triangular (e.g. by using
% a call to fact.m).
%
% T         intput matrix
% S         2nd matrix, if rectangular and problem is now generalised
% eigA      eigenvalues of the matrix, also produced by fact.m
% opts      an options parameter. Fields are as follows:
%           npts       grid will have npts*npts nodes 
%                 DEFAULT: 20
%           levels      vector log10(epsilon) for the desired epsilon levels
%                 DEFAULT: Depends on actual levels in contour plot
%           ax          axis on which to plot [min_real, max_real, min_imag, max_imag]
%                 DEFAULT: Based on eigenvalue locations
%           plotopt     option for contour plotter; e.g., 'k-' will plot black lines
%                 DEFAULT: None (i.e. colour)
%           ploteig     plot the computed eigenvalues [0/1]?
%                 DEFAULT: 1 (yes)
%           re_calc_lev automatically recompute epsilon levels [0/1]? 
%                 DEFAULT: 1 (yes)
%           Aisreal     is the input matrix real (symmetric (pseudo)spectra) [0/1]?
%                       (this is needed because T could be complex even if A was real)
%                 DEFAULT: 1 (yes)
%           proj_lev    the proportion to extend the axes by before projection
%                       i.e. suppose [a b c d] are the axes:
%                       projection box is: w=b-a;h=d-c; [a-proj_lev*w b+proj_lev*w
%                                                        c-proj_lev*h d+proj_lev*h]
%                 DEFAULT: 0.5
%           no_waitbar  set to 1 to avoid drawing waitbar
%                 DEFAULT: 0 (draw waitbar)
%           fig         set to the current figure
%
% Z         the singular values over the grid
% x         the x coordinates of the grid lines
% y         the y coordinates of the grid lines
% levels    the levels used for the contour plot (if automatically calculated)
% err       an error flag, used if automatic level creation failed:
%               0:  No error
%              -1:  No levels in range specified (either manually, or if
%                    matrix too normal to show levels)
%              -2:  Matrix so non-normal, only zero singular values everywhere
%              -3:  Computation cancelled
% T         the matrix may have been projected, so output it here
% eigA      output eigenvalues projected onto as well

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This variable is used to cancel the computation if necessary.
%% Don't want to cancel to start with!
global stop_comp;
global pause_comp
stop_comp = 0;

%% Get the version so we can do the right waitbar thing
this_matlab = ver('matlab');
this_ver = str2num(this_matlab.Version);

%% Check size of input matrix
[m,n] = size(T);
[ms,ns] = size(S);
if (ms~=1 | ns~=1) & (m~=ms | n~=ns), error('Matrix dimensions must match.'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract the data from the options sturcture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% If opts not passed, set it up as a dummy for the next bit of code
if nargin<4, opts.dummy = 1; end;

%% Number of points for grid
if isfield(opts,'npts'),
  npts = opts.npts;
else
  npts = 20;
end;

%% Plot options for contour
if isfield(opts,'plotopt'),
  if isempty(opts.plotopt),
    use_plotopt = 0; 
  else
    plotopt = opts.plotopt;
    use_plotopt = 1;
  end;
else
  use_plotopt = 0;
end;

%% Plot the eigenvalues?
if isfield(opts,'ploteig'),
  ploteig = opts.ploteig;
else
  ploteig = 1;
end;

%% Recalculate the levels?
if isfield(opts,'re_calc_lev'),
  re_calc_lev = opts.re_calc_lev;
else
  re_calc_lev = 0;
end;

%% Epsilon levels to use
if isfield(opts,'levels'),
  levels = opts.levels;
%% Need to check this for the contour command...
  if (length(levels) == 1), levels = [levels levels]; end;
else
%% Will get them from recalc_lev.m later, but need to set an
%% approximation here for use with approx axes if necessary
  levels = [-8:-1];
  re_calc_lev = 1;
end;

%% Axes to use
if isfield(opts,'ax'),
  ax = opts.ax;
else
  errordlg('Axis must be specified for pseudospectra computation','Error...','modal');
  err = -3;
  Z = []; x = []; y = [];
  return;
end;

%% Do we know whether A is real?
if isfield(opts,'Aisreal'),
  Aisreal = opts.Aisreal;
else
  Aisreal = 0;
end;

%% How much should we project by?
if isfield(opts,'proj_lev'),
  proj_lev = opts.proj_lev;
else
  proj_lev = inf;
end;

if ~isfield(opts,'scale_equal'),
  opts.scale_equal = 0;
end;

if ~isfield(opts,'fig'),
  opts.fig = gcf;
end;

if ~isfield(opts,'axis_handle'),
  opts.axis_handle = gca;
end;

if ~isfield(opts,'no_waitbar'),
  opts.no_waitbar = 0;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Utilise the symmetry if A is real and the ps area crosses
%% the x axis.
%%
%% Once this is done, the smaller half can be formed by copying the data
%% for the top half and fliping it top to bottom. (see end of code)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If the axis are not on scale equal, want npts gridpoints in each direction
if opts.scale_equal~=1,
  x_npts = npts;
  y_npts = npts;
else % We ARE on scale equal, want fewer gridpoints in the shorter axis
  y_dist = ax(4)-ax(3);
  x_dist = ax(2)-ax(1);
  if x_dist>y_dist,
    x_npts = npts;
    y_npts = max([5,ceil(y_dist/x_dist*npts)]);
  else
    x_npts = max([5,ceil(x_dist/y_dist*npts)]);
    y_npts = npts;
  end;
end;

if (Aisreal & ax(4)>0 & ax(3)<0)
%% shift_axes makes sure that the grid points mirror above and below axis
   [y, num_mirror_pts] = shift_axes(ax,y_npts);
else %% Matrix is not real or axes don't span 0
   num_mirror_pts = 0;
   y = linspace(ax(3),ax(4),y_npts);
end
x = linspace(ax(1),ax(2),x_npts);

%% Define a couple of useful constants
lx = length(x); ly=length(y);

%% Initialise Z
Z = Inf*ones(length(y), length(x));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Project the matrix onto a smaller dimensional invariant subspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If we have a dense, square matrix, we can do some projection
if ~issparse(T) & n==m,

%% Restrict to 'interesting' subspace, by ignoring eigenvector whose
%% eigenvalues lie outside a rectangle around the current axes
  axis_w = (ax(2)-ax(1));
  axis_h = (ax(4)-ax(3));
  if proj_lev>=0,
    proj_w = axis_w*proj_lev;
    proj_h = axis_h*proj_lev;
  else
    proj_size = -1/proj_lev;
  end;

  np=0;
  ew_range = ax;
%% Loop, extending range until 20 (or all) ews are included
  if m>20,
    while np < 20,
 
      if proj_lev>=0,
        ew_range = [ew_range(1)-proj_w ew_range(2)+proj_w ...
                    ew_range(3)-proj_h ew_range(4)+proj_h];
        select = find(real(eigA)>ew_range(1) & ...
                      real(eigA)<ew_range(2) & ...
                      imag(eigA)>ew_range(3) & ...
                      imag(eigA)<ew_range(4));
      else
        select = find(abs(eigA)>proj_size);
        proj_size = proj_size/2;
      end;


      np = length(select);

% Leave if the proj_lev is 0 (i.e. restrict to ews visible in window)
      if proj_lev==0, break; end;
    end;
  else
    np = m;
  end;


%% If there is no need to project (all ews are within range)
  if m==np,
    wb_offset = 0;
    m = size(T,1);
    if opts.no_waitbar~=1,
      if this_ver<6,
        hbar = waitbar(0,'Computing Pseudospectra...');
      else
        hbar = waitbar(0, ['Computing Pseudospectra...(line 1', ...
                                   ' of ',num2str(ly),')']);
      end;
    end;
  else
    wb_offset = 0.2;
    m = np;
    n = np;

%% Restrict the eigenvalues as well as the matrix (used in eigtool_switch_fn)
    eigA = eigA(select);

%% If we have found some eigenvalues in our 'window'
    if m>0,

      if opts.no_waitbar~=1,
        if this_ver<6,
          hbar = waitbar(0,'Computing Pseudospectra...');
        else
          hbar = waitbar(0, 'Projecting Matrix...');
        end;
      end;

%% Do the projection
      for i = 1:m
        for k = select(i)-1:-1:i
          G([2 1],[2 1]) = planerot([T(k,k+1) T(k,k)-T(k+1,k+1)]')';
          J = k:k+1; T(:,J) = T(:,J)*G; T(J,:) = G'*T(J,:);
        end
        if opts.no_waitbar~=1,
          waitbar(wb_offset*i/n,hbar);
        end;
% Check to see whether we're supposed to be paused; if so, wait
% for resume to be chosen.
       if pause_comp(opts.fig)==1, 
         hdl = findobj(opts.fig,'Tag','Pause');
         waitfor(hdl,'Callback');
       end;
       if stop_comp==opts.fig,
          err = -3; 
          if opts.no_waitbar~=1,
            close(hbar);
          end;
          h = warndlg('Pseudospectra computation cancelled.','Cancelled...','modal');
          waitfor(h);
          return;
        end;
      end
      T = triu(T(1:m,1:m));
    end;
  end;
else
  wb_offset = 0;
  if opts.no_waitbar~=1,
    if this_ver<6,
      hbar = waitbar(0,'Computing Pseudospectra...');
    else
      hbar = waitbar(0, ['Computing Pseudospectra...(line 1', ...
                                 ' of ',num2str(ly),')']);
    end;
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compute the resolvent norms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise some variables
% already_timed prevents updating at every gridpoint (after the first)
  already_timed = 0;
% ttime holds the total time spent on lu fact & Lanczos so far
  ttime = 0;
% Save the handle for the text to update
  msgbar_handle = findobj(opts.fig,'Tag','MessageText');
% Want to ignore the first data point as this can be unusually slow
  first_time = 1;

% Want to do different things if the matrix is sparse
  if issparse(T),
    I = speye(m);
    for j=ly:-1:1,      % Reverse order so that the first row is likely
                        % to have a complex gridpoint (better timings for lu)

% Update the waitbar
      if opts.no_waitbar~=1,
        if this_ver<6,
          waitbar(wb_offset+(1-wb_offset)*(ly-j)/ly,hbar);
        else
          waitbar(wb_offset+(1-wb_offset)*(ly-j)/ly,hbar,['Computing Pseudospectra...(line ', ...
                                 num2str(ly-j+1),' of ',num2str(ly),')']);
        end;
      end;

% Check to see whether we're supposed to be paused; if so, wait
% for resume to be chosen.
      if pause_comp(opts.fig)==1, 
        hdl = findobj(opts.fig,'Tag','Pause');
        waitfor(hdl,'Callback');
      end;

% Check to see whether the user has clicked on cancel
      if stop_comp==opts.fig,
        err = -3;
        if opts.no_waitbar~=1,
          close(hbar);
        end;
        h = warndlg('Pseudospectra computation cancelled.','Cancelled...','modal');
        waitfor(h);
        return;
      end;

% Now loop over the points in the x-direction
       for k=1:lx,
         zpt = x(k)+1i*y(j);
         clear L U L1 U1            % To ensure efficient memory usage
         t0 = clock; [L,U,P] = lu(T-zpt*I);
         L1 = L'; U1 = U';
         sigold = 0; qold = zeros(m,1); beta = 0; H = [];
         q = randn(n,1) + sqrt(-1)*randn(n,1); q = q/norm(q);
         for l=1:99
            v = L1\(U1\(U\(L\q))) - beta*qold;
            alpha = real(q'*v); v = v - alpha*q;
            beta = norm(v); qold = q; q = v/beta;
            H(l+1,l) = beta; H(l,l+1) = beta; H(l,l) = alpha;
%% Calculate the eigenvalues of H, but if error H is too big, so set
%% sig to an arbitrarily large value.
            try
              sig = max(eig(H(1:l, 1:l)));
            catch
              sig=1e308; break;
            end;
            if (abs(sigold/sig-1)<.001), break; end;
            sigold = sig; 
         end 
         Z(j,k) = 1/sqrt(sig);

%% Set the message if we haven't done so already (after the first point)
         if already_timed==0,
           if first_time==1,     % The first time, do nothing
             first_time = 0;
           else
             ttime = etime(clock,t0);   % Get the time
             total_time = ttime*lx*ly;
% Don't display estimated times if very short
             if total_time<10,
               no_est_time = 1;
             else
               no_est_time = 0;
% Don't time the first point - includes some 'setup time' for lu routine
% so is inaccurately large. Double time for 2nd point to get ttime correct
               ttime = ttime*2;     
% Work out whether to display as minutes or seconds
               [total_time,the_units] = pretty_time(total_time);
% Set the message and update the window
               the_message = ['EigTool: estimated remaining time is ', ...
                              num2str(total_time), ' ', the_units, '.'];
               set(msgbar_handle,'String', the_message);
               already_timed = 1;
               drawnow;
             end;
           end;
         else
           ttime = ttime+etime(clock,t0);  % If already done 2nd point, accumulate the time
         end;
       end

%% Set the message (in the j loop (i.e after each row is done)
       if no_est_time==0,
         total_time = ttime*(j-1)/(ly-j+1);
% Work out whether to display as minutes or seconds
         [total_time,the_units] = pretty_time(total_time);
% Set the message and update the window (if anytime left)
          if total_time>0,
            the_message = ['EigTool: estimated remaining time is ', ...
                          num2str(total_time), ' ', the_units, '.'];
            set(msgbar_handle,'String', the_message);
          end;
          drawnow;
        end;
    end

  else % The matrix is dense

% Want to do as many rows within the mexfile as possible, but still want to 
% update the waitbar sufficiently often.
     step = get_step_size(m,ly,'psacore');

% Loop over the rows
     for j=ly:-step:1,

% Check to see whether we're supposed to be paused; if so, wait
% for resume to be chosen.
        if pause_comp(opts.fig)==1, 
          hdl = findobj(opts.fig,'Tag','Pause');
          waitfor(hdl,'Callback');
        end;

        if stop_comp==opts.fig,
          err = -3; 
          if opts.no_waitbar~=1,
            close(hbar);
          end;
          h = warndlg('Pseudospectra computation cancelled.','Cancelled...','modal');
          waitfor(h);
          return;
        end;

        last_y = max(j-step+1,1);
        if opts.no_waitbar~=1,
          if this_ver<6,
            waitbar(wb_offset+(1-wb_offset)*(ly-j)/ly,hbar);
          else
            % Make the text pretty for the waitbar
            if step==1, the_lines = ['line ',num2str(ly-j+1)];
            else the_lines = ['lines ',num2str(ly-j+1),'-',num2str(ly-last_y+1)]; end;
            waitbar(wb_offset+(1-wb_offset)*(ly-j)/ly,hbar, ...
                   ['Computing Pseudospectra...(', ...
                               the_lines,' of ',num2str(ly),')']);
          end;
        end;

%% Actually do the singular value computation
        q = randn(n,1) + 1i*randn(n,1); q = q/norm(q);
        t0 = clock; Z(j:-1:last_y,:) = psacore(T,S,q,x,y(j:-1:last_y),1e-5,m-n+1);

% Accumulate the time
        ttime = ttime+etime(clock,t0);  

%% Use the total time estimate after the first call to decide whether to 
%% display the time or not
        if first_time==1,
          first_time = 0;
          total_time = ttime*ceil(ly/step);
          if total_time<10,
            no_est_time = 1;
          else
            no_est_time = 0;
          end;
        end;

%% Set the message (in the j loop (i.e after each row is done))
        if no_est_time==0,
          total_time = ttime*(floor((j-1)/step))/(ceil(ly/step)-floor((j-1)/step));
% Work out whether to display as minutes or seconds
          [total_time,the_units] = pretty_time(total_time);
% Set the message and update the window (if anytime left)
          if total_time>0,
            the_message = ['EigTool: estimated remaining time is ', ...
                          num2str(total_time), ' ', the_units, '.'];
            set(msgbar_handle,'String', the_message);
          end;
          drawnow;
        end;

     end

   end


if opts.no_waitbar~=1,
  if this_ver<6,
    waitbar(wb_offset+(1-wb_offset),hbar);
  else
    waitbar(wb_offset+(1-wb_offset),hbar,['Computing Pseudospectra...(done)']);
  end;
  close(hbar) 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now map the data if we need to to account for symmetry
%% Do the same for the vector y which is used as input to the
%% contour plotter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if num_mirror_pts<0,
%% Bottom half is the master...
  Z = [Z; flipud(Z(end+num_mirror_pts+1:end,:))];
  y = [y -fliplr(y(end+num_mirror_pts+1:end))];
elseif num_mirror_pts>0,
%% Top half is the master...
  if y(1)~=0,
    Z = [flipud(Z(1:num_mirror_pts,:)); Z];
    y = [-fliplr(y(1:num_mirror_pts)) y];
  else
    Z = [flipud(Z(2:num_mirror_pts+1,:)); Z];
    y = [-fliplr(y(2:num_mirror_pts+1)) y];
  end;

end;

%% Shift Z values so that there is no possibility of a zero singular value
Z = max(Z,1e-153);

%% Find out if we're currently 'hold on' or 'hold off'
holdstat = ishold;

%% Initially no error
err = 0;

%% If we should recalculate the levels
if re_calc_lev==1,

  [levels,err] = recalc_lev(Z,ax);

%% If an error occured
  if err~=0,
    if err==-1,
      errordlg('Range too small---no contours to plot. Refine grid or zoom out.','Error...','modal');
    elseif err==-2
      errordlg('Matrix too non-normal---resolvent norm is computationally infinite within current axes. Zoom out!','Error...','modal');
    end;

%% Now leave - nothing more we can do here
    return;
  end;

else
%% Check the user supplied levels will plot something
  if min(levels)>log10(max(max(Z))) | max(levels)<log10(min(min(Z))),
    [levels,err] = recalc_lev(Z,ax);
    h=warndlg('No contours to plot in range selected. `Smart'' levels used.','Invalid levels...','modal');
    waitfor(h);
    return;
  end;

end;

%% Check that the range has not overflowed
if min(levels)<-152,
  h=warndlg('Smallest level allowed by machine precision reached. Levels may be inaccurate.','Warning...','modal');
  waitfor(h);
end;
