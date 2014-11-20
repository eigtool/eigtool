function ps_data = switch_transientbestlb(fig,cax,this_ver,ps_data)

% function ps_data = switch_transientbestlb(fig,cax,this_ver,ps_data)
%
% Function that is called when the user presses the Transient menu's
% Lower Bound option.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues


   A = ps_data.matrix;

%% Actually do the plotting (restricting A to the upper nn by nn section
%% so we can approximate pseudomodes for matrices from the Arnoldi factorisation)

% Get the current state of the Go button (for later
  the_handle = findobj(fig,'Tag','RedrawPlot');
  go_state = get(the_handle,'Enable');
  set(the_handle,'Enable','off');

%% Update the message string
  ps_data = update_messagebar(fig,ps_data,40);

  disable_controls(fig);

% Get the type of transient we're currently dealing with
  [tfig,cax1,cax2,ftype] = find_trans_figure(fig,'A',1);

  cont = 1;
%% Get the point
  while cont==1,
    the_pt = ginput_eigtool(1,'crosshair');
    sel_pt = the_pt(1)+1i*the_pt(2);

    if the_pt(1)<0 & strcmp(ftype,'E'),
      h = errordlg('The selected point must be in the right half plane','Error...','modal');
      waitfor(h);
      ax = axis(cax);
% If there are no points in the right half plane, leave
      if ax(2)<0,
        enable_controls(fig,ps_data);
%% Reset the state of the Go button
        the_handle = findobj(fig,'Tag','RedrawPlot');
        set(the_handle,'Enable',go_state);
        ps_data = update_messagebar(fig,ps_data,'prev');
        return;
      end;
    elseif abs(the_pt(1)+1i*the_pt(2))<1 & strcmp(ftype,'P'),
      h = errordlg('The selected point must be outside the unit disc','Error...','modal');
      waitfor(h);
% If there are no points in the right half plane, leave
      ax = axis(cax);
      axpt1 = ax(1)+1i*ax(3);
      axpt2 = ax(1)+1i*ax(4);
      axpt3 = ax(2)+1i*ax(3);
      axpt4 = ax(2)+1i*ax(4);
      if abs(axpt1)<1 & abs(axpt1)<2 & abs(axpt1)<3 & abs(axpt4)<1,
        enable_controls(fig,ps_data);
%% Reset the state of the Go button
        the_handle = findobj(fig,'Tag','RedrawPlot');
        set(the_handle,'Enable',go_state);
        ps_data = update_messagebar(fig,ps_data,'prev');
        return;
      end;
    else
      cont = 0;
    end;
  end;

  [tfig,marker_h] = draw_trans_lb(A,the_pt,fig,ps_data);

%% Revert the message string
  ps_data = update_messagebar(fig,ps_data,'prev');

  enable_controls(fig,ps_data);

%% If there was an error

%% Store data so the marker can be redrawn/deleted
  marker_info.h = marker_h;
  marker_info.pos = sel_pt;
  marker_info.type = 'T';
  ps_data.mode_markers{tfig} = marker_info;

%% Reset the state of the Go button
  the_handle = findobj(fig,'Tag','RedrawPlot');
  set(the_handle,'Enable',go_state);
