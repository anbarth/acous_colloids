% populates phi0, sigmastar, and D_0V=C(:,1), and interpolating function
% parameters
avg_sigmastar_03_17;



% pick a volume fraction to work on


    CV_13 = D(13,:).*[1 1 1 0.95 1 1 1];
    CV_12 = D(12,:).*[1 1 1 1 1.001 1.005 1.005];
    CV_11 = D(11,:).*[1 1 1 0.999 1.004 1 1];
    CV_10 = D(10,:).*[1 1 1.001 1 1.005 1.005 1.005];
    CV_9 = D(9,:).*[1 1 1 0.995 1 1 1];
    CV_8 = D(8,:).*[1 1 0.999 1 0.995 0.94 0.93];
    CV_7 = D(7,:).*[1 1 1 0.995 1 0.98 0.98];
    CV_6 = D(6,:).*[1 1 1 1 1.005 1.01 1];
    my_phi_num = 6;
    showFxn = false;
    voltRange = 1:7;
    whichPlot = 0;




D(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];
% zero out the entries where i dont have data
D(:,volts_to_exclude_indices) = 0;
D(no_acoustic_vol_frac_indices,2:end) = 0;

y_handpicked_03_17 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);

if whichPlot==1
    show_F_vs_x(restricted_data_table,y_handpicked_03_17,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
    xlim([1e-3 1.5])
elseif whichPlot == 2
    show_F_vs_xc_x(restricted_data_table,y_handpicked_03_17,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end

return
show_F_vs_x(restricted_data_table,y_handpicked_03_17,@modelHandpickedAllExp,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',true)
xlim([1e-3 1.5])
show_F_vs_xc_x(restricted_data_table,y_handpicked_03_17,@modelHandpickedAllExp,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',true)

plot_C_phi_V(may_ceramic_09_17,y_handpicked_03_17);


