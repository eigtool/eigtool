function ps_data = switch_dots(fig,cax,this_ver,ps_data)

% Funcion to plot eigenvalues of random perturbations to
% the input matrix onto the current plot.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

n = length(ps_data.schur_matrix);

mtxs = input('Number of matrices? ');
ep = input('Size of perturbation? ');

ews = zeros(n*mtxs,1);

for i=1:mtxs,

  v1 = randn(n,1)+1i*randn(n,1); v1 = v1/norm(v1);
  v2 = randn(1,n)+1i*randn(1,n); v2 = v2/norm(v2);

  E = ep*v1*v2;

  ews((i-1)*n+1:i*n) = eig(ps_data.schur_matrix+E);
  
end;

plot(real(ews),imag(ews),'.','color',0.6*[1 0 1]);

ps_data.rand_pert_ews = ews;
