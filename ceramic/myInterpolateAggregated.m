% x,y: a list of points in x,y that represent a one-to-one function
% myY: any value between y_min and y_max
% myX: the x-value corresponding to myY, on the curve specified by x,y
function myX = myInterpolateAggregated(myY,x,y)

w = @(my_y,y_i) 1-exp(-(my_y*0.1 ./ abs(my_y-y_i)).^1.5);

sum_weights = sum(w(myY,y));
sum_weighted = sum(w(myY,y).*x);

myX = sum_weighted/sum_weights;

end

% points to the far left are biased to the right and vice versa
% maybe give some initial guess for myX and weight based on that too?