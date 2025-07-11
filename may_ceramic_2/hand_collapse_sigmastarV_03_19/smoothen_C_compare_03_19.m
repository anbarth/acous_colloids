optimize_sigmastarV_03_19;
y_acous = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confInts_acous = get_conf_ints(may_ceramic_09_17,y_acous,myModelHandle);

optimize_C_jardy_03_19;
y_acous_free = y_lsq_0V; myModelHandle = @modelHandpickedAllExp0V;
acoustics_free_data = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);
confInts_acous_free = get_conf_ints(acoustics_free_data,y_acous_free,myModelHandle);

% extract alpha from D
D_acous = y_acous(13:end);
D_acous_ci = confInts_acous(13:end);
phi0_acous = y_acous(2);
D_acous_free = y_acous_free(7:end);
D_acous_free_ci = confInts_acous_free(7:end);
phi0_acous_free = y_acous_free(2);
dphi_acous = phi0_acous-phi_list;
dphi_acous_free = phi0_acous_free-phi_list;


C_acous = D_acous'.*dphi_acous;
C_acous_ci = D_acous_ci.*dphi_acous;
C_acous_free = D_acous_free'.*dphi_acous_free;
C_acous_free_ci = D_acous_free_ci.*dphi_acous_free;

figure; hold on;
xlabel('\phi'); ylabel('C')
c=[0.7 0.7 0.7];
errorbar(phi_list,C_acous_free,C_acous_free_ci,'o','MarkerFaceColor',c,'Color',c)
errorbar(phi_list,C_acous,C_acous_ci,'ko','MarkerFaceColor','k')


prettyPlot;
myfig = gcf;
myfig.Position=[100,100,414,323];
