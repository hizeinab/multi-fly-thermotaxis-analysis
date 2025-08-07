function y_f = createFit_linear(t, y)


[xData, yData] = prepareCurveData( t, y );
polyorder={'poly1'};
for i=1:numel(polyorder)
    order = polyorder{i};
    ft_test = fittype( order );
    opts_test = fitoptions( 'Method', 'LinearLeastSquares' );
    opts_test.Normalize = 'on';
    opts_test.Robust = 'Bisquare';

    [fitresult_test, gof_test] = fit( xData, yData, ft_test, opts_test );
    bestgof = gof_test.rsquare;
    bestfitresult = fitresult_test;
    disp('___________________________________________________');
    disp(bestfitresult);
    disp(bestgof);
    y_f = feval(bestfitresult,t);    
    
end

end

