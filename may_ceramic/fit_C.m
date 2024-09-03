% pls pls pls run play_with_CV AND fit_sigmastar before this to populate y!!!

ft1 = fittype('1/(1+(x/a)^b)');
opts1 = fitoptions(ft1);
opts1.StartPoint = [0.4,-10];

ft2 = fittype('exp(-(a/x)^b)');
opts2 = fitoptions(ft2);
opts2.StartPoint = [0.44,7];

phiFake = linspace(0.15,0.75);

Cfit = zeros(size(C));
aFit = zeros(7,1);
bFit = zeros(7,1);

figure;
hold on;

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
xlim([0.15 0.75])
xline(phi0)
ylabel('C')
xlabel('\phi')

% for C, do a fit to each voltage
for jj=1:size(C,2)

    myC = C(:,jj);
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);

    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myColor = cmap(round(1+255*voltage/80),:);
    plot(myPhi,myC,'o','Color',myColor,'LineWidth',1.5);
    myFit1 = fit(myPhi,myC,ft1,opts1);
    plot(phiFake,1./(1+(phiFake/myFit1.a).^myFit1.b),'Color',myColor,'LineWidth',1)
    %plot(phiFake,1./(1+(phiFake/myFit1.a).^-10),'Color',myColor,'LineWidth',1)
    
    %myFit2 = fit(myPhi,myC,ft2,opts2);
    %plot(phiFake,exp(-(myFit2.a./phiFake).^myFit2.b),'Color','b','LineWidth',1)

    myPhi = phi_list+phi_fudge';
    Cfit(:,jj) = 1./(1+(myFit1.a*myPhi).^myFit1.b);

    aFit(jj) = myFit1.a;
    bFit(jj) = myFit1.b;
end

% fit a quadratic to a
figure; hold on;
plot(volt_list,aFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('a')
p = polyfit(volt_list,aFit,2);
V = linspace(0,80);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-r','LineWidth',1);
a_averaged = p(1)*volt_list.^2+p(2)*volt_list+p(3);

% just average b
figure; hold on;
plot(volt_list,bFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('b')
b_averaged = mean(bFit);
plot(V,b_averaged*ones(size(V)),'-r','LineWidth',1)

% populate C using just 4 parameters!!
C_final = zeros(size(C));
for jj=1:size(C,2)
    C_final(:,jj) = 1./(1+(phi_list/a_averaged(jj)).^b_averaged);
end

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y,numPhi);
y2 = zipParams(eta0, phi0, delta, A, width, sigmastar, C_final, phi_fudge);

show_cardy(dataTable,y2,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',2,'ShowInterpolatingFunction',true);



