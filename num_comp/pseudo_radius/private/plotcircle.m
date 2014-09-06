function [] = plotcircle(rad,plotfig)
% call : plotcircle(rad)
%   task
%                 Draws circle with the given radius.
%
%   input
%       rad     : radius of the circle which will be drawn
%       plotfig : figure handle, if no figure with this handle
%                 exists, a new figure will be opened, otherwise
%                 the circle will be drawn on the figure with
%                 handle plotfig.
%   output
%                 no output

if nargin < 2
	plotfig = 1;
end

num_of_points = 1000; 
rads = rad * rad;
xv = [];
yv = [];
inc = 4*rad / num_of_points;



x = -rad;
while x < +rad
    xv = [xv x];
    y = sqrt(rads - x*x);
    yv = [yv y];
    x = x + inc;
end

x = +rad;
while x > -rad
    xv = [xv x];
    y =  -sqrt(rads - x*x);
    yv = [yv y];
    
    x = x - inc;
end

xv = [xv xv(1)];
yv = [yv yv(1)];


figure(plotfig);
plot(xv,yv,'r-');