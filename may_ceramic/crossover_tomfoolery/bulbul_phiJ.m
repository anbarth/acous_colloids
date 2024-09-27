%dataTable = may_ceramic_09_17;
%[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17);
load("y_09_19_ratio_with_and_without_Cv.mat");
y_optimal = y_Cv;

f = @(sigma) sigma ./ (sigma+sigmastar);
phiJ = @(sigma) phi0-(phi0-phimu)*f(sigma);
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
minLogSig = log(min(stress_list)*0.99);
maxLogSig = log(max(stress_list)*1.01);

eta = [];
phiJ_phi = [];

fig_phiJ = figure;
ax_phiJ = axes('Parent', fig_phiJ,'YScale','log','XScale','log');
ax_phiJ.XLabel.String = '\phi_J-\phi';
ax_phiJ.YLabel.String = '\eta (Pa s)';
hold(ax_phiJ,'on');

a=2;
delta = 1;

[x,F,deltaF] = calc_x_F(dataTable,y_optimal);
x_crossover = 0.5;

cmap = winter(256);
%colormap(cmap);
L={};
%for kk=1
for kk = 1:length(stress_list)
    sigma = stress_list(kk);
    myColor = cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    
    L{end+1}=num2str(sigma);
    my_eta = [];
    my_delta_eta = [];
    my_phi = [];
    my_x = [];

    
    for ii=1:length(phi_list)
    
        myData = dataTable(dataTable(:,1)==phi_list(ii) & dataTable(:,3)==0, :);
        myX = x(dataTable(:,1)==phi_list(ii) & dataTable(:,3)==0);
        mySigma = myData(:,2);
        myEta = myData(:,4);
        myDeltaEta = myData(:,5);
            
        stressIndex = find(sigma==mySigma);
        if stressIndex
            my_eta(end+1) = myEta(stressIndex);
            my_delta_eta(end+1) = myDeltaEta(stressIndex);
            my_phi(end+1) = phi_list(ii);
            my_x(end+1) = myX(stressIndex);
        end
    end
  
   % plot(ax_phiJ,phiJ(sigma)-my_phi,my_eta,'--o','Color',myColor,'LineWidth',0.5)
    plot(ax_phiJ,phiJ(sigma)-my_phi(my_x>x_crossover),my_eta(my_x>x_crossover),'--o','Color',myColor,'LineWidth',2)
    %plot(ax_phiJ,phiJ(sigma)-my_phi,a*f(sigma).^-(delta-2).*(phiJ(sigma)-my_phi).^-delta,'-','Color',myColor);

    eta = [eta, my_eta];
    phiJ_phi = [phiJ_phi, phiJ(sigma)-my_phi];
end
legend(ax_phiJ,L);

