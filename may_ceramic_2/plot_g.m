function plot_g(dataTable, paramsVector)

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13);
f = @(sigma,jj) sigma ./ (sigma+sigmastar(jj));
phi_list = unique(dataTable(:,1));
volt_list = [0,5,10,20,40,60,80];
alpha = 3;

fig_g_sigma = figure;
ax_g_sigma = axes('Parent', fig_g_sigma,'XScale','log','YScale','linear');
hold(ax_g_sigma,'on');
ax_g_sigma.XLabel.String = "\sigma (Pa)";
ax_g_sigma.YLabel.String = "g(\sigma,\phi,V=0)";


cmap = viridis(256);
colormap(ax_g_sigma,cmap);
minPhi = 0.18;
maxPhi = 0.62;
myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

minSigma = min(dataTable(:,2));
maxSigma = max(dataTable(:,2));
sigma = logspace(log10(minSigma),log10(maxSigma));

for ii=1:length(phi_list)
    phi = phi_list(ii);
    myD = C(ii,1)*(phi0-phi).^alpha;
    myG = f(sigma,1)*myD;
    plot(ax_g_sigma,myG,'Color',myColor(phi),'LineWidth',1);
end

c1 = colorbar(ax_g_sigma);
clim(ax_g_sigma,[minPhi maxPhi]);
c1.Ticks = phi_list;

end
