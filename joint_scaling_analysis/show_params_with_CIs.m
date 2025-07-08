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


% now cycle through the different materials...
numMaterials = 3;
startIndex = 4;
figure; hold on;
for mm=1:numMaterials

    if mm==1
        s='CORNSTARCH';
        marker = '-s';
        c1 = '#cc2702';
        c2 = '#ed9755';
    elseif mm==2
        s='SILICA';
        marker = '-d';
        c1 = '#62337d';
        c2 = '#c572d4';
    else
        s='POLYDISPERSE SILICA';
        marker = '-o';
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

    disp('F0')
    dispParam(startIndex)
    disp('phi0')
    dispParam(startIndex+1)
    disp('sigmastar')
    dispParam(startIndex+2)


    %xlabel('\phi')
    %ylabel('D(\phi)')
    %errorbar(phi0-phi_list,D,D_err,marker,'LineWidth',1,'Color',c1,'MarkerFaceColor',c2)

    xlabel('\phi')
    ylabel('C(\phi)')
    C = D.*(phi0-phi_list)';
    C_err = D_err.*(phi0-phi_list)';
    errorbar(phi_list,C,C_err,marker,'LineWidth',1,'Color',c1,'MarkerFaceColor',c2)

    prettyplot;
   % makeAxesLogLog
    f1=gcf; f1.Position=[83,65,511,542];

    % move startIndex for next iteration
    startIndex = startIndex+3+numPhi;

end

%xlim([0.15 0.65]);
%ylim([-0.4 1.2]);
legend("CS","MS","PAS")




return

% find alpha
D = y(7:end);
D_ci = confInts(7:end);
phi0 = y(2);
dphi = phi0-phi_list;
cutoff_dphi = 0.17;
fitregion = dphi < cutoff_dphi;

linearfit = fittype('poly1');
myft2 = fit(log(dphi(fitregion)),log(D(fitregion))',linearfit);
alpha = -myft2.p1;
figure; hold on; makeAxesLogLog; errorbar(phi0-phi_list,D,D_ci,'ko'); prettyplot;
plot(dphi(fitregion),dphi(fitregion).^myft2.p1*exp(myft2.p2),'b-')