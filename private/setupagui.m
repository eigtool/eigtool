% Script called after aeigs has finished to store the final
% variables so that the GUI can get at them.

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

% Get the matrices H and V (called thev)
  extract_mtx;

% Append them to the existing data
  ps_data = get(opts.eigtool,'userdata');
  ps_data.proj_matrix = H;
  ps_data.proj_unitary_mtx = thev;
  set(opts.eigtool,'userdata',ps_data);
