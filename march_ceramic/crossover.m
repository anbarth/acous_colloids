dataTable = march_data_table_05_02;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\phi_c-\phi';
ax_eta.YLabel.String = '\eta(\phi_c-\phi)^2 (Pa s)';
hold(ax_eta,'on');

phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
stress_list = stress_list(1:end-2);
minSigma = min(stress_list);
maxSigma = max(stress_list);
cmap = viridis(256); 
myColor = @(sig) cmap(round(1+255*(log(sig)-log(minSigma))/(log(maxSigma)-log(minSigma))),:);

%phi_c = 0.69*ones(size(stress_list));
load("y_optimal_05_10_constrained.mat");
[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,9);
%C=ones(size(C));
f = @(sigma,jj) exp(-sigmastar(jj)./sigma);
phi_c_single = @(sigma,phi) phi0 - C(phi_list==phi,1).*f(sigma,1);
phi_c = @(sigma,phi) arrayfun(phi_c_single,sigma*ones(size(phi)),phi);
phi_c_list = [0.68,0.68,0.68, 0.68, 0.67, 0.65, 0.61, 0.61, 0.63, 0.6, 0.6, 0.6, 0.6, 0.6, 0.61, 0.61];

L = {};
for kk=1:length(stress_list)
%for kk=1
    mySigma = stress_list(kk);
    myDataIndices = dataTable(:,2)==mySigma & dataTable(:,3)==0;
    myPhi = dataTable(myDataIndices,1);
    myEta = dataTable(myDataIndices,4);

    %myPhi_c = phi_c_list(kk);
    %myPhi_c=phi0;
    myPhi_c = phi_c(mySigma,myPhi);


    plot(ax_eta,myPhi_c-myPhi,myEta.*(myPhi_c-myPhi).^2,'-o','LineWidth',1,'Color',myColor(mySigma));
    L{end+1} = num2str(mySigma);
end
legend(L);