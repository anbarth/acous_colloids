phi46 = cp_data(cp_data(:,1)==0.46,3:4);
phi48 = cp_data(cp_data(:,1)==0.48,3:4);
phi50 = cp_data(cp_data(:,1)==0.50,3:4);
phi52 = cp_data(cp_data(:,1)==0.52,3:4);
phi54 = cp_data(cp_data(:,1)==0.54,3:4);

%figure; hold on;
%ax1 = gca;
%ax1.XScale = 'log';
%ax1.YScale = 'log';

%plot(phi48(:,1),phi48(:,2),'-o');
%plot(phi52(:,1),phi52(:,2),'-o');
%plot(phi54(:,1),phi54(:,2),'-o');
%xlabel('\sigma (Pa)');
%ylabel('\eta (Pa s)');
%return;

%figure; hold on;
phis = [0.46,0.48,0.5,0.52,0.54];
etas = [min(phi46(:,2)),min(phi48(:,2)),min(phi50(:,2)),min(phi52(:,2)),min(phi54(:,2))];
%phis = [0.46,0.48,0.52,0.5,0.54];
%etas = [min(phi46(:,2)),min(phi48(:,2)),min(phi50(:,2)),min(phi52(:,2)),min(phi54(:,2))];
plot(phis,1./sqrt(etas),'o');
P = polyfit(phis,1./sqrt(etas),1);
sqrtEtaFit = P(1)*phis+P(2);
plot(phis,sqrtEtaFit,'r-');

xlabel('\phi')
ylabel('\eta^{-1/2}')

disp(-1*P(2)/P(1));