function [eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParamsHandpickedAll(y,numPhi)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
%y = reshape(y,[1 12+7*numPhi]);

eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar = y(6:12);
D = [y(13:12+numPhi);...
    y(13+numPhi:12+2*numPhi);y(13+2*numPhi:12+3*numPhi);...
    y(13+3*numPhi:12+4*numPhi);y(13+4*numPhi:12+5*numPhi);...
    y(13+5*numPhi:12+6*numPhi);y(13+6*numPhi:12+7*numPhi)]';

phi_fudge = y(13+7*numPhi:end);
phi_fudge(isnan(phi_fudge))=0;

end