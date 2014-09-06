function M = pde_demo(N)

%   M = PDE_DEMO(N) returns Matrix Market PDE
%   matrix (N can be 900 or 2961). The routine mmread.m is 
%   supplied by the Matrix Market of NIST:
%    http://math.nist.gov/MatrixMarket/
%   For more information, please see
%    http://math.nist.gov/MatrixMarket/data/NEP/matpde/matpde.html

% Version 2.3 (Sat Sep  6 16:27:02 EDT 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

  if N==900,
    M = mmread('pde900.mtx');
  elseif N==2961,
    M = mmread('pde2961.mtx');
  else
    error('Sorry, no data for that dimension.');
  end;
