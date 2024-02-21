figure; hold on;
ax1=gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');

plot(phi44_big(:,1),phi44_big(:,2),'-o');

CSS = 19;
CSV = 25;
plot(phi44_small(:,1)*CSS,phi44_small(:,2)*CSV,'-o');
plot(phi59_small(:,1)*CSS,phi59_small(:,2)*CSV,'-o');

legend('44% big','44% small','59% small');

% add WC lines -- no fitting just guessing :)
phi = [0.44, 0.59];
A = 0.1;
phi0 = 0.66;
phim = 0.595;
sigmastar = 5;
sigma = logspace(-2.2,2.7);
for ii=1:length(phi)
    eta=A*( phi0*(1-exp(-sigmastar./sigma)) + phim*exp(-sigmastar./sigma) - phi(ii) ).^(-2);
    plot(sigma, eta,'LineWidth',1);
end

figure; hold on;
ax1=gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
sigma44 = phi44_big(:,1);
eta44 = phi44_big(:,2);
x44 = exp(-sigmastar./sigma44) / (phi0-0.44);
F44 = eta44 * (phi0-0.44)^2;

sigma59 = phi59_small(:,1);
eta59 = phi59_small(:,2);
x59 = exp(-sigmastar./sigma59) / (phi0-0.59);
F59 = eta59 * (phi0-0.59)^2;

plot(x44,F44,'-o');
plot(x59,F59,'-o');