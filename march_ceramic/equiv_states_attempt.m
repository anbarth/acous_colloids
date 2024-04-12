% three sets of "equivalent" states?
%phi0 = 0.678;
phi0=0.65;

figure; hold on;
rescaledEtaVsT(equiv_states_04_04.phi44_sig02_rev,(phi0-0.44)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig05_0V_rev,(phi0-0.59)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig2_40V_rev,(phi0-0.59)^2);
legend("44%, 0.2pa, 0V","59%, 0.5pa, 0V","59%, 2pa, 40V")
%close;

figure; hold on;
rescaledEtaVsT(equiv_states_04_04.phi44_sig2_rev,(phi0-0.44)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig1_0V_rev,(phi0-0.59)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig4p6_40V_rev,(phi0-0.59)^2);
legend("44%, 2pa, 0V","59%, 1pa, 0V","59%, 4.6pa, 40V")
%close;

figure; hold on;
rescaledEtaVsT(equiv_states_04_04.phi44_sig20_rev,(phi0-0.44)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig1p2_0V_rev,(phi0-0.59)^2);
rescaledEtaVsT(equiv_states_04_04.phi59_sig5p6_40V_rev,(phi0-0.59)^2);
legend("44%, 20pa, 0V","59%, 1.2pa, 0V","59%, 5.6pa, 40V")
%close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure; hold on;
plotReversal(equiv_states_04_04.phi44_sig02_rev,(phi0-0.44)^2);
plotReversal(equiv_states_04_04.phi59_sig05_0V_rev,(phi0-0.59)^2);
plotReversal(equiv_states_04_04.phi59_sig2_40V_rev,(phi0-0.59)^2);
legend("44%, 0.2pa, 0V","59%, 0.5pa, 0V","59%, 2pa, 40V")
close;

figure; hold on;
plotReversal(equiv_states_04_04.phi44_sig2_rev,(phi0-0.44)^2);
plotReversal(equiv_states_04_04.phi59_sig1_0V_rev,(phi0-0.59)^2);
plotReversal(equiv_states_04_04.phi59_sig4p6_40V_rev,(phi0-0.59)^2);
legend("44%, 2pa, 0V","59%, 1pa, 0V","59%, 4.6pa, 40V")
close;

figure; hold on;
plotReversal(equiv_states_04_04.phi44_sig20_rev,(phi0-0.44)^2);
plotReversal(equiv_states_04_04.phi59_sig1p2_0V_rev,(phi0-0.59)^2);
plotReversal(equiv_states_04_04.phi59_sig5p6_40V_rev,(phi0-0.59)^2);
legend("44%, 20pa, 0V","59%, 1.2pa, 0V","59%, 5.6pa, 40V")
close;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure; hold on;
rateVsT(equiv_states_04_04.phi44_sig02_cess);
rateVsT(equiv_states_04_04.phi59_sig05_0V_cess);
rateVsT(equiv_states_04_04.phi59_sig2_40V_cess);
legend("44%, 0.2pa, 0V","59%, 0.5pa, 0V","59%, 2pa, 40V")
%close;

figure; hold on;
rateVsT(equiv_states_04_04.phi44_sig2_cess);
rateVsT(equiv_states_04_04.phi59_sig1_0V_cess);
rateVsT(equiv_states_04_04.phi59_sig4p6_40V_cess);
legend("44%, 2pa, 0V","59%, 1pa, 0V","59%, 4.6pa, 40V")
%close;

figure; hold on;
rateVsT(equiv_states_04_04.phi44_sig20_cess);
rateVsT(equiv_states_04_04.phi59_sig1p2_0V_cess);
rateVsT(equiv_states_04_04.phi59_sig5p6_40V_cess);
legend("44%, 20pa, 0V","59%, 1.2pa, 0V","59%, 5.6pa, 40V")
%close;