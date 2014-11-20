function [tfig,marker_h] = draw_trans_lb(A,the_pt,fig,ps_data,bnd,data_pts)

% function [tfig,marker_h] = draw_trans_lb(A,the_pt,fig,ps_data,bnd,data_pts)
%
% Function to draw the lower bound onto the transient plot.
%
% A       The matrix to use
% the_pt  the point to base the bound upon
% fig     the EigTool figure
% bnd     (optional) the bound, if already known
%
% tfig    figure handle of transient plot
% marker_h handle to the marker for the point.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% If there's one point, draw it as a circle. If more, draw them as a
% series of dots
if size(the_pt,1)<=1,
  marker_h=plot(the_pt(1),the_pt(2), ...
           'go','markersize',12,'linewidth',5);

  sel_pt = the_pt(1)+1i*the_pt(2);
else
  marker_h = plot(the_pt(:,1),the_pt(:,2),'g.'); 
  max_bnd = max(bnd);
end;

  drawnow;

  [m,n] = size(A);
  [tfig,cax1,cax2,ftype] = find_trans_figure(fig,'A',1);
  if tfig<1, 
    return;
  else
% If the bound wasn't input as an argument, find it
    if nargin<5,
      num_its = 20;
      q = randn(n,1)+1i*randn(n,1); q = q/norm(q);
      [Ss,q] = inv_lanczos(A,q,sel_pt,1e-15,num_its);

% Now compute the correct bound based on the norm of the resolvent (1/Ss)
      if strcmp(ftype,'E'),
        alp = the_pt(1);
        R = 1/Ss;
        t_range = get(cax1,'xlim');
        t_pts = t_range(1):ps_data.transient_step:t_range(end);
        eat = exp(alp*t_pts);
        bnd = eat./(1+(eat-1)/(alp*R));
        max_bnd = max(bnd);
%        bnd = max(1,the_pt(1)/Ss);
        data_pts = t_pts;
      elseif strcmp(ftype,'P'),
        r = abs(the_pt(1)+1i*the_pt(2));
        R = 1/Ss;
        k_range = get(cax1,'xlim');
        k = k_range(1):k_range(end);
        rk = r.^k;
        bnd = rk ./ (1+(rk-1)/((r-1)*(r*R-1)));
        max_bnd = max(bnd);
%        bnd = max(1,(abs(the_pt(1)+1i*the_pt(2))-1)/Ss);
        data_pts = k;
      end;
    end;

    set(tfig,'CurrentAxes',cax1);
    set(cax1,'NextPlot','add');
    ax = axis(cax1);
    h = findobj(tfig,'Tag','lin_bnd');
    if ishandle(h), delete(h); end;
    h2 = findobj(tfig,'Tag','lin_bnd_t');
    if ishandle(h2), delete(h2); end;
    h = plot(data_pts,bnd,'g-','Parent',cax1,'linewidth',2);
    h2 = text(.8*ax(2),max_bnd+ax(4)/15,num2str(max_bnd,'%10.4g'),'parent',cax1,'fontweight','bold');
    set(h,'Tag','lin_bnd');
    set(h2,'Tag','lin_bnd_t');
    if max_bnd>ax(4),
      ax(4) = max_bnd*1.5;
      axis(cax1,ax);
    end;

% Append the new handle to the userdata
    callback_str = ['delete_et_marker(',num2str(tfig),',',num2str(fig),',1)'];
    set(h,'DeleteFcn',callback_str);

    set(tfig,'CurrentAxes',cax2);
    set(cax2,'NextPlot','add');
    ax = axis(cax2);
    hs = findobj(tfig,'Tag','log_bnd');
    if ishandle(hs), delete(hs); end;
    hs2 = findobj(tfig,'Tag','log_bnd_t');
    if ishandle(hs2), delete(hs2); end;
    hs = semilogy(data_pts,bnd,'g-','Parent',cax2,'linewidth',2);
    hs2 = text(.8*ax(2),10^(log10(max_bnd)+log(ax(4)/max_bnd)/15),num2str(max_bnd,'%10.4g'),'parent',cax2,'fontweight','bold');
    set(hs,'Tag','log_bnd');
    set(hs2,'Tag','log_bnd_t');
    if max_bnd>ax(4),
      ax(4) = max_bnd*1.5;
      axis(cax2,ax);
    end;

% Append the new handle to the userdata
    callback_str = ['delete_et_marker(',num2str(tfig),',',num2str(fig),',1)'];
    set(hs,'DeleteFcn',callback_str);
  end;
