load("y_optimal_06_15.mat")
%collapse_params;
[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,11);
volt_list = [0,5,10,20,40,60,80];

figure; hold on;
plot(volt_list,sigmastar,'ok','LineWidth',2);

p = polyfit(volt_list,sigmastar,2);
V = linspace(0,80);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-r','LineWidth',1);