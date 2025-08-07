function theta11 = DirectionAngle_calculation(v_x , v_y)
% define argument
%https://nl.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
%https://nl.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
arguments
    v_x (:,:) double
    v_y (:,:) {double , mustBeEqualSize(v_y,v_x)}
end

%% this function uses:
% - mustBeEqualSize.m

%% code
%% my method for  # adjust to correct angle
theta1 = atand(v_y./v_x); 
theta11 = nan(length(theta1),1);
for i=1:length(theta1)
    if (v_y(i)>=0 && v_x(i)>=0)
        theta11(i) = theta1(i);
    elseif (v_y(i)>=0 && v_x(i)<0) 
        theta11(i) = 180 - abs(theta1(i));
    elseif (v_y(i)<0 && v_x(i)<0)
        theta11(i) = theta1(i) + 180;
    elseif (v_y(i)<0 && v_x(i)>=0)
        theta11(i) = 360 - abs(theta1(i));
    elseif theta1(i) == -90
        theta11(i) = 270;
    end
end


% for i=2:length(theta11)
%     if (theta11(i)==0 && theta11(i-1)>270)
%         theta11(i)=360;
%     end
% end

%% my second method for # adjust to correct angle
% % instead of all we could say atan2d(del_y1,del_x1) ; gives thata in range
% % [-pi,pi]
% theta = atan2d(del_y1,del_x1);
% for i=1:length(theta)
%     if (theta(i)==-180 && theta(i-1)<=180 && theta(i-1)>90)
%         theta(i) = 180;
%     elseif (theta(i)==180 && theta(i-1)>=-180 && theta(i-1)<-90)
%         theta(i) = -180;
%     end
% end

%% movekit correction
% theta12 = nan(length(theta1),1);
% theta12(1) = nan;
% for i=2:length(theta1)
%     if (del_y1(i)>=0 && del_x1(i)>=0)
%         theta12(i) = theta1(i);
%     elseif (del_y1(i)>=0 && del_x1(i)<0) 
%         theta12(i) = 180 + theta1(i);
%     elseif (del_y1(i)<0 && del_x1(i)<0)
%         theta12(i) = theta1(i) + 180;
%     elseif (del_y1(i)<0 && del_x1(i)>=0)
%         theta12(i) = 360 + theta1(i);
%     end
% end
end