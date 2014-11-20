function c = findcontour(cdat)

% function c = findcontour(cdat)
%
% Extract the actual contour levels plotted on a contour plot
%
% cdat        the contour data as output by contour
%
% c           a vector of the levels plotted

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues
% Based on a routine by Mark Embree

%% Initialise
c = [];
j = 1;

%% Loop over the data
while j<size(cdat,2)
  c = [c;cdat(1,j)];
  j = j+cdat(2,j)+1;
end

%% Tidy up the output
c = sort(unique(c));
