function direction = Direction_calculation(x_change , y_change)
arguments
    x_change (:,:) double
    y_change (:,:) {double , mustBeEqualSize(y_change,x_change)}
end
%%  Computes the direction of motion for a mover
direction(:,1) = reshape(x_change,[],1);
direction(:,2) = reshape(y_change,[],1);

end