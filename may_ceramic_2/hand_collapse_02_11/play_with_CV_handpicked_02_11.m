% populates phi0, sigmastar0V, D_0V, and interpolating function
% parameters
play_with_C_02_11;


% pick a volume fraction to work on


    CV_13 = D_0V(13)*[1 1 0.999 0.97 0.985 0.98 0.97];
    sigmastar_13 = sigmastar0V*[1 1.1 1.4 2 3.5 5.5 10];

    CV_12 = D_0V(12)*[1 0.999 0.997 0.993 0.98 0.975 0.955];
    sigmastar_12 = sigmastar0V*[1 1.1 1.3 1.8 3.2 5 7];
    
    CV_11 = D_0V(11)*[1 1 0.997 0.994 0.975 0 0];
    sigmastar_11 = sigmastar0V*[1 1.1 1.3 1.8 3.1 0 0];

    CV_10 = D_0V(10)*[1 0.995 0.989 0.976 0.955 0.96 0.92];
    sigmastar_10 = sigmastar0V*[1 1.1 1.2 1.7 3.1 6 8];

    CV_9 = D_0V(9)*[1 0.99 0.985 0.96 0.91 0.86 0.77];
    sigmastar_9 = sigmastar0V*[1 1 1.3 1.8 3 4.5 6];

    CV_8 = D_0V(8)*[1 0.996 0.99 0.97 0.91 0.87 0.76];
    sigmastar_8 = sigmastar0V*[1 1.1 1.3 1.9 3.4 8 12];

    CV_7 = D_0V(7)*[1 0.99 0.98 0.95 0.88 0.82 0.77];
    sigmastar_7 = sigmastar0V*[1 1.1 1.3 1.9 3.5 7 11];

    CV_6 = D_0V(6)*[1 0.99 0.96 0.95 0.86 0.8 0.75];
    sigmastar_6 = sigmastar0V*[1 1 1.2 1.8 3.1 5 9];
    my_phi_num = 8;
    voltRange = 1:7;
    showFxn = false;
    whichPlot = 2;
    

D = zeros(numPhi,numV);
D(:,1) = D_0V';
D(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];
sigmastar_list = [sigmastar_6;sigmastar_7;sigmastar_8;sigmastar_9;sigmastar_10;sigmastar_11;sigmastar_12;sigmastar_13];
sigmastar = sigmastar_list(my_phi_num-5,:);

phi_fudge = zeros(1,length(phi_list));
y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_02_11,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
    xlim([1e-3 1.5])
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_02_11,@modelHandpickedAllExp,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end








