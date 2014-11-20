function B = boeing_demo(mtx)

%   B = BOEING_DEMO(mtx) returns the "original" matrix B of
%   if mtx is 'O', or the "stabilised" matrix if mtx is 'S'.
%
%   These matrices of dimension 55 come from a flutter analysis of the
%   Boeing 767 aircraft reported as Benchmark Problem 90-06 in [1] (see
%   also [2]).
%
%   The unstable matrix corresponds to a dynamical system with no feedback, and
%   has an unstable pair of eigenvalues slightly inside the right half-plane.
%   The stable matrix has the form A + BKC, where A is the original matrix,
%   B and C are fixed 55 by 2 and 2 by 55 matrices respectively, and
%   K is a 2 by 2 feedback matrix that "stabilizes" A by static output
%   feedback, though not robustly.  Thus A has eigenvalues strictly in
%   the left half plane, but eps-pseudospectra that cross the imaginary axis
%   even for eps=1e-7. The stabilized matrix is from [3].
%
%   [1]: E. J. Davison, editor, "Benchmark problems for control
%        system design", Report of the IFAC Theory Commitee, 1990.
%   [2]: SLICOT Control and Systems Library,
%        http://www.win.tue.nl/wgs/slicot.html
%   [3]: J. V. Burke, A. S. Lewis and M. L. Overton, "A Nonsmooth,
%        Nonconvex Optimization Approach to Robust Stabilization by
%        Static Output Feedback and Low-Order Controllers",  submitted
%        to 4th IFAC Symposium on Robust Control Design, 2003.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

load boeing767

if mtx=='O',
  B = orig_mtx;
else
  B = opt_mtx;
end;
