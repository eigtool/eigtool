function A = airy_demo(N)

%   A = AIRY_DEMO(N) returns matrix A of dimension N.
%
%   Our "Airy operator" is an operator acting on functions of x
%   defined on [-1,1] according to the formula
%   
%              L u = epsilon*(d^2 u / dx^2) + i*x*u
%   
%   where epsilon is a small parameter.  The spectrum of this operator
%   is an unbounded discrete set contained in the half-strip Re z < 0,
%   -1 < Im z < 1.  The pseudospectra approximately fill the whole 
%   strip.  The pseudospectra of this operator were first considered
%   by Reddy, Schmid and Henningson as a model of the more complicated
%   Orr-Sommerfeld problem [1].  Our M-file is based on a Chebyshev
%   collocation spectral discretization with epsilon = 4e-3.
%
%   [1]: S. C. Reddy, P. J. Schmidt and D. S. Henningson,
%        "Pseudospectra of the Orr-Sommerfeld operator",
%        SIAM J. Appl. Math. 53(1), pp. 15-47, 1993.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  [D,x] = cheb(N);
  D2 = D^2;
  D = D(2:N,2:N); D2 = D2(2:N,2:N); x = x(2:N);
  A = 3e-4*D2 + 1i*diag(x);
