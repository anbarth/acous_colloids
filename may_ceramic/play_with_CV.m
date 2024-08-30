dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7011; phi_fudge = zeros(size(phi_list))'; xc = 1.0162; sigmastar0V = 0.3011;
C = ones(numPhi,numV);
C(:,1) = 1/xc*[0.01 0.025 0.05 0.1 0.25 0.5 0.75 0.8 0.85 0.925 0.95 0.975 1];


% interpolating function parameters to guide the eye 
eta0 = 0.0270; delta = -1.1995; A = 0.0227; width = 1.0955;


% pick a volume fraction
my_phi_num = 13;

if my_phi_num == 13
    CV_guess = [C(my_phi_num,1) 1 1 1 0.95 0.95 0.9];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.4 0.8 1.2 1.2];
elseif my_phi_num == 12
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 11
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 10
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 9
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 8
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 7
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
elseif my_phi_num == 6
    CV_guess = [C(my_phi_num,1) 1 1 1 1 1 1];
    sigmastar = [sigmastar0V 0.3011 0.3011 0.3011 0.3011 0.3011 0.3011];
end



C(my_phi_num,:) = CV_guess;
y_init = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

show_F_vs_x(dataTable,y_init,'PhiRange',my_phi_num,'ShowLines',true,'VoltRange',1:7,'ColorBy',1,'ShowInterpolatingFunction',true)
