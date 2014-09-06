function E = companion_demo(N)

%   E = COMPANION_DEMO(N) returns matrix E of
%   dimension N.
%
%   This matrix was suggested by Cleve Moler. It is the
%   companion matrix for the truncated power series of
%   exp(z). Note that serious rounding errors for N much
%   larger than 15 due to the large size of some entries.

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

  c = [1 1 ./ cumprod(1:N)];
  E = compan(fliplr(c));
