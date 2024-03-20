% x = [1,2,3,4,5,6,7,8,9,10,11];
% y = x.^2 +3;
% y = y+randn(size(x));
% x = x+randn(size(x));

plot(x,y,'o');
hold on;

y_fake = linspace(3,120);
x_fake = zeros(size(y_fake));
for ii=1:length(y_fake)
    x_fake(ii) = myInterpolateAggregated(y_fake(ii),x,y);
end

plot(x_fake,y_fake);