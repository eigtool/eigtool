 fprintf('\n           DISCRETE TIME STABILITY: MATRIX POWERS\n')
 fprintf('       ---------------------------------------------- \n\n')
 fprintf(' Many applications give rise to iterative processes where\n')
 fprintf(' one is concerned with whether or how fast A^k converges to\n')
 fprintf(' zero as k -> infinity.  Examples include stability analysis\n')
 fprintf(' of discretized ODEs and PDEs, shuffling of cards, stationary\n')
 fprintf(' iterative methods for solving linear systems (Gauss-Seidel,\n')
 fprintf(' SOR, etc.), and matrix population models.\n\n')
 fprintf(' The matrix A is stable if all its eigenvalues are smaller than\n')
 fprintf(' one in modulus, i.e., contained in the open unit disk.  But what\n')
 fprintf(' if the pseudospectra extend beyond the unit disk for small values\n')
 fprintf(' of epsilon?  Suppose for example that the 1e-4-pseudospectrum of\n')
 fprintf(' A includes points of absolute value 1.1 or larger.  Then\n')
 fprintf(' norm(A^k) must grow by a factor of at least 1000 before\n')
 fprintf(' it eventually decays.\n\n')
 fprintf(' Here are two examples, one where the pseudospectra indicate\n')
 fprintf(' that transient growth must occur, the other where pseudospectra\n')
 fprintf(' indicate that eigenvalues will be reliable.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fprintf(' Consider two 64-by-64 bidiagonal matrices with diagonal entries\n')
 fprintf(' alternating .5 and -.5.  A is bidiagonal, so its eigenvalues\n')
 fprintf(' can be read off the diagonal: .5 and -.5.  Thus the spectral\n')
 fprintf(' radius of A is .5.  From this we expect, asymptotically, for\n')
 fprintf(' norm(A^k) to be half as big as norm(A^(k-1)).\n\n')

 fprintf(' In the first instance, put 2 in each entry on the first superdiagonal,\n')
 fprintf(' thus giving a 64-by-64 matrix of the form\n\n')
 fprintf('                 [ .5   2   0   0   0 ] \n')
 fprintf('                 [  0 -.5   2   0   0 ] \n')
 fprintf('                 [  0   0  .5   2   0 ] \n')
 fprintf('                 [  0   0   0 -.5   2 ] \n')
 fprintf('                 [  0   0   0      .5 ] \n\n')
 fprintf(' To build the matrix and compute the pseudospectra of this matrix\n')
 fprintf(' using EIGTOOL, we issue the following commands:\n\n')

 fprintf('       A = .5*diag((-1).^[0:63]) + 2*diag(ones(63,1),1)\n')
 fprintf('       opts.ax = [-2 2 -2 2];\n')
 fprintf('       opts.unit_circle = 1;\n')
 fprintf('       eigtool(A,opts)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 clear opts
 A = .5*diag((-1).^[0:63]) + 2*diag(ones(63,1),1);
 opts.ax = [-2 2 -2 2];
 opts.unit_circle = 1;
 if ~exist('psademofig1','var'), psademofig1=figure('visible','off'); end;
 eigtool(A,opts,psademofig1)
 
 fprintf(' Note that the pseudospectra extend well beyond the unit disk for\n')
 fprintf(' small values of epsilon.  (Notice that EigTool has drawn the unit\n')
 fprintf(' circle as a thin line.)  For example, the 10^(-21) pseudospectrum\n')
 fprintf(' contains points of modulus 1.05.  This implies that norm(A^k) will\n')
 fprintf(' grow to be at least 0.05/1e-21 = 5e19 for some k before\n')
 fprintf(' eventually converging to zero.\n\n')

 fprintf(' It is easy to confirm this behavior using EIGTOOL.  Under the \n')
 fprintf(' "Transients" menu of the EIGTOOL window, select "Matrix Powers".\n')
 fprintf(' This will give you linear and log plots of norm(A^k) for increasing\n')
 fprintf(' k.  When you''ve seen enough, press "Stop".\n\n')

 fprintf(' One sees that norm(A^k) exceeds 10^(22) before eventually decaying.\n')
 fprintf(' To obtain a lower bound on this maximal growth using pseudospectra,\n')
 fprintf(' select "Best Estimate Lower Bound" from the "Transients" menu.\n')
 fprintf(' The result will fall short by a few orders of magnitude, but it gets\n')
 fprintf(' much closer if you zoom in near z=.1, press "Go", and try again.\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' Now consider a second example, the same as before but with smaller\n')
 fprintf(' entries on the superdiagonal.  A is a 64-by-64 matrix of the form\n\n')
 fprintf('                 [ .5  .2   0   0   0 ] \n')
 fprintf('                 [  0 -.5  .2   0   0 ] \n')
 fprintf('                 [  0   0  .5  .2   0 ] \n')
 fprintf('                 [  0   0   0 -.5  .2 ] \n')
 fprintf('                 [  0   0   0      .5 ] \n\n')

 fprintf('       A = .5*diag((-1).^[0:63]) + .2*diag(ones(63,1),1)\n')
 fprintf('       opts.ax = [-2 2 -2 2];\n')
 fprintf('       eigtool(A,opts)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 A = .5*diag((-1).^[0:63]) + .2*diag(ones(63,1),1);
 opts.ax = [-2 2 -2 2];
 eigtool(A,opts,psademofig1)

 fprintf(' This matrix has the same asymptotic convergence rate as the previous\n')
 fprintf(' one, but has a much more modest departure from normality.  The pseudospectra\n')
 fprintf(' are well contained by the unit disk for small values of epsilon.\n')
 fprintf(' Now select "Matrix Powers" from the "Transients" menu.  Observe there\n')
 fprintf(' is no transient growth in the matrix powers.\n\n');
 input('                - - -   press <return> to continue   - - - \n\n');
