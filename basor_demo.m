function T = basor_demo(N)

%   T = BASOR_DEMO(N) returns matrix T of dimension N.
%
%   T is a Toeplitz matrix of dimension N with a piecewise
%   continuous symbol. For N sufficiently large, each of the
%   illustrated pseudospectra will include the spectrum of the
%   infinite dimensional operator, but for this class of piecewise
%   continuous symbols, this value of N needs to be especially
%   large. The eigenvalues of this example have been studied by
%   Basor and Morrison [1] and the pseudospectra are illustrated
%   in [2].
%
%   [1]: Basor and Morrison "The Fisher-Hartwig conjecture and
%        Toeplitz eigenvalues", Linear Algebra Appl. 202 (1994),
%        pp. 129-142. 
%   [2]: A. Boettcher, M. Embree, and L. N. Trefethen "Piecewise
%        continuous Toeplitz matrices and operators: slow approach
%        to infinity", SIAM J. Matrix Analysis Appl. 24 (2002)
%        pp. 484-489.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  r = -i./[1:N]; c = [-i pi i./[1:N-2]];
  T = toeplitz(c,r);
