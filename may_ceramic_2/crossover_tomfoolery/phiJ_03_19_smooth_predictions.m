% import data and params
data_table = may_ceramic_09_17;
%smoothen_C_acous_free_03_19;
alpha = -myft2.p1;
D0 = exp(myft2.p2);
myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
phi0=paramsVector(2);
sigmastar = paramsVector(6);
D = paramsVector(7:end);
phi_list = unique(dataTable(:,1));



alpha=0.5;
%D0 = D(end)*(phi0-phi_list(end))^alpha;
%D0 = D(end)*(phi0-phi_list(end))^alpha * 0.86;
D0 = D(end)*(phi0-phi_list(end))^alpha * 0.9;

phimu = invD(1,D,phi_list,phi0,D0,alpha);
disp(phimu)

CSS=(50/19)^3;

% set up phiJ
phiJ = @(sigma) interpConstantX(1,sigma,phi0,sigmastar,D,alpha,D0,phi_list);

% set up phi_crossover
A = paramsVector(4);
eta0 = paramsVector(1);
delta = paramsVector(3);
xi0 = (A/eta0)^(1/(-2-delta));
xstar = (xi0+1)^(-1*alpha);
phi_crossover = @(sigma) interpConstantX(xstar,sigma,phi0,sigmastar,D,alpha,D0,phi_list);

% set up cmap for stress
stress_list = unique(dataTable(:,2));
minLogSig = log(min(stress_list)*0.99);
maxLogSig = log(max(stress_list)*1.01);
cmap = winter(256);
colorSig = @(sigma) cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);

% set up data storage
eta = [];
phiJ_phi = [];

% set up plot
fig_phiJ = figure;
ax_phiJ = axes('Parent', fig_phiJ,'YScale','log','XScale','log');
ax_phiJ.XLabel.String = '\phi_J(\sigma)-\phi';
ax_phiJ.YLabel.String = '\eta (Pa s)';
hold(ax_phiJ,'on');




L={};
for kk=7
%for kk = 1:length(stress_list)
    % identify stress
    sigma = stress_list(kk);
    L{end+1}=num2str(sigma);

    % set up data storage
    my_eta = [];
    my_delta_eta = [];
    my_phi = [];

    % find data
    for ii=1:length(phi_list)
    
        myData = dataTable(dataTable(:,1)==phi_list(ii) & dataTable(:,3)==0, :);
        mySigma = myData(:,2);
        myEta = CSS*myData(:,4);
        myDeltaEta = CSS*myData(:,5);
            
        stressIndex = find(sigma==mySigma);
        if stressIndex
            my_eta(end+1) = myEta(stressIndex);
            my_delta_eta(end+1) = myDeltaEta(stressIndex);
            my_phi(end+1) = phi_list(ii);
        end
    end
  
    % plot data
    myColor = colorSig(sigma);
    plot(ax_phiJ,phiJ(sigma)-my_phi,my_eta,'o','Color',myColor)

    % store data
    eta = [eta, my_eta];
    phiJ_phi = [phiJ_phi, phiJ(sigma)-my_phi];

    % get predictions
    %phi_fake = linspace(0.2,0.65);
    %D_fake = interp1(phi_list,D,phi_fake);
    %y_fake = [y(1:6) D_fake];
    %eta_hat = viscosity_prediction(phi_fake',sigma,0,[],y_fake,myModelHandle);
    eta_hat = viscosity_prediction(phi_list,sigma,0,[],paramsVector,myModelHandle);
    plot(phiJ(sigma)-phi_list,CSS*eta_hat,'-','Color',myColor)
    xline(phiJ(sigma)-phi_crossover(sigma),'Color',myColor)
end
%legend(ax_phiJ,L);
prettyplot
colormap(ax_phiJ,cmap);
dphi = linspace(0.1,0.4);
plot(ax_phiJ,dphi,0.2*dphi.^(-2),'r-')
%dphi = linspace(0.01,0.07);
%plot(ax_phiJ,dphi,0.4*dphi.^(-1.5),'r-')
%plot(ax_phiJ,dphi,50*dphi.^(-1),'r-')
%dphi = logspace(-4,-2);
%plot(ax_phiJ,dphi,1000*dphi.^(-0.33),'r-')


