function [total_time,the_units] = pretty_time(total_time)

% function [total_time,the_units] = pretty_time(total_time)
%
% Function to convert time in seconds to a whole number of
% hours, minutes or seconds depending on the size.

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

  if total_time<180,
    total_time = ceil(total_time);
    the_units = 'seconds';
  elseif total_time<10800,
    total_time = ceil(total_time/60);
    the_units = 'minutes';
  else % Display in hours
    total_time = round(total_time/360)/10;
    the_units = 'hours';
  end;
