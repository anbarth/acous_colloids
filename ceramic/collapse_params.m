%phi0=.5923;
phi0 = 0.6804;

%C = ones(6,1);
C = [0.2,0.9,1.2,1.1,0.9,0.7];


sigmastar = 4.45;



%meeraMultiplier = 1/0.2*0.04;

k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);

c = 9.45e-5;
d = 0.53;
%c = 7.48e-4;
%d=0.613;
A = @(P) exp(-c*P).^d;
%A = @(P) 1;