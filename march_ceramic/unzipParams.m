function [eta0, phi0, delta, sigmastar, C] = unzipParams(y,numPhi)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]

eta0 = y(1);
phi0 = y(2);
delta = y(3);
sigmastar = y(4:11);
C = [y(12:11+numPhi);...
    y(12+numPhi:11+2*numPhi);y(12+2*numPhi:11+3*numPhi);...
    y(12+3*numPhi:11+4*numPhi);y(12+4*numPhi:11+5*numPhi);...
    y(12+5*numPhi:11+6*numPhi);y(12+6*numPhi:11+7*numPhi);...
    y(12+7*numPhi:11+8*numPhi)]';

end