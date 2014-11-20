% Script to get the Hessenberg matrix from eigs variables
% and store it in variable H, and the orthogonal matrix V
% and store it in thev

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Extract the upper Hessenberg matrix created by ARPACK
%% from the workl array
  H=zeros(p);
  ih=double(ipntr(5));
  if isrealprob,
    if issymA,
      H=diag(workl(ih+1:ih-1+p),1) + ...
        diag(workl(ih+p:ih-1+2*p),0) + ...
        diag(workl(ih+1:ih-1+p),-1);
    else
      H(:) = workl(ih:ih-1+p^2);
    end;
  else

%% Slightly trickier for the complex case - stored in workl as interleaved
%% data [real(1) imag(1) real(2) imag(2) ... ]
     H(:) = complex(workl(ih:2:ih-1+2*p^2), ...
                    workl(ih+1:2:ih-1+2*p^2));
  end

%% These might not exist if we're calling this script DURING eigs
%% computation
  if ~exist('gui_v','var') & exist('v','var'), gui_v = v; end;
  if ~exist('gui_zv','var') & exist('zv','var'), gui_zv = zv; end;

%% Calculate the value of the last entry in the matrix H
%% (not returned by ARPACK)
    if isrealprob,
%% THIS DOESN'T DUPLICATE v AS LONG AS NEITHER v NOR thev
%% ARE MODIFIED
      thev = gui_v;
    else

%% MEMORY EFFICIENT WAY OF MOVING DATA FROM zv TO A COMPLEX MATLAB
%% MATRIX OF THE CORRECT SIZE
      thev = [];
      for i = 1:p,
        thev = [thev reshape(complex(gui_zv(1:2:2*n), ...
                                     gui_zv(2:2:2*n)),n,1)];
        gui_zv = gui_zv(2*n+1:end);
      end;
    end;

% If we have a real, symmetric problem, we can get the value we need
% without recomputing it
  if isrealprob & issymA,
    beta = workl(ih);
  else
    if Amatrix==1, w = A * thev(:,end);
    else w = feval(A,thev(:,end),varargin{7-Amatrix-Bnotthere:end}); end;
    h = (w'*thev)';
    mtxprod = w-thev*h;
    beta = norm(mtxprod);
  end;

%% Turn the matrix into a rectangular Hessenberg matrix
  H = [H; zeros(1,p-1) beta];

%% Clear these variables so that if this is called in a loop, everything
%% will still be working next time round
  clear gui_v gui_zv
