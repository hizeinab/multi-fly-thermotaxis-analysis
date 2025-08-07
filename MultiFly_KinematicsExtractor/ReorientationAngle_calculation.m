function del_theta = ReorientationAngle_calculation(theta)
% define argument
%https://nl.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
%https://nl.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
arguments
    theta (:,:) double
end


%% explanation 
%Computes the turning angle for a mover between two timesteps
% as the difference of its direction angle. Only possible for 2D data.
%% code

%theta = direction angle ; 
%del_theta = calculate difference in direction angle between current and previous timestamp
del_theta = [ nan ; diff(theta)]; 

%when differences exceed |180| convert values so that they stay in the domain -180 +180
% for i=2:length(del_theta)
%     if del_theta(i)>180
%         del_theta(i) = 360 - del_theta(i);
%     elseif del_theta(i)<-180
%         del_theta(i) = -360 - del_theta(i);
%     end 
% end

%sign + : CCW (Counter ClockWise) , sign - : CW (ClockWise)
for i=1:length(del_theta)
    if del_theta(i)>180 %CW ..> -
        %sign = -1;
        del_theta(i) = -abs(360 - del_theta(i));
    elseif del_theta(i)<-180 %CCW
        %sign = +1;
        del_theta(i) = abs(360 + del_theta(i));
    elseif (del_theta(i)<180 && del_theta(i)>0) %CCW
        %sign = +1;
        del_theta(i) = abs(del_theta(i));
    elseif (del_theta(i)>-180 && del_theta(i)<0) %CW
        %sign = -1;
        del_theta(i) = -abs(del_theta(i));
    end 
end
end