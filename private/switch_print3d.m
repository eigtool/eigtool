function switch_print3d(fig,ps_data)

% function switch_print3d(fig,ps_data)
%
% Function to create a figure without any of the GUI controls
% for printing the current pseudospectra

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues


% Get a new figure for the plot
    pfig = figure;
    set(pfig,'Tag','EigTool_3D_Plot');

% Add our menu to the figure
    h1 = uimenu('Parent',pfig, ...
	    'Callback','', ...
	    'Label','&Plot Controls', ...
	    'Tag','PlotControlsMenu');

% Display the ews depending on EigTool menu selection
    h2 = uimenu('Parent',h1, ...
	    'Callback','et_plot3d_switch_fn(''DispEws'')', ...
	    'Label','Display &Eigenvalues', ...
	    'Tag','DispEws');
    mnu_itm_h = findobj(fig,'Tag','DisplayEWS');
    cur_state = get(mnu_itm_h,'checked');
    set(h2,'Checked',cur_state);

% Change the position of the light source
    h2 = uimenu('Parent',h1, ...
	    'Callback','et_plot3d_switch_fn(''LightSource'')', ...
	    'Label','&Light Source Position', ...
	    'Tag','LightSource');

% Change the number of dark lines on the plot
    h2 = uimenu('Parent',h1, ...
	    'Callback','et_plot3d_switch_fn(''MeshSize'')', ...
	    'Label','&Mesh Size', ...
	    'Tag','MeshSize');

% Extract the data
    plot_data.x = ps_data.zoom_list{ps_data.zoom_pos}.x;
    plot_data.y = ps_data.zoom_list{ps_data.zoom_pos}.y;
    plot_data.Z = ps_data.zoom_list{ps_data.zoom_pos}.Z;
    plot_data.ews = ps_data.ews;
    plot_data.light_source = [7.5 30];
    plot_data.view = [-37.5 30];

% Comute the initial mesh size
    [xnpts,ynpts] = size(plot_data.Z);
    line_freq = floor(min(xnpts,ynpts)/10);
    plot_data.xline_freq = line_freq;
    plot_data.yline_freq = line_freq;
    set(pfig,'UserData',plot_data);

% Create the plot
    create_3d_plot(pfig);
