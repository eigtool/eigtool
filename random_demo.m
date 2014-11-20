function R = random_demo(N)

%   R = RANDOM_DEMO(N) returns matrix R of dimension N.
%
%   R is a random matrix whose entries are drawn from the
%   normal distribution with mean 0 and variance 1/N.
%
%   One can see from these pseudospectra that dense
%   random matrices are only mildly non-normal (in contrast,
%   for example, to triangular ones).  In the limit N -> Inf,
%   the norm and spectral abscissa converge to 2 and 1, 
%   respectively [1,2] and the condition number is of size
%   O(N) [3].  Of that factor of N, O(sqrt(N)) can be attributed
%   to variation in the size of the eigenvalues and O(sqrt(N))
%   to non-normality [4].  Pseudospectra for this example
%   were first plotted in [5].
%
%   [1]: S. Geman, "A limit theorem for the norm of random matrices"
%        The Annals of Probability 8(2), 1980, 252-261.
%   [2]: S. Geman, "The spectral radius of large random matrices"
%        The Annals of Probability 14(4), 1986, 1318-1328.
%   [3]: A. Edelman, "Eigenvalues and Condition Numbers of Random
%        Matrices", SIAM J. Matrix Anal. 9(4), 1988, 543-560.
%   [4]: J. T. Chalker and B. Mehlig, "Eigenvector Statistics in Non-
%        Hermitian Random Matrix Ensembles", Phys. Rev. Lett. 81(16),
%        1998, 3367-3370.
%   [5]: L. N. Trefethen, "Psuedospectra of matrices", in
%        "Numerical Analysis 1991" (Dundee 1991), Longman Sci.
%        Tech., Harlow, 1992, 234-266.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  R = randn(N)/sqrt(N);
