function y_f = createFitPoly_best(t, y)


[xData, yData] = prepareCurveData( t, y );
polyorder={'poly1';'poly2';'poly3';'poly4';'poly5';'poly6';'poly7';'poly8';'poly9';'poly10'};
for i=1:numel(polyorder)
    order = polyorder{i};
    ft_test = fittype( order );
    opts_test = fitoptions( 'Method', 'LinearLeastSquares' );
    opts_test.Normalize = 'on';
    opts_test.Robust = 'Bisquare';

    [fitresult_test, gof_test] = fit( xData, yData, ft_test, opts_test );

    if (gof_test.rsquare >= 0.9 || isnan(gof_test.rsquare))
         bestgof = gof_test.rsquare;
         bestfitresult = fitresult_test;
         disp('___________________________________________________');
         disp(bestfitresult);
         disp(bestgof);
         y_f = feval(bestfitresult,t); 
         %disp(y_fit);
         break;
    end
    
end

end

