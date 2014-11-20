function ps_data = switch_demo(fig,ps_data,the_demo)

% function ps_data = switch_demo(fig,ps_data,the_demo)
%
% Function to get a demo matrix to compute the pseudospectra of

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% Should we be using the fine or coarse grid?
    mnu_itm_h = findobj(fig,'Tag','FinerGrid');
    cur_state = get(mnu_itm_h,'checked');
    if strcmp(cur_state,'on'),
      grid_size = 'F';
    else
      grid_size = 'C';
    end;

%% Extract the options code from the end of the input
%% Last character is matrix size (L)arge or (S)mall,
%% or (C)ode
    specific_opts = the_demo(end);
    the_demo = the_demo(1:end-1);

%% If we're just printing out the code, set a dummy matrix size
    if strcmp(specific_opts,'C'),
      mtx_size = 'S';
    else
      mtx_size = specific_opts;
    end;

% Get the parameters and name of the routine
    [N,opts,routine] = set_demo_params(mtx_size,grid_size,the_demo);

% Display the code for the routine, or actually execute it
    if strcmp('C',specific_opts),
      type(routine);
      disp('Press <RETURN> to continue...');
      return;
    else
%% Don't want the user to be able to press anything
      disable_controls(fig);

%% Display a message to reassure the user in case the matrix
%% takes some time to generate
      ps_data = update_messagebar(fig,ps_data,38);

%% Calculate the matrix
      mtx = feval(routine,N);        
    end;

    arpack_zoom_message(opts);

%% Now go away and set the GUI up for this matrix
    ps_data = new_matrix(mtx,fig,opts);

% Give a message if doing ARPACK stuff, since may wish to zoom
% during computation
function arpack_zoom_message(opts)

% If no 'which' field, not ARPACK computation, so no message needed
if ~isfield(opts,'which'), return; end;

show_box = 0;

switch opts.which
case {'LM','BE'}
case 'SM'
  portion = 'central';
  show_box = 1;
case 'LR'
  portion = 'rightmost';
  show_box = 1;
case 'SR'
  portion = 'leftmost';
  show_box = 1;
case 'LI'
  portion = 'topmost';
  show_box = 1;
case 'SI'
  portion = 'bottommost';
  show_box = 1;
case 'LA'
  portion = 'leftmost';
  show_box = 1;
case 'SA'
  portion = 'rightmost';
  show_box = 1;
otherwise
end;

if show_box,
  h = msgbox(['As the computation for this demo proceeds, most of the interesting ' ...
          'action occurs at the ', portion,' part of the spectrum. You may wish ' ...
          'to pause the computation and zoom in during the execution.'],'modal');
  waitfor(h);
end;




