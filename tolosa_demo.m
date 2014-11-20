function T = tolosa_demo(N)

%   T = TOLOSA_DEMO(N) returns Matrix Market Tolosa
%   matrix (N can be 1090 or 4000). The routine mmread.m is 
%   supplied by the Matrix Market of NIST:
%    http://math.nist.gov/MatrixMarket/
%   For more information, please see
%    http://math.nist.gov/MatrixMarket/data/NEP/mvmtls/mvmtls.html

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  if N==1090,
    T = mmread('tols1090.mtx');
  elseif N==4000,
    T = mmread('tols4000.mtx');
  else
    error('Sorry, no data for that dimension.');
  end;
