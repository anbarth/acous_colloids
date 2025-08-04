dataTable = may_ceramic_09_17;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = 'rate (1/s)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');
cmap = plasma(256);
colormap(ax_eta,cmap);

phi_list = unique(dataTable(:,1));
phi = phi_list(10);
disp(phi)
ax_eta.Title.String = num2str(phi);

volt_list = [0,5,10,20,40,60,80];
logMinE0 = log(acoustic_energy_density(5));
logMaxE0 = log(acoustic_energy_density(80));
myColorAcous = @(E0) cmap(round(1+255*(log(E0)-logMinE0)/( logMaxE0-logMinE0 )),:);


for ii=1:length(volt_list)
    V = volt_list(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==V, :);
    
    sigma = myData(:,2);
    eta = myData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    
    if V==0
        myColor = [0 0 0];
    else
        myColor = myColorAcous(acoustic_energy_density(V));
    end

    plot(ax_eta,sigma./eta,eta, '-d','Color',myColor,'LineWidth',1);

end
