function ps_data = switch_filesave(fig,ps_data,saveas)

% function ps_data = switch_filesave(fig,ps_data,saveas)
%
% Function to remove the unitary matrix from the GUI's data
% structure if it is too large and the user doesn't want to 
% save it.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

[m,n] = size(ps_data.unitary_mtx);
if isreal(ps_data.unitary_mtx),
  var_space = 8;
else
  var_space = 16;
end;

% Calculate the memory needed by this matrix (in kB)
unit_m_mem = prod([m n var_space])/1024;

% If it's bigger than 500kB, ask the user whether they want to save it
if unit_m_mem > 500,
    if unit_m_mem>1024, % Convert to a nicer number if it's very large
      unit_m_mem = unit_m_mem/1024;
      units = 'M';
    else
      units = 'k';
    end;
    opts.CreateMode = 'modal';
    opts.Default = 'Yes';
    opts.Interpreter = 'none';
    quest_str = ['Do you want to save the unitary matrix that is using ', ...
                 num2str(unit_m_mem,'%15.1f'),units,'B of memory? This is only needed for' ...
                 ' pseudomode computation.'];
    button = questdlg(quest_str,'Save unitary matrix?','Yes','No','Cancel',opts);
    switch button
    case 'Yes' % Do nothing
    case 'No'
      ps_data.unitary_mtx = []; % Delete it
      ps_data.input_unitary_mtx = []; % Delete it
      ps_data.schur_unitary_mtx = []; % Delete it
      ps_data.proj_unitary_mtx = []; % Delete it
      set(fig,'userdata',ps_data);
    case 'Cancel'
      return;
    end;

end;

% Save the figure using the standard call
if saveas,
  filemenufcn(fig,'FileSaveAs');
else
  filemenufcn(fig,'FileSave');
end;


