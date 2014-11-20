function [nmin,nmax] = tidy_axes(vmin,vmax,tol)

% function [nmin,nmax] = tidy_axes(vmin,vmax,tol)
%
% Function to tidy up axis limits. It takes two limits
% (a max and min value) which can have a 'nasty' decimal
% expansion, and rounds them to nicer values. Note that
% the range of the input values will always be contained
% within the range of the output values.
%
% vmin         The minimum value
% vmax         The maximum value
% tol          A relative tolerence for the cleanup
%
% nmin         The tidy min value
% nmax         The tidy max value

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% What is the range of values?
span = vmax-vmin;

% Compute an absolute tolerence based on the span and 
% relative tolerence.
round_to = span*tol;

% Convert this to a nice round number
lround_to = log10(round_to);
expon = floor(lround_to);
mant = round(10^(lround_to-expon));
round_to = mant*10^expon;

% Create the output values based on this value
nmin = round_to*floor(vmin/round_to);
nmax = round_to*ceil(vmax/round_to);


