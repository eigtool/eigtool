function [Z,q] = inv_lanczos(A,q,z,tol,num_its)

% function [Z,q] = inv_lanczos(A,q,z,tol)
%
% A         the matrix to use to find sigma_min(zI-A)
% q         starting vector for the iteration
% z         point in the complex plane to use
% tol       tolerance to use
% num_its   Maximum number of iterations
%
% Z         the smallest singular values
% q         the smallest singular vector

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

[m,n] = size(A);
if m~=n, error('Matrix must be square'); end;

diaga = diag(A);
cdiaga = conj(diaga);

% Check to see whether it is better to use plain SVD rather than Lanczos
if n<200,

  A(1:m+1:end) = diaga - z;
  [U,S,V] = svd(full(A));
  Z = min(diag(S));
  q = V(:,end);

else

   H = zeros(num_its+1);

   if ~issparse(A),
     T1 = A;
     T2 = T1';
     T1(1:m+1:end) = diaga - z;
     T2(1:m+1:end) = cdiaga - z';
   else
     [L,U,P] = lu(A-z*speye(m));
     L1 = L'; U1 = U';
   end;

   qold = zeros(n,1);
   Q = q;
   beta = 0;
   sigold = 0;
   for l=1:num_its,
     if ~issparse(A),
       v = T1\(T2\q) - beta*qold;
     else
       v = U\(L\(L1\(U1\q))) - beta*qold;
     end;
     alpha = real(q'*v);
     v = v - alpha*q;
     beta = norm(v);
     qold = q;
     q = v/beta;
     Q = [Q q];
     H(l+1,l) = beta;
     H(l,l+1) = beta;
     H(l,l) = alpha;
%% Calculate the eigenvalues of H, but if error H is too big, so set
%% sig to an arbitrarily large value.
     try
       sig = max(eig(H(1:l, 1:l)));
     catch
       sig=1e308; break;
     end;
     resid = abs(sigold/sig-1); if (resid<tol|beta==0), break; end;
     sigold = sig;
   end;
   H = H(1:l,1:l);
   Z = 1/sqrt(sig);

%% Get the vector from the inverse Lanczos basis (catch error if matrix
%% is too non-normal; will cause user to be asked question below)
   try
     [V,D] = eig(H); q = Q(:,1:end-1)*V(:,end);
   catch
     l = num_its;
   end;

%% If iteration count exceeded, ask if SVD is OK
    if l>=num_its,
      opts.CreateMode = 'modal';
      opts.Default = 'Yes';
      opts.Interpreter = 'none';
      quest_str = ['Inverse Lanczos iteration failed to converge. ' ...
                  'Do you want to do a full SVD instead (this could be slow)?'];
      button = questdlg(quest_str,'Compute using full SVD?','Yes','No',opts);
      switch button
      case 'Yes' % Do the SVD
        A(1:m+1:end) = diaga - z;
        [U,S,V] = svd(full(A));
        Z = min(diag(S));
        q = V(:,end);
      case 'No' % Return error
        q = NaN;
        Z = NaN;
      end;
    end;

end; %% if n<200


