function et_call_num_comp(routine,fig)

% function et_call_num_comp(routine,fig)
%
% Function to wrap the call to functions from the numbers menu.
% This function ensures that EigTool's controls are disabled
% during the compuation, and sets up the data for the function.
%
% routine      A string containing the name of the routine to call
% fig          The figure number of the associated EigTool instance

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Get (and set up) some initial bits of data
ps_data = get(fig,'UserData');
this_matlab = ver('matlab');
this_ver = str2num(this_matlab.Version);
cax = findobj(fig,'Tag','MainAxes');

% If the menu item is checked, all we want to do is remove the markers
% from the pseudospectra plot
if strcmp(get(gcbo,'checked'),'on'),
  set(gcbo,'checked','off');
  for i=1:length(ps_data.numbers.markers),
    if strcmp(ps_data.numbers.markers{i}.tag,routine),
      ps_data.numbers.markers{i}.visible = 'off';
    end;
    ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

% Save the data back to EigTool
    set(fig,'UserData',ps_data);
  end;
  return;
end;

% Disable the controls while the compuation is going on
disable_controls(fig);

% Do the computation, passing in EigTool's data
try
  outputvals = feval(routine,ps_data);

% Save any data fields that should be set
  numbers = ps_data.numbers;
  if ~isempty(outputvals),

% Add the new data fields
    if ~isempty(outputvals{1}),
      for i=1:length(outputvals{1}),
        numbers = setfield(numbers,outputvals{1}{i}.field,outputvals{1}{i}.value);
      end;
    end;

% Add the new marker information
    if length(outputvals)>1 & ~isempty(outputvals{2}),

% Remove any existing markers
      i = 0;
      while i<length(numbers.markers),
        i = i+1;
        if strcmp(numbers.markers{i}.tag,routine),
          numbers.markers = {numbers.markers{1:i-1},numbers.markers{i+1:end}};
        end;
      end;

% Are we currently displaying markers?
      mnu_itm_h = findobj(fig,'Tag','DisplayPoints');
      marker_state = get(mnu_itm_h,'checked');

% Set up additional data for those markers just returned
      for i=1:length(outputvals{2}),
        outputvals{2}{i}.tag = routine;
        outputvals{2}{i}.visible = marker_state;
      end;
      numbers.markers = cat(2,numbers.markers,outputvals{2});

% Check the menu item if any markers are visible
      set(gcbo,'checked',marker_state);
    else
% Turn on any existing markers
      for i=1:length(numbers.markers),
        if strcmp(numbers.markers{i}.tag,routine),
          numbers.markers{i}.visible = marker_state;
          set(gcbo,'checked',marker_state);
        end;
      end;
    end;

  end;

% Redraw the figure (get a fresh copy of UserData in case it's changed
% since we last got it)
  ps_data = get(fig,'UserData');
  ps_data.numbers = numbers;

  ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

% Save the data back to EigTool
  set(fig,'UserData',ps_data);

catch
  h = errordlg(lasterr,'Error in external routine...','modal');
  waitfor(h);
end;

% Enable the controls again
enable_controls(fig,ps_data);
