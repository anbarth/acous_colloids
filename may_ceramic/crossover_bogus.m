% choose some parameters
eta0 = 1;
sigmastar = 1;
phi0 = 0.69;
delta = 1.8;
f = @(sigma) exp(-sigmastar./sigma);
phi_c = @(sigma) (1-f(sigma))*phi0 + f(sigma)*0.61; 
phi_c_plot = [ 0.6900    0.6765    0.636    0.621    0.616];

phi = [0 0.1 0.2 0.3 0.4 0.44 0.48 0.52 0.54 0.56 0.58 0.6];
minSigma = 0.1;
maxSigma = 100;
sigma = logspace(log10(minSigma),log10(maxSigma),5);
myColor = @(sig) cmap(round(1+255*(log(sig)-log(minSigma))/(log(maxSigma)-log(minSigma))),:);

% set up figure
fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\phi_c-\phi';
ax_eta.YLabel.String = '\eta(\phi_c-\phi)^2 (Pa s)';
hold(ax_eta,'on');


for kk=1:length(sigma)
%for kk=1
    mySigma = sigma(kk);
    myEta = eta0*(phi-phi0).^(-2).*( (phi_c(mySigma)-phi)./(phi0-phi) ).^-delta;
 
    %myPhi_c = phi_c(mySigma);
    myPhi_c = phi_c_plot(kk);
    plot(ax_eta,myPhi_c-phi,myEta.*(myPhi_c-phi).^2,'--o','LineWidth',1,'Color',myColor(mySigma));

end