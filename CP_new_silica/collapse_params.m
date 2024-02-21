%phi0=.5923;
phi0 = .58;

C = [1,1];


sigmastar = 30;



%meeraMultiplier = 1/0.2*0.04;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);
%A = @(P) exp(-c*P).^d;
A = @(P) 1;