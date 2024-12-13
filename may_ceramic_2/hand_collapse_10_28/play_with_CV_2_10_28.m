% populates phi0, sigmastar, and D_0V=C(:,1), and interpolating function
% parameters
fit_sigmastar_10_28;



% pick a volume fraction to work on


    CV_13 = C(13,:).*[1 1.001 1.00 1 1 1 0.97];
    CV_12 = C(12,:).*[1 1.002 1 1.002 1.0 1.0 1.02];
    CV_11 = C(11,:).*[1 1.002 1.005 1 1 1 1];
    CV_10 = C(10,:).*[1 1.00 1.0 1.02 1.03 1.0 1.06];
    CV_9 = C(9,:).*[1 1.02 1.02 1 1 1.02 1.15];
    CV_8 = C(8,:).*[1 1.01 1.005 1 1.01 0.9 0.9];
    CV_7 = C(7,:).*[1 1 1.01 1.01 1.07 1.01 1.03];
    CV_6 = C(6,:).*[1 1.03 1.01 1.04 1.08 1.03 1.1];
    my_phi_num = 6;
    showFxn = false;
    voltRange = 1:7;
    whichPlot = 0;




C(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];

y_handpicked_10_28 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_10_28,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_10_28,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end

%show_F_vs_x(dataTable,y_handpicked_10_28,'ColorBy',1,'ShowInterpolatingFunction',showFxn);%,'VoltRange',1,'ShowLines',true)
%show_F_vs_xc_x(dataTable,y_handpicked_10_28,'ColorBy',1,'ShowInterpolatingFunction',showFxn)





