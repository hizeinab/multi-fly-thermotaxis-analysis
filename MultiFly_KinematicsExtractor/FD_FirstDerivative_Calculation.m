function  x_dot = FD_FirstDerivative_Calculation(x_smooth, options)

arguments
    x_smooth (:,:) double
    options.fps double = 30

end
%% Using Central Finite Difference Method for velocity in x and y direction
%https://en.wikipedia.org/wiki/Finite_difference#:~:text=If%20a%20finite%20difference%20is,equations%2C%20especially%20boundary%20value%20problems.
%https://en.wikipedia.org/wiki/Finite_difference_coefficient


count_Frames = length(x_smooth);
x_dot = NaN(count_Frames,1);
dt = 1/options.fps;
%% Forward Finite Difference - derivative 1 - accuracy 6
for i=1:4
    x_dot(i) = ((-49/20)*x_smooth(i) + (6)*x_smooth(i+1) + (-15/2)*x_smooth(i+2)...
        + (20/3)*x_smooth(i+3) + (-15/4)*x_smooth(i+4)...
        + (6/5)*x_smooth(i+5) + (-1/6)*x_smooth(i+6))/dt;
end
%% Central Finite Difference - derivative 1 - accuracy 8
for i=5:count_Frames-4    
    x_dot(i) = ((1/280)*x_smooth(i-4)+(-4/105)*x_smooth(i-3)+(1/5)*x_smooth(i-2)...
        +(-4/5)*x_smooth(i-1)+(4/5)*x_smooth(i+1)...
        +(-1/5)*x_smooth(i+2)+(4/105)*x_smooth(i+3)+(-1/280)*x_smooth(i+4))/dt;    
end

%% Backward Finite Difference - derivative 1 - accuracy 6
for i=count_Frames-3:count_Frames    
    x_dot(i) = ((49/20)*x_smooth(i) + (-6)*x_smooth(i-1) + (15/2)*x_smooth(i-2)...
        + (-20/3)*x_smooth(i-3) + (15/4)*x_smooth(i-4)...
        + (-6/5)*x_smooth(i-5) + (1/6)*x_smooth(i-6))/dt;    
end

% convert to vector
x_dot = reshape(x_dot,[count_Frames,1]);
end