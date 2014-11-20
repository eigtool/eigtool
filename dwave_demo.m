function M = dwave_demo(N)

%   M = DWAVE_DEMO(N) returns Matrix Market dielectric channel
%   waveguide problem matrix (N can only be 2048). The routine 
%   mmread.m is supplied by the Matrix Market of NIST:
%    http://math.nist.gov/MatrixMarket/
%   For more information, please see
%    http://math.nist.gov/MatrixMarket/data/NEP/dwave/dwave.html

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  if N==2048,
    M = mmread('dw2048.mtx');
  else
    error('Sorry, no data for that dimension.');
  end;
