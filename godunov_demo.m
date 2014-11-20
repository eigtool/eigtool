function G = godunov_demo(N)

%   G = GODUNOV_DEMO returns the 7 x 7 matrix G.
%
%   The "Godunov matrix" is a 7 x 7 matrix that has been used
%   by S. K. Godunov to illustrate the difficulty of computing 
%   certain eigenvalues in floating point arithmetic [1]. The
%   entries of A are integers and the exact eigenvalues 
%   are -4, -2, -1, 0, 1, 2, 4. This can be seen from the 
%   fact that L*A/L is upper triangular, where L is the 
%   lower-triangular matrix defined by
%
%         L = eye(7); L(3,1) = 1; L(6,1) = 1;
%         L(5,3) = 1; L(7,[2 3 5]) = 1;
%
%   [1]: S. K. Godunov, "Modern Aspects of Linear Algebra",
%        Translations of Mathematical Monographs v. 175,
%        Amer. Math. Soc., Providence, RI, 1998.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  G = [ 289  2064   336   128    80     32    16
       1152    30  1312   512   288    128    32
        -29 -2000   756   384  1008    224    48
        512   128   640     0   640    512   128
       1053  2256  -504  -384  -756    800   208
       -287   -16  1712  -128  1968    -30  2032
      -2176  -287 -1565  -512  -541  -1152  -289 ];
