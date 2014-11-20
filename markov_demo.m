function M = markov_demo(N)

%   M = MARKOV_DEMO(N) returns a Markov chain transition matrix
%   for a random walk on an N by N triangular lattice.  It is an 
%   example of a matrix for which certain parts of the spectrum 
%   (in this case the interior) are highly non-normal, but other 
%   eigenvalues are well-conditioned and relevant to the application.
%   (Here, the left eigenvectors associated with eigenvalues of unit 
%   modulus determine the steady-state distribution of the Markov chain.
%   For more information, see [1]. 
%
%   [1]: Y. Saad, "Numerical methods for large eigenvalue
%        problems", Manchester University Press, Manchester,
%        p48ff, 1992.

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

N = N-1;
M = spalloc(N^2/2 + 3*N/2 + 1,N^2/2 + 3*N/2 + 1,4*(N^2/2 + 3*N/2 + 1));
Id = -1*ones(N+1,N+1);
m = 1;
for i = 0:N, for j=0:N-i
    Id(i+1,j+1) = m; m = m+1;
end, end

for i = 0:N, for j=0:N-i
% down
   if i==0, indx1=-1; else indx1 = Id(i-1+1,j+1); end;
   if j==0, indx2=-1; else indx2 = Id(i+1,j-1+1); end;
   if (indx1>0)&(indx2>0)
       M(Id(i+1,j+1), indx1) = (i+j)/(2*N);
       M(Id(i+1,j+1), indx2) = (i+j)/(2*N);
   elseif (indx1<0)&(indx2<0)
   elseif (indx1<0) 
       M(Id(i+1,j+1), indx2) = (i+j)/N;
   elseif (indx2<0) 
       M(Id(i+1,j+1), indx1) = (i+j)/N;
   end;
% up
   if (i+j < N)
      indx1 = Id(i+1+1,j+1);
      indx2 = Id(i+1,j+1+1); 
      M(Id(i+1,j+1), indx1) = 1/2 - (i+j)/(2*N);
      M(Id(i+1,j+1), indx2) = 1/2 - (i+j)/(2*N);
   end
end, end;
