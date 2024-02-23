%phi0=.5923;
phi0 = .656;

C = [1,1];


sigmastar = 5;



%meeraMultiplier = 1/0.2*0.04;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);

c = 4*10^-5;
%d = 0.35;
d=0.45;
%c=0.5;
%d=1;
A = @(P) exp(-c*P).^d;
%A = @(P) 1;