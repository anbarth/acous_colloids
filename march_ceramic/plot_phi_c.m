dataTable = march_data_table_05_02;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log');
ax_eta.XLabel.String = '\sigma';
ax_eta.YLabel.String = '\phi_c';
hold(ax_eta,'on');

phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
stress_list = stress_list(3:end-2);
minPhi = min(phi_list);
maxPhi = max(phi_list);
cmap = viridis(256); 
myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

%phi_c = 0.69*ones(size(stress_list));
load("y_optimal_05_10_constrained.mat");
[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,9);
f = @(sigma,jj) exp(-sigmastar(jj)./sigma);
phi_c_single = @(sigma,phi) phi0 - C(phi_list==phi,1)*f(sigma,1);
phi_c = @(sigma,phi) arrayfun(phi_c_single,sigma,phi);


L = {};
for ii=1:length(phi_list)      
    myPhi = phi_list(ii);
    mySigma = logspace(log10(0.001),log10(100));
    
    myPhi_c = phi_c(mySigma,myPhi*ones(size(mySigma)));

    plot(ax_eta,mySigma,myPhi_c,'-','LineWidth',1,'Color',myColor(myPhi));
    L{end+1} = num2str(myPhi);
end
yline(phi0,'k-','LineWidth',2)
L{end+1}='\phi_0';

legend(L);
