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
for mm=1:numMaterials

    if mm==1
        s='CORNSTARCH';
    elseif mm==2
        s='SILICA';
    else
        s='POLYDISPERSE SILICA';
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

    figure; hold on;
    title(s)
    xlabel('\phi')
    ylabel('D(\phi)')
    plot(phi_list,D_init,'-o','LineWidth',0.75);
    plot(phi_list,D,'-o','LineWidth',2);
    prettyplot;

    % move startIndex for next iteration
    startIndex = startIndex+3+numPhi;

end




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