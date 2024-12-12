dataTable = may_ceramic_06_05;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\phi_c-\phi';
ax_eta.YLabel.String = '\eta(\phi_c-\phi)^2 (Pa s)';
hold(ax_eta,'on');



stress_list = unique(dataTable(:,2));
stress_list = stress_list(3:end-2);
minSigma = min(stress_list);
maxSigma = max(stress_list);
cmap = viridis(256); 
myColor = @(sig) cmap(round(1+255*(log(sig)-log(minSigma))/(log(maxSigma)-log(minSigma))),:);



%phi_c_options = [0.63 0.67 0.7 0.73];
phi_c_options = [0.6 0.61 0.62 0.63 0.64 0.65 0.66];

L={};
for kk=8
    mySigma = stress_list(kk);
    myDataIndices = dataTable(:,2)==mySigma & dataTable(:,3)==0;
    myPhi = dataTable(myDataIndices,1);
    myEta = dataTable(myDataIndices,4);
    for ii=1:length(phi_c_options)
        myPhi_c = phi_c_options(ii);
        plot(ax_eta,myPhi_c-myPhi,myEta.*(myPhi_c-myPhi).^2,'--o','LineWidth',1);
        L{end+1}=num2str(myPhi_c);
    end
end
legend(L);