function C = chebspec_demo(N)

%   C = CHEBSPEC_DEMO(N) returns matrix C of
%   dimension N.
%
%   C is the Chebyshev spectral differentiation matrix of
%   dimension N [1] of the first derivative operator d/dx
%   on [-1,1] with boundary condition u(1)=0.
%   The pseudospectra of the infinite dimensional operator
%   consist of half-planes, which is suggested in this
%   low-dimensional discretization by the straight lines
%   that form the rightmost part of each pseudospectral
%   boundary [2].
%
%   [1]: L. N. Trefethen, "Spectral methods in MATLAB",
%        SIAM, 2000.
%   [2]: L. N. Trefethen, "Psuedospectra of matrices", in
%        "Numerical Analysis 1991" (Dundee 1991), Longman Sci.
%        Tech., Harlow, 1992, 234-266.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  C = gallery('chebspec',N);
  C = C(1:end-1,1:end-1);
