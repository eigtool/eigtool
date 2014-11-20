function M = olmstead_demo(N)

%   M = OLMSTEAD_DEMO(N) returns Matrix Market Olmstead
%   matrix (N can be 500 or 1000). The routine mmread.m is 
%   supplied by the Matrix Market of NIST:
%    http://math.nist.gov/MatrixMarket/
%   For more information, please see
%    http://math.nist.gov/MatrixMarket/data/NEP/olmstead/olmstead.html

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  if N==500,
    M = mmread('olm500.mtx');
  elseif N==1000,
    M = mmread('olm1000.mtx');
  else
    error('Sorry, no data for that dimension.');
  end;
