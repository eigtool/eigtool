function psademo

%PSADEMO - Start the Pseudospectra Tutorial
%   PSADEMO runs the script, presenting a menu that allows
%   the user to select one of the tutorials, which span
%   several application areas:
%
%    1 Introduction to pseudospectra
%    2 Discrete time stability
%    3 Continuous time stability
%    4 Convergence of matrix iterations (GMRES/etc. convergence)
%    5 Rounding errors (ill-conditioned eigenvalue computations)
%
%   See also: EIGTOOL

 choice = -1;

 while choice~=0 
    fprintf('\n      1. INTRODUCTION TO PSEUDOSPECTRA \n')
    fprintf('      2. DISCRETE TIME STABILITY (transient growth for A^k) \n')
    fprintf('      3. CONTINUOUS TIME STABILITY (transient growth for exp(t*A)) \n')
    fprintf('      4. CONVERGENCE OF MATRIX ITERATIONS (GMRES/etc. convergence) \n')
    fprintf('      5. ROUNDING ERRORS (ill-conditioned eigenvalue computations)\n')
    fprintf('      0. exit \n\n');

    fprintf('              select a menu option> ')
    choice = floor(str2num(input('','s'))); 
    while (length(choice) == 0) | (choice<0) | (choice>5)
       fprintf('              select a menu option> ')
       choice = floor(str2num(input('','s'))); 
    end
    if isnumeric(choice)
       switch choice 
          case 1, eval('psa_intro');
          case 2, eval('psa_pow');
          case 3, eval('psa_exp');
          case 4, eval('psa_kry');
          case 5, eval('psa_rnd');
       end
    end
 end 
