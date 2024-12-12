function plot_C_phi(stressTable, paramsVector)

alpha = 0.14;

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13);
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

%figure;
hold on;
%ylabel(strcat('C_',num2str(alpha)))
ylabel('C')
xlabel('\phi')


myC = C(:,1);
myPhi = phi_list+phi_fudge';


myPhi = myPhi(myC ~= 0);
myC = myC(myC~=0);

myC = myC .* (phi0-myPhi).^alpha;

%ax1=gca; ax1.XScale='log'; ax1.YScale='log';

%plot(myPhi,myC,'-o','LineWidth',1.5);
%phiFake = linspace(0.2,0.69);
%plot(phiFake,1./(1.3*(phi0-phiFake).^0.1))
%plot(phi0-myPhi,1./myC,'-o','LineWidth',1.5);

plot(myPhi,myC,'-r','LineWidth',1.5);

%plot(phiFake,0.8*(1+0.02*(phi0-phiFake).^-1));
%plot(phi0-myPhi,1./myC,'-o','LineWidth',1.5);
%disp(myC)
%plot(phi0-myPhi,log(myC),'-o','LineWidth',1.5);


%B = -50;
%a = 3;
%log_D_fake = B*(phi0-myPhi).^a;
%plot(phi0-myPhi,log_D_fake,'-','LineWidth',1);

%ylim([0 6])

end
