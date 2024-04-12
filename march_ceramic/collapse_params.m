%phi0=.5923;
phi0 = 0.678;

%sigmastar = 0.275; %k=1
%sigmastar = 0.1645; %k=0.5
sigmastar = 0.2263; %k=0.75

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
C = [1.0054    1.4365    1.2226    1.0036    0.8216]; %using calcC


%C = ones(5,1);



%k=0.5;
k=0.75;
%k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);

% k=0.5 + redefined P based on Q factor
c=0.0848;
d=0.3776;

% same as above but fix d=0.5
%c=0.1267;
%d=0.5;

% k=1 and using best fit exponential for calcA
%c = 1.7798e-04;
%d = 0.7842;

A = @(P) exp(-(c*P).^d);

%A = @(P) 1;