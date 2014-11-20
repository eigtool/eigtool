function add_mycolourbar(con,fig,clevs)

% function add_mycolourbar(con,fig,clevs)
%
% This function adds a discrete colourbar to a figure.
% The first argument is the data from the contour
% command (needed to determine which contours were
% actually drawn), and the second one is
% the figure to operate with. The third argument, clevs,
% is a vector of the epsilon levels requested on the plot.
%
% add_mycolourbar('off',fig) will remove the colourbar.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

main_axes = get(fig,'currentaxes');
set(main_axes,'Tag','MainAxes');

% Need to use pixels for the units while doing this
main_axes_units = get(main_axes,'units');
fig_units = get(fig,'units');
set(main_axes,'units','normalized')
set(fig,'units','normalized')

% Remove the colourbar if requested
if strcmp(con,'off'),
  cb_axes = findobj(fig,'Tag','MyColourBar');
  if ~isempty(cb_axes),
    delete(cb_axes);
    if main_axes~=cb_axes,
      a = get(main_axes,'pos');
    else
      main_axes = gca;
      a = get(main_axes,'pos');
    end;
    a(1) = a(1)*1.3;
    a(3) = a(3)*1.1;
    set(main_axes,'pos',a);
    return;
  end;
end;

% Add a colourbar if there isn't one there already
if isempty(findobj(fig,'Tag','MyColourBar')),

% Setup the minimum size for the main axes
  tight_axis_box(fig,main_axes);

% Make room for the colourbar
  a = get(main_axes,'pos');
  a(1) = a(1)/1.3;
  a(3) = a(3)/1.1;
  set(main_axes,'pos',a);

% Add the colourbar axes
%  b = [(a(1)+a(3))*1.05, a(2), a(3)/10, a(4)];
  fig_pos = get(fig,'pos');
  
  b = [(a(1)+a(3))*1.05, a(2), 0.065*0.48611/fig_pos(3), a(4)];
  cb_axes = axes('position',b);

% Set the colourbar properties
  set(cb_axes,'box','on');
  set(cb_axes,'Tag','MyColourBar');
  set(cb_axes,'XTick',[]);
  set(cb_axes,'XTickLabel','');
  set(cb_axes,'YAxisLocation','right');
  set(cb_axes,'YTickMode','manual');
  set(cb_axes,'Units','normalized');

  resize_et_colourbar(fig);
end;

% Update the colour bar
mycolourbar(fig,clevs,con,1);

% Setup the minimum size for the main axes
tight_axis_box(fig,main_axes);

% Set the main axes to the default
set(fig,'currentaxes',main_axes);

% Set a resize function to keep the colourbar the correct width
set(fig,'ResizeFcn','resize_et_colourbar(gcbf)');

% Reset the units
set(main_axes,'units',main_axes_units);
set(fig,'units',fig_units);
