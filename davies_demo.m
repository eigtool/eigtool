function A = davies_demo(N)

%   A = DAVIES_DEMO(N) returns matrix A of dimension N.
%
%   A is an anharmonic oscillator, -u_xx + cx2u, for c=1+3i, discretised
%   using a Chebyshev spectral method [3]. Since this discretization
%   includes numerous spurious eigenvalues, the matrix is projected
%   onto an appropriate invariant subspace to accelerate computation
%   of the pseudospectra. This example was first studied by Brian 
%   Davies [1,2].
%
%   [1]: E. B. Davies, "Pseudo-spectra, the harmonic oscillator and
%        complex resonances", Proc. Roy. Soc. Lond. Ser. A 455 (1999),
%        pp. 585-599.
%   [2]: E. B. Davies, "Semi-classical states for non-self-adjoint
%        Schroedinger operators", Commun. Math. Phys. 200 (1999), 
%        pp. 35-41.
%   [3]: L. N. Trefethen, "Spectral methods in MATLAB",
%        SIAM, 2000.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  [D,x] = cheb(N); %   cheb.m from Trefethen's "Spectral Methods in MATLAB"
  x = x(2:N);  

% Determine the length of the interval to truncate to based on N
  if N>130, L = 16; else L = 9; end;
  x = L*x; D = D/L;                   %   rescale to [-L,L]

  A = -D^2; A = A(2:N,2:N) + 1i*diag(x.^2);
