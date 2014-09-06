 fprintf('\n                 INTRODUCTION TO PSEUDOSPECTRA\n')
 fprintf('            --------------------------------------- \n\n')

 fprintf(' Eigenvalue analysis for nonsymmetric matrices can often yield\n')
 fprintf(' misleading results:  Expected decay rates might not materialize\n')
 fprintf(' in practice; matrix powers or exponentials exp(t*A) might exhibit\n')
 fprintf(' transient growth despite eigenvalue stability of the underlying matrix.\n')
 fprintf(' In this tutorial, we introduce the generalized notion of eigenvalues\n')
 fprintf(' called PSEUDOSPECTRA, show how to compute these sets in the complex\n')
 fprintf(' plane in MATLAB, and indicate how to interpret the results for \n')
 fprintf(' several classes of applications.\n\n')

 fprintf(' The epsilon-pseudospectrum of a matrix A, abbreviated here\n') 
 fprintf(' epsilon-psa(A), is defined by the following equivalent statements:\n\n')
 fprintf('     epsilon-psa(A) = {z: norm(inv(z*eye(n)-A)) >= 1/epsilon } \n\n')
 fprintf('                    = {z: z is an eigenvalue of A+E for\n')
 fprintf('                            some E with norm(E) <= epsilon }.\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

 fprintf(' If A is symmetric, then a perturbation E of norm epsilon cannot move\n')
 fprintf(' the eigenvalues of A by a distance greater than epsilon; epsilon-psa(A)\n')
 fprintf(' consists of disks of radius epsilon centered at each eigenvalue.  But for\n')
 fprintf(' many nonsymmetric problems, small perturbations can move the eigenvalues\n')
 fprintf(' dramatically.  This has a variety of implications explored below.\n\n')
 
 fprintf(' When dealing with nonsymmetric problems, it is always helpful to\n')
 fprintf(' check the pseudospectra to see if one should be concerned about the\n')
 fprintf(' physical significance of eigenvalues.  This can be done very simply\n')
 fprintf(' using the EIGTOOL command in MATLAB.\n\n') 

 fprintf(' We begin with a well-known example, the "Grcar matrix" that is built-in to\n')
 fprintf(' MATLAB.  We execute the following commands:\n\n')

 fprintf('       A = gallery(''grcar'',64);\n')
 fprintf('       eigtool(A)\n\n')

 input('                - - -   press <return> to continue   - - - \n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 psademofig1 = figure('visible','off');
 A = gallery('grcar',64);
 eigtool(A,psademofig1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fprintf(' EIGTOOL has computed the eigenvalues of A, shown in the plot as\n')
 fprintf(' black dots.  Along with those black dots, the plot shows\n')
 fprintf(' boundaries of epsilon-psa(A) for various values of epsilon.  The\n')
 fprintf(' color bar on the right indicates the value of epsilon on a logarithmic\n')
 fprintf(' scale.  From this plot, one can tell that perturbations of norm 0.1\n')
 fprintf(' can move the eigenvalues of A anywhere within the outermost orange\n')
 fprintf(' curve (labelled "-1" on the color bar), while perturbations of norm\n')
 fprintf(' 1e-9 can move eigenvalues anywhere within in the innermost blue curve\n')
 fprintf(' (labelled "-9").  (In addition to the blue curves visible, there\n')
 fprintf(' are also, in principle, additional little blue regions around each of\n')
 fprintf(' the other eigenvalues, so small that they are hidden "under the dots".)\n\n')

 fprintf(' Take a moment to adjust the controls in the EIGTOOL window:  Increase\n')
 fprintf(' the "Grid Size" on the right to obtain a plot with higher resolution,\n')
 fprintf(' or use the left mouse button to zoom in on a part of the spectrum.\n')
 fprintf(' (After making such changes click on the green "Go!" button to re-compute\n')
 fprintf(' the pseudospectra.)  Press the button to compute the Field of Values,\n')
 fprintf(' or explore the special features in the Extras menu like Display\n')
 fprintf(' Grid points or Display Imaginary Axis.\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fprintf(' It is interesting to compare how these pseudospectra compare with some\n')
 fprintf(' sets of eigenvalues eig(A+E) for randomly chosen E.  First, we will replace\n')
 fprintf(' the current plot with a plot showing only the pseudospectrum for epsilon=0.1.\n')
 fprintf(' (In practice, one wouldn''t regenerate the same data all over again, but\n')
 fprintf(' we do so here for ease of presentation.)\n\n')
 fprintf('       opts.levels = -1;\n')
 fprintf('       opts.npts   = 60;\n')
 fprintf('       opts.no_ews =  1;\n')
 fprintf('       eigtool(A,opts)\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');

 clear opts
 opts.levels = -1;
 opts.npts   = 60;
 opts.no_ews =  1;
 eigtool(A,opts,psademofig1);

 fprintf(' Now we will generate twenty random perturbations E and superimpose the\n')
 fprintf(' the eigenvalues of A+E over the pseudospectral plot.  We know that\n')
 fprintf(' all these eigenvalues must fall within the orange curve.\n\n')
 fprintf('       for j=1:20\n')
 fprintf('          E = randn(64)+1i*randn(64); E = .1*E/norm(E);\n')
 fprintf('          ew = eig(A+E); plot(real(ew),imag(ew),''k.'');\n')
 fprintf('       end\n\n')
 input('                - - -   press <return> to continue   - - - \n\n');

 for j=1:20
    E = randn(64)+1i*randn(64); E = .1*E/norm(E);
    ew = eig(A+E); plot(real(ew),imag(ew),'k.');
 end

 fprintf(' To learn more about pseudospectra, select one of the\n')
 fprintf(' following menu options.  Much more information, including\n')
 fprintf(' list of scientific applications and links to the literature,\n')
 fprintf(' can be found by selecting "Pseudospectra Gateway" in\n')
 fprintf(' EIGTOOL''s Help menu.\n')
