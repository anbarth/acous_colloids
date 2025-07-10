% training set
%optimize_sigmastarV_03_25;
%y_train = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
%confints_train = get_conf_ints(restricted_data_table,y_train,myModelHandle);
sigmastar_train = y_train(6:12); % rheo units
sigmastar_train_err = confints_train(6:12);

% full set
%optimize_sigmastarV_03_19;
%y_full = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
%confints_full = get_conf_ints(may_ceramic_09_17,y_full,myModelHandle);
sigmastar_full = y_full(6:12); % rheo units
sigmastar_full_err = confints_full(6:12);


CSS=(50/19)^3;
volt_list = [0 5 10 20 40 60 80];
E_list = acoustic_energy_density(volt_list);

% for training set, ignore zero entries
s = sigmastar_train~=0;
sigmastar_train = sigmastar_train(s);
sigmastar_train_err = sigmastar_train_err(s);
E_list_restricted = E_list(s);

% get sigma*_a
sigmastar0_train = sigmastar_train(1);
sigmastar_a_train = sigmastar_train-sigmastar0_train;
sigmastar0_full = sigmastar_full(1);
sigmastar_a_full = sigmastar_full-sigmastar0_full;

% fit sigma*_a_train(U) to a line
linfit = fittype("a*x");
%sigmastarFitParam = fit(E_list_restricted',sigmastar_acous',linfit,'StartPoint',1,'Weights',1./sigmastar_err);
sigmastarFitParam = fit(E_list_restricted',sigmastar_a_train',linfit,'StartPoint',1);
%sigmastarFitParam = fit(E_list_restricted(2:end)',sigmastar_a_train(2:end)',linfit,'StartPoint',1,'Weights',1./sigmastar_a_train(2:end)');

sigmastarFit = @(V) sigmastar0_train + sigmastarFitParam.a*acoustic_energy_density(V);
sigmastar_aFit = @(V) sigmastarFitParam.a*acoustic_energy_density(V);


figure; hold on;
xlabel("Acoustic energy density {\itU_a} (Pa)")
ylabel("\sigma^*_a (Pa)")


% plot training set fit
V = linspace(0,120);
plot(acoustic_energy_density(V),CSS*sigmastar_aFit(V),'r-');

% plot full set data
c = [0.7 0.7 0.7];
plot(E_list,CSS*sigmastar_a_full,'o','Color',c,'LineWidth',1)


% plot training set data
cmap = plasma(256);
logMinE0 = log(acoustic_energy_density(5));
logMaxE0 = log(acoustic_energy_density(80));
myColor = @(U) cmap(round(1+255*(log(U)-logMinE0)/( logMaxE0-logMinE0 )),:);
for jj=2:length(volt_list_restricted)

    colorV = myColor(acoustic_energy_density(volt_list_restricted(jj)));

    plot(E_list_restricted(jj),CSS*(sigmastar_a_train(jj)),'s','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
    %errorbar(acoustic_energy_density(volt_list_restricted(jj)),CSS*(sigmastar_acous(jj)),CSS*sigmastar_err(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);

    
    %xlim([0 100])
end




myfig = gcf;
myfig.Position=[886,181,267,337];
makeAxesLogLog
xlim([0.05,50])
xticks([10^-1 10^0 10^1])
ylim([0.03,34])
yticks([10^-1 10^0 10^1])
prettyPlot;
