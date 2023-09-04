% x,y: a list of points in x,y that represent a one-to-one function
% myY: any value between y_min and y_max
% myX: the x-value corresponding to myY, on the curve specified by x,y
function myX = myInterpolate(myY,x,y)
% convert row vecs to column vecs
if size(x,1)==1
    x = transpose(x);
end
if size(y,1)==1
    y = transpose(y);
end

% guarantee that the points are sorted in ascending order according to y
xy = sortrows([x,y],2);
x = xy(:,1);
y = xy(:,2);

myX = NaN;
for ii = 1:length(y)-1
   if y(ii) <= myY && myY <= y(ii+1)
       y1 = y(ii); y2 = y(ii+1); x1 = x(ii); x2 = x(ii+1);
       myX = (myY-y1)/(y2-y1)*(x2-x1)+x1;
       return
   end
end
%disp("i'm nan :(")
end