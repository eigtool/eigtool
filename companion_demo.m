function E = companion_demo(N)

%   E = COMPANION_DEMO(N) returns matrix E of
%   dimension N.
%
%   This matrix was suggested by Cleve Moler. It is the
%   companion matrix for the truncated power series of
%   exp(z). Note that serious rounding errors for N much
%   larger than 15 due to the large size of some entries.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  c = [1 1 ./ cumprod(1:N)];
  E = compan(fliplr(c));
