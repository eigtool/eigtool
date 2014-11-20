function ps_data = switch_createcode(fig,cax,ps_data)

% function ps_data = switch_createcode(fig,cax,ps_data)
%
% Function to output code which can be pasted into documents
% to create this figure in the future, exactly as it is now
% (N.B. by recomputing the data)

% Version 2.4.1 (Wed Nov 19 21:54:21 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

    disp(' ');
    disp('% Run the following commands to set up the necessary');
    disp('% options to create a printable plot of the pseudospectra.');
    disp('% Create the plot using ''eigtool(A,opts)'' where A is your matrix.');
    disp('% (If you are using eigs, simply pass these options along with');
    disp('% the eigs options to eigs itself.)');
    disp(['opts.npts=',num2str(ps_data.zoom_list{ps_data.zoom_pos}.npts),';']);

% Try to create the levels in code form if possible
    levs = ps_data.zoom_list{ps_data.zoom_pos}.levels;
    if levs.iseven==1, % If they're equally spaced
      disp(['opts.levels=',num2str(levs.first),':', ...
                            num2str(levs.step),':', ...
                            num2str(levs.last),';']);
    else
      disp(['opts.levels=[',num2str(exp_lev(ps_data.zoom_list{ps_data.zoom_pos}.levels)),'];']);
    end;

    disp(['opts.ax=[',num2str(ps_data.zoom_list{ps_data.zoom_pos}.ax),'];']);
    disp(['opts.proj_lev=',num2str(ps_data.zoom_list{ps_data.zoom_pos}.proj_lev),';']);
    if strcmp(get(findobj(fig,'Tag','Colour'),'checked'),'on'), colour = 1;
    else colour= 0; end;
    disp(['opts.colour=',num2str(colour),';']);
    if strcmp(get(findobj(fig,'Tag','ThickLines'),'checked'),'on'), thicklines = 1;
    else thicklines = 0; end;
    disp(['opts.thick_lines=',num2str(thicklines),';']);
    disp(['opts.scale_equal=',num2str(get(findobj(fig,'Tag','ScaleEqual'),'Value')),';']);
    if strcmp(get(findobj(fig,'Tag','ShowGrid'),'checked'),'on'), show_grid = 1;
    else show_grid = 0; end;
    disp(['opts.grid=',num2str(show_grid),';']);
    if strcmp(get(findobj(fig,'Tag','ShowDimension'),'checked'),'on'), show_dim = 1;
    else show_dim = 0; end;
    disp(['opts.dim=',num2str(show_dim),';']);
    if strcmp(get(findobj(fig,'Tag','DisplayEWS'),'checked'),'on'), no_ews = 0;
    else no_ews = 1; end;
    disp(['opts.no_ews=',num2str(no_ews),';']);
    if strcmp(get(findobj(fig,'Tag','DisplayPSA'),'checked'),'on'), no_psa = 0;
    else no_psa = 1; end;
    disp(['opts.no_psa=',num2str(no_psa),';']);
    disp(['opts.fov=',num2str(get(findobj(fig,'Tag','FieldOfVals'),'Value')),';']);
    if strcmp(get(findobj(fig,'Tag','DisplayColourbar'),'checked'),'on'), cbar = 1;
    else cbar = 0; end;
    disp(['opts.colourbar=',num2str(cbar),';']);
    if strcmp(get(findobj(fig,'Tag','DisplayImagA'),'checked'),'on'), imaga = 1;
    else imaga = 0; end;
    disp(['opts.imag_axis=',num2str(imaga),';']);
    if strcmp(get(findobj(fig,'Tag','DisplayUnitC'),'checked'),'on'), unitc = 1;
    else unitc = 0; end;
    disp(['opts.unit_circle=',num2str(unitc),';']);

    direct = get(findobj(fig,'Tag','Direct'),'Value');
    disp(['opts.direct=',num2str(direct),';']);
    if direct==0,
      disp(['opts.k=',get(findobj(fig,'Tag','ARPACK_k'),'String'),';']);
      disp(['opts.which=''',ps_data.ARPACK_which,''';']);
      if ~strcmp(ps_data.ARPACK_p,'auto'), 
        disp(['opts.p=',num2str(ps_data.ARPACK_p),';']);
      end;
      if ~strcmp(ps_data.ARPACK_tol,'auto'), 
        disp(['opts.tol=',num2str(ps_data.ARPACK_tol),';']);
      end;
      if ~strcmp(ps_data.ARPACK_maxit,'auto'), 
        disp(['opts.maxit=',num2str(ps_data.ARPACK_maxit),';']);
      end;
      if ~strcmp(ps_data.ARPACK_v0,'auto'), 
        disp(['opts.v0=eval(''',ps_data.ARPACK_v0_cmd,''');']);
      end;
    end;
    disp('opts.print_plot=1;');

    disp(' ');
    disp('Press <RETURN> to continue...');
