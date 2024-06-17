function y = zipParamsFudge(eta0, phi0, delta, sigmastar, C, phi_fudge)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ..., phi_fudge]

C0 = C(:,1)';
C5 = C(:,2)';
C10 = C(:,3)';
C20 = C(:,4)';
C40 = C(:,5)';
C60 = C(:,6)';
C80 = C(:,7)';

y = [eta0, phi0, delta, sigmastar, C0, C5, C10, C20, C40, C60, C80, phi_fudge];

end