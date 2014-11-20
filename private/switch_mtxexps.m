function ps_data = switch_mtxexps(fig,cax,this_ver,ps_data)

% function ps_data = switch_mtxexps(fig,cax,this_ver,ps_data)
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

    if isfield(ps_data,'transient_step'),
      default_val = num2str(ps_data.transient_step);
    else
      default_val = num2str(0.1);
    end;

    cont = 1;

    while cont==1,
% Get the time step to use
      s = inputdlg({['Please enter the time step to use for the ' ...
                     'transient computation (smaller = slower and ' ...
                     'more refined)']}, ...
                     'Transient time step...', 1,{default_val});
      if isempty(s), % If cancel chosen, close the figure and leave
        enable_controls(fig,ps_data);
        return;
      elseif isempty(s{1}), % If left blank, default to 0.1
        dt = 0.1;
        cont = 0;
      else
        dt = str2num(s{1});
        if length(dt)~=1 | isempty(dt) | ~isnumeric(dt) | ~isreal(dt) | dt<=0,
          h = errordlg('The time step must be a positive number','Error...','modal');
          waitfor(h);
        else
          cont = 0;
        end;
      end;

    end;

% Save the stepsize
  ps_data.transient_step=dt;

% Create the figure with a stop button
  [tfig,cax1,cax2] = find_trans_figure(fig,'E');

  A = ps_data.input_matrix;
  eAdt = expm(dt*A);

% Variables to hold the time & behaviour data
  trans = zeros(10000,1);
  the_time = trans;

% Initialise the first bit 
  trans(1) = 1;
  the_time(1) = 0;
  ax = [0 20*dt 0 2];
  ax2 = ax; ax2(3) = 1e-2;
  pos = 2;
  eAt = eye(size(A));
  max_tp = -inf;
  min_tp = inf;

  ax_factor = 3;

% Compute the spectral abscissa
  alp = max(real(ps_data.ews));

% Loop until asked to stop
  while stop_trans==0,
    eAt = eAt*eAdt;
    trans(pos) = norm(eAt);
    the_time(pos) = (pos-1)*dt;

% Keep the maximum for computing the plotting axes
    max_tp = max(max_tp,trans(pos));
    min_tp = min(min_tp,trans(pos));

% Plot the data
    set(cax1,'NextPlot','ReplaceChildren');
    plot(the_time(1:pos),trans(1:pos),'.-','Parent',cax1);
    grid(cax1,'on');
    set(cax1,'NextPlot','Add');
    plot(the_time(1:pos),exp(the_time(1:pos)*alp),'k--','Parent',cax1);

    set(cax2,'NextPlot','ReplaceChildren');
    semilogy(the_time(1:pos),trans(1:pos),'.-','Parent',cax2);
    grid(cax2,'on');
    set(cax2,'NextPlot','Add');
    semilogy(the_time(1:pos),exp(the_time(1:pos)*alp),'k--','Parent',cax2);

% Sort the axes out so they're not constantly changing
    if the_time(pos)>ax(2)*0.9,
      ax(2) = ax_factor*ax(2);
      ax2(2) = ax_factor*ax2(2);
    end;
    if max_tp>ax(4)*0.9,
      ax(4) = max(max_tp*1.5,ax_factor*ax(4));
    end;
    if (log10(min_tp)-log10(ax2(3)))/(log10(ax2(4))-log10(ax2(3)))<0.1
      ax2(3) = ax2(3)^ax_factor;
    end;
    if max_tp>ax2(4)*0.9,
      ax2(4) = ax2(4)^ax_factor;
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
    if max_tp>1e130 | min_tp<1e-130,
      cb = get(findobj(tfig,'Tag','Stop!'),'Callback');
      eval(cb);
      h = warndlg('Computation stopped due to numbers going out of range','Out of range','modal');
      waitfor(h);
    end;

    pos = pos+1;    
  end;

% Enable the right controls (to be sure that Lower bound is enabled correctly)
  enable_controls(fig,ps_data);
