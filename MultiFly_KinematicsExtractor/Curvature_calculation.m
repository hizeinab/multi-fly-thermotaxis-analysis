function k = Curvature_calculation(vx , vy , ax , ay , options)
% define argument
%https://nl.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
%https://nl.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
arguments
    vx (:,:) double
    vy (:,:) {double , mustBeEqualSize(vy,vx)}
    ax (:,:) {double , mustBeEqualSize(ax,vx)}
    ay (:,:) {double , mustBeEqualSize(ay,ax)}
    options.calculation_method {mustBeMember(options.calculation_method,['3d' , '2d'])} = '2d'

end

%% this function uses:
% - mustBeEqualSize.m

%% how to call
%Curvature_calculation(vx , vy , ax , ay , calculation_method='2d')

%% code
count_Frames = length(vx);
if all(options.calculation_method =='3d')
    
    Velocity(:,1) = vx;
    Velocity(:,2) = vy;
    Velocity(:,3) = zeros(count_Frames,1);

    Acceleration(:,1) = ax;
    Acceleration(:,2) = ay;
    Acceleration(:,3) = zeros(count_Frames,1);

    k = NaN(count_Frames,1);
    
    for i=1:count_Frames
        num = norm(cross(Velocity(i,:),Acceleration(i,:)));
        den = (norm(Velocity(i)))^3;
        k(i)= num/den;
    end

    k = reshape(k,[count_Frames,1]);

elseif all(options.calculation_method =='2d')

    k = NaN(count_Frames,1);
    for i=1:count_Frames
        k(i) = abs(vx(i) * ay(i) - vy(i) * ax(i) ) /...
        ((vx(i))^2 + (vy(i))^2)^(3/2);
    end
    k = reshape(k,[count_Frames,1]);
end
end
