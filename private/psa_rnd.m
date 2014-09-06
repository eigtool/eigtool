 fprintf('\n                     ROUNDING ERRORS   \n')
 fprintf('           ---------------------------------------- \n\n')

 fprintf(' Recall that the epsilon-pseudospectrum of a matrix A is defined by\n')
 fprintf(' the equivalent statements:\n\n');
 fprintf('     epsilon-psa(A) = {z: norm(inv(z*eye(n)-A)) >= 1/epsilon } \n\n')
 fprintf('                    = {z: z is an eigenvalue of A+E for\n')
 fprintf('                            some E with norm(E) <= epsilon }.\n\n')

 fprintf(' In words, the second definition says that epsilon-psa(A) consists\n')
 fprintf(' of all points in the complex plane that are eigenvalues of some\n')
 fprintf(' norm-epsilon (or smaller) perturbation of A.\n\n')
 
 fprintf(' When a matrix A is stored in floating point arithmetic on a computer,\n')
 fprintf(' rounding errors on the order of machine precision are typically made.\n')
 fprintf(' In MATLAB''s standard precision arithmetic, these are on the order of\n')
 fprintf(' 10^{-16}.  Thus we really store A+E for some E whose elements are\n') 
 fprintf(' of size 10^{-16}.  The best we can hope for is to compute numbers in\n')
 fprintf(' the epsilon-pseudospectrum -- "epsilon-pseudoeigenvalues" -- for\n')
 fprintf(' a value of epsilon on the order of machine precision.  (More\n')
 fprintf(' precisely, on the order of machine precision times norm(A).)\n\n')

 fprintf(' This is such a natural application of pseudospectra that it is easy\n')
 fprintf(' to get carried away into thinking that this is the primary, even\n')
 fprintf(' the only, application.  We emphasize that rounding error applications\n')
 fprintf(' account for only a small portion of applications of pseudospectra.\n')
 fprintf(' All other modules of this tutorial would be just the same\n')
 fprintf(' in exact arithmetic as they are in floating point!\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' For an example of rounding errors, we revisit the Grcar matrix\n')
 fprintf(' that we investigated in the introduction.  This matrix has the form\n\n')
 fprintf('              [   1     1     1     1     0     0     0  ] \n')
 fprintf('              [  -1     1     1     1     1     0     0  ] \n')
 fprintf('              [   0    -1     1     1     1     1     0  ] \n')
 fprintf('          A = [   0     0    -1     1     1     1     1  ] \n')
 fprintf('              [   0     0     0    -1     1     1     1  ] \n')
 fprintf('              [   0     0     0     0    -1     1     1  ] \n')
 fprintf('              [   0     0     0     0     0    -1     1  ] \n\n')
 fprintf(' We begin by plotting the eigenvalues of the Grcar matrix of dimension 150:\n\n')
 
 fprintf('         ew = eig(gallery(''grcar'',150));\n')
 fprintf('         plot(real(ew), imag(ew), ''k.''), hold on, axis equal\n\n');

 input('                - - -   press <return> to continue   - - - \n\n');

 ew = eig(gallery('grcar',150));
 if exist('psademofig1','var') & ishandle('psademofig1'), close(psademofig1), end;
 psademofig1=figure('visible','off'); 
 figure(psademofig1), clf
 plot(real(ew), imag(ew), 'k.'), hold on, axis equal

 fprintf(' In exact arithmetic, we should get the same results if we compute\n')
 fprintf(' the eigenvalues of the transpose of this matrix.  Let''s see what\n')
 fprintf(' we get with finite-precision arithmetic.\n\n')
 fprintf('         ew = eig(gallery(''grcar'',150)'');\n')
 fprintf('         plot(real(ew), imag(ew), ''ro'')\n\n');
 fprintf('         axis equal\n\n');
 fprintf(' The new eigenvalues will be plotted as red circles, and they should,\n')
 fprintf(' in exact arithmetic, coincide with the black dots.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 ew = eig(gallery('grcar',150)');
 plot(real(ew), imag(ew), 'ro')
 axis equal

 fprintf(' Though all the entries of A are exactly representable in IEEE floating\n')
 fprintf(' point arithmetic, rounding errors are made in the eigenvalue algorithm.\n')
 fprintf(' (The first matrix is already in upper Hessenberg form, while the second\n')
 fprintf(' matrix is not, so "eig" first reduces it to upper Hessenberg form, causing\n')
 fprintf(' rounding errors.)\n\n')

 fprintf(' How do the pseudospectra compare?  We expect the pseudospectra to be larger\n')
 fprintf(' in the area around the eigenvalues that are not in agreement.  We now perform\n')
 fprintf(' the following commands:\n\n')
 fprintf('         opts.print_plot = 1;\n')
 fprintf('         opts.ax = [-0.75 3 -3 3];\n')
 fprintf('         opts.no_ews = 1;\n')
 fprintf('         opts.levels = [-15 -11 -7 -3];\n')
 fprintf('         opts.npts   = 50;\n')
 fprintf('         eigtool(gallery(''grcar'',150)'',opts)\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');

 clear opts
 opts.ax = [-0.75 3 -3 3];
 opts.print_plot = 1;
 opts.no_ews = 1;
 opts.levels = [-15 -11 -7 -3];
 opts.npts   = 50;
 eigtool(gallery('grcar',150)',opts,psademofig1)

 fprintf(' Notice that the red circles (computed eigenvalues of the transposed Grcar\n')
 fprintf(' matrix) fall roughly on the boundary of the 10^{-15}-pseudospectrum.  This\n')
 fprintf(' is what we should expect, as MATLAB''s machine precision is on this order.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' To see another example of this same effect, go to the EigTool "Demos" menu\n')
 fprintf(' and select "Dense matrices/Frank/Compute Pseudospectra" from the cascading\n')
 fprintf(' menu options.  For this matrix, one can show that all the eigenvalues must\n')
 fprintf(' be real.  But zoom around the origin to see a ring of eigenvalues in the\n')
 fprintf(' complex plane; adjust the smallest contour level to -16 to see that these\n')
 fprintf(' eigenvalues are contained in the 10^{-16}-pseudospectrum.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');
