function ps_data = switch_method(fig,cax,this_ver,ps_data,btn,set_only)

% function ps_data = switch_method(fig,cax,this_ver,ps_data,btn)
%
% Function called when either of the Direct/Iterative radio
% buttons are chosen.

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

     fov_hdl = findobj(fig,'Tag','FieldOfVals');
     [m,n] = size(ps_data.input_matrix);

% Set the radio buttons correctly
     if strcmp(btn,'Direct'), 
       set(findobj(fig,'Tag','Direct'),'value',1);
       set(findobj(fig,'Tag','Iterative'),'value',0);
       set(findobj(fig,'Tag','Iterative'),'Callback','eigtool_switch_fn(''Iterative'')');
% Change back to the input matrix if we have a dense square matrix
       if isfield(ps_data,'schur_matrix'),
         ps_data.matrix = ps_data.schur_matrix;
         ps_data.ews = ps_data.orig_ews;
% These are not estimates, so should be plotted in black
         ps_data.ew_estimates = 0;
% If we have a sparse, square matrix, get rid of any ARPACK compression
       elseif m==n & issparse(ps_data.input_matrix),
         ps_data.matrix = ps_data.input_matrix;
       end;
% If there is a unitary matrix from the Schur decomposition, use that
% Otherwise, use the unitary matrix (optionally) input by the user
       if isfield(ps_data,'schur_unitary_mtx'),
         ps_data.unitary_mtx = ps_data.input_unitary_mtx*ps_data.schur_unitary_mtx;
       else
         ps_data.unitary_mtx = ps_data.input_unitary_mtx;
       end;
       ps_data.proj_valid = 0;

% If we're reverting to a square matrix, no longer have ARPACK projection
       ss = size(ps_data.matrix);
       if ss(1)==ss(2), ps_data.isHessenberg = 0; end;

% Only enable this if the pseudospectra have actually been computed % mpe (and have Schur factorization)
       if isfield(ps_data.zoom_list{ps_data.zoom_pos},'computed')&isfield(ps_data,'schur_matrix'), %mpe
         set(fov_hdl,'Enable','on');
       end;
       
       state = 'off';
     else
       set(findobj(fig,'Tag','Direct'),'value',0);
       set(findobj(fig,'Tag','Iterative'),'value',1);
       if ~isfield(ps_data,'schur_matrix')  % mpe
          set(fov_hdl,'Enable','off');
  %       fprintf('turing fov off: have Schur? %d\n', isfield(ps_data,'schur_matrix'));
       end
       state = 'on';
     end;

% Now enable/disable the ARPACK controls
     set(findobj(fig,'Tag','ARPACK_k'),'Enable',state);
     set(findobj(fig,'Tag','Which'),'Enable',state);
     set(findobj(fig,'Tag','ARPACKMenu'),'Enable',state);

% Enable the Go button
     if nargin<6 | set_only==0,
       ps_data = update_messagebar(fig,ps_data,33,1);
       ps_data = toggle_go_btn(fig,'Go!','on',ps_data);
     end;
