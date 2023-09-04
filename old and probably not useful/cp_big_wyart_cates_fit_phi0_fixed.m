phi0 = 0.5882;

% change this list to modify which phis are included in the fit!
phis = [46,48,50,52,54];
%phis = [44,46,48,50];

stressTable = cp_data_trimmed;

sigma = stressTable(:,3);
eta = stressTable(:,4);
phi = stressTable(:,1);

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
fitfxn = @(x) x(1)*10^4*( phi0*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  
%costfxn = @(x) sum(abs( (fitfxn(x)-eta)./eta ));  

upper_bounds = [Inf,Inf,phi0];
lower_bounds = [0,0,0.55];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [2e-6, 10, 0.5501],[],[],...
            [],[],lower_bounds,upper_bounds,[],opts);
%s = fminsearch(costfxn, [0.001, 5, 0.56, 0.6]);
%s = fminsearch(costfxn, [0.001, 20, 0.5]);

disp(s);
etaFit = fitfxn(s);

figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;
for ii=1:length(phis)
    myPhi = phis(ii)/100;
    myData = stressTable(stressTable(:,1)==myPhi,:);
    myStress=myData(:,3);
    myEta=myData(:,4);
    myEtaFit=etaFit(stressTable(:,1)==myPhi);
    myEtaSilly=etaSilly(stressTable(:,1)==myPhi);
    %myEta = CSV*myData(:,4);
    %myEtaFit = f(s)
    %myEtaFit = s(1)*10^4*( s(4)*(1-exp(-s(2)./myStress)) + s(3)*exp(-s(2)./myStress) - myPhi ).^(-2);
    myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.2)),:);
    plot(myStress,myEta,'o','Color',myColor);
    plot(myStress,myEtaFit,'Color',myColor);
    %plot(myStress,myEtaSilly,'--','Color',myColor);
end
%title('stress sweeps');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');