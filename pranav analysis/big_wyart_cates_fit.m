low_phis = [20,25,30,35,40]; % DONT CHANGE OR REMOVE

% change this list to modify which phis are included in the fit!
phis = [20,25,30,35,40,44,46,48,50,52,53,54,55];
%phis = [44,46,48,50];


sweeps_by_vol_frac = cell(length(phis),1);
allData = zeros(0,9);
for ii=1:length(phis)
%for ii = 1:length(phis)
    matFileName = strcat('phi_0',num2str(phis(ii)),'.mat');
    load(matFileName);
    % take the stress sweep, but exclude low torque stuff
    if any(low_phis == phis(ii))
        mySweep = stress_sweep(stress_sweep(:,6)>10^(-3),:);
    else
        % values where eta decreases excluded
        mySweep = stress_sweep_trimmed(stress_sweep_trimmed(:,6)>10^(-3),:);
    end
    sweeps_by_vol_frac{ii}=mySweep;
    allData(end+1:end+size(mySweep,1),:)=[mySweep, phis(ii)/100*ones(size(mySweep,1),1)];
end


sigma = CSS*allData(:,3);
eta = CSV*allData(:,4);
phi = allData(:,9);

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
% x(4) = phi_0
fitfxn = @(x) x(1)*10^4*( x(4)*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  
%costfxn = @(x) sum(abs( (fitfxn(x)-eta)./eta ));  

constraintMatrix = zeros(4,4);
% phi_mu-phi_0 < 0 (phi_mu < phi_0)
constraintMatrix(1,3)=1;
constraintMatrix(1,4)=-1;
constraintVector = [0,0,0,0];
upper_bounds = [Inf,Inf,.74,.74];
lower_bounds = [0,0,0.55,.57];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [2e-6, 1.3, 0.55, 0.59],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
%s = fminsearch(costfxn, [0.001, 5, 0.56, 0.6]);
%s = fminsearch(costfxn, [0.001, 20, 0.5]);

disp(s);
etaFit = fitfxn(s);
etaSilly = fitfxn([2.2089e-06, 26.376, 0.5172, 0.5821]); % fit for just phi=44-50%

figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;
for ii=1:length(phis)
    myData=sweeps_by_vol_frac{ii};
    myPhi = phis(ii)/100;
    %myStress=CSS*myData(:,3);
    myStress=CSS*allData(allData(:,9)==myPhi,3);
    myEta=CSV*allData(allData(:,9)==myPhi,4);
    myEtaFit=etaFit(allData(:,9)==myPhi);
    myEtaSilly=etaSilly(allData(:,9)==myPhi);
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