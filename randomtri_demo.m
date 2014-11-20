function R = randomtri_demo(N)

%   R = RANDOMTRI_DEMO(N) returns matrix R of
%   dimension N.
%
%   R is an upper triangular random matrix whose entries
%   are drawn from the normal distribution with mean 0 and
%   variance 1/N.
%
%   Unlike a matrix whose entries are all random, taking
%   non-zero entries only in the upper (or lower) triangle 
%   produces a matrix with a high degree of non-normality [1,2].
%
%   [1]: J. M. Varah, "On the separation of two matrices",
%        SIAM J. Numer. Anal. 16, pp. 216-222, 1979.
%   [2]: L. N. Trefethen, "Psuedospectra of matrices", in
%        "Numerical Analysis 1991" (Dundee 1991), Longman Sci.
%        Tech., Harlow, 1992, 234-266.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  R = triu(randn(N))/sqrt(N);
