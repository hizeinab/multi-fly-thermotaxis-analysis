function X_Smooth = createFit_smooth(tt, X1_new_copy)


[xData, yData] = prepareCurveData( tt, X1_new_copy );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.995;

% Fit model to data.
[fitresult_smooth, gof_smooth] = fit( xData, yData, ft, opts );
% disp('SMOOTHing with smoothing parameter =');
% disp(opts.SmoothingParam);

% disp(fitresult_smooth);
% disp(' r-square after smoothing the whole curve on fitted data =');
% disp(gof_smooth.rsquare);
X_Smooth = feval(fitresult_smooth,tt);

end




