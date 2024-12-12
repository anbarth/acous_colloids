dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7013; 
sigmastar = 0.4589*ones(1,numV);
phi_fudge = zeros(size(phi_list))';


% not important here
eta0 = 0.0270; delta = -1; A = 0.04; width = 1;


% determined in hand_collapse_10_28 and copied to here
D = zeros(numPhi,numV);
D_0V = [0.01 0.025 0.1 0.2 0.25 0.4 0.7 0.8 0.85 0.97 0.95 0.97 1.02]*1/1.01/1.02;
D(:,1) = D_0V;

y_handpicked_11_18 = zipParams(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);


% pick a volume fraction to work on


    DV_13 = D(13,1)*[1 1 0.997 0.98 0.975 0.95 0.95];
    phi0V_13 = phi0*[1 1 1 1 1.07 1.07 1.05];
    my_phi_num = 13;
    voltRange = [1 5 6 7];
    showFxn = false;
    whichPlot = 0;

   


    DV_12 = D(12,1)*[1 0.999 0.996 0.989 0.97 0.96 0.93];

    
    DV_11 = D(11,1)*[1.0000    1    0.995    0.986    0.965         0         0];


    DV_10 = D(10,1)*[1.0000    0.995    0.993   0.965    0.94    0.92    0.87];


    DV_9 = D(9,1)*[1.0000    0.98    0.97   0.95    0.9         0.85         0.72];


    DV_8 = D(8,1)*[1.0000    0.995    0.985    0.955    0.87         0.81         0.75];


    DV_7 = D(7,1)*[1.0000    0.995    0.97    0.94    0.82         0.74         0.69];


    DV_6 = D(6,1)*[1.0000    0.985    0.98    0.93    0.8         0.75         0.64];

D(6:13,:) = [DV_6;DV_7;DV_8;DV_9;DV_10;DV_11;DV_12;DV_13];

y_handpicked_11_18 = zipParams(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);

    show_F_vs_x_phi0V(may_ceramic_09_17,y_handpicked_11_18,phi0V_13,'PhiRange',13,'ShowLines',true,'VoltRange',voltRange)
