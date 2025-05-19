function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedJoint(stressTable, y)

% universal stuff comes first
delta = y(1);
A = y(2);
width = y(3);
startIndex = 4;
numMaterials = length(unique(stressTable(:,6)));

% make blank vectors to fill in
x = NaN(size(stressTable,1),1);
F = x;
delta_F = x;
F_hat = x;
eta = x;
delta_eta = x;
eta_hat = x;

% now cycle through the different materials...
for mm=1:numMaterials
    myData = stressTable(:,6)==mm;
    phi_list = unique(stressTable(myData,1));
    numPhi = length(phi_list);
    %phi_list_per_material{mm} = phi_list;

    F0 = y(startIndex);
    phi0 = y(startIndex+1);
    sigmastar = y(startIndex+2);
    D = y(startIndex+3:startIndex+2+numPhi);

    y_single = [F0 phi0 delta A width sigmastar D];


    [x_1,F_1,delta_F_1,F_hat_1,eta_1,delta_eta_1,eta_hat_1] = modelHandpicked(stressTable(myData,:), y_single);
    x(myData) = x_1;
    F(myData) = F_1;
    F_hat(myData) = F_hat_1;
    delta_F(myData) = delta_F_1;
    eta(myData) = eta_1;
    delta_eta(myData) = delta_eta_1;
    eta_hat(myData) = eta_hat_1;

    % move startIndex for next iteration
    startIndex = startIndex+3+numPhi;

end


end