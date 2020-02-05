function get_rotation_kb(pixSize)

    % load an image, rotate, save rotation angle ('rot_angle_XXXX.txt')
    
    % zoom magnification
    zoomr = 11;
    
    % ask user for image and load
    [image1, pathname] = uigetfile('*.tif', 'select BrightField file', 'select BrightField file');
    if ~image1, return, end
    data_orig = imread([pathname, image1]);
    [~, suffix, ~] = fileparts(image1);
    
    % adjust contrast
    data_orig = imresize(data_orig,zoomr,'nearest');
    data_orig = double(imadjust(data_orig,stretchlim(data_orig, [0 1])))/(2^17-1);
    
    % show image
    h1 = figure(sum('PALM'));
    clf; imagesc(data_orig); axis equal; axis off; colormap(gray);
    iptsetpref('ImshowInitialMagnification','fit'); 
    iptsetpref('ImshowBorder','tight');  
    title('Click on the two cell poles')
    set(h1,'KeyPressFcn',@handleKeyNone,'Name','Rotate image','NumberTitle','off','Position',[50,50,1000,600]);            
    
    % keep rotating until it's right
    keepGoing = true;
    while keepGoing
        
        % select one band to define the rotation angle (in degrees)
        [x,y] = ginput(2); % get length of cell
        xy = [x,y];
        % select one band to define the short axis and cell middle
        [w,z] = ginput(2); % get width of cell
        wz = [w,z];
        max_length = sqrt((x(1)-x(2))^2+(y(1)-y(2))^2)/zoomr; % size in pixels
        max_length = max_length*pixSize/1000; %length in um
        max_width = sqrt((w(1)-w(2))^2+(z(1)-z(2))^2)/zoomr;
        max_width = max_width*pixSize/1000;
        Band_angle = atand(slope(xy));
        
        % define the center of the image
        size(data_orig,1)
        size(data_orig,2)
        center=size(data_orig)/2+0.5;
        
        % rotate the two lines you drew
        xy_rot = rotate_point(xy, Band_angle, center);
        wz_rot = rotate_point(wz, Band_angle, center);
        
        % find the intersection of the two lines, then rotate that point
        orig = two_line_intersection(xy,wz)/zoomr;
        orig_rot = rotate_point(orig,Band_angle,center);
        orig_rot = two_line_intersection(xy_rot,wz_rot)/zoomr;
        
        % display the rotated data
        data_rotated = imrotate(data_orig,Band_angle,'nearest','crop');
        imagesc(data_rotated); axis equal; axis off; colormap(gray)
        hold on
        plot(x,y,'--r')
        plot(w,z,'--g')
        plot(xy_rot(:,1),xy_rot(:,2),'--m')
        plot(wz_rot(:,1),wz_rot(:,2),'--b')
        plot(orig(1,1)*zoomr,orig(1,2)*zoomr,'yo','MarkerSize',16)
        plot(orig_rot(1)*zoomr,orig_rot(2)*zoomr,'co','MarkerSize',16)
        
    
        % ask user if it's ok
        button = questdlg('Did it rotate correctly?','Rotation','Yes','No - try again', 'No - quit', 'Yes');
        switch button
            case 'Yes'
                keepGoing = false;
                title(['Rotation angle: ' num2str(Band_angle,3) ' degrees'])
                [token, remain]=strsplit(image1,'.');
                imwrite(data_rotated,strcat(token{1},'_rotated.',token{2}))
            case 'No - try again'
                imagesc(data_orig); axis equal; axis off; colormap(gray);
                title('Click on two ends of the band')
            otherwise  
                keepGoing = false;
                return    
        end       
 
    end
    
    drawnow
    
    % save rotation angle
    save([pathname 'rot_angle_' suffix '.txt'], '-ascii', 'Band_angle')
    save([pathname,'trans_mat_' suffix '.txt'], '-ascii', 'orig_rot')
    save([pathname,'max_width.txt'], '-ascii', 'max_width')
    save([pathname,'max_length.txt'], '-ascii', 'max_length')
    
end
    
    
   