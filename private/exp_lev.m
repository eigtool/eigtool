function levels = exp_lev(lev_desc)

% function levels = exp_lev(lev_desc)
%
% This function expands the compressed vector form of the levels
% to full vector form.
%
% lev_desc    The compressed description
%
% levels      The expanded levels

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If the levels are evenly spaced
if lev_desc.iseven==1,
  if lev_desc.step~=0,
    levels = fliplr([lev_desc.last:-lev_desc.step:lev_desc.first]);
  else
    levels = [lev_desc.first lev_desc.first];
  end;
else
  levels = lev_desc.full_levels;
  if length(levels)==1,
    levels = levels*[1 1];
  end;
end;
