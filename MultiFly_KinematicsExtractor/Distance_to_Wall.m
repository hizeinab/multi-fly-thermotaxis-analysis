function shortest_dist = Distance_to_Wall(x,y,options)
arguments
    x (:,:) double
    y (:,:) {double , mustBeEqualSize(y,x)}
    options.x_center_chamber double % x value of the center of circular chamber (x value - wall circle)
    options.y_center_chamber double % y value of the center of circular chamber (y value - wall circle)
    options.Radius_chamber double % radius of circular chamber
end
frame_no = length(x);
a = repmat(options.x_center_chamber,frame_no,1);
b = repmat(options.y_center_chamber,frame_no,1);
R = repmat(options.Radius_chamber,frame_no,1);
%% program to find the Shortest distance between a point and a circle
%each point = P = (x(i),y(i))
OP = sqrt( (x-a).^2 + (y-b).^2); %distance between point and center
shortest_dist = abs(R  - OP);
end

