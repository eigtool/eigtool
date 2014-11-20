function switch_psademo

% function switch_safety
%
% Function called when Pseudospectra Tutorial menu option is chosen

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  h = msgbox(['To learn more about pseudospectra and their applications, ' ...
              'type   psademo   at the MATLAB command prompt; you will be ' ...
              'led through a step-by-step guide to pseudospectra and '  ...
              'their applications.'],'modal');
  waitfor(h);

