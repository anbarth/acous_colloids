%phi0=.5923;
phi0 = 0.678;

sigmastar = 0.275;

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
C = [0.7912    1.1503    0.9825    0.8263    0.7167]; %calcC

%C = ones(5,1);



k=0.5;
%k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);


% vanilla
c=   1.6785e-04;
d=    0.3999;


% k=0.5 + redefined P based on Q factor
%c=0.1267;
%d=0.5;

% k=3
%c=0.0014;
%d=0.8831;

A = @(P) exp(-(c*P).^d);

%A = @(P) 1;