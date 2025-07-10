% populates phi0, sigmastar0V, D_0V, and interpolating function
% parameters

%optimize_C_jardy_07_08;
y = y_lsq_0V;
eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar0V = y(6);
D = y(7:end);


% pick a volume fraction to work on


c=1;

    my_phi_num = 13;
    voltRange = 1:7;
    showFxn = false;
    whichPlot = 1;


y_handpicked_07_08 = [eta0, phi0, delta, A, width, sigmastar0V, c, D];

if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_07_08,@modelLinearSigmastarA,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
    xlim([1e-3 1.5])
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_07_08,@modelLinearSigmastarA,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end


%show_F_vs_xc_x(dataTable,y_handpicked_03_19,@modelHandpickedSigmastarV)





