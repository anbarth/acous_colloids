%phi0=.5923;
phi0 = 0.6547;

sigmastar = 0.32;

meeraMultiplier_X = 1/2*15.4/13.95;
% glycerol viscosity 20c: 1.412 Pa s
% 90-10 GW viscosity 20c: 0.23 Pa s
% expect this factor to be 0.23/1.412 = 0.163
meeraMultiplier_Y = 1/0.2*0.09; %=0.45. hm, not what i expected
%meeraMultiplier = 1/0.2*0.04;

C = [0.8 1.1 0.6];




k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);




%A = @(P) exp(-(c*P).^d);
%A = @(P) exp(-c*P).^d;
A = @(P) 1;