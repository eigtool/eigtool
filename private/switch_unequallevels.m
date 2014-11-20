function ps_data = switch_unequallevels(fig,cax,this_ver,ps_data)

% function ps_data = switch_unequallevels(fig,cax,this_ver,ps_data)
%
% Function called when the 'Unequal Levels' menu option is
% chosen.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

% Initialise so we go at least once through the loop
    new_levels = 'error';
    cur_lev = exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels);

% If only 1 level, only display 1 in the window
    if length(cur_lev)==2 & diff(cur_lev)==0,
      cur_lev = cur_lev(1);
    end;
    initial_text = ['[',num2str(10.^(cur_lev)),']'];


    while strcmp(new_levels,'error'),

      new_levels_cmd = inputdlg({['Please enter a vector of epsilon levels (epsilon>0):']}, ...
                              'New levels...', 1, {initial_text});

%% Remove any trailing blanks
      the_cmd = deblank(char(new_levels_cmd));

%% If user selected cancel or didn't type anything, leave.
      if isempty(the_cmd),
        return;
      end;

%% Remove ; if it is at the end - causes eval to fail below
      if the_cmd(end)==';',
        the_cmd = the_cmd(1:end-1);
      end;

%% Execute the command to get the data - catch if it fails...
      new_levels = evalin('base',the_cmd,'''error''');
   
      if strcmp('error',new_levels),
        the_err = get(0,'ErrorMessage');
        h=errordlg(['Error: ', ...
                    the_err ' Please try again.'],'Error...','modal'); 
        waitfor(h);
        initial_text = the_cmd;
      elseif isempty(new_levels),
        h=errordlg(['Error: This vector is empty. Please try again.'],'Error...','modal'); 
        waitfor(h);
        new_levels = 'error'; % Go round the loop again
        initial_text = the_cmd;
      else
        if ~isempty(find(new_levels==0)),
          h=errordlg(['Sorry, levels must be strictly positive.' ...
                      ' Please try again.'],'Error...','modal'); 
          waitfor(h);
          new_levels = 'error'; % Go round the loop again
          initial_text = the_cmd;
        else
          new_levels = sort(log10(new_levels));
% Remove duplicates
          dd = diff(new_levels);
          new_levels = new_levels([find(dd) end]);
          ps_data.zoom_list{ps_data.zoom_pos}.levels = comp_lev(new_levels);
          ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);
          return;
        end;
      end;
    end;














