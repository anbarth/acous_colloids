figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
%ax1.YScale = 'log';
sigma = logspace(-1,4);
f = @(sigmastar, sigma) exp(-(sigmastar ./ sigma));
plot(sigma,f(1,sigma));
plot(sigma,f(3,sigma));