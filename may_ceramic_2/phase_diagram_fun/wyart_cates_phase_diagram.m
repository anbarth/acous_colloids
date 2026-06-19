


% set up fig
figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma (Pa)')
xlim([0.5 0.7])
ylim([1e-2 1e2])

sigma=logspace(-2,2);

% plot jamming line
phi0=0.64; phimu=0.55; sigmastar=1;
f=@(sigma) exp(-sigmastar./sigma);
phiJ=@(sigma) phi0*(1-f(sigma))+phimu*f(sigma);





df_dsigma = @(sigma) exp(-sigmastar./sigma)*sigmastar./sigma.^2;
phiDST = phiJ(sigma)-(phi0-phimu)*2*df_dsigma(sigma).*sigma;

patch([0 0 1 1],[min(sigma),max(sigma),max(sigma),min(sigma)],[0.5373    0.7098    0.9098],'EdgeColor','none')

patch([phiDST, flip(phiJ(sigma))], [sigma, flip(sigma)], [0.0196    0.5255    1.0000],'EdgeColor','none')

patch([phiJ(sigma), phi0, phi0], [sigma, max(sigma), min(sigma)], [0.9608    0.5020    0.0078],'EdgeColor','none')

patch([phi0, phi0, 1, 1],[max(sigma), min(sigma), min(sigma), max(sigma)],[.4 .4 .4],'EdgeColor','none')

plot(phiJ(sigma),sigma,'k-','LineWidth',1)
plot(phiDST,sigma,'k-','LineWidth',1)
xline(phi0,'k','LineWidth',1)

prettyplot

% sigma = [1e-1 1 5 10];
% for ii=1:length(sigma)
%     sig = sigma(ii);
%     dlogeta_dlogsigma_1 = @(phi) -2*sig*(phiJ(sig)-phi).^(-1).*((phimu-phi0)*df_dsigma(sig))-1;
%     phi_DST = fzero(dlogeta_dlogsigma_1,0.55);
%     plot(phi_DST,sig,'ro')
% end