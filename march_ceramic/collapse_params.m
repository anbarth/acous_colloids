%phi0=.5923;
phi0 = 0.6804;

sigmastar = 4.45;

meeraMultiplier_X = 1/2*15.4/13.95;
% glycerol viscosity 20c: 1.412 Pa s
% 90-10 GW viscosity 20c: 0.23 Pa s
% expect this factor to be 0.23/1.412 = 0.163
meeraMultiplier_Y = 1/0.2*0.09; %=0.45. hm, not what i expected
%meeraMultiplier = 1/0.2*0.04;

%C = ones(6,1);
%C = [0.5,1.1,1.3,1.15,0.93,0.7]; % xc = 7.9

% iteration 1
%C = [0.63    1.39    1.7    1.48    1.195    0.9];
c=9.45e-5;
d=0.5261;

C = [0.5    1.37    1.65    1.35    1.18    0.9];




k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);




A = @(P) exp(-(c*P).^d);
%A = @(P) exp(-c*P).^d;
%A = @(P) 1;