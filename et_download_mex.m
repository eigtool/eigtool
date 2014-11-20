function et_download_mex

% function et_download_mex
%
% Function to display a dialog box indicating where to download
% mex files from

% Version 2.4.1 (Wed Nov 19 21:54:20 EST 2014)
% Copyright (c) 2002-2014, The Chancellor, Masters and Scholars
% of the University of Oxford, and the EigTool Developers. All rights reserved.
% EigTool is maintained on GitHub:  https://github.com/eigtool
% Report bugs/request features at https://github.com/eigtool/eigtool/issues

if exist('psacore')~=3,
   ButtonName=questdlg(['This version of EigTool is implemented entirely with m-files. ' ...
                        'By downloading compiled MEX files for your system, it is possible ' ...
                        'to speed up pseudospectra computations by a factor of up to 3.'], ...
                       'MEX files...', ...
                       'Download MEX files','OK','Download MEX files');

   if strcmp(ButtonName,'Download MEX files'),
     web('http://www.comlab.ox.ac.uk/pseudospectra/eigtool/download/');
   end;
else
   h = msgbox('You are already using EigTool''s MEX files - no further speedups are currently possible.', ...
              'MEX files...','modal');
   waitfor(h); 
end;
