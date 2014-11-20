function [A,ierr,isHessenberg] = matrix_check(A,opts)

% function [A,ierr,isHessenberg] = matrix_check(A,opts)
%
% Check the input matrix for errors. Return the matrix,
% (it may be modified in this routine) and a flag
% indicating the error.
%
% ierr = 1: EigTool doesn't work for 1x1 matrices
% ierr = 2: EigTool doesn't work for sparse rectangular matrices
% ierr = 3: EigTool doesn't work for m<n rectangular matrices
% ierr = 4: Inf/NaN in matrix entries
% ierr = 5: m<n for rect matrix

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  isHessenberg = 0;
  ierr = 0;

  [m,n] = size(A);

%% Matrix must be 2x2 or larger
  if m==1 & n==1,
      h = errordlg('Sorry, EigTool only works for 2x2 and larger matrices.', 'Error...','modal');      
      waitfor(h);
      ierr = 1;
      return;
  end;

%% If the matrix is short and fat, give message
  if m<n,
      h = errordlg('Sorry, EigTool does not work for short, fat rectangular matrices yet.', 'Error...','modal');
      waitfor(h);
      ierr = 3;
      return;
  end;

%% Code currently only works for square sparse matrices
  if issparse(A),
    if (m~=n), 
      h = errordlg('Sorry, EigTool does not work for sparse rectangular matrices yet.', 'Error...','modal');      
      waitfor(h);
      ierr = 2;
      return;
    end;
  end;

%% Check data in matrix
  if any(any(isnan(A))) | any(any(isinf(A))),
    h = errordlg('At least one entry of the input matrix is NaN or Inf. Please check and try again.','Error...','modal');
    waitfor(h);
    ierr = 4;
    return;
  end;

%% Set this variable to indicate if the matrix is Hessenberg
  if m==(n+1), isHessenberg = 1-any(any(tril(A,-2)));
  else
    isHessenberg = 0; 
  end;
