% ft_collapse = fittype('y0+a1*exp(-((x-b1)/c1)^2)');
% opts = fitoptions(ft1);
% opts.StartPoint = [0.7,21298,25,0.03];
% myFit1 = fit(x,y,ft1,opts);
% my_b1 = myFit1.b1;
% ci = confint(myFit1);

% 3 values of x and 4 values of y
x = [1 1 1 1 2 2 2 2 3 3 3 3 ]';
y = [2 4 6 8 2 4 6 8 2 4 6 8 ]';
z = rand(12,1)*10;

ft1 = fittype('p00 + p10*x + p20*x^2 + p01*y + p11*x*y + p21*x^2*y + p02*y^2 + p12*x*y^2 + p22*x^2*y^2 + p03*y^3 + p13*x*y^3 + p23*x^2*y^3',...
    independent=["x" "y"], dependent="z");
myFit = fit([x,y],z,ft1);
figure;
plot(myFit,[x,y],z);