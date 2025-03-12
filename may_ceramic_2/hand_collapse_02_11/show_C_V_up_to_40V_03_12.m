%smooth_C_03_11;

figure; hold on;

cmap = plasma(256);
ylabel('C')
xlabel('\phi')
%xlim([0.4 0.65])

for jj=1:size(C,2)

    myC = C(:,jj);
    myC_err = C_err(:,jj);
    myPhi = phi_list;
    voltage = volt_list(jj);

    myPhi = myPhi(myC ~= 0);
    myC_err = myC_err(myC~=0);
    myC = myC(myC~=0);

    myColor = cmap(round(1+255*voltage/80),:);
    if jj < 5
        %errorbar(myPhi,myC,myC_err,'o','Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor);
        %plot(myPhi,myC,'o','Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor);
        plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,cFit.x1,phi_list,voltage),'Color',myColor,'LineWidth',1.5)
    else
        plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,cFit.x1,phi_list,voltage),'--','Color',myColor,'LineWidth',1.5)
    end
    
    %plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,cFit.x1,phi_list,voltage),'Color',myColor,'LineWidth',1.5)
end
prettyPlot;


for jj=1:size(C,2)
    figure; hold on;
    
    cmap = plasma(256);
    ylabel('C')
    xlabel('\phi')
    xlim([0.42 0.65])
    ylim([0.4 1.2])



    myC = C(:,jj);
    myC_err = C_err(:,jj);
    myPhi = phi_list;
    voltage = volt_list(jj);

    myPhi = myPhi(myC ~= 0);
    myC_err = myC_err(myC~=0);
    myC = myC(myC~=0);

    myColor = cmap(round(1+255*voltage/80),:);
    errorbar(myPhi,myC,myC_err,'o','Color',myColor,'LineWidth',0.75,'MarkerFaceColor',myColor);
    
    plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,cFit.x1,phi_list,voltage),'Color',myColor,'LineWidth',1.5)
    prettyPlot;
end
