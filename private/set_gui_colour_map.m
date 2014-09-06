function cm = set_gui_colour_map(fig)

% function cm = set_gui_colour_map(fig)
%
% Function to set the colourmap of a figure to the standard
% one used by the GUI.

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

cm = getpref('EigTool','colormap');
set(fig,'colormap',cm);
