function ps_data = switch_printonly(fig,cax,ps_data)

% function ps_data = switch_printonly(fig,cax,ps_data)
%
% Function to save the pseudospectra data to a file for
% quick plot recreation (no recomputation needed)

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    file_name = inputdlg('Please enter a filename for the saved data.', ...
                         'Save for Quick Print Creation...',1);

%% Leave if cancel pressed
    if isempty(file_name), return; end;

% Rename the variables for easy saving...
    Z = ps_data.zoom_list{ps_data.zoom_pos}.Z;
    x = ps_data.zoom_list{ps_data.zoom_pos}.x;
    y = ps_data.zoom_list{ps_data.zoom_pos}.y;
    hdl = findobj(fig,'Tag','ThickLines');
    cur_state = get(hdl,'checked');
    if strcmp(cur_state,'on'),
      thick_lines = 1;
    else
      thick_lines = 0;
    end;
    mnu_itm_h = findobj(fig,'Tag','Colour');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      colour = 1;
    else
      colour = 0;
    end;
    levels = exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels);
    if get(findobj(fig,'Tag','ScaleEqual'),'Value')==1, %% Currently on equal scale
      scale_equal = 1;
    else                     %% not on equal scale
      scale_equal = 0;
    end;
    ews = ps_data.ews;
    ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;

%% Get the matrix dimension if necessary
    mnu_itm_h = findobj(fig,'Tag','ShowDimension');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      dim_str = get(findobj(fig,'Tag','DimText'),'string');
    else
      dim_str = '';
    end;
  
%% Get the grid if necessary
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

%% Save whether the ews are displayed or not
    mnu_itm_h = findobj(fig,'Tag','DisplayEWS');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      no_ews = 0;
    else
      no_ews = 1;
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

    save(file_name{1},'Z','x','y','thick_lines','colour', ...
                   'levels','scale_equal','ews','ax','dim_str','grid_on', ...
                   'fov','no_ews','imag_axis','unit_circle','colourbar');

