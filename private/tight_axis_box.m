function tight_axis_box(fig,cax)

% function tight_axis_box(fig,cax)
%
% Set the position box of the axes so that it is the
% same as the visable axes.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

if nargin<1, fig = gcf; end;
if nargin<2, cax = gca; end;

% Need to use pixels for the units while doing this
cax_units = get(cax,'units');
fig_units = get(fig,'units');
set(cax,'units','pixels')
set(fig,'units','pixels')

fig_pos = get(fig,'pos');
p = get(cax,'pos');
a = axis(cax);

% Work out where the bottom left & right points of the axis pos
% map to in the axes
set(fig,'currentpoint',[p(1);p(2)]);
pt = get(cax,'currentpoint');
bl = [pt(2,1); pt(2,2)];

set(fig,'currentpoint',[p(1)+p(3);p(2)]);
pt = get(cax,'currentpoint');
br = [pt(2,1); pt(2,2)];

% Scale the width of the axis accordingly
d = br-bl;
width_factor = (a(2)-a(1))/d(1);
wchange = p(3)-p(3)*width_factor;
p(3) = p(3)-wchange;

% Work out where the left top & bottom points of the axis pos
% map to in the axes
set(fig,'currentpoint',[p(1);p(2)]);
pt = get(cax,'currentpoint');
lt = [pt(2,1); pt(2,2)];

set(fig,'currentpoint',[p(1);p(2)+p(4)]);
pt = get(cax,'currentpoint');
lb = [pt(2,1); pt(2,2)];

% Scale the width of the axis accordingly
d = -lt+lb;
height_factor = (a(4)-a(3))/d(2);
hchange = p(4)-p(4)*height_factor;
p(4) = p(4)-hchange;

% Now set the axis to the new position
set(cax,'pos',p);

% Give the figure a new size too 
fig_pos(3) = fig_pos(3)-wchange;
fig_pos(4) = fig_pos(4)-hchange;
set(fig,'pos',fig_pos);

% Reset the units
set(cax,'units',cax_units);
set(fig,'units',fig_units);
