function G = grcar_demo(N)

%   G = GRCAR_DEMO(N) returns matrix G of dimension N.
%
%   The Grcar matrix is also in the MATLAB gallery, and can be
%   created by the command G = gallery('grcar',N)
%
%   This is a popular example in the field of matrix iterations
%   of a matrix whose spectrum is in the right half-plane but
%   whose numerical range is not.  It's also a popular example
%   in the study of nonsymmetric Toeplitz matrices.  The matrix
%   was first described in [1] and its pseudospectra were first 
%   plotted in [2].
%
%   [1]: J. F. Grcar, "Operator coefficient methods for linear
%        equations", tech. report SAND89-8691, Sandia National
%        Labs, 1989
%   [2]: L. N. Trefethen, "Psuedospectra of matrices", in
%        "Numerical Analysis 1991" (Dundee 1991), Longman Sci.
%        Tech., Harlow, 1992, 234-266.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  G = diag(ones(N,1),0) - diag(ones(N-1,1),-1) + ...
      diag(ones(N-1,1),1) + diag(ones(N-2,1),2) + ...
      diag(ones(N-3,1),3);
