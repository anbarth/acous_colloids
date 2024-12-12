function plot_Q_phi(y_reduced)

[eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(y_reduced);
Qform = @(dphi,alpha,b,q0,q1) ((q0*dphi).^alpha+(q1*dphi).^(alpha+b));

dphi = phi0-linspace(0.2,0.62);

figure; hold on; box on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
xlabel('\phi_0-\phi'); ylabel('Q')

plot(dphi,Qform(dphi,alpha,b,q0params(2),q1params(2)),'LineWidth',1.5)
prettyPlot;
end