function Z = psacore(T,S,q,x,y,tol,bw)

% function Z = psacore(T,S,q,x,y,tol,bw)
%
% This function is the main computational routine for dense matrix
% pseudospectra computation. This m-file is provided as a back-up in
% case the mex file version for a particular platform fails or does
% not exist. USING THIS M-FILE VERSION WILL RESULT IN SIGNIFICANTLY
% SLOWER PERFORMANCE. 
%
% T         long-triangular matrix to compute pseudospectra of
% S         2nd matrix from generalised pencil zS-T. Set to 1 if 
%           the problem is not generalised
% q         a starting vector for the inverse-Lanczos iteration
%           (the same vector is used to start each point in the
%           grid defined by x and y). IT MUST BE NORMALISED TO
%           HAVE LENGTH 1.
% x         x-values of the grid to compute the pseudospectra over
% y         y-values of the grid to compute the pseudospectra over
% tol       The tolerance to use to determine when to stop the
%           inverse-Lanczos iteration (suggested 1e-5).
% bw        the bandwidth of the input matrix
%
% Z         the singular values corresponding to the grid points
%           x and y.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% fprintf('IN PSACORE.M: NO MEX FILE!\n')

lx = length(x);
ly = length(y);

[m,n] = size(T);
[ms,ns] = size(S);
if m<n, error('Matrix must be mxn with m>=n'); end;
if (ms~=1 | ns~=1) & (ms~=m) & (ns~=n), error('Matrix dimensions for S & T do not match'); end;
use_eye = 0;
if (ms==1) & (ns==1), use_eye = 1; end;

Z = zeros(ly,lx);
diaga = diag(T);
cdiaga = conj(diaga);

% Check to see whether it is better to use plain SVD rather than Lanczos
if n<55,

  if use_eye, % If we are just doing the standard thing
    for j=1:ly
      for k=1:lx
        zpt = x(k)+1i*y(j);
        T(1:m+1:end) = diaga - zpt;
        Z(j,k) = min(svd(T));
      end;
    end;
  else
    for j=1:ly
      for k=1:lx
        zpt = x(k)+1i*y(j);
        A = T-zpt*S;
        Z(j,k) = min(svd(A));
      end;
    end;
  end;

else

   qt = q;
   H = zeros(100);

   if m==n,
     T1 = T;
     T2 = T1';
   end;

   opts_lt.LT = true;
   opts_ut.UT = true;

   for j=1:ly
     for k=1:lx
       zpt = x(k)+1i*y(j);

% For rectangular matrices...
       if m~=n,

% If we don't have a generalised problem
         if use_eye,
           T(1:m+1:end) = diaga - zpt;
           T1 = T;
         else
           T1 = T-zpt*S;
         end;

% If we're rectangular Hessenberg, with m>200, use HessQR algorithm
         if bw==2 & m>200,
           for jj=1:n-1,
             xx = [T1(jj,jj); T1(jj+1,jj)];
             tmp = T1(jj+1,jj);
             if tmp ~= 0,
               r = norm(xx);
               G = [xx'; -xx(2) xx(1)]/r;
             else
               G = eye(2);
             end
             T1(jj:jj+1,jj:end) = G*T1(jj:jj+1,jj:end);
           end;
         else
           T1 = qr(T1);
         end;
         T1 = triu(T1(1:n,1:n));
         T2 = T1';
       else
         T1(1:m+1:end) = diaga - zpt;
         T2(1:m+1:end) = cdiaga - zpt';
       end;

       q = qt;
       qold = zeros(n,1);
       beta = 0;
       sigold = 0;
       for l=1:99,
         s1 = linsolve(T2,q,opts_lt);
         s2 = linsolve(T1,s1,opts_ut);
         v = s2 - beta * qold;
            
      %   v = T1\(T2\q) - beta*qold;
         alpha = real(q'*v);
         v = v - alpha*q;
         beta = norm(v);
         qold = q;
         q = v/beta;
         H(l+1,l) = beta;
         H(l,l+1) = beta;
         H(l,l) = alpha;
%% Calculate the eigenvalues of H, but if error H is too big, so set
%% sig to an arbitrarily large value.
         try
           sig = max(eig(H(1:l, 1:l)));
         catch
           warning('sigmin set to smallest value possible.');
           sig=1e308; break;
         end;
         if (abs(sigold/sig-1)<tol|beta==0), break; end;
         sigold = sig;
       end;
       Z(j,k) = 1/sqrt(sig);

     end 
   end

end; %% if n<55

