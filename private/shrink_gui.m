function shrink_gui(fig,scale)

% function shrink_gui(fig,scale)
%
% Function to reduce the size of the GUI and all its controls
% for example if using a laptop screen

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

cs = get(fig,'children');

% Scale all the objects in the figure
for i=1:length(cs),

  p = get(cs(i),'position');

  if isempty(findstr('Menu',get(cs(i),'Tag'))),  set(cs(i),'position',scale*p); end;

end;

% Scale the figure itself
p = get(fig,'position');
set(fig,'position',scale*p);

% Reduce the fontsize in the message text a bit
h = findobj(fig,'Tag','MessageText');
set(h,'fontsize',12);
