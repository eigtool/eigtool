function [return_now,ps_data] = switch_import(fig,old_ps_data)

% function [return_now,ps_data] = switch_import(fig,old_ps_data)
%
% Function to get a new matrix to compute the pseudospectra of

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Initialise the matrix to go at least once through the loop
    A='error';
    if isfield(old_ps_data,'import_mtx_cmd'),
      the_cmd = old_ps_data.import_mtx_cmd;
    else
      the_cmd = '';
    end;

    ps_data = [];
    return_now = 0;

%% Keep asking until we get a matrix or cancel is chosen
    while strcmp(A,'error'),

%% Display a dialog asking for the data
      new_mtx = inputdlg({['Please enter the name of a variable ' ...
            'containing the matrix, or a command to generate the ' ...
            'matrix you wish to use. See also the `Demos'' menu:']}, ...
       'New Matrix...', 1,{the_cmd});

%% Remove any trailing blanks and save the command
      the_cmd = deblank(char(new_mtx));

%% If user selected cancel or didn't type anything, leave.
      if isempty(the_cmd),
%        return_now = 1;
        return;
      end;

%% Remove ; if it is at the end - causes eval to fail below
      if the_cmd(end)==';',
        the_cmd = the_cmd(1:end-1);
      end;

%% Execute the command to get the data - set A to [] if fail...
      A = evalin('base',the_cmd,'''error''');
      ss = size(A);

      if strcmp('error',A),
        the_err = get(0,'ErrorMessage');
        h=errordlg(['Error: ', ...
                    the_err ' Please try again.'],'modal'); 
        waitfor(h);
      else

%% Now go away and set the GUI up for this matrix, saving the 
%% data after it's been created
        ps_data = new_matrix(A,fig);
        ps_data.import_mtx_cmd = the_cmd;
        set(fig,'userdata',ps_data);

%% Make sure we return here, without changing anything below!
        return_now = 1;
        return;
      end;

    end;

