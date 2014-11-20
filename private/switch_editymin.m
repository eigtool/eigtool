function ps_data = switch_editymin(fig,cax,ps_data)

% function ps_data = switch_editymin(fig,cax,ps_data)
%
% Function called when min y value changed

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    s = get(gcbo,'String');
    n = str2num(s);
    if ~isempty(n) & length(n)==1,
      if n<ps_data.zoom_list{ps_data.zoom_pos}.ax(4),

% If we're zooming out
        if n<ps_data.zoom_list{ps_data.zoom_pos}.ax(3),

%% If the current zoom level is computed, start a new position
          if isfield(ps_data.zoom_list{ps_data.zoom_pos},'computed') ...
                & ps_data.zoom_list{ps_data.zoom_pos}.computed==1,

% If we're not at the beginning of the zoom list, 
            if ps_data.zoom_pos>1,
              ps_data.zoom_list = cat(2,{ps_data.zoom_list{ps_data.zoom_pos}, ...
                                         ps_data.zoom_list{ps_data.zoom_pos:end}});
% Else we're already at the first one - just insert a new zoom at the beginning
            else
              ps_data.zoom_list = cat(2, {ps_data.zoom_list{1}}, ps_data.zoom_list);
            end;

%% Initially just duplicate the data from the current pseudospectra
            ps_data.zoom_pos = 1;

            ps_data.zoom_list{ps_data.zoom_pos}.computed = 0;
          end;

% else we're zooming in
        else

%% If the current zoom level is computed, start a new position
          if isfield(ps_data.zoom_list{ps_data.zoom_pos},'computed') ...
                & ps_data.zoom_list{ps_data.zoom_pos}.computed==1,
%% Initially just duplicate the data from the current pseudospectra
            ps_data.zoom_list{ps_data.zoom_pos+1} = ...
                        ps_data.zoom_list{ps_data.zoom_pos};

%% Now remove any others from the end of the zoom list
            ps_data.zoom_list = cat(2,{ps_data.zoom_list{1:ps_data.zoom_pos+1}});
%% Increment the count
            ps_data.zoom_pos = ps_data.zoom_pos+1;
            ps_data.zoom_list{ps_data.zoom_pos}.computed = 0;
          end;
        end;

        ps_data.zoom_list{ps_data.zoom_pos}.ax(3)=str2num(get(gcbo,'String'));
        set(cax,'xlim',ps_data.zoom_list{ps_data.zoom_pos}.ax(1:2));
        set(cax,'ylim',ps_data.zoom_list{ps_data.zoom_pos}.ax(3:4));
      else
        errordlg('Minimum y value must be smaller than maximum y value!', ...
                 'Invalid input','modal');
      end;
    else
      errordlg('Invalid number for minimum y value','Invalid input','modal');
    end;

%% Move the dimension string
    move_dimension_str(fig,ps_data.zoom_list{ps_data.zoom_pos}.ax);

%% Enable the 'Go!' button now we've changed the axis
    if strcmp(ps_data.comp,'ARPACK')~=1,
      ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
      ps_data = update_messagebar(fig,ps_data,2);
    else
%% If doing an ARPACK computation, switch to manual axes
      mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
      set(mnu_itm_h,'checked','off');
    end;
