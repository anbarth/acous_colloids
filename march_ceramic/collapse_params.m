%phi0=.5923;
phi0 = 0.67;

%sigmastar = 0.2784; %k=1
%sigmastar = 0.1647; %k=0.5
%sigmastar = 0.2149; %k=0.75

meeraMultiplier_X = 1/2*15.4/13.95;
% glycerol viscosity 20c: 1.412 Pa s
% 90-10 GW viscosity 20c: 0.23 Pa s
% expect this factor to be 0.23/1.412 = 0.163
meeraMultiplier_Y = 1/0.2*0.09; %=0.45. hm, not what i expected
%meeraMultiplier = 1/0.2*0.04;



% C = ones(9,8);

% write C for each voltage separately
C1 = [0.2 0.4706    1.2145    1.5268    1.2664    1.0458    0.9993    0.7640    0.6991];
C2 = [0.0880    0.1180    1.2636    1.5033    1.2550    1.0218    0.9864    0.7607    0.6921];
C3 = [ 0.0880    0.1180    1.1316    1.4465    1.2055    0.9676    0.9589    0.7441    0.6722];
C4 = [0.0880    0.1180    1.1430    1.4468    1.1923    0.9374    0.9525    0.7393    0.6621];
C5 = [0.0880    0.1180    0.9594    1.4224    1.1449    0.8703    0.9244    0.7262    0.6378];
C6 = [0.0880    0.1180    1.0061    1.3806    1.0617    0.7783    0.8779    0.7028    0.6055];
C7 = [0.0880    0.1180    0.9594    1.3378    0.9989    0.6987    0.8552    0.6818    0.5892];
C8 = [0.0880    0.1180    0.9919    1.3715    0.9639    0.6469    0.8524    0.6885    0.5890];
C = 1/10*[C1',C2',C3',C4',C5',C6',C7',C8'];
%C = 1/10*[C1',C1',C1',C1',C1',C1',C1',C1'];

% Cvec = 1/10*[C1';C2';C3';C4';C5';C6';C7';C8'];
% volt_list = [0,5,10,20,40,60,80,100];
% load('data\datatable_05_02.mat');
% phi_list = unique(march_data_table_05_02(:,1));
% lookupPhiV = zeros(9*8,2);
% for ii=1:8
%     lookupPhiV((9*ii-8):9*ii,1) = phi_list;
%     lookupPhiV((9*ii-8):9*ii,2) = ones(9,1)*volt_list(ii);
% end
% C = @(phi,V) Cvec(lookupPhiV(:,1)==phi & lookupPhiV(:,2)==V);

%k=1;
%k=0.75;
%k=0.5;
%f = @(sigma) exp(-(sigmastar ./ sigma).^k);

% k(V)

k = [1 1 1 1 1 1 1 1];

%sigmastar = [0.2916 0.2916 0.2916 0.2916 0.2916 0.2916 1 0.2916];
%sigmastar = [linspace(0.2916,1,7),1.2];

%sigmastar = 0.2784*ones(1,8);
%sigmastar(7) = 1;
sigmastar = [0.2784    0.3515    0.4130    0.4637    0.6290    0.8909    1.0958    1.4797];


f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^k(jj));

% k=0.5 + redefined P based on Q factor
c=0.0848;
d=0.3776;

% same as above but fix d=0.5
%c=0.1267;
%d=0.5;

% k=1 and using best fit exponential for calcA
%c = 1.7798e-04;
%d = 0.7842;

%A = @(P) exp(-(c*P).^d);

A = @(P) 1;