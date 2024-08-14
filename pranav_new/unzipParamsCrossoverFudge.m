function [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y,numPhi)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]

eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar = y(6:13);
C = [y(14:13+numPhi);...
    y(14+numPhi:13+2*numPhi);y(14+2*numPhi:13+3*numPhi);...
    y(14+3*numPhi:13+4*numPhi);y(14+4*numPhi:13+5*numPhi);...
    y(14+5*numPhi:13+6*numPhi);y(14+6*numPhi:13+7*numPhi);y(14+7*numPhi:13+8*numPhi)]';

phi_fudge = y(14+8*numPhi:end);

end