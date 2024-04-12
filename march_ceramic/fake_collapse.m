phi0 = 0.64;
phi0_wrong = 0.63;
phimu = 0.6;
sigmastar = 1;
beta = -1.5;
alpha = 3;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
xc = 1/(phi0-phimu)^alpha;
xc_plot = 1/(phi0-phimu);

%C_075 = [1 1 1 1 1 1] * xc/xc_plot;
%C_075 = [1.25 1.18 1.07 1.02 1 0.98] * 0.455;



phi = [0.5, 0.54, 0.58, 0.59, 0.595, 0.599];
sigma = [0.1,0.2,0.5,1,2,5,10,20,50,100,200,500,1000];

% C = x_true/x_plot = (phi0-phi)/(phi0-phi)^alpha = (phi0-phi)^(1-alpha)
%C = (phi0-phi).^(1-alpha);
C = [300  300  350  440  500  594.8840];

fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');
ax_collapse.XLabel.String = "x";
ax_collapse.YLabel.String = "F";
minPhi = min(phi);
maxPhi = max(phi);

fig_xc_x = figure;
ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
hold(ax_xc_x,'on');
ax_xc_x.XLabel.String = "x_c-x";
ax_xc_x.YLabel.String = "F";

cmap = viridis(256); 

for ii=1:length(phi)
    myPhi = phi(ii);

    x_true = f(sigma)/(phi0-myPhi)^alpha;
    x_plot = f(sigma)/(phi0_wrong-myPhi)*C(ii);
    F = (xc-x_true).^beta;
    F_plot = F / (phi0-myPhi)^2 * (phi0_wrong-myPhi)^2;

    myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
    plot(ax_collapse,x_plot,F_plot,'-o','Color',myColor)
    plot(ax_xc_x,xc-x_plot,F,'-o','Color',myColor)
end

close(fig_xc_x);

% figure; hold on;
% ax1 = gca;
% ax1.XScale = 'log';
% ax1.YScale = 'log';
% plot(phi0-phi,C./(phi0-phi),'--o')