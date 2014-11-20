function ps_data = switch_mtxpowers(fig,cax,this_ver,ps_data)

% function ps_data = switch_mtxpowers(fig,cax,this_ver,ps_data)
%
% Function called when the 'Matrix Posers' menu option
% is chosen

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

  disable_controls(fig);

% Initialise the stopping variable
  global stop_trans
  stop_trans = 0;

% Set the stepsize
  sp_step = 1;

% Create the figure with a stop button
  [tfig,cax1,cax2] = find_trans_figure(fig,'P');

  A = ps_data.input_matrix^sp_step;

% Variables to hold the time & behaviour data
  trans = zeros(10000,1);
  the_pwr = trans;

% Initialise the first bit 
  trans(1) = 1;
  the_pwr(1) = 0;
  ax = [0 20 0 1.5];
  ax2 = ax; ax2(3) = 1e-2;
  pos = 2;
  mtx = eye(size(A));
  max_tp = -inf;
  min_tp = inf;

  ax_factor = 3;

% Compute the spectral radius
  alp = max(abs(ps_data.ews));

% Loop until asked to stop
  while stop_trans==0,
    mtx = A*mtx;
    trans(pos) = norm(mtx);
    the_pwr(pos) = sp_step*(pos-1);

% Keep the maximum for computing the plotting axes
    max_tp = max(max_tp,trans(pos));
    min_tp = min(min_tp,trans(pos));

% Plot the data
    set(cax1,'NextPlot','ReplaceChildren');
    plot(the_pwr(1:pos),trans(1:pos),'.-','Parent',cax1);
    grid(cax1,'on');
    set(cax1,'NextPlot','Add');
    plot(the_pwr(1:pos),alp.^the_pwr(1:pos),'k--','Parent',cax1);

    set(cax2,'NextPlot','ReplaceChildren');
    semilogy(the_pwr(1:pos),trans(1:pos),'.-','Parent',cax2);
    grid(cax2,'on');
    set(cax2,'NextPlot','Add');
    semilogy(the_pwr(1:pos),alp.^the_pwr(1:pos),'k--','Parent',cax2);

% Sort the axes out so they're not constantly changing
    if the_pwr(pos)>ax(2)*0.9,
      ax(2) = ax_factor*ax(2);
      ax2(2) = ax_factor*ax2(2);
    end;
    if max_tp>ax(4)*0.9,
      ax(4) = max(max_tp*1.5,ax_factor*ax(4));
    end;
    if max_tp>ax2(4)*0.9,
      ax2(4) = ax2(4)^ax_factor;
    end;
    if (log10(min_tp)-log10(ax2(3)))/(log10(ax2(4))-log10(ax2(3)))<0.1
      ax2(3) = ax2(3)^ax_factor;
    end;

    set(cax2,'xlim',ax2(1:2));
    set(cax1,'xlim',ax(1:2));
    set(cax2,'ylim',ax2(3:4));
    set(cax1,'ylim',ax(3:4));

    yspan = log10(ax2(4))-log10(ax2(3));
    step = max(1,floor(yspan/3));
    ticks = floor(log10(ax2(4))):-step:log10(ax2(3));
    set(cax2,'ytick',sort(10.^ticks));
    drawnow;

% Stop the computation if the numbers get too large or too small
    if max_tp>1e130 | (min_tp<1e-130 & min_tp~=0),
      cb = get(findobj(tfig,'Tag','Stop!'),'Callback');
      eval(cb);
      h = warndlg('Computation stopped due to numbers going out of range','Out of range','modal');
      waitfor(h);
    elseif min_tp==0,
      cb = get(findobj(tfig,'Tag','Stop!'),'Callback');
      eval(cb);
      h = warndlg('Computation stopped due to exactly zero matrix','Zero matrix found','modal');
      waitfor(h);
    end;

    pos = pos+1;    
  end;

% Enable the right controls (to be sure that Lower bound is enabled correctly)
  enable_controls(fig,ps_data);
