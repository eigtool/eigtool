function switch_print(fig,ps_data)

% function switch_print(fig,ps_data)
%
% Function to create a figure without any of the GUI controls
% for printing the current pseudospectra

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    if isfield(ps_data,'print_line_thickness'),
       line_thickness = ps_data.print_line_thickness;
    else
       hdl = findobj(fig,'Tag','ThickLines');
       cur_state = get(hdl,'checked');
       if strcmp(cur_state,'on'),
         line_thickness = 1;
       else
         line_thickness = 0;
       end;
    end;

%% Privide a figure number if there was one stored
    if isfield(ps_data,'print_plot_num'),
      the_figure = ps_data.print_plot_num;
    else
      figure_num = inputdlg({['Please enter a figure number to plot in ' ...
                              'or leave blank for a new figure. If the ' ...
                              'figure already exists and ''hold on'' is set, ' ...
                              'the pseudospectra will be superimposed on top.']}, ...
                              'Figure number...', 1,{''});
      if isempty(figure_num),
        return;
      elseif isempty(figure_num{1}),
        the_figure = -1;
      else
        the_figure = str2num(figure_num{1});
      end;
    end;

%% Get the matrix dimension if necessary
    mnu_itm_h = findobj(fig,'Tag','ShowDimension');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      dim_str = get(findobj(fig,'Tag','DimText'),'string');
    else
      dim_str = '';
    end;

%% Get the matrix dimension if necessary
    mnu_itm_h = findobj(fig,'Tag','ShowGrid');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      grid_on = 1;
    else
      grid_on = 0;
    end;

%% Set the fov variable if we want to plot the field of values
    if isfield(ps_data,'show_fov') & ...
      ps_data.show_fov,
        fov =  ps_data.fov;    
    else
      fov = [];  
    end;  

%% Display the ews depending on menu selection
    mnu_itm_h = findobj(fig,'Tag','DisplayEWS');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      ews = ps_data.ews;
    else
      ews = [];
    end;

%% Display the psa depending on menu selection
    mnu_itm_h = findobj(fig,'Tag','DisplayPSA');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      Z = ps_data.zoom_list{ps_data.zoom_pos}.Z;
    else
      Z = zeros(size(ps_data.zoom_list{ps_data.zoom_pos}.Z));
    end;

    mnu_itm_h = findobj(fig,'Tag','Colour');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      colour = 1;
    else
      colour = 0;
    end;

    mnu_itm_h = findobj(fig,'Tag','DisplayImagA');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      imag_axis = 1;
    else
      imag_axis = 0;
    end;

    mnu_itm_h = findobj(fig,'Tag','DisplayUnitC');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      unit_circle = 1;
    else
      unit_circle = 0;
    end;

    mnu_itm_h = findobj(fig,'Tag','DisplayColourbar');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      colourbar = 1;
    else
      colourbar = 0;
    end;

    if isfield(ps_data,'ew_estimates'), approx_ews = ps_data.ew_estimates;
    else approx_ews = 0; end;

    setup_print_fig(Z, ...
                    ps_data.zoom_list{ps_data.zoom_pos}.x, ...
                    ps_data.zoom_list{ps_data.zoom_pos}.y, ...
                    exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels), ...
                    ps_data.zoom_list{ps_data.zoom_pos}.ax, ...
                    ews, ...
                    colour, ...
                    line_thickness, ...
                    get(findobj(fig,'Tag','ScaleEqual'),'Value'), ...
                    dim_str,grid_on,fov,approx_ews, ...
                    imag_axis,unit_circle,colourbar,the_figure);

