dataTable = meera_si_table;
phi_list_full = unique(dataTable(:,1));
dataTable = dataTable(dataTable(:,1)<=0.53,:);


% extracted from spreadsheet
sigmastar = 48.21682;
%phi0 = 0.5777;
phi0=0.59;

% from the sheet Cphi2
C1 = 1/14.5*[0.820754717	1.299528302	1.299528302	1.215932914	0.968069666	0.889150943	0.783303983	0.577623844];
phi_list = unique(dataTable(:,1));
C = C1(ismember(phi_list_full,phi_list));
%C = 1/14.5*ones(size(C));
D = C./(phi0-phi_list');


f=@(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar_WC,phimu,phi0_WC] = wyart_cates(dataTable,f,false);


eta0 = eta0;
delta = -1.5;
A = eta0;
width = 0.5;
y = [eta0 phi0 delta A width sigmastar D];

% show collapse
show_F_vs_x(dataTable,y,@modelHandpicked,'ShowInterpolatingFunction',false,'ShowLines',true); prettyplot; xlim([1e-5 1.5])
%show_F_vs_xc_x(dataTable,y,@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot;


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