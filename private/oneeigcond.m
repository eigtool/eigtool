function [the_cond,rev,lev] = oneeigcond(T,ew,no_waitbar)

% function [the_cond,rev,lev] = oneeigcond(T,ew,no_waitbar)
%
% Function to compute a condition number of the specified eigenvalue
% using inverse iteration to find the eigenvectors. The algorithm is
% much more efficient (O(N^2)) if the input matrix is triangular (for
% example created by schur(.) followed by rsf2csf) or Hessenberg. If
% inverse iteration fails, the user is asked whether they'd like to
% do a full (dense) SVD.
%
% T           The input matrix
% ew          The eigenvalue whose condition number we wish to compute
% no_waitbar  Set to 1 to avoid drawing a waitbar
%
% the_cond    The condition number
% rev         The right eigenvector
% lev         The left eigenvector

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Some general setup stuff
[n,m] = size(T);
if n~=m, errordlg('Input matrix must be square.','Error...','modal'); end;

%% Setup stuff in case inverse iteration cannot find the eigenvector
opts.CreateMode = 'modal';
opts.Default = 'Yes';
opts.Interpreter = 'none';
quest_str = ['The eigenvector could not be determined using inverse iteration.' ...
             ' Do you want to do a full (dense) SVD instead (this could be slow)?'];

%% Turn warnings off while we do this - lots of 
%% messages about matrix being near-singular 
%% (which is, after all, the whole point)
warn_status = warning;
warning('off');

% Tolerance for inv-it
tol = 1e-14;

% Perturb the eigenvalue to prevent exactly singular system
ew = ew*(1+eps);

%% Subtract ew*eye off
T(1:n+1:end) = T(1:n+1:end)-ew;

%% For small matrices, just use the SVD
if n<200,

  [U,S,V] = svd(full(T));
  rev = V(:,end);
  lev = conj(U(:,end));

else  % use inverse iteration

  if issparse(T), [L,U,P] = lu(T); end;

  wb_size=200;
  if n>wb_size & no_waitbar~=1,
    hbar = waitbar(0,'Computing eigenvalue condition number...');
  end;

  initial_guess = randn(n,1);
  initial_guess = initial_guess/norm(initial_guess);

%% Indicator to show if ev couldn't be determined from inv-it.
  infs_found = 0;

%% Inverse iteration to find right eigenvector
  rev = initial_guess;

  max_its = 3;

%% Maximum max_its iterations
  for i=1:max_its,

    oldev = rev;
    if issparse(T),
      rev = U \ (L \ (P*rev));
    else
      rev = T \ rev;
    end;
 
%% If the ew approx is such that we get an exactly singular system
    if any(isinf(rev)),
      infs_found = 1;
      break;
    end;

    lam = oldev'*rev;
    resid = norm(rev-lam*oldev)/abs(lam);
    if resid<tol, rev=rev/norm(rev); break; end;
    rev = rev/norm(rev);

%% Leave early if possible
%    if norm(rev-oldev,inf)<1e-15, break; end;

    if n>wb_size & no_waitbar~=1,
      waitbar(0.5*(i/max_its),hbar);
    end;

  end;

%% If we found the right ev without any problems
  if ~(infs_found | resid>tol),

%% Now do the same for the left eigenvector
    lev = initial_guess;

    if n>wb_size & no_waitbar~=1,
      waitbar(0.5,hbar);
    end;

% We only need the transpose of these matrices now
    if issparse(T),
      L = L.'; U = U.';
    end;

%% Maximum max_its iterations
    for i=1:max_its,
 
      oldev = lev;
      if issparse(T),
        lev = P.'*(L\(U\lev));  % Note transpose of L & U done above 
      else
        lev = (T.') \ lev;
      end;

%% If the ew approx is such that we get an exactly singular system
      if any(isinf(lev)),
        infs_found = 1;
        break;
      end;

      lam = oldev'*lev;
      resid = norm(lev-lam*oldev)/abs(lam);
      if resid<tol, lev=lev/norm(lev); break; end;

      lev = lev/norm(lev);

%% Leave early if possible
%      if norm(lev-oldev,inf)<1e-15, break; end;

      if n>wb_size & no_waitbar~=1,
        waitbar(0.5*(1+i/max_its),hbar);
      end;

    end;

  end;

% If we failed to find either lev or rev, ask user if it's OK to use
% a full SVD
  if infs_found | resid>tol,
    button = questdlg(quest_str,'Compute using full SVD?','Yes','No',opts);
    switch button
    case 'Yes' % Do the SVD
      [U,S,V] = svd(full(T));
      rev = V(:,end);
      lev = conj(U(:,end));
    case 'No'  % Return error
      rev = NaN;
      lev = NaN;
    end; 
  end;

  if n>wb_size & no_waitbar~=1,
    close(hbar);
  end;

end;

%% Calculate the condition number
the_cond = abs(1/(lev.'*rev));

%% Revert the warning status
warning(warn_status);



