% populates phi0, sigmastar, and D_0V=C(:,1), and interpolating function
% parameters
play_with_C;
sigmastar0V = sigmastar(1);



% pick a volume fraction to work on


    CV_13 = C(13,1)*[1 1 0.997 0.98 0.975 0.95 0.95];
    sigmastar_13 = [sigmastar0V 0.5 0.6 0.9 1.5 2.5 4];

    CV_12 = C(12,1)*[1 0.999 0.996 0.989 0.97 0.96 0.93];
    sigmastar_12 = [sigmastar0V 0.49 0.6 0.8 1.4 2.1 2.7];
    
    CV_11 = C(11,1)*[1.0000    1    0.995    0.986    0.965         0         0];
    sigmastar_11 = [sigmastar0V 0.5 0.6 0.8 1.5 0 0];

    CV_10 = C(10,1)*[1.0000    0.995    0.993   0.965    0.94    0.92    0.87];
    sigmastar_10 = [sigmastar0V 0.5 0.6 0.8 1.4 2.4 3];

    CV_9 = C(9,1)*[1.0000    0.98    0.97   0.95    0.9         0.85         0.72];
    sigmastar_9 = [sigmastar0V 0.45 0.55 0.8 1.4 2 2];

    CV_8 = C(8,1)*[1.0000    0.995    0.985    0.955    0.87         0.81         0.75];
    sigmastar_8 = [sigmastar0V 0.5 0.6 0.85 1.4 3 5];


    CV_7 = C(7,1)*[1.0000    0.995    0.97    0.94    0.82         0.74         0.69];
    sigmastar_7 = [sigmastar0V 0.53 0.6 0.8 1.2 2.2 3.5];


    CV_6 = C(6,1)*[1.0000    0.985    0.98    0.93    0.8         0.75         0.64];
    sigmastar_6 = [sigmastar0V 0.48 0.6 0.8 1.2 1.9 2.7];
    my_phi_num = 13;
    voltRange = 1:7;
    showFxn = false;
    whichPlot = 0;




C(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];
sigmastar_list = [sigmastar_6;sigmastar_7;sigmastar_8;sigmastar_9;sigmastar_10;sigmastar_11;sigmastar_12;sigmastar_13];
sigmastar = sigmastar_list(my_phi_num-5,:);

y_handpicked_10_07 = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);
if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_10_07,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_10_07,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end

%show_F_vs_x(dataTable,y_init,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
%show_F_vs_xc_x(dataTable,y_init,'ColorBy',1,'ShowInterpolatingFunction',showFxn)





