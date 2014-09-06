function [S,T] = rect_fact(A)

% function [S,T] = rect_fact(A)
%
% Compute the long-triangular form of the matrix. This should be called
% before psa_computation.m which requires a long-triangular matrix as input.
%
% A           the matrix to factor
% 
% S           the triangular factors
% T           the triangular factor (if m<2n)

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

  [m,n] = size(A);

  if m>=2*n,  % Use QR form
    [Q,R] = qr(A(n+1:end,:),0);
    S = [A(1:n,:); R];
    T = 1;
  else        % Use QZ form
    T = eye(m,n);
    [S,T,Q,Z] = qz(A(end-n+1:end,:),T(end-n+1:end,:));
    S = [A(1:m-n,:)*Z; S];
    T = [Z(1:m-n,:); T];
  end;
