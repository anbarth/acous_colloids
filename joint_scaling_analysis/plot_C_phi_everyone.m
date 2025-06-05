phi_list_cs = unique(cornstarch_table(:,1));
phi_list_ceramic = unique(ceramic_table(:,1));
phi_list_si = unique(silica_table(:,1));

phi0_cs = y_cs(2);
phi0_ceramic = y_ceramic_handpicked_03_19(2);
phi0_si = y_si(2);

D_cs = y_cs(7:end)';
D_ceramic = y_ceramic_handpicked_03_19(7:end)';
D_si = y_si(7:end)';

C_cs = D_cs.*(phi0_cs-phi_list_cs);
C_ceramic = D_ceramic.*(phi0_ceramic-phi_list_ceramic);
C_si = D_si.*(phi0_si-phi_list_si);

figure; hold on; makeAxesLogLog; prettyplot;
plot(phi0_cs-phi_list_cs,C_cs,'-s','Color','#cc2702','MarkerFaceColor','#ed9755');
plot(phi0_si-phi_list_si,C_si,'-d','Color','#62337d','MarkerFaceColor','#c572d4');
plot(phi0_ceramic-phi_list_ceramic,C_ceramic,'-o','Color','#094f0d','MarkerFaceColor','#229c53');
ylim([1e-4 0.3])
%xlim([0.04 0.7])
xlim([0.03 1])
%ylim([0.03 1])


x=logspace(log10(0.05),log10(0.15));
plot(x,7/4*x,'r-')

legend('CS','MS','PAS','Slope of -1')
xlabel('\phi_0-\phi');ylabel('C(\phi)')