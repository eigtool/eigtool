function [fig,cax1,cax2,ftype] = find_trans_figure(guifig,ftype,get_h_only)

% function [fig,cax1,cax2,ftype] = find_trans_figure(guifig,ftype,get_h_only)
%
% This function looks through all the figures to see if there is
% already one for plotting transients in. If there is, it returns
% the figure number. If not, it creates one.
%
% guifig    The figure number of the parent GUI
% ftype     Type of transient behaviour ('A'll, 'P'owers or 'E'xponentials)
% get_h_only   Just get a handle to the existing figure (return
%              fig=-1 if none exist)
%
% fig       The figure number of the transients figure
% cax1      The handle to the non-log scale axes
% cax2      The handle to the log scale axes
% ftype     Type of transient behaviour ('P'owers or 'E'xponentials)

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Set the default value
  if nargin<3, get_h_only = 0; end;

% The tag used to identify pseudmode plots
  pmtag = ['TransientsFig_',num2str(guifig)];

% Get the figures
  figs = get(0,'children');

  cax1 = -inf;
  cax2 = -inf;

% See if there's one already
  fig = -1;
  for i=1:length(figs),
    the_tag = get(figs(i),'Tag');
% Ignore the final character (underscore then type of transient)
    if strcmp(the_tag(1:end-2),pmtag),
      fig = figs(i); 
      cax1 = findobj(fig,'Tag','non_log');
      cax2 = findobj(fig,'Tag','log_axes');
      oftype = the_tag(end);
% If the types don't match, change the Tag
      if ~strcmp(oftype,ftype) & ~strcmp(ftype,'A'),
        type_change = 1;
        set(fig,'Tag',[pmtag '_' ftype]);
% Set the ftype variable to be the actual type (might have been 'A' on input)
     else
        type_change = 0;
        ftype = oftype;
      end;

% If we found the handles we need and don't want a stop button
      if get_h_only~=1 & ~isempty(cax1) & ~isempty(cax2),
        set(cax1,'NextPlot','replacechildren');
        set(cax2,'NextPlot','replacechildren');
        set(cax2,'YScale','log');
% Ensure the axes say the correct thing
        if type_change==1,
          cur_fig = get(0,'CurrentFigure');
          set(0,'CurrentFigure',fig);
          if strcmp(ftype,'P'),
             set(fig,'currentaxes',cax1);
             xlabel('k');
             ylabel('||A^k||');
             title('Linear plot of transient behaviour of ||A^k||','fontweight','bold')
             set(fig,'currentaxes',cax2);
             xlabel('k');
             ylabel('||A^k||');
             title('Logarithmic plot of transient behaviour of ||A^k||','fontweight','bold')
          elseif strcmp(ftype,'E'),
             set(fig,'currentaxes',cax1);
             xlabel('t');
             ylabel('||e^{At}||');
             title('Linear plot of transient behaviour of ||e^{At}||','fontweight','bold')
             set(fig,'currentaxes',cax2);
             xlabel('t');
             ylabel('||e^{At}||');
             title('Logarithmic plot of transient behaviour of ||e^{At}||','fontweight','bold')
          end;
          set(0,'CurrentFigure',cur_fig);
        end;
      elseif get_h_only==1,
        return;
      else
        break;
      end;
    end;
  end;

% If there wasn't one, create a new one
 if fig==-1 & ~get_h_only,
    fig = figure;
    set(fig,'Tag',[pmtag '_' ftype]);
    set(fig,'Name',['Transients associated with EigTool (',num2str(guifig),')']);
    set(fig,'Toolbar','figure');
  elseif get_h_only,
    return;
  end;

% Disable the lower bound option when the figure is closed
  del_fn_t = ['if ishandle(',num2str(guifig),'),'];
  del_fn = ['set(findobj(',num2str(guifig),',''Tag'',''TransientLB''),''Enable'',''off''); '];
  del_fn2 = ['set(findobj(',num2str(guifig),',''Tag'',''TransientBestLB''),''Enable'',''off''); '];
  del_fn = [del_fn_t del_fn del_fn2 ' end; delete(',num2str(fig),')'];
  set(fig,'CloseRequestFcn',del_fn);

% Add the axes
  if ~isempty(cax1) & ~ishandle(cax1),
    cax1 = axes('position',[0.13 0.63 .775 .28]);
    set(cax1,'NextPlot','replacechildren');
    set(cax1,'Tag','non_log');
    set(fig,'currentaxes',cax1);
    if strcmp(ftype,'P'),
      xlabel('k');
      ylabel('||A^k||');
      title('Linear plot of transient behaviour of ||A^k||','fontweight','bold')
    elseif strcmp(ftype,'E'),
      xlabel('t');
      ylabel('||e^{At}||');
      title('Linear plot of transient behaviour of ||e^{At}||','fontweight','bold')
    end;
  end;
  if ~isempty(cax2) & ~ishandle(cax2),
    cax2 = axes('position',[0.13 0.21 .775 .28]);
    set(cax2,'NextPlot','replacechildren');
    set(cax2,'YScale','log');
    set(cax2,'Tag','log_axes');
    set(fig,'currentaxes',cax2);
    if strcmp(ftype,'P'),
      xlabel('k');
      ylabel('||A^k||');
      title('Logarithmic plot of transient behaviour of ||A^k||','fontweight','bold')
    elseif strcmp(ftype,'E'),
      xlabel('t');
      ylabel('||e^{At}||');
      title('Logarithmic plot of transient behaviour of ||e^{At}||','fontweight','bold')
    end;
  end;

%for cax = [cax1 cax2],
%  set(0,'currentfigure',fig)
%  set(fig,'currentaxes',cax);
%  if strcmp(ftype,'P'),
%    xlabel('k');
%    ylabel('||A^k||');
%  elseif strcmp(ftype,'E'),
%    xlabel('t');
%    ylabel('||e^{At}||');
%  end;
%end;

% Add the stop button
  if get_h_only==0,
    cb_str = ['global stop_trans; stop_trans=1; delete(', ...
              'findobj(',num2str(fig),',''Tag'',''Stop!''))'];
    uicontrol('Style','pushbutton', ...
            'callback',cb_str, ...       
            'String','Stop','pos',[220 25 120 30],'Tag','Stop!', ...
            'BackgroundColor',[1 0.352291792379578 0.25431683106714], ...
            'Parent',fig);
  end;

  set(fig,'doublebuffer','on');
