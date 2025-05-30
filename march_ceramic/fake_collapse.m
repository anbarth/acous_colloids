% assume the underlying data obey F ~ (xc-x)^beta,
% with x = f/(phi0-phi)^alpha

% if alpha~=1, but then we try to plot against f/(phi0-phi) anyway,
% could we fix it with C(phi)?

% if i had phi0 a bit incorrect, what would that change?

phi0_true = 0.64;
phi0_plot = 0.64;
phimu = 0.6;
sigmastar = 1;
delta = -1.5;
alpha = 2;

k_real=1;
f = @(k,sigma) exp(-(sigmastar ./ sigma).^k);
xc = 1/(phi0_true-phimu)^alpha;
xc_plot = 1/(phi0_true-phimu);

%C_075 = [1 1 1 1 1 1] * xc/xc_plot;
%C_075 = [1.25 1.18 1.07 1.02 1 0.98] * 0.455;



phi = [0.5, 0.54, 0.58, 0.59, 0.595, 0.599];
sigma = [0.1,0.2,0.5,1,2,5,10,20,50,100,200,500,1000];

% if you've got the exponent in the denominator wrong...
% C = x_true/x_plot = (phi0-phi)/(phi0-phi)^alpha = (phi0-phi)^(1-alpha)
% assuming we got phi0 correct
C = (phi0_true-phi).^(1-alpha);

% if you've got phi0 wrong... 
% this succeeds in aligning the divergences, but they wont collapse
% C = x_true/x_plot = (phi0_wrong-phi)/(phi0_true-phi)
%C = (phi0_wrong-phi)./(phi0-phi);

%C = [1 1 1 1 1 1];

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

for ii=length(phi):-1:1
%for ii=1:length(phi)
    myPhi = phi(ii);

    x_true = f(k_real,sigma)/(phi0_true-myPhi)^alpha;
    x_plot = f(k_real,sigma)/(phi0_plot-myPhi)*C(ii);

    % true value of F=eta(phi0-phi)^beta follows a power law in xc-x
    F = (xc-x_true).^delta;

    % the value we plot is eta*(phi0_plot-phi)^2
    % = (F_true/(phi0_true-phi)^2)*(phi0_plot-phi)^2
    F_plot = F / (phi0_true-myPhi)^2 * (phi0_plot-myPhi)^2;

    myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
    plot(ax_collapse,x_plot,F_plot,'-o','Color',myColor,'LineWidth',2)
    plot(ax_xc_x,xc-x_plot,F,'-o','Color',myColor)
end

close(fig_xc_x);

% figure; hold on;
% ax1 = gca;
% ax1.XScale = 'log';
% ax1.YScale = 'log';
% plot(phi0-phi,C./(phi0-phi),'--o')