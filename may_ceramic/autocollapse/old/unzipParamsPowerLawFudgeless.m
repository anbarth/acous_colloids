function [eta0, phi0, delta, sigmastar, C] = unzipParamsPowerLawFudgeless(y,numPhi)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]

eta0 = y(1);
phi0 = y(2);
delta = y(3);
sigmastar = y(4:10);
C = [y(11:10+numPhi);...
    y(11+numPhi:10+2*numPhi);y(11+2*numPhi:10+3*numPhi);...
    y(11+3*numPhi:10+4*numPhi);y(11+4*numPhi:10+5*numPhi);...
    y(11+5*numPhi:10+6*numPhi);y(11+6*numPhi:10+7*numPhi)]';

end