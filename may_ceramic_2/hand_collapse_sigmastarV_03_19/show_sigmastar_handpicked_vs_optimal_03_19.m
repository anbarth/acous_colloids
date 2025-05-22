play_with_sigmastar_03_19;


CSS = (50/19)^3;
%CSS = 1;

V_data = [volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list];
sigmastar_data = [sigmastar_6,sigmastar_7,sigmastar_8,sigmastar_9,sigmastar_10,sigmastar_11,sigmastar_12,sigmastar_13];

sigmastar_avg = zeros(1,7);
sigmastar_std = zeros(1,7);
for jj=1:7
    volt = volt_list(jj);
    sigmastar_avg(jj)=mean(sigmastar_data(V_data==volt));
    sigmastar_std(jj)=std(sigmastar_data(V_data==volt));
end

% use average values for next step
sigmastar = sigmastar_avg;

y = [eta0, phi0, delta, A, width, sigmastar, D];
%show_F_vs_xc_x(dataTable,y,@modelHandpickedSigmastarV,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',1,'ShowInterpolatingFunction',false)




figure; hold on;
makeAxesLogLog;
prettyplot
xlabel('U_a')
ylabel('\sigma^*_a')
minPhi = min(phi_list); maxPhi = max(phi_list); cmap = viridis(256); myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
for my_phi_num = 6:13
    phi = phi_list(my_phi_num);
    mySigmastar = sigmastar_list_full(my_phi_num-5,:);

    mySigmastar = mySigmastar-mySigmastar(1);

    myVoltList = volt_list(mySigmastar~=0);
    mySigmastar = mySigmastar(mySigmastar~=0);
    plot(acoustic_energy_density(myVoltList),mySigmastar*CSS,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    
    %plot(acoustic_energy_density_phi(myVoltList,phi),mySigmastar,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    %disp(mySigmastar)
    
end

%errorbar(acoustic_energy_density(volt_list),(sigmastar_avg-sigmastar_avg(1))*CSS,sigmastar_std*CSS,'ok','LineWidth',1)

%ylim([1e-3 3])
xlim([0.05 50])
ylim([0.05 50])


V = linspace(0,200);
plot(acoustic_energy_density(V),acoustic_energy_density(V),'k--')



% now plot optimized parameters
%optimize_sigmastarV_03_19

% get optimal parameters
y=y_lsq;
sigmastar = y(6:12);
sigmastar_0 = sigmastar(1);
sigmastar_a = sigmastar(2:end)-sigmastar(1);

% transform into correct parameter space for finding CIs
y_log = y; 
y_log(6) = log(y(6));
y_log(7:12) = log(y(7:12)-y(6));
ci = get_conf_ints(dataTable,y_log,@modelHandpickedSigmastarV_logsigmastar)';


log_sigmastar_0_ci = ci(6);
log_sigmastar_a_ci = ci(7:12);

sigmastar_0_upper = sigmastar_0*exp(log_sigmastar_0_ci);
sigmastar_0_lower = sigmastar_0/exp(log_sigmastar_0_ci);
sigmastar_a_upper = sigmastar_a.*exp(log_sigmastar_a_ci);
sigmastar_a_lower = sigmastar_a./exp(log_sigmastar_a_ci);

disp(sigmastar_0)
disp(sigmastar_0_lower)
disp(sigmastar_0_upper)
disp(sigmastar_a)
disp(sigmastar_a_lower)
disp(sigmastar_a_upper)

sigmastar_a_ci_u = sigmastar_a_upper-sigmastar_a;
sigmastar_a_ci_l = sigmastar_a-sigmastar_a_lower;

V = [5 10 20 40 60 80];
errorbar(acoustic_energy_density(V),CSS*sigmastar_a,CSS*sigmastar_a_ci_l,CSS*sigmastar_a_ci_u,'ok')



