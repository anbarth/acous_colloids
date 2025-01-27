% x,y: a list of points in x,y that represent a one-to-one function
% myX: any value between x_min and x_max
% myY: the y-value corresponding to myX, on the curve specified by x,y
function myY = myInterpolateX(myX,x,y)
% convert row vecs to column vecs
if size(x,1)==1
    x = transpose(x);
end
if size(y,1)==1
    y = transpose(y);
end

% guarantee that the points are sorted in ascending order according to x
[x,sortIdx] = sort(x);
y=y(sortIdx);

myY = NaN;
for ii = 1:length(y)-1
   if x(ii) <= myX && myX <= x(ii+1)
       y1 = y(ii); y2 = y(ii+1); x1 = x(ii); x2 = x(ii+1);
       %myY = (myX-x1)/(x2-x1)*(y2-y1)+y1;
       myY = exp( (log(myX)-log(x1))/(log(x2)-log(x1))*(log(y2)-log(y1))+log(y1) );
       return
   end
end
%disp("i'm nan :(")
end