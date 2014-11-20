function H = hatano_demo(N)

%   H = HATANO_DEMO(N) returns matrix H of dimension N.
%
%   Since the Nobel prize-winning work of P. Anderson in 1958, random
%   tridiagonal matrices have been famous as models of disordered
%   condensed matter quantum systems; their eigenvectors are
%   exponentially localized, and this is connected with lack of
%   transparency to light and conductivity to electrons of certain
%   1D physical systems [1].  The Hatano-Nelson model was proposed
%   in 1996 by two physicists as a contribution to the "nonhermitian
%   quantum mechanics" of certain systems in physics and biology [2].
%   This example matrix is tridiagonal and exponentially nonnormal;
%   pseudospectra such problems are analyzed in [3].  Hatano and
%   Nelson actually proposed the periodic analogue with nonzero
%   corner elements, which is much closer to normal.
%
%   [1]: P. Anderson, "Absence of diffusion in certain random lattices",
%        Phys. Rev., 109 (1958), 1492-1505.
%   [2]: N. Hatano and D. R. Nelson, "Localization transitions in non-
%        Hermitian quantum mechanics", Phys. Rev. Lett. 77 (1996), 570-573.
%   [3]: L. N. Trefethen, M. Contedini, and M. Embree, "Spectra,
%        pseudospectra, and localization for random bidiagonal matrices"
%        Comm. Pure Appl. Math. 54 (2001), 595-623.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  g = 0.4;
  H = exp(-g)*diag(ones(N-1,1),-1) + ...
              diag(3*rand(N,1)-1.5) + ...
       exp(g)*diag(ones(N-1,1),1);
