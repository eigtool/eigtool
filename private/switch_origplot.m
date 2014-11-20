function ps_data = switch_origplot(fig,cax,this_ver,ps_data,ax_only)

% function ps_data = switch_origplot(fig,cax,this_ver,ps_data,ax_only)
%
% Function called when using a new matrix

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Added a fifth argument (ax_only) in cases where we just want to set the axes.
      if nargin<5, ax_only = 0; end

%% Initialise for the first run
      ps_data.zoom_pos = 1;
      ps_data.zoom_list = {ps_data.zoom_list{1}};

%% Determine the default axes, based on the eigenvalues
      if isempty(ps_data.zoom_list{ps_data.zoom_pos}.ax)

%% Define the axes based on the position of the eigenvalues
        ca = [min(real(ps_data.ews)) max(real(ps_data.ews)) ...
              min(imag(ps_data.ews)) max(imag(ps_data.ews))];

%% Make sure the axes have some height and width to start with
        if ca(1)==ca(2),
          ca = [ca(1)-0.5 ca(2)+0.5 ca(3) ca(4)];
        end;
        if ca(3)==ca(4),
          ca = [ca(1) ca(2) ca(3)-0.5 ca(4)+0.5];
        end;

%% Now extend that box a bit
        widtha=ca(2)-ca(1);
        lengtha=ca(4)-ca(3);
        ext = max(widtha,lengtha);
        ps_data.zoom_list{ps_data.zoom_pos}.ax = ...
                      [ca(1)-ext/2 ca(2)+ext/2 ca(3)-ext/2 ca(4)+ext/2];

%% Tidy up the axis limits
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(2)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(2),0.02);
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(4)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(4),0.02);

      end;

%% After we've set everything up, need to redraw
      if ~ax_only, ps_data = switch_redraw(fig,cax,this_ver,ps_data); end
