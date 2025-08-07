function T = Add_orientation_Info(T , vid, n_fly)
% find orientation of each fly in every frames
for frame_no = unique(T.frame)'
    orient = NaN(n_fly,1);
    img = read(vid,frame_no+2);
    
    for id_desire = 1:n_fly
        w_search = 50; %width of searching bb
        orient(id_desire) = Orientation_id(T, img, frame_no, id_desire, w_search);
    end
    T.orienatation(T.frame==frame_no) = orient;
end

fps = vid.FrameRate;
time_frames = (unique(T.frame) - 1)/fps;

% find turning angle and angular velocity of each fly during experiment
for id_desire = 1:n_fly
    % turning angle
    orient_id = T.orienatation(T.id==id_desire);
    change_orient_id_revised = NaN(size(orient_id));
    for frame_no = 2:length(orient_id)
        Max_Orient_Change = 90; %Max change in direction between 2 consequative frames
        change_orient_id_revised(frame_no) = Change_Orient_id(orient_id(frame_no - 1) , orient_id(frame_no) , Max_Orient_Change); 
    end
    orient_ascending_smooth_id = Orientation_Smooth(orient_id , change_orient_id_revised, time_frames);
    turning_angle_id = [NaN ; diff(orient_ascending_smooth_id)];
    T.turning_angle(T.id == id_desire) = turning_angle_id;
    
    % angular velocity
    w_smooth_id = Angular_Velocity_id(orient_ascending_smooth_id, time_frames);
    T.angular_velocity(T.id == id_desire) = w_smooth_id;

end




%% local functions

function orient = Orientation_id(csv_table, img, frame_no, id_desire, w_search)
% 1) this function find the orientation of each fly by thresholding in its corresponding Bounding Box

xc = csv_table.xc(csv_table.id==id_desire & csv_table.frame==frame_no);
yc = csv_table.yc(csv_table.id==id_desire & csv_table.frame==frame_no);

w = w_search;

min_x = floor(xc - w/2);
min_y = floor(yc - w/2);
max_x = ceil(xc + w/2);
max_y = ceil(yc + w/2);

frame_crop = img(min_y:max_y , min_x:max_x);

level = graythresh(frame_crop); 
gray = im2gray(frame_crop);
seg_I = imbinarize(gray,level); %binarize with otsu's threshold
kernel = ones(3);
%closeBW = imclose(seg_I,kernel);
OpenBW = imopen(seg_I,kernel);

Remove_small = bwareaopen(OpenBW,60,4); %detect small regions which their area is less than 60pixel and with connectivity 4

%[labeledImage, numberOfBlobs] = bwlabeln(Remove_small==0 , 4); %remove small regions
[labeledImage, ~] = bwlabeln(Remove_small==0 , 4); %remove small regions

labeledImage_Extractlargestregion = bwpropfilt(logical(labeledImage),'Area',1); %bwareafilt(logical(labeledImage),1)

measurements = regionprops(labeledImage_Extractlargestregion, 'Centroid' , ...
    'FilledImage', ...
    'FilledArea' , ...
    'MajorAxisLength',...
    'MinorAxisLength',...
    'Orientation', ...
    'Area');

orient = measurements.Orientation;


% figure;
% imshow(labeledImage_Extractlargestregion);
% t = linspace(0,2*pi,50);
% a = measurements.MajorAxisLength/2;
% b = measurements.MinorAxisLength/2;
% Xc = measurements.Centroid(1);
% Yc = measurements.Centroid(2);
% phi = deg2rad(measurements.Orientation);
% x = Xc + a*cos(t)*cos(phi) + b*sin(t)*sin(phi);
% y = Yc - a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
% hold on;
% plot(x,y,'r','Linewidth',1);

end


function turning_angle = Change_Orient_id(o1 , o2 , Max_change)
% 2) this function initialize turning-angle for each fly
del_theta = o2 - o1;
turning_angle = del_theta;

if (o1<0 && o2>0 && del_theta>Max_change) %CW ..> -
    sign = -1;
    turning_angle = sign * abs(180 - del_theta);

elseif (o1<0 && o2>0 && del_theta<Max_change) %CCW ..> -
    sign = +1;
    turning_angle = sign * abs(del_theta);

elseif (o1>0 && o2<0 && del_theta<-Max_change) %CCW
    sign = +1;
    turning_angle = sign  * abs(180 + del_theta);

elseif (o1>0 && o2<0 && del_theta>-Max_change) %CW
    sign = -1;
    turning_angle = sign  * abs(del_theta);

elseif ((o1>0 && o2>0) || (o1<0 && o2<0)) %the sign is = sign(delta_theta) 
    turning_angle = del_theta;

end
end

function orient_ascending_smooth = Orientation_Smooth(orient_id , Revised_change_orient_id, time_frames)
% 3) this function smooth the orientation angle of body

orient_ascending = NaN(size(orient_id));
% orient_180 = NaN(size(orient_id));
orient_ascending(1) = orient_id(1);
% orient_180(1) = orient_id(1);

for i=2:length(orient_id)
    orient_ascending(i) = orient_ascending(i-1)+Revised_change_orient_id(i);
    
%     if orient_ascending(i)>180
%         orient_180(i) = orient_ascending(i) - 360;
%     elseif orient_ascending(i)<-180
%         orient_180(i) = 360 + orient_ascending(i);
%     else
%         orient_180(i) = orient_ascending(i);
%     end
end

[~ , orient_ascending_smooth] = CurveFitter(time_frames , orient_ascending, 'window_size', 9 , 'fit_method', 'createFit_ss');


end

function [w_smooth] = Angular_Velocity_id(orient_ascending_smooth, time_frames)
% 4) this function calculate angular-velocity for each fly
fps = 1/ (time_frames(2) - time_frames(1));
w = gradient(orient_ascending_smooth)*fps;
[~ , w_smooth] = CurveFitter(time_frames , w, 'window_size', 9 , 'fit_method', 'createFit_ss');

end

end