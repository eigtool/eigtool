function grow_main_axes(fig,grow)

% function grow_main_axes(fig,grow)
%
% Function to hide the colourbar and use the space to 
% extend the main axes. Arguments are a figure handle
% to the GUI figure, and 'grow', which is 1 to extend
% the main axes, and 0 to shrink them and show the
% colourbar again.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

ma_h = findobj(fig,'Tag','MainAxes');
cb_h = findobj(fig,'Tag','MyColourBar');
cb_children = get(cb_h,'children');

% If we're growing the main axes and not already grown
if grow==1 & (strcmp(get(cb_h,'visible'),'on') | strcmp(get(ma_h,'visible'),'off')) ,

% Get the colour bar position and make it invisible
  cb_pos = get(cb_h,'pos');
  set(cb_h,'visible','off');
  for i=1:length(cb_children),
    set(cb_children(i),'visible','off');
  end;

% Save the current position of the axes so that we can return later
% (only if the data is not already stored there)
  ma_pos = get(ma_h,'pos');
  cur_ud = get(ma_h,'userdata');
  if isempty(cur_ud), set(ma_h,'userdata',ma_pos); end;

% Extend the axes
  ma_pos(3) = cb_pos(1)+cb_pos(3)-ma_pos(1);

  set(ma_h,'pos',ma_pos);

% If grow==0, we're shrinking them back again
elseif grow==0 & strcmp(get(cb_h,'visible'),'off'),

  mnu_itm_h = findobj(fig,'Tag','DisplayColourbar');
  cur_state = get(mnu_itm_h,'checked');
  if strcmp(cur_state,'off'),
    return;
  end;

% Change the position to that stored in userdata (if it was there)
  ma_pos = get(ma_h,'userdata');
  if ~isempty(ma_pos),
    set(ma_h,'pos',ma_pos);
  end;

% Turn on the colourbar again
  set(cb_h,'visible','on');
  for i=1:length(cb_children),
    set(cb_children(i),'visible','on');
  end;

end;

% Make sure the main axes are visible
set(ma_h,'Visible','on');

