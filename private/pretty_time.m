function [total_time,the_units] = pretty_time(total_time)

% function [total_time,the_units] = pretty_time(total_time)
%
% Function to convert time in seconds to a whole number of
% hours, minutes or seconds depending on the size.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

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
