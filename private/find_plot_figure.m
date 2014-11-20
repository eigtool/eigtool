function fig = find_plot_figure(guifig,mtype)

% function fig = find_plot_figure(guifig,mtype)
%
% This function looks through all the figures to see if there is
% already one for plotting pseudomodes in. If there is, it returns
% the figure number. If not, it creates one.
%
% guifig    The figure number of the parent GUI
% mtype     The type of mode (E)igen or (P)seudo or (R)itz vector.
% 
% fig       The figure number of the pseudomode figure

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues
% Please report bugs and request features at https://github.com/eigtool/eigtool/issues

% The tag used to identify pseudmode plots
  pmtag = ['PseudomodeFig_',num2str(guifig),'_',mtype];

% Get the figures
  figs = get(0,'children');

% See if there's one already
  fig = -1;
  for i=1:length(figs),
    if strcmp(get(figs(i),'Tag'),pmtag),
      fig = figs(i);
      if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me
      return;
    end;
  end;

  if mtype=='P',
    title_str = 'seudomode';
  elseif mtype=='E',
    title_str = 'igenmode';
  elseif mtype=='R',
    title_str = 'itz vector';
  end;

% If there wasn't one, create a new one
 if fig==-1,
    fig = figure;
    set(fig,'Tag',pmtag);
    set(fig,'Name',[mtype,title_str,'s associated with EigTool (',num2str(guifig),')']);
    if ~verLessThan('matlab','8.4'), fig = fig.Number; end        % me
  end;

% Add the menu to allow the figure to be kept
  the_call = 'set(gcbf,''Tag'',''OldPSFig''); delete(findobj(gcbf,''Tag'',''PSModeControls''))';
  h1 = uimenu('Parent',fig, ...
        'Label',['&',mtype,title_str,' Controls'], ...
        'Tag','PSModeControls');
  h2 = uimenu('Parent',h1, ...
        'Callback',the_call, ...
        'Label',['&Keep this ',mtype,title_str], ...
        'Tag','KeepPM');

%% Set the callback for the psmode figure so that it can delete the correct
%% marker when it is closed
  callback_str = ['delete_et_marker(',num2str(fig),',',num2str(guifig),')'];
  set(fig,'CloseRequestFcn',callback_str);

