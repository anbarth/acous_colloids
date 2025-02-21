%calcCollapse_acous_free_01_22;
paramsVector = y_optimal;

dataTable = may_ceramic_09_17;
sigma_list = unique(dataTable(:,2));

for sigma_index = 14
    
    
    sigma = sigma_list(sigma_index);
    
    phiJ = phiJHandpicked0V(sigma,dataTable,paramsVector);
    
    fig_phiJ=figure; hold on;
    makeAxesLogLog;
    ax_phiJ = gca;
    title(strcat('\sigma=',num2str(sigma)))
    xlabel('\phi_J-\phi'); ylabel('\eta')

    fig_phi0=figure; hold on;
    makeAxesLogLog;
    ax_phi0 = gca;
    title(strcat('\sigma=',num2str(sigma)))
    xlabel('\phi_J-\phi'); ylabel('\eta(\phi_0-\phi)^2')
    
    phi = [];
    eta = [];
    delta_eta = [];
    for kk=1:size(dataTable,1)
        if dataTable(kk,3)~=0
            continue
        end
        if dataTable(kk,2)~=sigma
            continue
        end
        phi(end+1) = dataTable(kk,1);
        eta(end+1) = dataTable(kk,4);
    
        delta_eta_rheo = dataTable(kk,5);
        delta_phi = 0.01;
        delta_eta_volumefraction = dataTable(kk,4)*2*(phi0-dataTable(kk,1))^(-1)*delta_phi;
        delta_eta(end+1) = sqrt(delta_eta_rheo.^2+delta_eta_volumefraction.^2);
    end
    
    dphi = phiJ-phi;
    errorbar(ax_phi0,dphi,eta.*(phi0-phi).^2,delta_eta,'-o')
    errorbar(ax_phiJ,dphi,eta,delta_eta,'-o')
    
    % fit for delta
    linearfit = fittype('poly1');
    myft2 = fit(log(dphi)',log(eta)',linearfit);
    plot(ax_phiJ,dphi,exp(myft2.p2)*dphi.^myft2.p1,'r-');
    mySlope=myft2.p2;
    annotation(fig_phiJ,'textbox', [0.6, 0.75, 0.1, 0.1], 'String', strcat("\phi_J(\sigma) = ",num2str(phiJ)))
    annotation(fig_phiJ,'textbox', [0.6, 0.65, 0.1, 0.1], 'String', strcat('slope = ',num2str(mySlope)))
    
    show_F_vs_xc_x(dataTable,paramsVector,@modelHandpicked0V,'ColorBy',2,'VoltRange',1,'HighlightStress',sigma);
end