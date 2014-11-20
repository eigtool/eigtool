function [y, num_mirror] = shift_axes(ax,npts)

% function [y, num_mirror] = shift_axes(ax,npts)
%
% Function to handle the shifting of data points to take advantage of
% symmetry. The data points must be made symmetric about the x-axis
% so that the points can be mirrored.
%
% ax          the axis to work with
% npts        the number of points in the grid
% 
% y           a vector containing the y values of the grid
% num_mirror  the number of points to reflect to get the other half
%                 positive: calculate top half, mirror bottom half
%                 negative: calculate bottom half, mirror top half

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Axes are always shifted so that grid points straddle the x-axis
%% i.e. a grid point never lies on the x-axis

if ax(4)>-ax(3),
%% If the top part is larger...

%% The number of points to be used in the top part
  tpts = floor((ax(4)/(ax(4)-ax(3)))*npts);

%% Points are equally spaced, distance h. First point is half 
%% that distance from the origin as corresponding point is that
%% distance the other side of the origin.
  y = linspace(ax(4)/(2*(tpts-1)+1), ax(4), tpts);

%% Now insert a point corresponding to the bottom point in the
%% axes into this range so that the edge is handled properly

%% Find out where the new point should be inserted
  n = sum(y<-ax(3));

%% Insert it in the correct place...
  if abs(y(min([end,n+1]))+ax(3))>1e-15, y = [y(1:n) -ax(3) y(n+1:end)]; end;

%% The number of points which will need to be mirrored
  num_mirror = n+1;

elseif ax(4)<-ax(3)
%% If the bottom part is larger...

%% The number of points to be used in the bottom part
  bpts = floor((ax(3)/(ax(3)-ax(4)))*npts);

%% Points are equally spaced, distance h. First point is half 
%% that distance from the origin as corresponding point is that
%% distance the other side of the origin.
  y = linspace(ax(3),ax(3)/(2*(bpts-1)+1), bpts);

%% Now insert a point corresponding to the bottom point in the
%% axes into this range so that the edge is handled properly

%% Find out where the new point should be inserted
  n = sum(y<-ax(4));

%% Insert it in the correct place if there is not already a point there...
  if abs(y(max([1,n]))+ax(4))>1e-15, y = [y(1:n) -ax(4) y(n+1:end)]; end;

%% The number of points which need to be mirrored
%% (negative to indicate that bottom is master)
  num_mirror = -(length(y)-(n+1)+1);

else % They must be equal (and opposite)

% Calculate the top half and mirror the rest
  if mod(npts,2)==1,
    y = linspace(0,ax(4),(npts+1)/2);
    num_mirror = (npts+1)/2-1; % don't want to include the origin in the mirroring
  else
    step = (ax(4)-ax(3))/npts;
    y = linspace(step/2,ax(4),npts/2);
    num_mirror = npts/2;
  end;

end;




