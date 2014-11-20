function mycolourbar(cbarfig, ps_epslev,con,colour)

% function mycolourbar(cbarfig, ps_epslev,con,colour)
%
% Function to create the colour bar. 
%
% cbarfig     A handle to the figure to create the colour bar on
% ps_epslev   The epsilon levels which were requested in the
%             contour plot
% con         The output of the contour command
% colour      Are the contours plotted in colour (1) or b/w (0)?

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Get a handle to the Colourbar Axes and make them the default.
mycb = findobj(cbarfig,'Tag','MyColourBar');
the_cur_axes = get(cbarfig,'CurrentAxes');
set(cbarfig,'CurrentAxes',mycb);
set(0,'CurrentFigure',cbarfig);

cbar_vis = get(mycb,'visible');

%% Clear them
cla(mycb);

%% These commands are equivalent to hold on
set(cbarfig,'NextPlot','add');
set(mycb,'NextPlot', 'add');

%% Find out which levels were actually plotted
clevs = findcontour(con);

if isempty(clevs),
  h = errordlg('No contours to plot in range selected. Select a new range.','Error...','modal');
  waitfor(h);
  set(cbarfig,'CurrentAxes',the_cur_axes);
  return;
end;

%% If not black and white
if colour==1,
%% Acutally create the colour bar, using one colour for each
%% possible contour level (even those which don't appear on this
%% plot)
  clevs = ps_epslev;
else
  clevs = sort(clevs(:));
end;

%% Reshape to the correct shape
clevs = clevs(:)';

%% Make sure clevs just has one entry for each level
if clevs(1) == clevs(end), clevs = clevs(1); end;

%% Set the axes with a little extension to make sure that the thick line
%% lies within the axes
if length(clevs)<=1,
  the_ext = 0.1;
else
  the_ext = (clevs(end)-clevs(1))/60;
end;
set(mycb,'ylim',[clevs(1)-the_ext clevs(end)+the_ext]);
set(mycb,'xlim',[0 1]);

%% Set the tick marks (reduce the number if they'll overlap)
spacing = ceil(length(clevs)/20);
if length(clevs)>1,
  set(mycb,'YTick',[clevs(1) ...
                    clevs(1+spacing:spacing:end-spacing) ...
                    clevs(end)]);
else
  set(mycb,'YTick',clevs(1));
end;

%% Get the colour map so that we know what colours to use
cm = get(cbarfig,'ColorMap');

%% Now loop over each of the contours which has been plotted
for i=1:length(clevs),

%% If the colour bar is in colour
  if colour==1,

%% Work out which entry in the colour table matches the contour
    if clevs(end)~=clevs(1),
      the_entry = min(fix((clevs(i)-clevs(1))/(clevs(end)-clevs(1))*(length(cm)))+1,length(cm));
    else
      the_entry = length(cm);
    end;

%% Draw it
    line([0 1],[clevs(i),clevs(i)],'linewidth',5, ...
                              'color',cm(the_entry,:),'parent',mycb, ...
                              'visible',cbar_vis)
  else %% Colourbar is in b/w

%% Draw a black line
    line([0 1],[clevs(i),clevs(i)],'linewidth',5, ...
                              'color',[0 0 0],'parent',mycb, ...
                              'visible',cbar_vis)
  end;

%% Fudge the fact that the coloured lines are drawn OVER the bounding box
%% of the window:
  yl = get(mycb,'ylim');
  plot([0 0],yl,'k-','linewidth',0.5,'visible',cbar_vis);
  plot([1 1],yl,'k-','linewidth',0.5,'visible',cbar_vis);

end;

set(cbarfig,'CurrentAxes',the_cur_axes);
