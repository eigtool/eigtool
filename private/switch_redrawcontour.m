function ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data)

% function ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data)
%
% Function to actually plot the pseudospectra

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues


    mnu_itm_h = findobj(fig,'Tag','DisplayPSA');
    cur_state_psa = get(mnu_itm_h,'checked');
    mnu_itm_h = findobj(fig,'Tag','DisplayEWS');
    cur_state_ews = get(mnu_itm_h,'checked');
    mnu_itm_h = findobj(fig,'Tag','DisplayImagA');
    cur_state_imaga = get(mnu_itm_h,'checked');
    mnu_itm_h = findobj(fig,'Tag','DisplayUnitC');
    cur_state_unitc = get(mnu_itm_h,'checked');

    if strcmp(cur_state_ews,'off') & strcmp(cur_state_psa,'off'),
% To ensure psa removed if neither psa nor ews shown
      cla(cax);
    else
%% This command is equivalent to hold off (but keeping other axis properties)
      set(cax,'NextPlot', 'ReplaceChildren');
    end;

%% Don't plot contours if there is no contour data to draw (could be because
%% the  user clicked 'Stop')
    if isfield(ps_data,'zoom_list') ...
       & isfield(ps_data.zoom_list{ps_data.zoom_pos},'x') ...
       & ~isempty(ps_data.zoom_list{ps_data.zoom_pos}.x),

% Go back to letting MATLAB choose the axis ticks (they are removed
% by display_welcome), and display the colourbar again
      set(cax,'ytickmode','auto');
      set(cax,'xtickmode','auto');
      grow_main_axes(fig,0);

%% Initialise this in case it's not set below (needed in mycolourbar)
      con = [];

%% Plot the imaginary axis if it should be on
      if strcmp(cur_state_imaga,'on'),
        plot([0 0],ps_data.zoom_list{ps_data.zoom_pos}.ax(3:4),'-', ...
             'color',.6*[1 1 1],'linewidth',1);
%% This command is equivalent to hold on
        set(cax,'NextPlot', 'add');
      end;

%% Plot the unit circle if it should be on
      if strcmp(cur_state_unitc,'on'),
        th = linspace(0,2*pi,500);
        eth = exp(1i*th);
        plot(real(eth),imag(eth),'-','color',.6*[1 1 1],'linewidth',1)
%% This command is equivalent to hold on
        set(cax,'NextPlot', 'add');
      end;

%% Plot the grid, if it should be on:
      mnu_itm_h = findobj(fig,'Tag','ShowGrid');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'on'),
        [X,Y] = meshgrid(ps_data.zoom_list{ps_data.zoom_pos}.x, ...
                         ps_data.zoom_list{ps_data.zoom_pos}.y);
        h = plot(X,Y,'k.','markersize',1);
%% Store the handle for the grid so that it can be deleted.
        set(h,'Tag','GridText');

%% This command is equivalent to hold on
        set(cax,'NextPlot', 'add');
      end;

% Display the pseudospectra
      if strcmp(cur_state_psa,'on'),

        contour_levels = exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels);

        if length(contour_levels)==1,
          contour_levels = [contour_levels contour_levels];
        end;

        mnu_itm_h = findobj(fig,'Tag','Colour');
        cur_state = get(mnu_itm_h,'checked');
        if strcmp(cur_state,'on'),
          colour = 1;
        else
          colour = 0;
        end;

        if colour==1,
          if length(contour_levels)>0,
            [con,con_hdl] = contour(ps_data.zoom_list{ps_data.zoom_pos}.x, ... % mpe edit
                        ps_data.zoom_list{ps_data.zoom_pos}.y, ...
                        log10(ps_data.zoom_list{ps_data.zoom_pos}.Z), ...
                        contour_levels);
          end;
        else
          if length(contour_levels)>0,
            set(fig,'CurrentAxes',cax); set(0,'CurrentFigure',fig);
            [con,con_hdl] = contour(ps_data.zoom_list{ps_data.zoom_pos}.x, ... % mpe edit
                        ps_data.zoom_list{ps_data.zoom_pos}.y, ...
                        log10(ps_data.zoom_list{ps_data.zoom_pos}.Z), ...
                        contour_levels,'k');
          end;
        end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
% This code adjusts for MATLAB 7's new "contourgroup" object.          % mpe new
% EigTool 2.04 used MATLAB 6 "patch" objects.                          % mpe new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new
        if (this_ver>=7) & (length(contour_levels)>0),                 % mpe new
           mnu_itm_thick = findobj(fig,'Tag','ThickLines');            % mpe new 
           cur_state_thicklines = get(mnu_itm_thick,'checked');        % mpe new
           if strcmp(cur_state_thicklines,'on')                        % mpe new
              set(con_hdl,'linewidth',2);                              % mpe new 
           else                                                        % mpe new
              set(con_hdl,'linewidth',1);                              % mpe new
           end                                                         % mpe new
        end                                                            % mpe new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mpe new

%% This command is equivalent to hold on
       set(cax,'NextPlot', 'add');

%% Limit the colours plotted to the epsilon levels we're interested in
        the_levels = exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels);
        set(cax,'clim',[the_levels(1)-1e-14 the_levels(end)]);

%% Create the colour bar
        mycolourbar(fig,exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels),con, ...
             colour);

      end;

%% Restore the axes (contour will change them to x & y vals)
      if this_ver<6,
        set(fig,'CurrentAxes',cax);
        axis(ps_data.zoom_list{ps_data.zoom_pos}.ax);
      else
        axis(cax,ps_data.zoom_list{ps_data.zoom_pos}.ax);
      end;


%% Plot the eigenvalues (after the contour, so they can be seen)
%% Remove 0* from top line for purple approx's
      if strcmp(cur_state_ews,'on'),
        if ps_data.ew_estimates==1, ew_col = 0*0.5*[1 0 1];
        else ew_col = [0 0 0]; end;
        plot(real(ps_data.ews),imag(ps_data.ews),'.','Parent',cax,'color',ew_col); 
      end;

%% This command is equivalent to hold on
      set(cax,'NextPlot', 'add');

%% Plot the field of values, if the data is there
      if isfield(ps_data,'show_fov') & ...
         ps_data.show_fov,
           z =  ps_data.fov;      
           plot(real(z),imag(z),'k--','Parent',cax);
      end;  

%% Plot circles corresponding to any (pseudo)eigenmodes
      for i=1:length(ps_data.mode_markers),
        if ~isempty(ps_data.mode_markers{i}),
          m_info = ps_data.mode_markers{i};
          if strcmp(m_info.type,'E'), % Get the colour right
            col = 'co';
          elseif strcmp(m_info.type,'P'), % Get the colour right
            col = 'mo';
          elseif strcmp(m_info.type,'T'), % Get the colour right
            col = 'go';
          elseif strcmp(m_info.type,'B'), % Get the colour right
            col = 'g.';
          end;
%% Save the handle for deletion later
          ps_data.mode_markers{i}.h = plot(real(m_info.pos),imag(m_info.pos), ...
                                      col,'markersize',12,'linewidth',5);
        end;
      end;

%% Plot any extra markers determined by the contents of the 'Numbers' menu
      for i=1:length(ps_data.numbers.markers),
        if ~isempty(ps_data.numbers.markers{i}),
          m_info = ps_data.numbers.markers{i};
%% Save the handle for deletion later
          if strcmp(m_info.visible,'on'),
            ps_data.numbers.markers{i}.h = plot(real(m_info.pos),imag(m_info.pos), ...
                                        m_info.style,'markersize',m_info.size,'linewidth',5);
          elseif isfield(m_info,'h') & ishandle(m_info.h),
            delete(m_info.h);
          end;
        end;
      end;


%% Display the dimension, if it should be on:
      mnu_itm_h = findobj(fig,'Tag','ShowDimension');
      cur_state = get(mnu_itm_h,'checked');
      if strcmp(cur_state,'on'),
%% Get the width and height of the axes
%        the_d = diff(ps_data.zoom_list{ps_data.zoom_pos}.ax);
%        shift = max(the_d([1 3]));
%        l = ps_data.zoom_list{ps_data.zoom_pos}.ax(1);
%        t = ps_data.zoom_list{ps_data.zoom_pos}.ax(3);
        M = ps_data.zoom_list{ps_data.zoom_pos}.dims(1);
        N = ps_data.zoom_list{ps_data.zoom_pos}.dims(2);
        [im,in] = size(ps_data.input_matrix);
% If no projection has taken place
        if im==M & in==N,
          if M==N,
            the_str = ['dim = ',num2str(M)];
          else
            the_str = ['dim = ',num2str(M),' x ',num2str(N)];
          end;
% Need to display both orig size and proj size (must have im==in for projection)
        else
          if M==N,
            the_str = ['dim = ',num2str(im),' \rightarrow ',num2str(M)];
          else
            the_str = ['dim = ',num2str(im),' \rightarrow ',num2str(M),' x ',num2str(N)];
          end;
        end;
        h = text(0,0,the_str,'fontsize',12,'fontweight','bold');
%        h = text(l+shift/20,t+shift/20,the_str,'fontsize',12,'fontweight','bold');
        set(h,'units','pixels');
        set(h,'position',[15 15 0]);
        set(h,'Tag','DimText');
      end;
        
%% Make sure that the edit text boxes say the right thing
      if this_ver<6,
        set(fig,'CurrentAxes',cax);
        the_ax = axis;
      else
        the_ax = axis(cax);
      end;
      set_edit_text(fig,the_ax,ps_data.zoom_list{ps_data.zoom_pos}.levels, ...
                    ps_data.zoom_list{ps_data.zoom_pos}.npts, ...
                    ps_data.zoom_list{ps_data.zoom_pos}.proj_lev);
    elseif ~isfield(ps_data,'comp_stopped') | isempty(ps_data.comp_stopped)
% Display some text on the screen as a welcome
      display_welcome_text(fig,cax);
    end;
