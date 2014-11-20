function setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
                         thick_lines,scale_equal,dim_str, ...
                         grid_on,fov,approx_ews,imag_axis, ...
                         unit_circle,colourbar,fig)

% function setup_print_fig(Z,x,y,levels,ax,ews,colour, ...
%                          thick_lines,scale_equal,dim_str, ...
%                          grid_on,fov,approx_ews,imag_axis, ...
%                          unit_circle,colourbar,fig)
%
% Function to create a printable plot (without the GUI buttons
% etc.) from the minimum singular value data.
%
% Z         The mimium singular values over the grid
% x         The x values of the gridpoints
% y         The y values of the gridpoints
% levels    The epsilon levels to plot
% ax        The axes to use
% ews       The eigenvalues
% colour    Plot the data using coloured contours?
% thick_lines  Plot the data using thick lines (1) or not (0); other values
%           are defined by interpolation
% scale_equal  Plot the data using axis equal (1=yes, 0=no)
% dim_str   String with the matrix dimenisions ('' for none)
% grid_on   Plot the grid as well (1 for on, 0 for off)
% fov       Data for the field of values (empty if not there)
% approx_ews ews are approximate  - plot them in purple.
% imag_axis Add the imaginary axis in grey
% unit_circle Add the unit circle in grey
% colourbar Include the colourbar on the plot?
% fig       Figure number to put the plot in

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Create a new figure and set up the colourmap
      if nargin<17 | fig<0,
        print_fig = figure;
      else
        print_fig = figure(fig);
      end;
      set_gui_colour_map(print_fig);

% Add some axes to the new figure and set the other options
      pf_axes_h = get(print_fig,'currentaxes');
      if isempty(pf_axes_h), pf_axes_h = axes; end;
      orig_dplw = get(print_fig,'defaultpatchlinewidth');
      orig_dllw = get(print_fig,'defaultlinelinewidth');
      if thick_lines==1,
        set(print_fig,'defaultpatchlinewidth',2);
        set(print_fig,'defaultlinelinewidth',2);
      elseif thick_lines==0
        set(print_fig,'defaultpatchlinewidth',1);
        set(print_fig,'defaultlinelinewidth',1);
      else
        set(print_fig,'defaultpatchlinewidth',thick_lines+1);
        set(print_fig,'defaultlinelinewidth',thick_lines+1);
      end;
      set(pf_axes_h,'box','on');

%% Plot the imaginary axis if it should be on
      if imag_axis==1,
        plot([0 0],ax(3:4),'-','color',.6*[1 1 1],'linewidth',1);
        hold on;
      end;

%% Plot the unit circle if it should be on
      if unit_circle==1,
        th = linspace(0,2*pi,500);
        eth = exp(1i*th);
        plot(real(eth),imag(eth),'-','color',.6*[1 1 1],'linewidth',1)
        hold on;
      end;

      if grid_on==1,
        [X,Y] = meshgrid(x,y);
        plot(X,Y,'k.','markersize',1);
        hold on;
      end;

      if length(levels)==1, levels = levels*[1 1]; end;

% If Z is non-zero (i.e. we want to plot the psa)
      if any(any(Z)),
        if colour==1,
          [con,con_hdl] = contour(x,y,log10(Z),levels);                % mpe edit
        else
          [con,con_hdl] = contour(x,y,log10(Z),levels,'k');            % mpe edit
        end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
% This code adjusts for MATLAB 7's new "contourgroup" object.          % mpe new
% EigTool 2.04 used MATLAB 6 "patch" objects.                          % mpe new
        this_matlab = ver('matlab');                                   % mpe new, from new_matrix.m 
        this_ver = str2num(this_matlab.Version);                       % mpe new, from new_matrix.m
        if (this_ver>=7)                                               % mpe new
           if thick_lines,                                             % mpe new
              set(con_hdl,'linewidth',2);                              % mpe new
           else                                                        % mpe new
              set(con_hdl,'linewidth',1);                              % mpe new
           end                                                         % mpe new
        end                                                            % mpe new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
      end;



      if scale_equal==1, %% Currently on equal scale
        axis equal;
      else                     %% not on equal scale
        axis normal;
      end;
%% Set the axes to match those of the gui
      axis(ax);

% Set the position box of the axes to be the same as the axis
% (i.e. no blank space around axes). This will give us extra 
% space for the colourbar
      tight_axis_box(print_fig,pf_axes_h);

% If Z is non-zero (i.e. we want to plot the psa)
      if any(any(Z)),
        if colour==1 & colourbar==1,
          add_mycolourbar(con,print_fig,levels);
        end;
      end;

% Set the main axes to the default
      set(print_fig,'currentaxes',pf_axes_h);

      set(pf_axes_h,'clim',[min(levels)-1e-15 ...
                            max(levels)]);

      hold on;

%% Plot the eigenvalues
      if approx_ews==1, ew_col = 0*0.5*[1 0 1];
      else ew_col = [0 0 0]; end;
      print_ew_size = getpref('EigTool','print_ew_size');
      plot(real(ews),imag(ews),'.','markersize',print_ew_size,'color',ew_col); 

%% Plot the field of values if it's there
      if ~isempty(fov),
         plot(real(fov),imag(fov),'k--');
      end;

      if ~isempty(dim_str),
%% Get the width and height of the axes
        the_d = diff(ax);
        shift = max(the_d([1 3]));
        l = ax(1);
        t = ax(3);
        text(l+shift/20,t+shift/20,dim_str,'fontsize',12,'fontweight','bold');
      end;

%% Restore the original linewidths
      set(print_fig,'defaultpatchlinewidth',orig_dplw);
      set(print_fig,'defaultlinelinewidth',orig_dllw);
