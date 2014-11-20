function ps_data = switch_fieldofvals(fig,cax,this_ver,ps_data)

% Code to plot the field of values of the matrix, based on 
% Nick Higham's fv.m

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

%% This variable is used to cancel the computation if necessary.
%% Don't want to cancel to start with!
   global stop_comp;
   stop_comp = 0;

%% Save the state of the Go btn for afterwards
   the_handle = findobj(fig,'Tag','RedrawPlot');
   go_state = get(the_handle,'Enable');

   mnu_itm_h = findobj(fig,'Tag','FieldOfVals');
   cur_state = get(mnu_itm_h,'value');
   if cur_state==1,

%% Enable the STOP button
   ps_data = toggle_go_btn(fig,'Stop!','on',ps_data);

% Use the preset number of points if possible
   if isfield(ps_data,'fov_npts'),
     thmax = ps_data.fov_npts;
   else
     thmax = 20;
   end;

%% If there is already computed data, and it was computed with this number
%% of gridpoints, no need to do anything other than display it. Otherwise,
%% must compute the fov.
     if ~isfield(ps_data,'fov') ...
        | length(ps_data.fov) ~= 2*(thmax+1),

%% Asways use the original matrix for computing the field of values
       A = ps_data.schur_matrix;
       [m,n] = size(A);
       z = zeros(2*thmax+1,1);

%% Use a waitbar
       if ps_data.no_waitbar~=1,
         hbar = waitbar(0,'Computing field of values...');
       end;

%% Loop, changing the angle of rotation of the matrix
       for i = 0:thmax,
          if stop_comp==fig,
            if ps_data.no_waitbar~=1,
              close(hbar);
            end;
            h = warndlg('Field of values computation cancelled.','Cancelled...','modal');
            waitfor(h);
            set(mnu_itm_h,'value',0); % reset the state
            ps_data = toggle_go_btn(fig,'Go!',go_state,ps_data);
            return;
          end;
          th = i/thmax*pi;
          Ath = exp(1i*th)*A;               % Rotate A through angle th.
          H = 0.5*(Ath + Ath');             % Hermitian part of rotated A.
          [X, D] = eig(H);
          [lmbh, k] = sort(real(diag(D)));
          z(1+i) = rq(A,X(:,k(1)));         % RQ's of A corr. to eigenvalues of H
          z(1+i+thmax) = rq(A,X(:,k(end)));  % with smallest/largest real part.
          if ps_data.no_waitbar~=1,
            waitbar((i+1)/thmax,hbar);
          end;
       end

       if ps_data.no_waitbar~=1,
         close(hbar);
       end;

%% Want the curve to be closed when plotted 
       z = [z; z(1)];

       ps_data.fov = z;

     end;

     ps_data.show_fov = 1;

%% Check to see whether it intersects the current axes. If not,
%% inform the user that they should zoom out.
     test_gt_r = real(ps_data.fov)>ps_data.zoom_list{ps_data.zoom_pos}.ax(1);
     test_lt_r = real(ps_data.fov)<ps_data.zoom_list{ps_data.zoom_pos}.ax(2);
     test_gt_i = imag(ps_data.fov)>ps_data.zoom_list{ps_data.zoom_pos}.ax(3);
     test_lt_i = imag(ps_data.fov)<ps_data.zoom_list{ps_data.zoom_pos}.ax(4);

     if ~any(test_gt_r & test_lt_r & test_gt_i & test_lt_i),
        h = warndlg(['The boundary of the field of values is not visible' ...
                     ' on the current axes: zoom out with the right mouse' ...
                     ' button to see it.'], ...
                     'Zoom out to see fov...','modal');
        waitfor(h);
     end;

   else
     ps_data.show_fov = 0;

   end;

%% Enable the Go button
   ps_data = toggle_go_btn(fig,'Go!',go_state,ps_data);

%% Add the curve itself to the plot (via redrawcontour)
   ps_data = switch_redrawcontour(fig,cax,this_ver,ps_data);

function z = rq(A,x)
%RQ      Rayleigh quotient.
%        RQ(A,x) is the Rayleigh quotient of A and x, x'*A*x/(x'*x).
z = x'*A*x/(x'*x);





