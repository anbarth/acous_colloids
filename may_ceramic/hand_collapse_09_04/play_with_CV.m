%dataTable = may_ceramic_06_25;
dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7011; phi_fudge = zeros(size(phi_list))'; xc = 1.0162; sigmastar0V = 0.3011;
C = zeros(numPhi,numV);
C(:,1) = 1/xc*[0.01 0.025 0.05 0.1 0.25 0.5 0.75 0.8 0.85 0.925 0.95 0.975 1];


% interpolating function parameters to guide the eye 
eta0 = 0.0270; delta = -1.1995; A = 0.0227; width = 1.0955;


% pick a volume fraction to work on
my_phi_num = 7;

    CV_13 = [C(13,1) 0.98 0.98 0.98 0.95 0.95 0.94];
    sigmastar_13 = [sigmastar0V 0.3011 0.3011 0.6 0.8 1.2 2];

    CV_12 = [C(12,1) 0.95 0.95 0.95 0.93 0.91 0.9];
    sigmastar_12 = [sigmastar0V 0.3011 0.3011 0.5 0.8 1.3 2];

    CV_11 = [C(11,1) 0.93 0.93 0.9 0.875 0 0];
    sigmastar_11 = [sigmastar0V 0.3011 0.35 0.5 0.8 0 0];

    CV_10 = [C(10,1) 0.91 0.9 0.875 0.85 0.82 0.8];
    sigmastar_10 = [sigmastar0V 0.3011 0.37 0.5 0.9 1.5 2];

    CV_9 = [C(9,1) 0.83 0.83 0.8 0.75 0.7 0.65];
    sigmastar_9 = [sigmastar0V 0.3011 0.4 0.6 1 1.5 2];

    CV_8 = [C(8,1) 0.78 0.78 0.76 0.7 0.65 0.5];
    sigmastar_8 = [sigmastar0V 0.3011 0.35 0.5 1 2 2.5];

    CV_7 = [C(7,1) 0.75 0.72 0.7 0.65 0.57 0.53];
    sigmastar_7 = [sigmastar0V 0.35 0.4 0.6 1 2 3.1];

    CV_6 = [C(6,1) 0.49 0.47 0.46 0.42 0.36 0.32];
    sigmastar_6 = [sigmastar0V 0.32 0.4 0.6 1 1.5 2.5];



C(6:13,:) = [CV_6;CV_7;CV_8;CV_9;CV_10;CV_11;CV_12;CV_13];
sigmastar_list = [sigmastar_6;sigmastar_7;sigmastar_8;sigmastar_9;sigmastar_10;sigmastar_11;sigmastar_12;sigmastar_13];
sigmastar = sigmastar_list(my_phi_num-5,:);

y_init = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);
%show_F_vs_x(dataTable,y_init,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',1:7,'ColorBy',1,'ShowInterpolatingFunction',true)





