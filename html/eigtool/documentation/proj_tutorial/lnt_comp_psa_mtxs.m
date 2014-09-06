function [B,A] = lnt_comp_psa_mtxs(N)

D = zeros(N+2,N+2); i=(0:N+1)'; ci = [2;ones(N,1);2];
x = cos(pi*i/(N+1));
for j = 0:N+1
  cj = 1; if j==0 | j==N+1 cj = 2; end
  denom = cj*(x(i+1)-x(j+1)); denom(j+1) = 1;
  D(i+1,j+1) = ci.*(-1).^(i+j)./denom;
  if j>0 & j<N+1 D(j+1,j+1) = -.5*x(j+1)/(1-x(j+1)^2); end;
  end;
D(1,1) = (2*(N+1)^2+1)/6; D(N+2,N+2) = -(2*(N+1)^2+1)/6;
L=10;
x=x(2:N+1); x=L*x; D=D/L;
A = D^2; A = A(2:N+1,2:N+1);
A = A+(3+3*sqrt(-1))*diag(x.^2) - (1/16)*diag(x.^4);
w = sqrt(pi*sqrt(L^2-x.^2)/(2*(N+1)));
B = zeros(N,N); for j=1:N, B(:,j) = w.*A(:,j)/w(j); end;
