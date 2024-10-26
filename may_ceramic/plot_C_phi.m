function plot_C_phi(stressTable, paramsVector)

alpha = 0;

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13);
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

figure;
hold on;


%xlim([0.15 0.75])
ylabel('D')
xlabel('\phi')
%xline(phi0)


myC = C(:,1);
myPhi = phi_list+phi_fudge';


myPhi = myPhi(myC ~= 0);
myC = myC(myC~=0);

myC = myC .* (phi0-myPhi).^alpha;

%ax1=gca; ax1.XScale='log'; ax1.YScale='log';
%plot(phi0-myPhi,myC,'-o','LineWidth',1.5);
plot(myPhi,myC,'-o','LineWidth',1.5);

%phiFake = linspace(0.2,0.69);
%plot(phiFake,1./(1.3*(phi0-phiFake).^0.1))
%plot(phiFake,0.8*(1+0.02*(phi0-phiFake).^-1));

%ylim([0 2])


end
