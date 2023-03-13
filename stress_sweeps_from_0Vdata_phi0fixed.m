global stress_list phi_list data_by_vol_frac

%phisToInclude = [0.2,0.25,0.3,0.35,0.4,0.44,0.46,0.48,0.5];
%phisToInclude = [0.44,0.46,0.48,0.5];
phisToInclude = [0.5,0.52,0.53,0.54];

figure;hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;

sigma = zeros(0,1);
eta = zeros(0,1);
phi = zeros(0,1);

for ii = 1:8
        myPhi = phi_list(ii)/100;
        phi_data = data_by_vol_frac{ii};
        mySigma = stress_list(1:size(phi_data,2));
        myEta = phi_data(1,:); % viscosities for just 0 voltage
        myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.2)),:);
        plot(mySigma,myEta,'d','Color',myColor);
        
        % fill in big lists
        sigma(end+1:end+length(mySigma)) = mySigma;
        eta(end+1:end+length(mySigma)) = myEta;
        phi(end+1:end+length(mySigma)) = myPhi*ones(length(mySigma),1);
end

% add in low volume fraction stuff too
phi = [0.2;0.25;0.3;0.35;0.4;phi];
% eta values from sigma_1Pa const stress run, last value
eta = [0.2102; 0.2590; 0.3718; 0.5918; 0.7999;eta]; 
myLowStress = 1*CSS;
sigma = [myLowStress; myLowStress; myLowStress; myLowStress; myLowStress; sigma];
for ii = 1:5
    myColor = cmap(round(1+255*(0.55-phi(ii))/(0.55-0.2)),:);
    plot(sigma(ii),eta(ii),'d','Color',myColor);
end

% only include volume fractions listed at the top
include_me = false(length(phi),1);
for ii=1:length(phi)
    if any(phisToInclude==phi(ii))
        include_me(ii) = true;
    end
end
phi = phi(include_me);
eta = eta(include_me);
sigma = sigma(include_me);

title('0V steady state data');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');

%return


% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
phi0 = 0.6386;
fitfxn = @(x) x(1)*10^4*( phi0*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  


constraintMatrix = zeros(3,3);
constraintVector = [0,0,0];
upper_bounds = [Inf,Inf,phi0];
lower_bounds = [0,0,0.55000001];


opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [2e-6, 10, 0.58],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);

disp(s);
etaFit = fitfxn(s);
etaSilly = fitfxn([5e-6, 10.1811, 0.551]);

for ii=1:length(phisToInclude)
    
    myPhi = phisToInclude(ii);
    mySigma = sigma(phi==myPhi);
    myEta = eta(phi==myPhi);
    myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.2)),:);
    

    myEtaFit=etaFit(phi==myPhi);
    myEtaSilly=etaSilly(phi==myPhi);

    %plot(mySigma,myEta,'o','Color',myColor);
    plot(mySigma,myEtaFit,'Color',myColor);
    if myPhi <= 0.4
        plot([mySigma*0.75, mySigma*1.25],[myEtaFit,myEtaFit],'Color',myColor);
    end
    %plot(myStress,myEtaSilly,'--','Color',myColor);
end
%title('stress sweeps');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');


