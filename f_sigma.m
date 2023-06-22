figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
box on
%ax1.YScale = 'log';
sigma = logspace(0,3);
f = @(sigmastar, sigma) exp(-(sigmastar ./ sigma));
plot(sigma,f(10,sigma));
plot(sigma,f(100,sigma));