function A = supg_demo(N)

%   A = SUPG_DEMO(N) returns a matrix corresponding to the
%   SUPG discretisation of an advection-diffusion operator.
%   This demo is based on a function by Mark Embree, which
%   was essentially distilled from the IFISS software of 
%   Elman and Silvester.  See:
%      http://www.ma.umist.ac.uk/djs/software.html
%   and [1].
%   For this example, whilst the eigenvalues computed by eigs
%   are inaccurate due to the sensitivity of the problem, the
%   approximate pseudospectra are very good approximations to
%   the true ones.
%
%   [1]: B. Fischer, A. Ramage, D. Silvester and A. Wathen,
%        "Towards Parameter-Free Streamline Upwinding for 
%        Advection-Diffusion Problems", Comput. Methods Appl. 
%        Mech. Eng., 179, 1999, 185-202.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

h = 1/(N+1);
theta = 0;
if N<20, nu = 0.01;
else nu = 0.0001; end;

% Compute the "optimal" upwinding parameter
hbar = h/(max(sin(theta), cos(theta)));
delta = max(0, 1/2 - nu/hbar);

w = [-sin(theta) cos(theta)];
wx2 = w(1)^2;
wy2 = w(2)^2;

if (N > 10)
   A = sparse(N*N, N*N);
   v = ones(N,1);

   for j=1:N

      A(N*(j-1)+1:N*j, N*(j-1)+1:N*j) = ...
         spdiags( v*(nu*[-1/3 8/3 -1/3] + ...
                      h*[-w(1)/3  0 w(1)/3] + ...
                      delta*h*[(wy2-2*wx2)/3 4/3*(wx2+wy2) (wy2-2*wx2)/3]), ...
         [-1,0,1],N,N);

      if (j>1) A(N*(j-1)+1:N*j, N*(j-2)+1:N*(j-1)) = ...
         spdiags( v*(nu*[-1/3 -1/3 -1/3] + ...
                     h*[-(w(1)+w(2))/12 -w(2)/3 (w(1)-w(2))/12] + ...
                     delta*h* ...
             [(-(wx2+wy2)/6-w(1)*w(2)/2) (wx2-2*wy2)/3 (-(wx2+wy2)/6+w(1)*w(2)/2)]), ...
         [-1,0,1],N,N);
      end;
      if (j<N) A(N*(j-1)+1:N*j, N*j+1:N*(j+1)) = ...
         spdiags( v*(nu*[-1/3 -1/3 -1/3] + ...
                      h*[(w(2)-w(1))/12 w(2)/3 (w(1)+w(2))/12] + ...
                      delta*h* ...
             [(-(wx2+wy2)/6+w(1)*w(2)/2) (wx2-2*wy2)/3 (-(wx2+wy2)/6-w(1)*w(2)/2)]), ...
         [-1,0,1],N,N);
      end;
   end;

else 
   H = zeros(N*N); S = zeros(N*N); U = zeros(N*N);

   for j=1:N
     for k=1:N
        row = (j-1)*N+k;
        H(row, row) = 8/3;
        if (k > 1), H(row, row-1) = -1/3; end;
        if (k < N), H(row, row+1) = -1/3; end;
        if (j > 1), H(row, row-N) = -1/3; end;
        if (j < N), H(row, row+N) = -1/3; end;
        if ((j > 1) & (k > 1)), H(row, row-N-1) = -1/3; end;
        if ((j > 1) & (k < N)), H(row, row-N+1) = -1/3; end;
        if ((j < N) & (k > 1)), H(row, row+N-1) = -1/3; end;
        if ((j < N) & (k < N)), H(row, row+N+1) = -1/3; end;
     end
   end

   for j=1:N
     for k=1:N
        row = (j-1)*N+k;
        S(row, row) = 0;
        if (k > 1), S(row, row-1) = -1/3*w(1); end;
        if (k < N), S(row, row+1) =  1/3*w(1); end;
        if (j > 1), S(row, row-N) = -1/3*w(2); end;
        if (j < N), S(row, row+N) =  1/3*w(2); end;
        if ((j > 1) & (k > 1)), S(row, row-N-1) = -(w(1)+w(2))/12; end;
        if ((j > 1) & (k < N)), S(row, row-N+1) =  (w(1)-w(2))/12; end;
        if ((j < N) & (k > 1)), S(row, row+N-1) =  (w(2)-w(1))/12; end;
        if ((j < N) & (k < N)), S(row, row+N+1) =  (w(1)+w(2))/12; end;
     end
   end

   for j=1:N
     for k=1:N
        row = (j-1)*N+k;
        U(row, row) = 4/3*(wx2+wy2);
        if (k > 1), U(row, row-1) = (wy2-2*wx2)/3; end;
        if (k < N), U(row, row+1) = (wy2-2*wx2)/3; end;
        if (j > 1), U(row, row-N) = (wx2-2*wy2)/3; end;
        if (j < N), U(row, row+N) = (wx2-2*wy2)/3; end;
        if ((j > 1) & (k > 1)), U(row, row-N-1) = -(wx2+wy2)/6 - w(1)*w(2)/2; end;
        if ((j > 1) & (k < N)), U(row, row-N+1) = -(wx2+wy2)/6 + w(1)*w(2)/2; end;
        if ((j < N) & (k > 1)), U(row, row+N-1) = -(wx2+wy2)/6 + w(1)*w(2)/2; end;
        if ((j < N) & (k < N)), U(row, row+N+1) = -(wx2+wy2)/6 - w(1)*w(2)/2; end;
     end
   end

   A = nu*H + h*S + delta*h*U;
end

if (nargout > 1)
   b = zeros(N*N,1);
   b(floor(N/2))       = (1/3)*nu + (1/12)*h + (1/6)*delta*h;
   b(floor(N/2)+1)     = (2/3)*nu + (5/12)*h + (5/6)*delta*h;
   b(floor(N/2)+2:N-1) = nu + (1/2)*h + delta*h;
   b(N)                = (5/3)*nu + (5/12)*h + (5/6)*delta*h;

   b(N*[2:N-1])        = nu;
   b(N*N)              = (2/3)*nu + (1/12)*h - (1/6)*delta*h;
end
