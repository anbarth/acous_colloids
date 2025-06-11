%optimize_collapse;

confInts = get_conf_ints(dataTable,y,myModelHandle);
confInts = confInts';
dispParam = @(paramNum) disp([y_init(paramNum) y(paramNum) confInts(paramNum)]);

disp('delta')
dispParam(1)
disp('A')
dispParam(2)
disp('h')
dispParam(3)

cutoff_dphi_list = [0.15,0.12,0.2];

% now cycle through the different materials...
numMaterials = 3;
startIndex = 4;
%figure; hold on;
for mm=1:numMaterials

    if mm==1
        s='CORNSTARCH';
        marker = 's';
        c1 = '#cc2702';
        c2 = '#ed9755';
    elseif mm==2
        s='SILICA';
        marker = 'd';
        c1 = '#62337d';
        c2 = '#c572d4';
    else
        s='POLYDISPERSE SILICA';
        marker = 'o';
        c1='#094f0d';
        c2='#229c53';
    end
    disp(s);
    
    myData = dataTable(:,6)==mm;
    phi_list = unique(dataTable(myData,1));
    numPhi = length(phi_list);


    F0 = y(startIndex);
    phi0 = y(startIndex+1);
    sigmastar = y(startIndex+2);
    D = y(startIndex+3:startIndex+2+numPhi);
    D_init = y_init(startIndex+3:startIndex+2+numPhi);

    F0_err = confInts(startIndex);
    phi0_err = confInts(startIndex+1);
    sigmastar_err = confInts(startIndex+2);
    D_err = confInts(startIndex+3:startIndex+2+numPhi);

    % find alpha
    dphi = phi0-phi_list;
    cutoff_dphi = cutoff_dphi_list(mm);
    fitregion = dphi < cutoff_dphi;
    linearfit = fittype('poly1');
    myft2 = fit(log(dphi(fitregion)),log(D(fitregion))',linearfit);
    alpha = -myft2.p1;
    myft2_ci = confint(myft2);
    alpha_ci_lower = myft2.p1-myft2_ci(1,1);
    alpha_ci_upper = myft2_ci(2,1)-myft2.p1;

    

    disp('F0')
    dispParam(startIndex)
    disp('phi0')
    dispParam(startIndex+1)
    disp('sigmastar')
    dispParam(startIndex+2)
    disp('alpha')
    disp([alpha alpha_ci_lower alpha_ci_upper])

    figure; hold on;
    title(s)
    xlabel('\phi_0-\phi')
    ylabel('D(\phi)')

    errorbar(phi0-phi_list,D,D_err,marker,'LineWidth',1,'Color',c1,'MarkerFaceColor',c2)
    plot(dphi(fitregion),dphi(fitregion).^myft2.p1*exp(myft2.p2),'b-')
    prettyplot;
    makeAxesLogLog
    f1=gcf; f1.Position=[83,65,511,542];

    % move startIndex for next iteration
    startIndex = startIndex+3+numPhi;

end



