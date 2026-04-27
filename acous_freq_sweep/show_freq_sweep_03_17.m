


struct_list = {freq_sweep_03_17.sig2_80_350kHz, freq_sweep_03_17.sig2_350_650kHz,...
    freq_sweep_03_17.sig2_650_950kHz, freq_sweep_03_17.sig2_950_1000kHz,...
    freq_sweep_03_17.sig2_1000_1300kHz, freq_sweep_03_17.sig2_1300_1500kHz};

figure; hold on;
ylabel('\eta/\eta_0')
xlabel('acoustic frequency (kHz)')

for i=1:length(struct_list)
    rheoStruct = struct_list{i};
    eta0 = getEta0(rheoStruct);
    freq = rheoStruct.freq_list;
    eta = averageEtaBetweenTimeMarkers(rheoStruct);
    plot(freq,eta/eta0,'-o')
end
prettyplot

% resistor anti-peaks from feb 2026 experiments on bottom plate
pks = [105 140 235 285 370 400 445 860 1150 1450];
xline(pks)