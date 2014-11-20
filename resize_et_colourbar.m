function resize_et_colourbar(fig)

% function resize_et_colourbar(fig)
%
% Function to resize the colourbar to keep it the same
% width no matter how large the figure is.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues


% Find the colourbar and set its units to pixels
cb_axes = findobj(fig,'Tag','MyColourBar');
cb_units = get(cb_axes,'units');
set(cb_axes,'units','pixels');

% Update the width
pcb = get(cb_axes,'pos');
pcb(3) = 36.35;

% Reset the position and return the units
set(cb_axes,'pos',pcb);
set(cb_axes,'units',cb_units);
