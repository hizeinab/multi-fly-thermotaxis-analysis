function [y_fitted_data,yy_smooth] = CurveFitter(x , y , options)
% define argument
%https://nl.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
%https://nl.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
arguments
    x (:,:) double
    y (:,:) {double , mustBeEqualSize(y,x)}
    options.window_size {mustBeInteger(options.window_size)} = 9
    options.fit_method {mustBeMember(options.fit_method,['createFit_ss','craeteFit_linear','createFitPoly_best'])} = 'createFit_ss'
end

%% this function uses:
% - createFit_ss.m , craeteFit_linear.m , createFitPoly3.m
% - mustBeEqualSize.m

%% how to call
%CurveFitter(x,y,window_size=9,fit_method='createFit_ss')

%% explanation 
% x , y : point data 
% y_fit : fitted data in each window
% y_fitted_data : final fitted y-data vector
% xx_smooth : apply smmothing spline method on y_fitted_data
%% 1. fit to data in each window  
w = options.window_size;
start =  1;
final = start + w;

count_Frames = length(x);
createFit = str2func(options.fit_method); %https://nl.mathworks.com/matlabcentral/answers/339629-passing-names-of-functions-to-another-function-with-parameters-as-input-in-matlab
% size of Y_MAT
points_in_window = w+1;
if mod(count_Frames-1,w)==0
    col_total = (count_Frames-1)/w;
    Y_mat = NaN(points_in_window,col_total); %round to down
else
    col_total = ceil((count_Frames)/w);
    Y_mat = NaN(points_in_window,col_total);
end

for col=1:col_total
    
    if final <= count_Frames
       y_fit = createFit(x(start:final), y(start:final));
       Y_mat(:,col) = y_fit;    
     
       start = final;
       final = start + w;    
   
    else
        remain_points = count_Frames-start+1;
        final = count_Frames;  
        if remain_points>=2
            y_fit = createFit(x(start:final), y(start:final));
            Y_mat(1:remain_points,col) = y_fit;
        end
    end


end


%% 2. curve must be continuous ... without jump
% Y_mat1 matrix is continuous form of initial matrix Y_mat
Y_mat1 = Y_mat;
%for j=1: col -1 : BECAUSE the last column doesn't need this process
for j=1:col_total -1
     Y_mat1(end,j)= (Y_mat1(end,j)+ Y_mat1(1,j+1))/2;
     Y_mat1(1,j+1)=Y_mat1(end,j);
end


%% 3. delete repetetive frame
y_fitted_data = reshape(Y_mat1,[],1);
y_fitted_data(points_in_window+1:points_in_window:numel(y_fitted_data)) = [];

%% 4. delete the last 0 in X1 mat , number of elements must be equal to number of total frames
y_fitted_data(count_Frames+1:end) = [];

%% 5. new smoothing spline method
yy_smooth = createFit_smooth(x, y_fitted_data);

end