function B = landau_demo(N)

%   T = LANDAU_DEMO(N) returns matrix T of dimension N.
%
%   T represents an integral equation from laser theory investigated
%   by Landau [1] in one of the earliest applications of
%   pseudospectra.
%
%   [1]: H. J. Landau, "The notion of approximate eigenvalues
%        applied to an integral equation of laser theory",
%        Quart. Appl. Math. 35 (1977), pp. 165-172.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Define the parameter, based on N
  if N>200, F = 32; else F = 12; end;

% calculate nodes and weights for Gaussian quadrature
  beta = 0.5*(1-(2*[1:N-1]).^(-2)).^(-0.5);
  T = diag(beta,1) + diag(beta,-1);
  [V D] = eig(T); [nodes index] = sort(diag(D));
  weights = zeros(N,1); weights([1:N]) = (2*V(1,index).^2);

% Construct matrix B
  B = zeros(N,N);
  for k=1:N
    B(k,:)= weights(:)'* sqrt(1i*F).*exp(-1i*pi*F*(nodes(k) - nodes(:)').^2);
  end

% Weight matrix with Gaussian quadrature weights
  w = sqrt(weights);
  for j=1:N, B(:,j) = w.*B(:,j)/w(j); end
  clear D T V beta index j k nodes w weights
