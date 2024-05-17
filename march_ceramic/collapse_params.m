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

% best k=1 collapse
%C = [0.7 1.3 1.15 0.95 0.8]; % by eye
%C = [0.4 1.3 0.9 0.8 0.8]; % aligning elbows?
%C = [1.0902    1.5301    1.3011    1.0537    0.8429]; %calcC


% k=0.5
%C = [0.9 1.2 1.1 0.9 0.8];
%C = [0.7912    1.1503    0.9825    0.8263    0.7167]; %calcC with sigmastar=0.275
%C = [1.0459    1.4173    1.1928    0.9792    0.8144]; %calcC with sigmastar=0.1645

% k=0.75
%C = [1.0054    1.4365    1.2226    1.0036    0.8216]; %using calcC


% good stuff here
%C = [0.2 0.4706    1.2145    1.5268    1.2664    1.0458    0.9993    0.7640    0.6991];


%G = [1 1 1 1 0.7 0.65 0.65 0.5];
%G = [1 1 1 0.9 0.8 0.75 0.65 0.6];
%G = [1 1 1 1 1 1 1 1];
%G = linspace(1,0.9,8);


% C0 = [0.2 0.4706    1.2145    1.5268    1.2664    1.0458    0.9993    0.7640    0.6991];
% Gphi = [0.46,0.46,0.46,0.46,0.4,0.5,0.2,0.1,0.1]; 
% %Gphi = ones(1,9)*0.6; 
% G = zeros(9,8);
% volt_list = [0,5,10,20,40,60,80,100];
% for ii=1:size(G,1)
%     %G(ii,:) = linspace(1,Gphi(ii),8);
%     G(ii,:) = C0(ii) * (1 - Gphi(ii).*volt_list/100);
% end
% C = G*1/10;

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
%C = 1/10*[C1',C2',C3',C4',C5',C6',C7',C8'];
Cvec = 1/10*[C1';C2';C3';C4';C5';C6';C7';C8'];
volt_list = [0,5,10,20,40,60,80,100];
load('data\datatable_05_02.mat');
phi_list = unique(march_data_table_05_02(:,1));
lookupPhiV = zeros(9*8,2);
for ii=1:8
    lookupPhiV((9*ii-8):9*ii,1) = phi_list;
    lookupPhiV((9*ii-8):9*ii,2) = ones(9,1)*volt_list(ii);
end
C = @(phi,V) Cvec(lookupPhiV(:,1)==phi & lookupPhiV(:,2)==V);

%k=1;
%k=0.75;
%k=0.5;
%f = @(sigma) exp(-(sigmastar ./ sigma).^k);

% k(V)

k = [1 1 1 1 1 1 1 1];

%sigmastar = [0.2916 0.2916 0.2916 0.2916 0.2916 0.2916 1 0.2916];
%sigmastar = [linspace(0.2916,1,7),1.2];

%sigmastar = 0.2784*ones(1,8);
%sigmastar = [0.2784 0.2784 0.2784 0.2784 0.2784 0.2784 0.2784 0.2784];
sigmastar = [0.2784    0.3515    0.4130    0.4637    0.6290    0.8909    1.0958    1.4797];
%sigmastar = linspace(0.2784,1.2,8);

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