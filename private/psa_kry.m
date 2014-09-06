 fprintf('\n               CONVERGENCE OF MATRIX ITERATIONS   \n')
 fprintf('           ---------------------------------------- \n\n')
 fprintf(' Large, sparse linear systems A*x = b, of the kind that one might\n')
 fprintf(' obtain through discretization of three-dimensional PDEs,\n')
 fprintf(' are often solved using Krylov subspace methods, a class\n')
 fprintf(' of algorithms that includes the conjugate gradient algorithm\n')
 fprintf(' for symmetric positive definite matrices (pcg in MATLAB) and\n')
 fprintf(' GMRES, Bi-CGSTAB, and QMR for nonsymmetric problems (gmres,\n')
 fprintf(' bicgstab, and qmr in MATLAB).\n\n')

 fprintf(' Pseudospectra can provide information about how such iterations will\n')
 fprintf(' converge.  In particular, GMRES is straightforward to analyze.\n')
 fprintf(' At the k-th iteration, the residual r_k satisfies the optimality\n')
 fprintf(' condition\n\n')
 fprintf('         norm(r_k) =    min     norm(p(A) r_0),\n')
 fprintf('                      p in P_k \n\n')
 fprintf(' where P_k denotes the set of polynomials of degree-k with p(0)=1,\n')
 fprintf(' and r_0 is the initial residual, r_0 = b-A*x_0. (x_0 is the\n')
 fprintf(' initial guess.)\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' Trefethen (1990) developed a bound on norm(r_k) using pseudospectra:\n\n')
 fprintf('                      L(eps)                              \n')
 fprintf('      norm(r_k)  <=  --------      min          max         |p(z)|, \n')
 fprintf('                     2*pi*eps    p in P_k   z in eps-psa(A)\n\n')
 fprintf(' where L(eps) is the length of the boundary of eps-psa(A), for any\n')
 fprintf(' choice of eps.  In words, this bound suggests that GMRES convergence\n')
 fprintf(' will be slow when the pseudospectra are significantly larger than\n')
 fprintf(' the eigenvalues for small values of eps.  Convergence predictions\n')
 fprintf(' based only on eigenvalues may be misleading.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' Let''s investigate a couple of examples.  First, let A be a Jordan\n')
 fprintf(' block with 1 on the main diagonal and d on the superdiagonal, so that\n')
 fprintf(' A has the form: \n\n')
 fprintf('                 [  1   d   0   0   0 ] \n')
 fprintf('                 [  0   1   d   0   0 ] \n')
 fprintf('                 [  0   0   1   d   0 ] \n')
 fprintf('                 [  0   0   0   1   d ] \n')
 fprintf('                 [  0   0   0   0   1 ] \n\n')

 fprintf(' When d=0, A is just the identity matrix, and GMRES converges in a single\n')
 fprintf(' iteration.  As d is increased, the pseudospectra become larger and larger\n') 
 fprintf(' for a fixed value of epsilon.  In fact, eps-psa(A) is a disk centered\n')
 fprintf(' at 1 with radius approximately d*eps^(1/N) for large matrix dimensions\n')
 fprintf(' and eps < 1.  If r_eps denotes this radius, then\n\n')
 fprintf('            min          max          |p(z)|  =  (r_eps)^k,\n')
 fprintf('         p in P_k   z in eps-psa(A)\n\n')
 fprintf(' so that the GMRES convergence bound predicts a deteriorating\n')
 fprintf(' convergence rate as the superdiagonal parameter d is increased.\n') 
 fprintf(' Indeed, this is what one observes in practice, and pseudospectra\n')
 fprintf(' predict the convergence rate perfectly.\n\n')

 fprintf(' First, consider the pseudospectra of this matrix with d=0.5:\n\n')
 fprintf('                 N = 64;\n')
 fprintf('                 A1 = eye(N) + 0.5*diag(ones(N-1,1),1);\n')
 fprintf('                 opts.ax = [0 2 -1 1];\n') 
 fprintf('                 opts.levels = [-10:-1];\n')
 fprintf('                 eigtool(A1,opts,1);\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');
 

 N = 64; 
 A1 = eye(N) + 0.5*diag(ones(N-1,1),1);
 clear opts
 opts.ax = [0 2 -1 1]; 
 opts.levels = [-10:-1];
 if ~exist('psademofig1','var'), psademofig1=figure('visible','off'); end
 eigtool(A1,opts,psademofig1);


 fprintf(' Compare these pseudospectra to those for the matrix with d=0.75.\n')
 fprintf(' Notice that they have similar structure, but the circles are now\n')
 fprintf(' closer to the origin.\n\n')
 fprintf('                 A2 = eye(N) + 0.75*diag(ones(N-1,1),1);\n')
 fprintf('                 eigtool(A2,opts,1);\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 A2 = eye(N) + 0.75*diag(ones(N-1,1),1);
 eigtool(A2,opts,psademofig1);

 fprintf(' Finally, consider the matrix with d=1.0.  Now the epsilon-pseudospectra\n')
 fprintf(' nearly contain the origin even for very small values of epsilon.\n\n')
 fprintf('                 A3 = eye(N) + diag(ones(N-1,1),1);\n')
 fprintf('                 eigtool(A3,opts,1);\n\n')

 input('                - - -   press <return> to continue   - - - \n');

 A3 = eye(N) + 1*diag(ones(N-1,1),1);
 eigtool(A3,opts,psademofig1);

 fprintf('\n')
 
 fprintf(' Now we compare how GMRES converges for these three different\n')
 fprintf(' matrices.  We expect the convergence to get slower as the\n')
 fprintf(' pseudospectra increase in size and proximity to the origin,\n')
 fprintf(' so d=0.5 should give the most rapid convergence, and d=1\n')
 fprintf(' the slowest.\n\n');
 fprintf('                 b = randn(N,1);\n');
 fprintf('                 [x,flag,relres,iter,resvec1] = gmres(A1,b,[],1e-12,N);\n');
 fprintf('                 [x,flag,relres,iter,resvec2] = gmres(A2,b,[],1e-12,N);\n');
 fprintf('                 [x,flag,relres,iter,resvec3] = gmres(A3,b,[],1e-12,N);\n');
 fprintf('                 figure(2), clf\n');
 fprintf('                 semilogy([0:length(resvec1)-1],resvec1,''b-''), hold on\n');
 fprintf('                 semilogy([0:length(resvec2)-1],resvec2,''g-'')\n');
 fprintf('                 semilogy([0:length(resvec3)-1],resvec3,''r-'')\n');
 fprintf('                 legend(''d=0.5'', ''d=0.75'', ''d=1'')\n');
 fprintf('                 xlabel(''iteration''), ylabel(''residual norm'')\n\n');

 input('                - - -   press <return> to continue   - - - \n\n');
 
 b = randn(N,1);
 [x,flag,relres,iter,resvec1] = gmres(A1,b,[],1e-12,N);
 [x,flag,relres,iter,resvec2] = gmres(A2,b,[],1e-12,N);
 [x,flag,relres,iter,resvec3] = gmres(A3,b,[],1e-12,N);
 if ~exist('psademofig2','var'), psademofig2=figure('visible','off'); end
 figure(psademofig2), clf
 semilogy([0:length(resvec1)-1],resvec1,'b-'), hold on
 semilogy([0:length(resvec2)-1],resvec2,'g-')
 semilogy([0:length(resvec3)-1],resvec3,'r-')
 legend('d=0.5', 'd=0.75', 'd=1')
 xlabel('iteration'), ylabel('residual norm')

 fprintf(' In the above situation, one observes a fixed rate of convergence\n')
 fprintf(' determined by the nonnormality.  Often, when the nonnormality is\n')
 fprintf(' less acute, one observes an initial slow convergence phase, followed\n')
 fprintf(' by more rapid convergence at an asymptotic rate determined by the\n')
 fprintf(' spectrum.  We illustrate this point with a discretized convection\n')
 fprintf(' diffusion problem, available in EigTool as "supg_demo":\n\n')
 fprintf('            A = supg_demo(12); \n')
 fprintf('            opts.ax = [-0.025 0.175 -0.1 0.1];\n')
 fprintf('            opts.levels = [-8:-2];\n');
 fprintf('            eigtool(full(A))\n\n')
 
 input('                - - -   press <return> to continue   - - - \n\n');

 A = supg_demo(12);
 clear opts
 opts.ax = [-0.025 0.175 -0.1 0.1];
 opts.levels = [-8:-2];
 eigtool(full(A),opts,psademofig1); 
 
 fprintf(' Notice that the eigenvalues are clustered away from the origin,\n')
 fprintf(' yet for small values of eps, the eps-pseudospectra are much\n')
 fprintf(' closer to the origin, indicating that there may be slow convergence.\n\n')
 fprintf(' To observe how GMRES converges for this example, we compute\n')
 fprintf(' the residual convergence curve for a random initial residual,\n') 
 fprintf(' and compare the result to GMRES applied to a normal matrix\n')
 fprintf(' with the same eigenvalues.\n\n')

 fprintf('     b = randn(144,1); \n')
 fprintf('     [x,flag,relres,iter,resvec1] = gmres(A,b,[],1e-10,144);\n')
 fprintf('     [x,flag,relres,iter,resvec2] = gmres(diag(eig(A)),b,[],1e-10,144);\n')
 fprintf('     semilogy([0:length(resvec1)-1],resvec1), hold on\n')
 fprintf('     semilogy([0:length(resvec2)-1],resvec2)\n')
 fprintf('     xlabel(''iteration''), ylabel(''residual norm'')\n\n')
 

 input('                - - -   press <return> to continue   - - - \n\n');
 
 b = randn(144,1);
 [x,flag,relres,iter,resvec1] = gmres(A,b,[],1e-10,144);
 [x,flag,relres,iter,resvec2] = gmres(diag(eig(full(A))),b,[],1e-10,144);
 figure(psademofig2), clf
 semilogy([0:length(resvec1)-1],resvec1), hold on
 semilogy([0:length(resvec2)-1],resvec2, 'r-')
 legend('non-normal', 'normal')
 xlabel('iteration'), ylabel('residual norm')

 fprintf(' As suggested, the GMRES convergence curve for the nonnormal matrix\n')
 fprintf(' exhibits a period of transient stagnation before eventually converging\n')
 fprintf(' at a similar rate to the normal matrix with the same spectrum.\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');
