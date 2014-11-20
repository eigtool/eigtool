function sh = nice_3d_plot(x,y,z,qx,qy,xs,ys,light_pos)

% function nice_3d_plot(x,y,z,qx,qy,xs,ys,light_pos)
%
% Function to produce a lighted surface plot with 
% lines superimposed on top to better show the surface
% structure.
%
% x      A vector containing the x data for the surface
% y      A vector containing the y data for the surface
% Z      A matrix containing the surface data
% qx     The x grid size for the superimposed lines
%        e.g. qx=2 for a line on every other datapoint
% qy     The y grid size
% xs     The number of the first x gridline (default 1)
% ys     The number of the first y gridline (default 1)
% light_pos  Position for the light source (optional)

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Set some defaults if necessary
if nargin<6, xs = 1; end;
if nargin<7, ys = 1; end;

% Draw the surface
colormap(hot);
if nargin<8, sh=surfl(x,y,z);
else sh=surfl(x,y,z,light_pos); end;
shading interp

% Get the data that was actually plotted
x=get(sh,'xdata');
y=get(sh,'ydata');
z=get(sh,'zdata');

% Define the grid data in the x direction and
% plot the lines
if qx>0,
  xi=x(xs:qx:end,:);
  yi=y(xs:qx:end,:);
  zi=z(xs:qx:end,:);
  lh=line(xi',yi',zi','color',[0 0 0]);
end;

% Define the grid data in the y direction and
% plot the lines
if qy>0,
  xi=x(:,ys:qy:end);
  yi=y(:,ys:qy:end);
  zi=z(:,ys:qy:end);
  lh=line(xi,yi,zi,'color',[0 0 0]);
end;

axis tight
