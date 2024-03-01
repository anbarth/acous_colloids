
phi0 = 0.5965;

C = ones(8,1);
%C = [0.5,1.1,1.3,1.15,0.93,0.7];


sigmastar = 0.7374;

meeraMultiplier_X = 1/2;
% glycerol viscosity 20c: 1.412 Pa s
% 90-10 GW viscosity 20c: 0.23 Pa s
% expect this factor to be 0.23/1.412 = 0.163
meeraMultiplier_Y = 1/0.2*0.09; %=0.45. hm, not what i expected
%meeraMultiplier = 1/0.2*0.04;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);

%c = 9.45e-5;
%d = 0.53;

%c = 7.48e-4;
%d=0.613;

c = 1.91e-4;
d = 1.07;
%A = @(P) exp(-c*P).^d;
A = @(P) 1;