function A = twisted_demo(N)

%   A = TWISTED_DEMO(N) returns matrix A of dimension N.
%
%   The "cross" matrix is an example of a banded "twisted circulant matrix".
%   It is tridiagonal (with periodic wraparound) but instead of having
%   constant diagonals, as in a true circulant matrix, it has a smoothly
%   varying main diagonal.  The result is an exponentially strong degree
%   of nonnormality, with pseudomodes in the form of wave packets.
%   See [1].
%   
%   [1]: J. Chapman and L. N. Trefethen, "Wave packet pseudomodes of twisted
%        Toeplitz matrices", to appear.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  x = 2*pi*(0:N-1)/N;
  D = diag(ones(N-1,1),1); D(N,1) = 1;
  A = diag(2*sin(x)) + D - D';
