dataTable = may_ceramic_09_17;
%optimize_sigmastarV_03_19;

myModelHandle = @modelHandpickedSigmastarV; paramsVector = y_fmincon;
confInts = get_conf_ints(dataTable,paramsVector,myModelHandle);

sigmastar = paramsVector(6:12);
sigmastar_ci = confInts(6:12);

CSS = (50/19)^3;

ci_left_6 = 0.0201; ci_right_6 = 0.1601;
ci_left_7 = 0.0202; ci_right_7 = 0.1786;
ci_left_8 = 0.0245; ci_right_8 = 0.2233;
ci_left_9 = 0.0347; ci_right_9 = 0.3323;
ci_left_10 = 0.0800; ci_right_10 = 0.6558;
ci_left_11 = 0.1292; ci_right_11 = 1.3622;
ci_left_12 = 0.2133; ci_right_12 = 2.1913;

ci_brute_force = [ci_left_6, ci_right_6; ci_left_7, ci_right_7; ...
    ci_left_8, ci_right_8; ci_left_9, ci_right_9; ...
    ci_left_10, ci_right_10; ci_left_11, ci_right_11; ...
    ci_left_12, ci_right_12];

volt_list = [0 5 10 20 40 60 80];
U = acoustic_energy_density(volt_list);

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
errorbar(U,CSS*sigmastar,CSS*sigmastar_ci,'ko')

for ii=1:length(U)
    myU = U(ii);
    mySigmastar = sigmastar(ii);
    err_lower = mySigmastar-ci_brute_force(ii,1);
    err_upper = ci_brute_force(ii,2)-mySigmastar;
    errorbar(myU*1.1,CSS*mySigmastar,CSS*err_lower,CSS*err_upper,'bo')
end
xlabel('U_a (Pa)')
ylabel('\sigma^*_{tot} (Pa)')

prettyplot