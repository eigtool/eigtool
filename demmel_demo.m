function D = demmel_demo(N)

%   D = DEMMEL_DEMO(N) returns matrix D of dimension N.
%
%   D is Demmel's matrix, which was perhaps the first matrix 
%   whose pseudospectra (with N=3) appeared in a published
%   paper [1]. Demmel devised the matrix in order to disprove
%   a conjecture of Van Loan's [2].
%
%   [1]: J. W. Demmel, "A counterexample for two conjectures
%        about stability", IEEE Trans. Auto. Control, AC-32,
%        pp. 340-343, 1987.
%   [2]: C. Van Loan, "How near is a stable matrix to an
%        unstable matrix?", in R. Brualdi, et al., eds,
%        Contemporary Mathematics 47, Amer. Math. Soc., 1985

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  B = 10^(4/(N-1));
  c = [1; zeros(N-1,1)];
  r = B.^(0:N-1);
  D = -toeplitz(c,r);
