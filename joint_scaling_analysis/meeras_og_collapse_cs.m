dataTable = meera_cs_table;
phi_list_full = unique(dataTable(:,1));
dataTable = dataTable(dataTable(:,1)<=0.54,:);


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
[F0,sigmastar_WC,phimu,phi0_WC] = wyart_cates(dataTable,f,false);

F0 = F0*1.5;
delta = -1.5;
A = 1;
width = 0.5;
y_cs_og = [F0 phi0 delta A width sigmastar D];

% show collapse
show_F_vs_x(dataTable,y_cs_og,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot; xlim([1e-5 1.5])
show_F_vs_xc_x(dataTable,y_cs_og,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot;

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