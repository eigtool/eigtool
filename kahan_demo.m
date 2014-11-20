function K = kahan_demo(N)

%   K = KAHAN_DEMO(N) returns matrix K of dimension N.
%
%   The Kahan matrix is also in the MATLAB gallery, and can be
%   created by the command G = gallery('kahan',N)
%
%   Kahan's matrix [2] was devised to illustrate that QR 
%   factorisation with column pivoting is not a fail-safe
%   method for determining the rank of the matrix. Rank
%   determination is related to the "distance to singularity"
%   of a matrix [1], or in other words, how large a perturbation
%   is needed to make the matrix singular. The pseudospectra are
%   shown in [3].
%
%   [1]: N. J. Higham, "Matrix nearness problems and applications",
%        NA Rep. 161, Dept. of Maths., U. of Manchester, June 1988.
%   [2]: W. Kahan, "Numerical linear algebra", Canad. Math. Bull. 9,
%        pp. 757-801, 1966.
%   [3]: L. N. Trefethen, "Psuedospectra of matrices", in
%        "Numerical Analysis 1991" (Dundee 1991), Longman Sci.
%        Tech., Harlow, 1992, 234-266.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

s = (1/10)^(1/(N-1));
c = sqrt(1-s^2);

col = -s.^(0:N-1)'*c;
K = triu(repmat(col,1,N),1)+diag(s.^(0:N-1));
