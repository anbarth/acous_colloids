% populates phi0, sigmastar0V, D_0V, and interpolating function
% parameters
%optimize_C_03_25;

y = y_fmincon_0V;
eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar0V = y(6);
D = y(7:end);


% pick a volume fraction to work on


    sigmastar_13 = sigmastar0V*[1 1.1 1.4 2.1 4 6 11];
    sigmastar_12 = sigmastar0V*[1 1.1 1.4 1.8 3.2 5 6];
    sigmastar_11 = sigmastar0V*[1 1.1 1.3 1.9 3.5 0 0];
    sigmastar_10 = sigmastar0V*[1 1.1 1.3 1.8 3.7 6.5 8];
    sigmastar_9 = sigmastar0V*[1 1.05 1.4 2 3.5 6 8];
    sigmastar_8 = sigmastar0V*[1 1.1 1.4 2 4.2 10 16];
    sigmastar_7 = sigmastar0V*[1 1.15 1.4 2 3.8 9 13];
    sigmastar_6 = sigmastar0V*[1 1.1 1.4 2 3.8 6.5 11];

    my_phi_num = 13;
    voltRange = 1:3;
    showFxn = false;
    whichPlot = 2;

% zero out unused entries
sigmastar_list_full = [sigmastar_6;sigmastar_7;sigmastar_8;sigmastar_9;sigmastar_10;sigmastar_11;sigmastar_12;sigmastar_13];
sigmastar_list_temp = sigmastar_list_full;
sigmastar_list_temp(:,excluded_V_indices) = 0;
sigmastar_list = zeros(size(sigmastar_list_temp));
included_acous_phi_indices = intersect(6:13,included_phi_indices);
sigmastar_list(included_acous_phi_indices-5,:) = sigmastar_list_temp(included_acous_phi_indices-5,:);

sigmastar = sigmastar_list(my_phi_num-5,:);

y_handpicked_03_25 = [eta0, phi0, delta, A, width, sigmastar, D];

if whichPlot==1
    show_F_vs_x(dataTable,y_handpicked_03_25,@modelHandpickedSigmastarV,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
    xlim([1e-3 1.5])
elseif whichPlot == 2
    show_F_vs_xc_x(dataTable,y_handpicked_03_25,@modelHandpickedSigmastarV,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',voltRange,'ColorBy',1,'ShowInterpolatingFunction',showFxn)
end








