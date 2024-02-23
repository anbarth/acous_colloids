%phi0=.5923;
phi0 = 0.6959;

C = [0.2,0.8,1.2,0.9,0.7];


sigmastar = 4.15;



%meeraMultiplier = 1/0.2*0.04;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);

c = 1.1e-4;
d = 0.53;
A = @(P) exp(-c*P).^d;
%A = @(P) 1;