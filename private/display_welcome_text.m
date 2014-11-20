function display_welcome_text(fig,cax)

% function display_welcome_text(fig,cax)
%
% Print out welcome text onto the main axes, and turn off
% the axis ticks etc.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Reduce the font size if EigTool is in SMALL mode
  SMALL_GUI = getpref('EigTool','SMALL_GUI');
  if SMALL_GUI==1,
    font_reduce = 2;
  else
    font_reduce = 0;
  end;

% Make sure we overwrite everything else
  set(cax,'NextPlot','ReplaceChildren');

% Initialise the axes in case something funny happens
  axis(cax,[0 1 0 1]);

% Now put the message up

  h = text(0.33,0.72,'EigTool','fontweight','bold', ...
                           'fontsize',20-font_reduce,'fontname','helvetica','Parent',cax);
  set(h,'Tag','ETwelcome');

% Now make sure we add
  set(cax,'NextPlot','Add');
  text(0.055,0.55,'To begin experimenting, please','fontweight','normal', ...
                           'fontsize',16-font_reduce,'fontname','helvetica','Parent',cax);
  text(0.055,0.48,'select examples from the Demos','fontweight','normal', ...
                           'fontsize',16-font_reduce,'fontname','helvetica','Parent',cax);
  text(0.055,0.41,'menu above, or select the item','fontweight','normal', ...
                           'fontsize',16-font_reduce,'fontname','helvetica','Parent',cax);
  text(0.055,0.34,'New Matrix from the File menu','fontweight','normal', ...
                           'fontsize',16-font_reduce,'fontname','helvetica','Parent',cax);
  text(0.055,0.27,'to enter your own matrix.','fontweight','normal', ...
                           'fontsize',16-font_reduce,'fontname','helvetica','Parent',cax);

% Turn off the axis labels for now
  set(cax,'ytick',[]);
  set(cax,'xtick',[]);
 
% Extend the main axes to use all available space
  grow_main_axes(fig,1);

