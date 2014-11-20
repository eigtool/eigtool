function C = convdiff_fd_demo(N)

%   C = CONVDIFF_FD_DEMO(N) returns matrix C of dimension N.
%
%   C is the 2-D convection-diffusion operator
%         -e*laplacian(u) + u_y
%   on the unit square with Dirichlet boundary conditions. The
%   discretisation is done using finite differences (see, e.g., [1]),
%   resulting in large, sparse matrices. The code is based on a
%   routine by Daniel Loghin.
%
%   [1]: L. Hemmingsson, "A Semi-circulant Preconditioner for the
%        Convection-Diffusion Equation", Numer. Math 81, 1998, 211-248

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Diffusion parameter
e = 1e-2;

% Wind blowing in y-direction.
w1 = 0;
w2 = 1;

% Set up the grid size (more points in y direction due to wind)
n1 = N;
n2 = 4*N;
h1 = 1/(n1+1);
h2 = 1/(n2+1);

% Generate 1D finite difference matrices
alpha1 = w1/h1;
beta1 = 2*e/h1^2;
alpha2 = w2/h2;
beta2 = 2*e/h2^2;

A1 = spdiags(ones(n1,1)*[-alpha1-beta1 2*beta1 alpha1-beta1], -1:1, n1, n1);
A2 = spdiags(ones(n2,1)*[-alpha2-beta2 2*beta2 alpha2-beta2], -1:1, n2, n2);

% Now compute the 2D finite difference matrix
C = kron(speye(n2),A1) + kron(A2,speye(n1));
