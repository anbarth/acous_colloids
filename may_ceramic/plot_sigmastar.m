%collapse_params;
load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;

volt_list = [0,5,10,20,40,60,80];

figure; hold on;


p = polyfit(volt_list,sigmastar*19,2);
V = linspace(0,80);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-r','LineWidth',1);

plot(volt_list,sigmastar*19,'ok','LineWidth',2);

xlabel('V')
ylabel('\sigma^* (Pa)')