function disable_controls(fig)

% function disable_controls(fig)
%
% Function to disable the controls on the GUI figure
% pointed to by fig.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Disable all the edit text boxes
  the_handle = findobj(fig,'Tag','xmin');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','xmax');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','ymin');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','ymax');
  set(the_handle,'Enable','off');

  the_handle = findobj(fig,'Tag','firstlev');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','lastlev');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','nolev');
  set(the_handle,'Enable','off');

  the_handle = findobj(fig,'Tag','meshsize');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','safety');
  set(the_handle,'Enable','off');

%% Disable the buttons
  the_handle = findobj(fig,'Tag','EwCond');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','RedrawPlot');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','OrigPlot');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Print');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Import');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','FieldOfVals');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','PseudoMode');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Plot3D');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Quit');
  set(the_handle,'Enable','off');

%% Disable the checkboxes
  the_handle = findobj(fig,'Tag','ARPACK_k');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Which');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Direct');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','Iterative');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','AutoLev');
  set(the_handle,'Enable','off');
  the_handle = findobj(fig,'Tag','ScaleEqual');
  set(the_handle,'Enable','off');

%% Disable the axes so that user cannot click again until this
%% one is finished.
    the_handle = findobj(fig,'Tag','MainAxes');
    set(the_handle,'HitTest','off');

%% Disable the menus
   the_handle = findobj(fig,'Tag','FileMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','ExtrasMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','ARPACKMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','TransientsMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','NumbersMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','DemosMenu'); 
   set(the_handle,'Enable','off');
   the_handle = findobj(fig,'Tag','WindowMenu'); 
   set(the_handle,'Enable','off');

% Can only use this for dense matrices - it will be re-enabled then
   the_handle = findobj(fig,'Tag','ExportSchur');
   set(the_handle,'Enable','off');

% Can only use this when we have eigenvalues
   the_handle = findobj(fig,'Tag','ExportEws');
   set(the_handle,'Enable','off');

% Disable click/drag in axes
    set(fig,'WindowButtonDownFcn','');
