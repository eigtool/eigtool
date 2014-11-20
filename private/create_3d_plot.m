function create_3d_plot(fig)

% function create_3d_plot(fig)
%
% Function to create a 3d plot from the current pseudospectra
% data. Also called when the plot options are changed using
% the menu in a 3D plot figure.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Make sure the current figure is active
    figure(fig);

% Get the data to create the plot
    plot_data = get(fig,'UserData');
    x = plot_data.x;
    y = plot_data.y;
    Z = plot_data.Z;
    ews = plot_data.ews;
    xline_freq = plot_data.xline_freq;
    yline_freq = plot_data.yline_freq;
    light_source = plot_data.light_source;

    cax = get(fig,'CurrentAxes');
    hold off;
    
% If we've already got a picture, store a few of the parameters
    if ~isempty(cax) & strcmp('EigTool_3D_Plot',get(fig,'Tag')),
      cur_zlim = zlim;
      [cur_v_a,cur_v_e] = view;
    end;

% Draw the surface
    if isempty(light_source),
      nice_3d_plot(x,y,-log10(Z),xline_freq,yline_freq,1,1);
    else
      nice_3d_plot(x,y,-log10(Z),xline_freq,yline_freq,1,1,light_source);
    end;

% Restore the settings saved above
    if ~isempty(cax) & strcmp('EigTool_3D_Plot',get(fig,'Tag')),
      view([cur_v_a,cur_v_e]);
      zlim(cur_zlim);
    end;

% Add a few extras and tidy up the plot
    xlabel('Real');
    ylabel('Imag');
    zlabel('log_{10}(resolvent norm)');
%    xlabel(sprintf('xline_freq = %d', xline_freq))
%    ylabel(sprintf('yline_freq = %d', yline_freq))
    if isempty(cax), cax = get(fig,'CurrentAxes'); end;

% If we've got enough points to make a nice smooth plot...
% Plot the eigenvalues
    hold on;
    ax = axis(cax);
    max_ht = max(max(-log10(Z)));
    mnu_itm_h = findobj(fig,'Tag','DispEws');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      for k=1:length(ews),
        [m,i] = min(abs(x-real(ews(k))));
        [m,j] = min(abs(y-imag(ews(k))));
        if  real(ews(k))>=ax(1) & real(ews(k))<=ax(2) ...
          & imag(ews(k))>=ax(3) & imag(ews(k))<=ax(4),
          plot_ew(ax,ews(k),-log10(Z(j,i)),max_ht,cax);
        end;
      end;
    end;

    dar = get(cax,'DataAspectRatio');
    set(cax,'PlotBoxAspectRatio',[dar(1:2) min(dar(1:2))]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_ew(ax,ew,vc,ht,cax)

% function plot_ew(ax,ew,vc,ht,cax)
%
% Function to plot the eigenvalues of the matrix as 3D cylinders

% Work out how large they should be
scale = min(ax(4)-ax(3),ax(2)-ax(1));
clims = get(cax,'clim');

% Plot the cylinder
[x,y,z] = cylinder(scale/250*[1 1],20);
x = x+real(ew);
y = y+imag(ew);
z = .75*vc+ z*vc*.28;
surf(x,y,z,ones(size(z))*clims(1))

% Put a lid on it, and also a base
fill3(x(1,:),y(1,:),ones(size(x(1,:)))*(.75*vc+.28*vc),ones(size(x(1,:)))*clims(1),'linestyle','none')
fill3(x(1,:),y(1,:),ones(size(x(1,:)))*.75*vc,ones(size(x(1,:)))*clims(1),'linestyle','none')



