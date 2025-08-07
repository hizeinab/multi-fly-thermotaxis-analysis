function y_f = createFit_ss(c, cc)


[xData, yData] = prepareCurveData( c, cc );

p = [0.4];
for i=1:numel(p)
    ft_test = fittype( 'smoothingspline' );
    opts_test = fitoptions( 'Method', 'SmoothingSpline' );
    opts_test.SmoothingParam = p(i);

    [fitresult_test, gof_test] = fit( xData, yData, ft_test, opts_test );
    bestgof = gof_test.rsquare;
    bestfitresult = fitresult_test;
    %%disp('___________________________________________________');
    %disp(bestfitresult);
    %https://nl.mathworks.com/help/matlab/ref/sprintf.html
    %%sprintf("Smoothing Spline Done for %0.5f-%0.5f frame ",c(1)*30,c(end)*30)
    %https://nl.mathworks.com/help/curvefit/fit.html#bto2vuv-1-fitOptions
    %%sprintf("r-square value is %0.5f",bestgof)
    y_f = feval(bestfitresult,c);    
    
end




