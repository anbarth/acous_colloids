function y = reducedParamsToFullParams(yReduced,phi_list)

if nargin == 1
    phi_list = [0.1999 0.2503 0.2997 0.3500 0.4009  0.4396 0.4604 0.4811 0.5193 0.5398 0.5607 0.5898 0.6101]';
end

% y = [eta0, phi0, delta, A, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
[eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(yReduced);

volt_list = [0 5 10 20 40 60 80];
numV = length(volt_list);
numPhi = length(phi_list);

D = zeros(numPhi,numV);
sigmastar = zeros(1,numV);
dphi = phi0-phi_list;
for jj=1:numV
    V = volt_list(jj);
    sigmastar(jj) = sigmastarParams(1)*V^2 + sigmastarParams(2)*V + sigmastarParams(3);
    q0 = q0params(1)*V + q0params(2);
    q1 = q1params(1)*V + q1params(2);
    D(:,jj) = 1./( (q0*dphi).^alpha + (q1*dphi).^(alpha+b) );
end

D0 = D(:,1)';
D5 = D(:,2)';
D10 = D(:,3)';
D20 = D(:,4)';
D40 = D(:,5)';
D60 = D(:,6)';
D80 = D(:,7)';
phi_fudge = zeros(1,numPhi);

y = [eta0, phi0, delta, A, width, sigmastar, D0, D5, D10, D20, D40, D60, D80, phi_fudge];

end