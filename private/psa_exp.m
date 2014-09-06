 fprintf('\n        CONTINUOUS TIME STABILITY: MATRIX EXPONENTIAL \n')
 fprintf('      ----------------------------------------------------- \n\n')
 fprintf(' Suppose we are solving the linear system of ordinary differential\n')
 fprintf(' equations\n\n')
 fprintf('                     x''(t)  =  A x(t)\n\n')
 fprintf(' given the initial state x(0).  The solution to this equation\n')
 fprintf(' can be written as\n')
 fprintf('                     x(t)  =  exp(t*A) x(0),\n\n')
 fprintf(' where "exp(t*A)" is the matrix exponential ("expm" in MATLAB).\n\n')

 fprintf(' The matrix A is said to be STABLE if all its eigenvalues have\n')
 fprintf(' negative real part.  For stable matrices, we have\n\n')
 fprintf('               norm(exp(t*A)) -> 0   as t -> infinity\n\n')
 fprintf(' and the asymptotic rate of this decay is determined by the\n')
 fprintf(' real part of the rightmost eigenvalue in the complex plane.\n\n')

 fprintf(' An important application of these ideas arises when studying\n')
 fprintf(' the stability of steady state solutions to nonlinear differential\n')
 fprintf(' equations, where the matrix A results from a linearization about\n')
 fprintf(' a steady state.  (For example, we might analyze flow of water\n')
 fprintf(' in a pipe by linearizing about the steady state known as the\n')
 fprintf(' laminar solution.)  The linearization is valid on small time\n')
 fprintf(' scales, while the eigenvalue stability result holds for\n')
 fprintf(' asymptotically large time scales.  When A is nonnormal, there\n')
 fprintf(' may be transient growth in exp(t*A) before the eventual decay,\n')
 fprintf(' and the mismatch between the time scales of linearization and\n')
 fprintf(' convergence may lead to incorrect predictions about the stability\n')
 fprintf(' of the original nonlinear equation.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fprintf(' The measure of the asymptotic convergence rate of exp(t*A) is the\n')
 fprintf(' SPECTRAL ABSCISSA, the real part of the rightmost eigenvalue of A.\n')
 fprintf(' To illustrate the potential for transient growth in exp(t*A), we\n')
 fprintf(' investigate three matrices, all with the same spectral abscissa,\n')
 fprintf(' but with dramatically different pseudospectra and exp(t*A).\n\n')

 fprintf(' All three examples have spectral abscissa equal to -1.  The first\n')
 fprintf(' is a normal matrix, A = -I:\n\n')

 fprintf('                 [ -1   0   0   0   0 ] \n')
 fprintf('                 [  0  -1   0   0   0 ] \n')
 fprintf('           A1 =  [  0   0  -1   0   0 ] \n')
 fprintf('                 [  0   0   0  -1   0 ] \n')
 fprintf('                 [  0   0   0   0  -1 ] \n\n')

 fprintf(' The epsilon-pseudospectrum of this matrix is the epsilon ball\n')
 fprintf(' centered at the single eigenvalue -1.  For comparison with our\n')
 fprintf(' next examples, we plot these pseudospectra:\n\n')

 fprintf('       N = 64;\n')
 fprintf('       A1 = -eye(N);\n')
 fprintf('       opts.imag_axis = 1;\n')
 fprintf('       opts.ax = [-3 2 -2.5 2.5];\n')
 fprintf('       opts.levels = [0 -1 -2];\n')
 fprintf('       eigtool(A1,opts)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 clear opts
 if ~exist('psademofig1','var'), psademofig1=figure('visible','off'); end
 N = 64;
 A1 = -eye(N);
 opts.ax = [-3 2 -2.5 2.5];
 opts.imag_axis = 1;
 opts.levels = [-10:0];
 eigtool(A1,opts,psademofig1)

 fprintf(' Since A1 is a normal matrix with spectral abscissa = -1,\n\n')
 fprintf('               norm(exp(t*A1)) = exp(-t);\n\n')
 fprintf(' there will be no transient growth, and convergence will occur at\n')
 fprintf(' a consistent, fixed rate.\n\n')

 fprintf('       t = linspace(0,10,30);\n') 
 fprintf('       figure(2), clf\n') 
 fprintf('       for j=1:length(t), normexptA(j) = norm(expm(A1*t(j))); end\n')
 fprintf('       semilogy(t,normexptA, ''b-''), hold on\n\n') 

 input('                - - -   press <return> to continue   - - - \n\n');

 clear normexptA
 t = linspace(0,10,30);
 if ~exist('psademofig2','var'), psademofig2=figure('visible','off'); end
 figure(psademofig2), clf
 for j=1:length(t), normexptA(j) = norm(expm(A1*t(j))); end
 semilogy(t,normexptA, 'b-'), hold on

 fprintf(' Our second example is the matrix with -1 in every entry on or above\n')
 fprintf(' the main diagonal,\n\n')

 fprintf('                 [ -1  -1  -1  -1  -1 ] \n')
 fprintf('                 [  0  -1  -1  -1  -1 ] \n')
 fprintf('           A2 =  [  0   0  -1  -1  -1 ] \n')
 fprintf('                 [  0   0   0  -1  -1 ] \n')
 fprintf('                 [  0   0   0   0  -1 ] \n\n')

 fprintf(' In contrast to the previous example, this matrix is terribly far\n')
 fprintf(' from normality, as revealed by a plot of its pseudospectra:\n\n')

 fprintf('       A2 = -triu(ones(N));\n')
 fprintf('       eigtool(A2,opts)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 A2 = -triu(ones(N));
 eigtool(A2,opts,psademofig1)

 fprintf(' As the dimension N gets larger and larger, this matrix acts\n')
 fprintf(' as if its spectrum were the entire halfplane { real(z) < -1/2 }.\n')
 fprintf(' Thus, it behaves as if its spectral radius were -1/2, rather\n')
 fprintf(' than -1.  To back up this claim, we plot norm(exp(t*A2)):\n\n')

 fprintf('       for j=1:length(t), normexptA(j) = norm(expm(A2*t(j))); end\n')
 fprintf('       semilogy(t,normexptA, ''g-'')\n')
 fprintf('       legend(''A1=-eye(N)'', ''A2=-triu(ones(N))'')\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 figure(psademofig2)
 for j=1:length(t), normexptA(j) = norm(expm(A2*t(j))); end
 semilogy(t,normexptA, 'g-')
 legend('A1=-eye(N)', 'A2=-triu(ones(N))')

 fprintf(' As expected, the matrix still converges (for modest values of\n')
 fprintf(' epsilon, the epsilon-pseudospectra are still contained in the\n')
 fprintf(' left half plane), but the rate is slowed, so that on this\n')
 fprintf(' time scale, a good approximation is:\n\n')
 fprintf('           norm(exp(t*A2)) behaves like exp(-t/2)\n\n')
 fprintf(' Of course, asymptotically, the slope of this line must improve\n')
 fprintf(' to that observed for A1, but this is not observed on the time\n')
 fprintf(' scale shown.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' Our final example is a simple modification of the last one.\n') 
 fprintf(' Now all entries above the diagonal are +1 rather than -1:\n\n')

 fprintf('                 [ -1  +1  +1  +1  +1 ] \n')
 fprintf('                 [  0  -1  +1  +1  +1 ] \n')
 fprintf('           A3 =  [  0   0  -1  +1  +1 ] \n')
 fprintf('                 [  0   0   0  -1  +1 ] \n')
 fprintf('                 [  0   0   0   0  -1 ] \n\n')

 fprintf(' This change makes all the difference:  now the pseudospectra\n') 
 fprintf(' fall far into the right half plane, as observed in the following\n')
 fprintf(' EigTool plot.\n\n')

 fprintf('       A3 = -eye(N)+triu(ones(N),1);\n')
 fprintf('       eigtool(A3,opts)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 A3 = -eye(N)+triu(ones(N),1);
 eigtool(A3,opts,psademofig1)

 fprintf(' Now as the dimension N gets larger and larger, this matrix acts\n')
 fprintf(' as if its spectrum were the entire halfplane { real(z) > -3/2 }.\n')
 fprintf(' Even for epsilon = 10^{-10}, the epsilon-pseudospectrum contains\n')
 fprintf(' points z with real(z) > 1.  Thus, we expect transient growth\n')
 fprintf(' in exp(t*A3), as seen in the following computation:\n\n') 

 fprintf('    for j=1:length(t), normexptA(j) = norm(expm(A3*t(j))); end\n')
 fprintf('    semilogy(t,normexptA, ''r-'')\n')
 fprintf('    legend(''A1=-eye(N)'', ''A2=-triu(ones(N))'', ''A3=-eye(N)+triu(ones(N),1)'',2)\n\n') 
 input('                - - -   press <return> to continue   - - - \n\n');

 figure(psademofig2)
 for j=1:length(t), normexptA(j) = norm(expm(A3*t(j))); end
 semilogy(t,normexptA, 'r-')
% axis([0 10 1e-5 1e5])
 legend('A1=-eye(N)', 'A2=-triu(ones(N))', 'A3=-eye(N)+triu(ones(N),1)',2)

 fprintf(' This "stable" matrix behaves nothing like stably:  norm(exp(t*A))\n')
 fprintf(' grows by nearly 15 orders of magnitude on this time scale!\n')
 fprintf(' We are guaranteed that it must eventually decay, but this\n')
 fprintf(' mathematical fact will likely be irrelevant to any physical\n')
 fprintf(' system governed by this matrix.\n\n');

 input('                - - -   press <return> to continue   - - - \n\n');
