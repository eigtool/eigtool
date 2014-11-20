function [levels,err] = recalc_lev(sigmin,ax)

% function [levels,err] = recalc_lev(sigmin,ax)
%
%   Function to automatically calculate level curves to plot given the minimum
% singular value data. If possible, 'nice' numbers are used (e.g. multiples of
% 0.1, 0.25, 0.5, 1), but these would not produce satisfactory levels then any
% equally spaced numbers can be returned.
%   The function will also try to determine the maximum 'sensible' contour to
% plot for a given axis---this is to try and indicate when a matrix is reasonably
% normal by not plotting large numbers of fairly meaningless contours.
%
% sigmin        the minimum singular values returned by a psa algorithm
% ax            the axis to plot on, used to determine what is 'normal'
%
% levels        the computed levels
% err           If an error occured, this has the error number:
%                  err = 0:  No error
%                  err = -2: All singular values are zero! No levels

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Initialise err
  err = 0;

%% Find the maximum and minimum levels in the data we want a contour of
  smin = min(min(sigmin));
  smax = max(max(sigmin));

%% If there is no data (i.e. VERY non-normal)
  if smax<=1e-150,
%% Inform user and exit
    levels = [];
    err = -2;
    return;
  end;

%% If the smallest singular value is 1e-153 (manually set in psa_computation),
%% use second smallest
  if smin<=1e-150, 
    smin = min(min(sigmin(sigmin>=1e-150)));
  end;

%% Convert these to levels
  max_val=log10(smax);
  min_val=log10(smin);

%% Default number of lines to try and display
  num_lines = 8;

%% Now want to make sure that only 'interesting' contours are shown...
  scale = min(ax(4)-ax(3),ax(2)-ax(1));
  last_lev = log10(0.03*scale);

%% If we are going to remove some lines, want to reduce the number of
%% lines shown - want fewer lines to indicate normality...
  if max_val >= last_lev,
    num_lines = ceil(num_lines*(last_lev-min_val)/(max_val-min_val));
    max_val = last_lev;
  end;

%% If we won't show any contours now...
  if max_val < min_val,
%% Use this, even though it doesn't really help indicate
%% the degree of non-normality of the matrix 
    max_val = log10(smin) + 1/10*log10(smax/smin);
    num_lines = 3;
  end;

%% Now use this value as the maximum number of lines which will be drawn
%% (num_lines itself will depend on which 'nice' numbers fall in the range
%% requested). 
  max_lines = num_lines;

%% Calculate the step size we want to use for the levels,
%% but will only give a step size of 0.25, 0.5 or 1.
  if num_lines>0,

    stepsize=max(round((max_val-min_val)/num_lines*4)/4,0.25);

%% Don't want to have a stepsize of 0.75, which is possible above
%% Don't want it to be greater than one either
    if stepsize>=0.75, stepsize=1;end;

%% If using quarters didn't work very well (i.e. not enough lines)
    if (max_val - min_val)/stepsize < max_lines,

%% Try using 10ths
      stepsize=max(round((max_val-min_val)/num_lines*10)/10,0.1);
    
%% Only want to have a stepsize other than 0.1, 0.2, 0.5
      if stepsize==0.3, stepsize=0.2;end;
      if stepsize==0.4, stepsize=0.5;end;
      if stepsize>=0.6 & stepsize <=0.8, stepsize=0.5;end;
      if stepsize>=0.9, stepsize=1; end;
    end;

%% If we STILL haven't got many lines
    if (max_val - min_val)/stepsize < ceil(max_lines/2),
%% Forget about trying to make nice numbers
      stepsize = (max_val - min_val) / max_lines;
    else
%% Round these numbers down to nice multiples of the stepsize
      min_val = ceil(min_val/stepsize)*stepsize;
      max_val = floor(max_val/stepsize)*stepsize;
    end;

%% Redefine the levels
    if stepsize>0,
      levels=[min_val:stepsize:max_val];
    else %% Just one contour
      levels=[min_val max_val];
    end;
  end;

%% Don't display too many levels
  ll = length(levels);
  levels = fliplr(levels(end:-max(floor(ll/9),1):1));

%% Ensure that the levels output is suitable for input to contour
  if length(levels)==1, levels = [levels levels]; end;

%% Display a message to the user giving a hint as to how non-normal their
%% matrix is.
%  nn_scale = 10^(min(levels))/max(ax(2)-ax(1),ax(4)-ax(3));
%  if nn_scale>5e-4, disp('Matrix is fairly normal: analysis based on eigenvalues likely to be accurate.');
%  elseif nn_scale>5e-7, disp('Matrix is moderately non-normal: analysis based on eigenvalues may be inaccurate.');
%  else disp('Matrix is highly non-normal: analysis based on eigenvalues likely to be inaccurate.');
%  end;


