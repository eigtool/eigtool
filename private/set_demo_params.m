function [N,opts,routine] = set_demo_params(mtx_size,grid_size,the_matrix)

% function [N,opts,routine] = set_demo_params(mtx_size,grid_size,the_matrix)
%
% Function to set the demo parametersbased on the matrix and gridsize

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Set matrix size explicitly if it is supplied as a number
  if isnumeric(mtx_size),
    N = mtx_size; 
  end;

% Set grid size explicitly if it is supplied as a number
  if isnumeric(grid_size),
    opts.npts = grid_size; 
  end;

% Use thin lines if we're on a fine grid unless overridden below
  if strcmp(grid_size,'F'),
    opts.thick_lines = 0;
  end;

% Do the example-specific stuff here
switch the_matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Boeing'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'boeing';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),     % Unstable (original)
        N = 'O';
      elseif strcmp(mtx_size,'S'), % Stable (optimised)
        N = 'S';
      end;
    end;
    opts.levels = -5:.5:-2;
    opts.imag_axis = 1;
    opts.ax = [-100 70 -100 100];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Demmel'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'demmel';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 50;
        opts.ax = [-10 10 -10 10];
        opts.levels = -15:0;
      else
        N = 3;
        opts.ax = [-5 2 -4 4];
        opts.levels = -5.8:.2:-2.6;
      end;
    end;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 201;
      else
        opts.npts = 81;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Gallery3'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'gallery3';
    N = 3; % Not acutally used - matrix always has size 3
    opts.ax = [-.5 4.5 -2 2];
    opts.levels = -4:.25:-2;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 200;
      else
        opts.npts = 80;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Gallery5'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'gallery5';
    N = 5; % Not acutally used - matrix always has size 5
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 200;
      else
        opts.npts = 80;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Companion'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'companion';
    N = 10; 
    opts.levels = -6:.5:-0.5;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 200;
      else
        opts.npts = 80;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Godunov'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'godunov';
    N = 7; % Not acutally used - matrix always has size 7
    opts.ax = [-15 15 -15 15];
    opts.levels = -13:0.5:-9;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 200;
      else
        opts.npts = 80;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Frank'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'frank';
    if ~isnumeric(mtx_size),
      N = 32;
      opts.ax = [-20 140 -50 50];
      opts.levels = -10:0;
    end;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 150;
      else
        opts.npts = 60;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Kahan'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'kahan';
    if ~isnumeric(mtx_size),
      N = 30;
      opts.ax = [-1 1.5 -1 1];
      opts.levels = -6:.5:-1.5;
    end;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 150;
      else
        opts.npts = 60;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Chebspec'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'chebspec';
     if ~isnumeric(mtx_size),
      N = 20;
      opts.ax = [-10 60 -40 40];
    end;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 200;
      else
        opts.npts = 80;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ConvDiff'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'convdiff';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 100;
        opts.ax = [-200 20 -80 80];
        opts.levels = -10:0;
        opts.proj_lev = 1;
      else
        N = 40;
        opts.ax = [-40 10 -20 20];
        opts.levels = -10:0;
      end;
    end;
    opts.imag_axis = 1;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'GaussSeidel'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'gaussseidel';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),     % Upwind
        N = {40,'U'};
      elseif strcmp(mtx_size,'S'), % Downwind
        N = {40,'D'};
      elseif strcmp(mtx_size,'N'), % Classical, no wind
        N = {40,'C'};
      end;
    end;
    opts.unit_circle = 1;
    opts.levels = -11:-1;
    opts.ax = [-1 1.2 -1 1];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Grcar'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'grcar';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 100;
        opts.levels = -17:2:-1;
      else
        N = 50;
        opts.levels = -8:-1;
      end;
    end;
    opts.ax = [-1.5 3.5 -4 4];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ToeplitzPCS'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'basor';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 100;
        opts.levels = -3.5:.5:-1;
      else
        N = 50;
        opts.levels = -3:.5:-1;
      end;
    end;
    opts.ax = [-4 7 -6 3];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 60;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Random'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'random';
    if ~isnumeric(mtx_size),
      N = 50;
      opts.levels = -2:.25:-1;
    end;
    opts.ax = [-1.5 1.5 -1.5 1.5];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'RandomTri'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'randomtri';
    if ~isnumeric(mtx_size),
      N = 50;
      opts.levels = -13:-1;
    end;
    opts.ax = [-1 1 -1 1];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Riffle'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'riffle';
    if ~isnumeric(mtx_size),
      N = 52;
      opts.levels = -11:-2;
    end;
    opts.ax = [-0.5 0.7 -0.5 0.5];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Twisted'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'twisted';
    if ~isnumeric(mtx_size),
      N = 101;
      opts.levels = -13:-1;
    end;
    opts.ax = [-2.5 2.5 -2.5 2.5];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Transient'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'transient';
    if ~isnumeric(mtx_size),
      N = 30;
      opts.levels = -5:0.5:-1.5;
    end;
    opts.imag_axis = 1;
    opts.unit_circle = 1;
    opts.ax = [-1.3 0.3 -0.8 0.8];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Davies'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'davies';
    if ~isnumeric(mtx_size),
      N = 70;
      opts.ax = [0 20 0 20];
      opts.levels = -5:.5:-.5;
      opts.proj_lev = 1.5;
    end;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 60;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Anderson'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'hatano';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 200;
        opts.levels = -22:3:-1;
      else
        N = 100;
        opts.levels = -11:2:-1;
      end;
    end;
    opts.ax = [-4 4 -1.5 1.5];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 60;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Landau'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'landau';
    if ~isnumeric(mtx_size),
      if strcmp(mtx_size,'L'),
        N = 250;
        opts.levels = -4.5:.5:-1;
      else
        N = 120;
        opts.levels = -3:.25:-1;
      end;
    end;
    opts.ax = [-1.1 1.2 -1.1 1.1];
    opts.proj_lev = -100;
    opts.unit_circle = 1;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Airy'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'airy';
    if ~isnumeric(mtx_size),
      N = 120;
      opts.ax = [-2 .2 -1.2 1.2];
      opts.levels = -15:-2;
      opts.proj_lev = 0.5;
    end;
    opts.imag_axis = 1;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'OrrSommerfeld'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'orrsommerfeld';
    if ~isnumeric(mtx_size),
      N = 100;
      opts.ax = [-1 .2 -1.05 0];
      opts.levels = -7.5:.5:-2;
      opts.proj_lev = 1;
    end;
    opts.imag_axis = 1;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%
% MATRIX MARKET DEMOS
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Dwave'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'dwave';
    N = 2048;
    opts.direct = 0;
    opts.p = 60;
    opts.v0 = ones(N,1);
    opts.k = 25;
    opts.which = 'LR';
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Markov'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'markov';
    if strcmp(mtx_size,'L'),
      N = 100;
    else
      N = 30;
    end;
    opts.v0 = ones((N-1)^2/2 + 3*(N-1)/2 + 1,1);
    opts.p = 90;
    opts.k = 50;
    opts.which = 'LM';
    opts.direct = 0;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'PDE'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'pde';
    if strcmp(mtx_size,'L'),
      N = 2961;
    else
      N = 900;
    end;
    opts.v0 = ones(N,1);
    opts.p = 70;
    opts.k = 40;
    opts.which = 'LR';
    opts.direct = 0;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Olmstead'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'olmstead';
    if strcmp(mtx_size,'L'),
      N = 1000;
    else
      N = 500;
    end;
    opts.direct = 0;
    opts.p = 60;
    opts.v0 = [1; zeros(N-1,1)];
    opts.k = 20;
    opts.which = 'LR';
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'RDB'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'rdbrusselator';
    if strcmp(mtx_size,'L'),
      N = 3200;
    else
      N = 800;
    end;
    opts.direct = 0;
    opts.p = 60;
    opts.v0 = [1; zeros(N-1,1)];
    opts.k = 25;
    opts.which = 'LR';
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 120;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'SkewLap'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'skewlap3d';
    N = 20;
    opts.v0 = ones((N-1)^3,1);
    opts.p = 25;
    opts.k = 10;
    opts.which = 'LR';
    opts.direct = 0;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'SparseRand'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'sparserandom';
    if strcmp(mtx_size,'L'),
      N = 100000;
    else
      N = 30000;
    end;
    opts.v0 = ones(N,1);
    opts.p = 50;
    opts.k = 15;
    opts.which = 'LR';
    opts.direct = 0;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'SparseCD'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'convdiff_fd';
    if strcmp(mtx_size,'L'),
      N = 30;
    else
      N = 20;
    end;
    opts.v0 = ones(4*N^2,1);
    opts.p = 60;
    opts.k = 30;
    opts.which = 'SR';
    opts.direct = 0;
    opts.imag_axis = 1;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'SUPG'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'supg';
    N = 30;
    opts.v0 = ones(N^2,1);
    opts.p = 100;
    opts.k = 50;
    opts.which = 'LM';
    opts.direct = 0;
    opts.ax = [-0.01 0.07 -0.04 0.04];
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'Tolosa'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    routine = 'tolosa';
    if strcmp(mtx_size,'L'),
      N = 4000;
    else
      N = 1090;
    end;
    opts.v0 = ones(N,1);
    opts.p = 60;
    opts.k = 30;
    opts.which = 'LI';
    opts.direct = 0;
    if ~isnumeric(grid_size),
      if strcmp(grid_size,'F'),
        opts.npts = 100;
      else
        opts.npts = 50;
      end;
    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error('Undefined matrix in set_demo_params! Please contact tgw@comlab.ox.ac.uk');

end;

routine = [routine,'_demo'];


