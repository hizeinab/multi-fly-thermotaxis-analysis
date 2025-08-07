function [Distance_traveled_between,Distance_traveled_total] = Distance_calculation(csv_file, options)
arguments
    csv_file table
    options.distance_metric {mustBeMember(options.distance_metric,['euclidean' , 'minkowski' , 'mahalanobis' , 'seuclidean'])} = 'euclidean'

end

Dist_metric = options.distance_metric; %%https://nl.mathworks.com/help/stats/pdist2.html#d124e734322
n_fly = length( csv_file(csv_file.frame==1 , :).id );
Distance_traveled_between = cell(n_fly,1);
Distance_traveled_total = cell(n_fly,1);
for ID_no=1:n_fly
  for f=csv_file.frame(1):csv_file.frame(end)+1

    if f==1
      Distance_traveled_between{ID_no} = [Distance_traveled_between{ID_no};0];   %Distance_traveled_between{ID_no}(1) = 0;
    else
      %% current pos
      a = [ csv_file( ( (csv_file.frame==f) & (csv_file.id==ID_no) ) , : ).xc  ,  csv_file( ( (csv_file.frame==f) & (csv_file.id==ID_no) ) , : ).yc ];
      %% previous pos
      b = [ csv_file( ( (csv_file.frame==f-1) & (csv_file.id==ID_no) ) , : ).xc  ,  csv_file( ( (csv_file.frame==f-1) & (csv_file.id==ID_no) ) , : ).yc ];
      %% euclidean distance between frame f and f-1
      d = pdist2(a,b,Dist_metric);
 
      Distance_traveled_between{ID_no} = [Distance_traveled_between{ID_no};d];   %Distance_traveled_between{ID_no}(f-1) = d;
    Distance_traveled_total{ID_no} = cumsum(Distance_traveled_between{ID_no});
    end
  end
end
end