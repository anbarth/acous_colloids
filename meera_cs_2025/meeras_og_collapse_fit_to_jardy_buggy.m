% extracted from spreadsheet
sigmastar = 3.884513;
phi0 = 0.6448091;

% from the sheet Cphi2
C1 = 1/14.5*[0.015927632	0.018405264	0.097091989	0.449867948	0.738476722	0.690197403 ...
    1.09725352	1.434802329	1.901770102	2.192992289	2.439498924	2.409932549	...
    2.348813303	2.394189546	2.31713165	2.191783254	2.170025002	2.096806397	2.052581479...
    1.930983088	1.912993783	1.804182513	1.622650521	1.577736347	1.514463988	1.39644087	...
    1.242312633	1.260424989	1.093716733	0.953947368];
phi_list = unique(dataTable(:,1));
C = C1(ismember(phi_list_full,phi_list));
D = C./(phi0-phi_list');

f=@(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar_WC,phimu,phi0_WC] = wyart_cates(dataTable,f,false);

eta0 = eta0*1.5;
delta = -1.5;
A = eta0;
width = 0.5;
y = [eta0 phi0 delta 0.2 width sigmastar D];
show_F_vs_xc_x(dataTable,y,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot;
%return

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpicked(dataTable, y);
H = F.*x.^2;
xi = 1./x-1;

%jardy = @(A, eta0, h, delta, xi) sqrt(A*eta0)*xi.^((-2+delta)/2) .* ( (xi/(A/eta0)^(1/(-2-delta))).^h + (xi/(A/eta0)^(1/(-2-delta))).^(-h) ).^((-2-delta)/(2*h));
%jardyfittype = fittype(jardy,'Independent','xi');
%myjardyfit = fit(xi,H,jardyfittype,'StartPoint',[A eta0 width delta],'Weights',1./delta_eta.^2);

jardy = @(A, eta0, h, delta, x) x.^2 .* (sqrt(A*eta0)*(1./x-1).^((-2+delta)/2)) .* ( ((1./x-1)./(A/eta0)^(1/(-2-delta))).^h + ((1./x-1)./(A/eta0)^(1/(-2-delta))).^(-h) ).^((-2-delta)/(2*h));
jardyfittype = fittype(jardy,'Independent','x');
myjardyfit = fit(x,F,jardyfittype,'StartPoint',[A eta0 width delta],'Lower',[0 0 0 -Inf],'Upper',[Inf Inf Inf 0],'Weights',1./delta_eta.^2);
yjardy = [myjardyfit.eta0 phi0 myjardyfit.delta myjardyfit.A myjardyfit.h sigmastar D];

%costfxn = @(y)  sum(get_residuals(dataTable,y,@modelHandpicked).^2);

% show collapse
show_F_vs_x(dataTable,yjardy,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot; %xlim([1e-5 1.5])
%show_F_vs_xc_x(dataTable,yjardy,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot;
return
% find alpha
dphi = phi0-phi_list;
cutoff_dphi = 0.17;
fitregion = dphi < cutoff_dphi;

linearfit = fittype('poly1');
myft2 = fit(log(dphi(fitregion)),log(D(fitregion))',linearfit);
alpha = -myft2.p1;
figure; hold on; makeAxesLogLog; plot(phi0-phi_list,D,'ko'); prettyplot;
plot(dphi(fitregion),dphi(fitregion).^myft2.p1*exp(myft2.p2),'b-')