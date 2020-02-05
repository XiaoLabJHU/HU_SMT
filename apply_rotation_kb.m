function apply_rotation_kb()

    % load coordinates and rotation angle, rotate, save new coordinates

    % ask user for coordinates
    [filename, pathname] = uigetfile('*.mat', 'select Coordinate file', 'select Coordinate file');
    if ~filename, return, end
    data_orig = load([pathname, filename]);
    [~, prefix, ~] = fileparts(filename);
    
    % code to get actual structure with coordinates
    m=fieldnames(data_orig);
    varname=sprintf('data_orig.%s',m{1,1});
    data_orig=eval(varname);
    
    % ask user for rotation angle
    [filename, pathname] = uigetfile('*.txt', 'select Rotation file', 'select rotation file');
    if ~filename, return, end
    Band_angle = load([pathname, filename]);
    
    % ask user for translation point
    [filename, pathname] = uigetfile('*.txt', 'select translation file', 'select translation file');
    if ~filename, return, end
    orig = load([pathname, filename]);
    
    data_rotated = data_orig;
    data_norm = data_orig;
    
    % set cell center
    img_center = [20.5 20.5];
    
    for i=1:length(data_orig.TracksROI)
        % extract coordinates
        coords_orig = data_orig.TracksROI(i).Coordinates(:,2:3);     % change these columns to match your data
        coords_rotated=[];
        coords_norm=[];
        
        % rotate the x/y coordinates, then translate the x/y coordinates
        coords_rotated = rotate_point(coords_orig,Band_angle,img_center); 
        coords_norm(:,1) = coords_rotated(:,1) - orig(1,1);
        coords_norm(:,2) = coords_rotated(:,2) - orig(1,2);
        
        % insert rotated coords back into the original file structure
        data_rotated.TracksROI(i).Coordinates(:,2:3) = coords_rotated;
        data_norm.TracksROI(i).Coordinates(:,2:3) = coords_norm;
        
    end
    
    % show scatterplot of rotated coordinates
    %h1 = figure(sum('PALM'));
    %set(figure(h1),'KeyPressFcn',@handleKeyNone,'Name','Rotate image','NumberTitle','off','Position',[50,50,1000,600]);
    %scatter(coords_rotated(:,1), coords_rotated(:,2), 50, 'b', 'fill')
    %box on; axis equal
    %title('rotated coordinates')
    %xlabel('X'); ylabel('Y')
    
    
    
    % save rotated coordinates
    save([ pathname prefix '_rotated.mat'], 'data_rotated');
    save([ pathname prefix '_norm.mat'], 'data_norm');