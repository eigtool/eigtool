function [U,T,eigA] = fact(A,no_waitbar)

% function [U,T,eigA] = fact(A,no_waitbar)
%
% Perform the Schur decomposition of the matrix. This should be called
% before psa_computation.m which requires a triangular matrix as input.
%
% A           the matrix to factor
% no_waitbar  set to 1 to avoid displaying waitbar
% 
% U           the unitary matrix (used for plotting pseudomodes)
% T           the triangular factor
% eigA        the eigenvalues of the matrix

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Get the dimension of A and check that it is square
[n,m]=size(A);
if n~=m, error('Only works for square matrices'); end;

%% Check to see whether matrix is triangular already
if any(any(tril(A,-1)))==0

  T = A; eigA = diag(A);
  U = 1;

else

%% Don't display the wait bar if the matrix is small.
%% The waitbar will jump in 2 stages, but at least it gives
%% something to look at.
  maxn=200;

%% Don't use waitbar if n is small - too fast!
  if n>maxn & no_waitbar~=1, hbar = waitbar(0, 'Computing Schur Factorisation...'); end;

%% Make sure the screen is up to date before we start this
  drawnow;

%% Actually do the Schur decomposition
  [U,T] = schur(A,'complex'); 

%% If we're using waitbar
%% schur is about 70% of time, rsf2csf the rest
  if n>maxn & no_waitbar~=1, waitbar(0.7,hbar); end;

%% Last bit of waitbar
  if n>maxn & no_waitbar~=1, waitbar(0.95,hbar); end;

%% Make sure matrix is really triangular
  T = triu(T);

%% Extract the eigenvalues
  eigA = diag(T);

%% Close the waitbar if necessary
  if n>maxn & no_waitbar~=1, close(hbar); end;

end;
