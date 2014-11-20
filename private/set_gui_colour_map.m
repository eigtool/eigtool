function cm = set_gui_colour_map(fig)

% function cm = set_gui_colour_map(fig)
%
% Function to set the colourmap of a figure to the standard
% one used by the GUI.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

cm = getpref('EigTool','colormap');
set(fig,'colormap',cm);
