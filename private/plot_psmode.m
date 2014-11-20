function [pmfig,q] = plot_psmode(fig,sel_pt,A,UnitaryM,mtype,no_waitbar,approx)

% function [pmfig,q] = plot_psmode(fig,sel_pt,A,UnitaryM,mtype,no_waitbar,approx)
%
% Function to plot the pseudmode correspinding to a particular
% point in the complex plane.
%
% fig         handle to the GUI figure
% sel_pt      the point the pseudomode is centred on 
% A           the matrix
% UnitaryM    the unitary matrix which relates A to the original matrix
% mtype       'P' or 'E': a pseudomode, or an eigenmode?
% no_waitbar  Display a waitbar for eigenvector determination (0/1)?
% approx      Is the condition no. approximate (i.e. from Arnoldi?)
%
% pmfig       the figure number of the allocated figure
% q           the pseudomode (2-norm normalised)

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Set this argument if necessary
    if nargin<6, no_waitbar = 0; end;

    [m,n] = size(A);

% Do we have an eigenmode or a pseudomode?
    if strcmp(mtype,'P'),
      title_str = 'pseudo';
      num_its = 20;
      q = randn(n,1)+1i*randn(n,1); q = q/norm(q);
      [Ss,q] = inv_lanczos(A,q,sel_pt,1e-15,num_its);
      the_col = 'm';
    elseif strcmp(mtype,'E'),
      title_str = 'eigen';
      [Ss,q] = oneeigcond(A,sel_pt,no_waitbar);
      the_cond = Ss;
      the_col = 'c';
    end;
% If iterations failed to converge and the user didn't want to use an SVD
    if isnan(Ss) | isnan(q),
      pmfig = -1;
      return;
    end;

% Get a plot to put the results in
    pmfig = find_plot_figure(fig,mtype);
    set(0,'CurrentFigure',pmfig);

% Transform the vector to take account of the Schur decomposition performed
% at the start of the GUI.
    q = UnitaryM*q;

% Use the specific x values if they are defined in the base workspace,
% or otherwise just use the index number
    x = evalin('base','psmode_x_points_','1:length(q)');

% Plot the results
    subplot(2,1,1); hold off; plot(x,real(q),the_col); hold on; 
                    plot(x,abs(q),'k'); plot(x,-abs(q),'k');
    full_title_str = ['Absolute value (black) and real part (coloured) of ',title_str, ...
                     'mode: \lambda=',num2str(sel_pt)];
    title(full_title_str);
% Set the correct axis limits
    set(gca,'xlim',x([1 end]));

% Add the value of the resolvent norm
    if approx,
      the_rel = '\approx';
    else
      the_rel = '=';
    end;
    if strcmp(mtype,'P'),
      the_str = ['\epsilon = ',num2str(Ss(end),'%15.2e')];
    else
      the_str = ['\kappa(\lambda) ',the_rel,' ',num2str(the_cond,'%15.2e')];
    end;
    ax = axis;
    the_d = diff(ax);
    l = ax(1);
    t = ax(3);
    text(l+the_d(1)/40,t+the_d(3)/10,the_str,'fontsize',12,'fontweight','bold');

% Plot the absolute value on a log scale in the second plot
    if sum(abs(diff(q)))/length(q)<10*eps, 
      warning('y-axis limits are too small to create a log plot.');
      subplot(2,1,2); cla;
    else % Otherwise, make sure they're on a log scale
      subplot(2,1,2); cla; hold on; semilogy(x,abs(q),'k'); hold on;
      set(gca,'xlim',x([1 end]));
      set(gca,'YScale','log');
    end;

% Bring the current graphic window to the front
    shg;


