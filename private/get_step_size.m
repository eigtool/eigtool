function step = get_step_size(n,ly,routine)

% function step = get_step_size(n,ly)
% Function to compute a stepsize which will allow as many rows
% of the grid to be done as possible within the psacore***
% mexfiles, but will still allow the waitbar to be updated
% sufficiently often.
%
% n        The dimension of the matrix
% ly       The number of gridpoints in the y direction
% routine  The name of the routine which will use the step size
%
% step     The number of rows of the grid to compute at once

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Generate a stepsize
if n<100, step = max(1,floor(ly/8));
else step = min(ly,max(1,floor(4*ly/n))); end;

% If we can see the m-file (i.e. no mex file),
% decrease the stepsize as the computation will take
% much longer
if exist(routine,'file')==2,
  step = max(1,floor(step/4));
end;
