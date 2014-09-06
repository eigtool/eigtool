function build_numbers_menu(fig)

% function build_numbers_menu(fig)
%
% Function to build the menu of number calculators. This is based
% on files found in the num_comp directory within the eigtool
% directory tree.
%
% fig    the figure number of the GUI to create the menu in

% First, work out where eigtool is
loc = et_get_file_location('eigtool');
loc2 = et_get_file_location('startup');

% This is where the number computation routines are stored
% - add it to the path
num_dir_loc = [loc 'num_comp/'];
addpath(num_dir_loc)

% What files are there in that directory?
num_comps = what(num_dir_loc);
routines = sortrows(num_comps.m);
num_routines = length(routines);

% If we've actually got some routines, set up the menu
if num_routines>0,

% Create the menu
  mnu_h = uimenu('Parent',fig, ...
          'Label','&Numbers', ...
          'Tag','NumbersMenu');

% Get the menu text for each routine
  for i=1:num_routines,

% Call the routine (removing the '.m' from the end)
    routine = routines{i};
    routine = routine(1:end-2);
    [routine_name,mtx_type,mtx_shape] = feval(routine,'name');

% Package up the data
    routine_data.mtx_type = mtx_type;
    routine_data.mtx_shape = mtx_shape;

% Set the callback string, used when the menu item is selected
    cb_str = ['et_call_num_comp(''',routine,''',',num2str(fig),');'];

% Add the item to the menu
    h2 = uimenu('Parent',mnu_h, ...
            'Callback',cb_str, ...
            'Label',routine_name, ...
            'Tag',routine, ...
            'UserData',routine_data);
   
  end;

% One final menu option to toggle display of the points these
% quantities are attained at (if applicable). This item is always
% available.
  routine_data.mtx_type = 'b';
  routine_data.mtx_shape = 'b';
  h2 = uimenu('Parent',mnu_h, ...
          'Callback','eigtool_switch_fn(''DisplayPoints'');', ...
          'checked','on', ...
          'Label','Display Points', ...
          'Separator','on', ...
          'Tag','DisplayPoints', ...
          'UserData',routine_data);

end;
