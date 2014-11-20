function loc = et_get_file_location(fname)

% function loc = et_get_file_location(fname)
%
% Function to find the full path to a particular MATLAB file,
% given the filename, fname.
%
% See also: WHICH

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Remove '.m' from filename, if there
if strcmp(fname(end-1:end),'.m'),
  fname = fname(1:end-2);
end;

% Get the full path, including the filename
floc = which(fname);

% Remove the filename to get just the path
% (remember to remove the '.m' from the filename too)
flen = length(fname);
loc = floc(1:end-flen-2);
