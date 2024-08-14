%collapse_params;
load("y_optimal_08_13.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,8);

volt_list = [0,5,10,20,40,60,80,100];

figure; hold on;


p = polyfit(volt_list,sigmastar*19,2);
V = linspace(0,100);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-r','LineWidth',1);

plot(volt_list,sigmastar*19,'ok','LineWidth',2);

xlabel('V')
ylabel('\sigma^* (Pa)')