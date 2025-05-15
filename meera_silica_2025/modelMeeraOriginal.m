function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelMeeraOriginal(stressTable, y)

eta0 = y(1);
delta = y(2);
A = y(3);
width = y(4);


% extracted from spreadsheet
sigmastar = 3.884513;
phi0 = 0.6448091;

% from the sheet Cphi2
phi_list_full = [0.162790698	0.205882353	0.249821437	0.267491927	0.295363632	0.313466986	0.341182353	0.35944277 ...
    0.388888889	0.413043478	0.437401565	0.457485301	0.466654914	0.466954638	0.476871023	0.487139892	...
    0.487240829	0.497157577	0.497664856	0.507123776	0.507429647	0.517652161	0.527617952	0.535150646 ...
    0.538357991	0.548322838	0.558650724	0.559173733	0.569031441	0.580099477]';
C1 = 1/14.5*[0.015927632	0.018405264	0.097091989	0.449867948	0.738476722	0.690197403 ...
    1.09725352	1.434802329	1.901770102	2.192992289	2.439498924	2.409932549	...
    2.348813303	2.394189546	2.31713165	2.191783254	2.170025002	2.096806397	2.052581479...
    1.930983088	1.912993783	1.804182513	1.622650521	1.577736347	1.514463988	1.39644087	...
    1.242312633	1.260424989	1.093716733	0.953947368];
phi_list = unique(stressTable(:,1));

phi_list_rounded = round(phi_list*1000)/1000;
phi_list_full_rounded = round(phi_list_full*1000)/1000;
C = C1(ismember(phi_list_full_rounded,phi_list_rounded));
D = C'./(phi0-phi_list);


f = @(sigma) exp(-sigmastar./sigma);


N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);
eta = zeros(N,1);
delta_eta = zeros(N,1);

for kk = 1:N
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta(kk) = stressTable(kk,4);        
    delta_eta_rheo = max(stressTable(kk,5),eta(kk)*0.05);
    delta_phi = 0.02;
    delta_eta_volumefraction = eta(kk)*2*(phi0-phi)^(-1)*delta_phi;
    delta_eta(kk) = sqrt(delta_eta_rheo.^2+delta_eta_volumefraction.^2);

    ii = find(phi == phi_list);
    
    if voltage == 0
        x(kk) = D(ii)*f(sigma);
        F(kk) = eta(kk)*(phi0-phi)^2;
        delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
    else
        x(kk) = 0;
        F(kk) = 0;
        delta_F(kk) = 0;
    end
end

% calculate F_hat from x
%alpha=1/2;
alpha=1;
xi = x.^(-1/alpha)-1^(-1/alpha);
%xi = x.^-2 - xc^-2;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
H_hat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    H_hat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

F_hat = 1./x.^(2/alpha) .* H_hat;
F_hat(H_hat==0) = eta0;

eta_hat = zeros(N,1);
for kk = 1:N
    phi = stressTable(kk,1);
    eta_hat(kk) = F_hat(kk)*(phi0-phi)^-2;
end 



end