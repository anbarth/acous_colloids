ovarlez_data = [0.708502024291497, 0.1265822784810129
0.708502024291497, 0.18354430379746844
1.7206477732793513, 0.32911392405063333
2.9757085020242915, 0.4303797468354431
2.9757085020242915, 0.8037974683544307
4.676113360323885, 0.9050632911392407
6.700404858299594, 1.189873417721519
9.129554655870445, 1.4810126582278484
12.004048582995953, 1.658227848101266
12.004048582995953, 1.708860759493671
15.20242914979757, 2.0886075949367093];

f = [10 50 15 20 50 25 30 50 35 40 50 45]; % Hz
A = [500 100 500 500 200 500 500 300 500 500 400 500]*1e-6; % m 
% delete one point to be consistent with fig 7
f(7)=[];
A(7)=[];

%rho_solvent = 1000;
%rho_particle = 1300;
%phi_w = .29;
%rho_s = phi_w*rho_particle+(1-phi_w)*rho_solvent;

% checking correspondance bw fig 6 and fig 7 data points
rho_s = 1521.3;
sigma_v_calculated = 1/2*rho_s * A.^2 .* (2*pi*f).^2;


rate_c = ovarlez_data(:,2);
sigma_c = 10*rate_c;
sigma_v = ovarlez_data(:,1);

rate_OSP = 2*pi*f .* A/(28e-3);






%return
figure; hold on;
xlabel('\sigma_v'); ylabel('\sigma_c')
plot(sigma_v,sigma_c,'o')
k_v = 1.5;
x = linspace(min(sigma_v),max(sigma_v));
plot(x,k_v*x,'b-')

%rate_OSP = (sigma_v*2/200).^(1/2)/(28*10^-3); % proportional to gamma_OSP but missing prefactor
figure; hold on;
xlabel('rate_{OSP}'); ylabel('rate_c')
plot(rate_OSP,rate_c,'o')
plot(0,0,'ko','MarkerFaceColor','k')
k_OSP = 0.5;
%offset_OSP = -0.5;
x = linspace(min(rate_OSP),max(rate_OSP));
plot(x,k_OSP*x+offset_OSP,'b-')