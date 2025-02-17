% populates phi0, sigmastar, and D_0V=C(:,1), and interpolating function
% parameters
fit_sigmastar_02_11;



% pick a volume fraction to work on


    CV_13 = D(13,:).*[1 1 1 0.95 1 1 1];
    CV_12 = D(12,:).*[1 1 1 1 1.001 1.001 1.005];
    CV_11 = D(11,:).*[1 1 1 1 1 1 1];
    CV_10 = D(10,:).*[1 1 1 1 1 1 1];
    CV_9 = D(9,:).*[1 1 1 1 1 1 1];
    CV_8 = D(8,:).*[1 1 1 1 1 1 1];
    CV_7 = D(7,:).*[1 1 1 1 1 1 1];
    CV_6 = D(6,:).*[1 1 1 1 1 1 1];
    my_phi_num = 11;
    showFxn = false;
    voltRange = 1:3;
    whichPlot = 2;




D(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];

y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);

if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_02_11,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
    xlim([1e-3 1.5])
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_02_11,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end

%show_F_vs_x(dataTable,y_handpicked_10_07,'ColorBy',1,'ShowInterpolatingFunction',showFxn);%,'VoltRange',1,'ShowLines',true)
%show_F_vs_xc_x(dataTable,y_handpicked_10_07,'ColorBy',1,'ShowInterpolatingFunction',showFxn)





