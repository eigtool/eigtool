function et_plot3d_switch_fn(the_function)

% function et_plot3d_switch_fn(the_function)
%
% Function called when a menu item in the 3D-pseudospectra plot is
% selected.
%
% See also: EIGTOOL

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

fig = gcbf;
figure(fig);

itm = gcbo;
redraw_fig = 0;

% Get the data from the figure
plot_data = get(fig,'UserData');

switch the_function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'DispEws'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cur_state = get(itm,'checked');
    if strcmp(cur_state,'on'),
      set(itm,'Checked','off');
    else
      set(itm,'Checked','on');
    end;
    redraw_fig = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'LightSource'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    default_vals = {['[ ',num2str(plot_data.light_source),' ]']};

% Loop around until we get valid values
    cont = 1;
    while cont==1,

      s = inputdlg({['Please enter a direction for the light source, in [AZ,EL] ' ...
                     'view coordinates.']}, ...
                     'Light Source...', 1,default_vals);
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      elseif isempty(s{1}), % If left blank, error (will be trapped below)
        light_source = 'error';
      else
        light_source = str2num(s{1});
      end;

% Check the value we've got
      if length(light_source)==2,
        cont = 0;
        redraw_fig = 1;
        plot_data.light_source = light_source;
      else
        h = errordlg('Invalid value for light source direction','Invalid input','modal');
        waitfor(h);
      end;

    end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'MeshSize'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  default_vals = {num2str(plot_data.xline_freq),num2str(plot_data.yline_freq)};

% Loop around until we get valid values
    cont = 1;
    while cont==1,

      AddOpts.Resize='off';
      AddOpts.WindowStyle='modal';
      AddOpts.Interpreter='tex';
      s = inputdlg({['Please enter a value for the mesh interval in the x-direction'], ...
                    ['Please enter a value for the mesh interval in the y-direction']}, ...
                     'Mesh Size...', [1;1],default_vals);
      if isempty(s),        % If cancel chosen, just do nothing
        return;
      else
        xline_freq = str2num(s{1});
        yline_freq = str2num(s{2});
      end;

% Check the value we've got
      if length(xline_freq)==1 & length(yline_freq)==1,
        cont = 0;
        redraw_fig = 1;
        plot_data.xline_freq = xline_freq;
        plot_data.yline_freq = yline_freq;
      else
        h = errordlg('Invalid value for mesh sizes','Invalid input','modal');
        waitfor(h);
      end;

    end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is there just in case of a bug somewhere!
    errordlg([the_function ': Undefined action! This should not ' ...
             'have happened in the release version. Please contact ' ...
             'tgw@comlab.ox.ac.uk.'],'Error...','modal');

end;  % END OF SWITCH STATEMENT

% Save the data back to the figure
set(fig,'UserData',plot_data);

% Redraw the figure
if redraw_fig,
  create_3d_plot(fig);
end;
