function ps_data = switch_psarea(fig,cax,this_ver,ps_data)

% function ps_data = switch_psarea(fig,cax,this_ver,ps_data)
%
% Function called when a box is dragged (or a button clicked)
% in the pseudospectra axes

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    click_pt = get(gcf,'currentpoint');
    ax_pos = get(cax,'position');

%% Check to see if click lies in axes. If not, leave
    if click_pt(1)<ax_pos(1) | click_pt(1)>ax_pos(1)+ax_pos(3) ...
     | click_pt(2)<ax_pos(2) | click_pt(2)>ax_pos(2)+ax_pos(4),
      return;
    end;

%% Left button to zoom in, right to zoom out to previous level.
    if strcmp('normal',get(fig,'selectiontype')),

%% Actually do the box dragging
      sel_rect = rbbox;

%% Need to convert the rectangle returned from rbbox (in pixels) to one 
%% defined in axis coordinates.
      set(fig,'CurrentPoint',[sel_rect(1) sel_rect(2)]);
      pt1=get(cax, 'CurrentPoint');
      set(fig,'CurrentPoint',[sel_rect(1)+sel_rect(3) ...
                              sel_rect(2)+sel_rect(4)]);
      pt2=get(cax, 'CurrentPoint');

%% Now make an 'axis like' vector out of it
      final_rect=[min([pt1(1,1) pt2(1,1)]) max([pt1(1,1) pt2(1,1)]) ...
                  min([pt1(1,2) pt2(1,2)]) max([pt1(1,2) pt2(1,2)])];

%% Limit the dragged rectangle to the actual axes
      final_rect(1) = max(final_rect(1),ps_data.zoom_list{ps_data.zoom_pos}.ax(1));
      final_rect(2) = min(final_rect(2),ps_data.zoom_list{ps_data.zoom_pos}.ax(2));
      final_rect(3) = max(final_rect(3),ps_data.zoom_list{ps_data.zoom_pos}.ax(3));
      final_rect(4) = min(final_rect(4),ps_data.zoom_list{ps_data.zoom_pos}.ax(4));

      if this_ver<6,
        set(fig,'CurrentAxes',cax);
        ax = axis;
      else
        ax = axis(cax);
      end;
      aw = ax(2)-ax(1); ah = ax(4)-ax(3);

%% If no rectangle, zoom in on point clicked, mag factor 2
      if abs(final_rect(2)-final_rect(1))/aw<0.01 ...
         | abs(final_rect(4)-final_rect(3))/ah<0.01,

%% If we are at the end of the chain of zooming, want to zoom further
        if ps_data.zoom_pos==size(ps_data.zoom_list,2),

%% Get the width and height of the current axes
          w = ps_data.zoom_list{ps_data.zoom_pos}.ax(2) ...
              - ps_data.zoom_list{ps_data.zoom_pos}.ax(1);
          h = ps_data.zoom_list{ps_data.zoom_pos}.ax(4) ...
              - ps_data.zoom_list{ps_data.zoom_pos}.ax(3);

%% Initially just duplicate the data from the current pseudospectra
          ps_data.zoom_list{ps_data.zoom_pos+1} = ...
                      ps_data.zoom_list{ps_data.zoom_pos};

%% Increment the count by one
          ps_data.zoom_pos = ps_data.zoom_pos+1;

%% Work out the new axes
          ps_data.zoom_list{ps_data.zoom_pos}.ax(1) = final_rect(1) - w/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(2) = final_rect(1) + w/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(3) = final_rect(3) - h/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(4) = final_rect(3) + h/4;

          final_rect = ps_data.zoom_list{ps_data.zoom_pos}.ax;
%% If the matrix is real, and the dragged box 'almost' symmetric about
%% the x-axis, force that symmetry
          if ps_data.AisReal==1,
            span = final_rect(4) - final_rect(3);
            the_diff = (final_rect(4) + final_rect(3))/span; 
            if abs(the_diff) < 0.15
              final_rect(3) = -max(abs([final_rect(3:4)]));
              final_rect(4) = max(abs([final_rect(3:4)]));
            end;
          end;
          ps_data.zoom_list{ps_data.zoom_pos}.ax = final_rect;

%% Tidy up the axis limits
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(2)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(2),0.05);
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(4)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(4),0.05);

%% Switch to the new axes
          if this_ver<6,
            axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
          else
            axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
          end;

% If we're in an ARPACK computation...
          if strcmp(ps_data.comp,'ARPACK')==1,
 %% If doing an ARPACK computation, switch to manual axes
            mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
            set(mnu_itm_h,'checked','off');
          else
%% This level is currently zoomed, not computed
            ps_data.zoom_list{ps_data.zoom_pos}.computed = 0;

%% Change the message and enable the Go! button
            ps_data = update_messagebar(fig,ps_data,2);

%% Enable the 'Go!' button
            ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
          end;

          if this_ver<6,
            set(fig,'CurrentAxes',cax);
            the_ax = axis;
          else
            the_ax = axis(cax);
          end;
          set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);

%% Move the dimension string
          move_dimension_str(fig,the_ax);

        else %% There is already a zoomed area to go to

%% Increment the count
          ps_data.zoom_pos = ps_data.zoom_pos+1;

% If we're in an ARPACK computation...
          if strcmp(ps_data.comp,'ARPACK')==1,
 %% If doing an ARPACK computation, switch to manual axes
            mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
            set(mnu_itm_h,'checked','off');
            if this_ver<6,
              set(fig,'CurrentAxes',cax);
              axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
            else
              axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
            end;
            the_ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
            set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                          ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                          ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
          else
%% Change the title accordingly
            if ps_data.zoom_list{ps_data.zoom_pos}.computed==1,
%% Change the message 
              ps_data = update_messagebar(fig,ps_data,1);

%% Disable the 'Go!' button
              ps_data = toggle_go_btn(fig,'Go!','off',ps_data);
            else
%% Change the message and enable the Go! button
              ps_data = update_messagebar(fig,ps_data,2);
%% Enable the 'Go!' button
              ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
            end;

%% Now redraw
            ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
          end;
        end;

      else %% There was a rectangle

%% Initially just duplicate the data from the current pseudospectra
        ps_data.zoom_list{ps_data.zoom_pos+1} = ...
                    ps_data.zoom_list{ps_data.zoom_pos};

%% Now remove any others from the end of the zoom list
        ps_data.zoom_list = cat(2,{ps_data.zoom_list{1:ps_data.zoom_pos+1}});

%% Increment the count
        ps_data.zoom_pos = ps_data.zoom_pos+1;

%% If the matrix is real, and the dragged box 'almost' symmetric about
%% the x-axis, force that symmetry
        if ps_data.AisReal==1,
          span = final_rect(4) - final_rect(3);
          the_diff = (final_rect(4) + final_rect(3))/span; 
          if abs(the_diff) < 0.07
            final_rect(3) = -max(abs([final_rect(3:4)]));
            final_rect(4) = max(abs([final_rect(3:4)]));
          end;
        end;

%% Finally set the axes for computation of the pseudospectra
        ps_data.zoom_list{ps_data.zoom_pos}.ax=final_rect;

%% Tidy up the axis limits
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(2)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(2),0.02);
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(4)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(4),0.02);

%% Switch to the new axes
        if this_ver<6,
          set(fig,'CurrentAxes',cax);
          axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
        else
          axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
        end;

%% This level is currently zoomed, not computed
        ps_data.zoom_list{ps_data.zoom_pos}.computed = 0;

% If we're in an ARPACK computation...
        if strcmp(ps_data.comp,'ARPACK')==1,
 %% If doing an ARPACK computation, switch to manual axes
          mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
          set(mnu_itm_h,'checked','off');
        else
%% Change the message and enable the Go! button
          ps_data = update_messagebar(fig,ps_data,2);
%% Enable the 'Go!' button
          ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
        end;

        the_ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
        set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                      ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                      ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);

%% Move the dimension string
        move_dimension_str(fig,the_ax);
      end;

    elseif strcmp('alt',get(fig,'selectiontype')), 

%% Restore the previous zoom level
      if ps_data.zoom_pos>1,

%% Decrement the count
        ps_data.zoom_pos = ps_data.zoom_pos-1;
 
% If we're in an ARPACK computation...
        if strcmp(ps_data.comp,'ARPACK')==1,
%% If doing an ARPACK computation, switch to manual axes
          mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
          set(mnu_itm_h,'checked','off');
          if this_ver<6,
            set(fig,'CurrentAxes',cax);
            axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
          else
            axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
          end;
          the_ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
          set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
        else
          if ps_data.zoom_list{ps_data.zoom_pos}.computed==1,
%% Change the message and disable the Go! button
            ps_data = update_messagebar(fig,ps_data,1);
%% Disable the 'Go!' button
            ps_data = toggle_go_btn(fig,'Go!','off',ps_data);
            ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
          else
%% Change the message and enable the Go! button
            ps_data = update_messagebar(fig,ps_data,2);
%% Enable the 'Go!' button
            ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
            ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
          end;
        end;
      else
%% Right click, and no previous zoom-entry to go to; zoom out by a factor of 2

        new_list_entry = ps_data.zoom_list{1};
        new_list_entry.computed = 0;

%% Make an extra zoom list entry
        ps_data.zoom_list = cat(2, {new_list_entry}, ps_data.zoom_list);

%% Get the click point in axis coordinates
        pt=get(cax, 'CurrentPoint');


% Work out whether the entire field of values is currently visible. If not,
% will zoom to ensure this.
        if isfield(ps_data,'fov') & isfield(ps_data,'show_fov') ...
           & ps_data.show_fov==1,
% This is the extent of the fov
          mnr = min(real(ps_data.fov));
          mxr = max(real(ps_data.fov));
          mni = min(imag(ps_data.fov));
          mxi = max(imag(ps_data.fov));

% If currently visible, no need to do anything
          if   mnr > ps_data.zoom_list{ps_data.zoom_pos}.ax(1) ...
             & mxr < ps_data.zoom_list{ps_data.zoom_pos}.ax(2) ...
             & mni > ps_data.zoom_list{ps_data.zoom_pos}.ax(3) ...
             & mxi < ps_data.zoom_list{ps_data.zoom_pos}.ax(4),
            zoom_to_fov = 0;
          else % Else, zoom out so show it
            zoom_to_fov = 1;
          end;
       else
          zoom_to_fov = 0;
       end;

%% If the field of values is shown, zoom out to show it all
        if zoom_to_fov==1,
          w = mxr-mnr;
          h = mxi-mni;

          ps_data.zoom_pos = 1;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(1) = mnr - w/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(2) = mxr + w/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(3) = mni - h/4;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(4) = mxi + h/4;
        else

%% Get the width and height of the current axes
          w = ps_data.zoom_list{2}.ax(2) ...
              - ps_data.zoom_list{2}.ax(1);
          h = ps_data.zoom_list{2}.ax(4) ...
              - ps_data.zoom_list{2}.ax(3);

          ps_data.zoom_pos = 1;

%% Grow the axes around the point clicked on
          ps_data.zoom_list{ps_data.zoom_pos}.ax(1) = pt(1,1) - w;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(2) = pt(1,1) + w;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(3) = pt(1,2) - h;
          ps_data.zoom_list{ps_data.zoom_pos}.ax(4) = pt(1,2) + h;
        end;

%% Tidy up the axis limits
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(2)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(1), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(2),0.05);
        [ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
         ps_data.zoom_list{ps_data.zoom_pos}.ax(4)] = tidy_axes( ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(3), ...
                            ps_data.zoom_list{ps_data.zoom_pos}.ax(4),0.05);

%% And make the change
        axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);

% If we're in an ARPACK computation...
        if strcmp(ps_data.comp,'ARPACK')==1,
%% If doing an ARPACK computation, switch to manual axes
          mnu_itm_h = findobj(fig,'Tag','ARPACK_auto_ax');
          set(mnu_itm_h,'checked','off');
          the_ax = ps_data.zoom_list{ps_data.zoom_pos}.ax;
          set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                        ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
        else
          ps_data = update_messagebar(fig,ps_data,2);
%% Enable the 'Go!' button
          ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
          ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
        end;
      end;

    end;
