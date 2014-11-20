function A = transient_demo(N)

%   A = TRANSIENT_DEMO(N) returns matrix A of dimension N.
%
%   The matrix in this demo is designed to have transient
%   behaviour in both ||A^k|| and ||e^{tA}||. To see this,
%   run the demo, then go to the `Transients' menu to view
%   the behaviour. Lower bounds on the transient behaviour
%   can be plotted by selecting items from the same menu.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  x = 2*pi*(0:N-1)/N;
  D = diag(ones(N-1,1),1); D(N,1) = 1;
  A = diag(exp(1i*x)) + D;
  A = .4*A - .5*eye(N);
