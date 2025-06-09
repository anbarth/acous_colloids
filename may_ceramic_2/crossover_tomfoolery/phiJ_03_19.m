% import data and params
data_table = may_ceramic_09_17;
%smoothen_C_acous_free_03_19;
alpha = -myft2.p1;
D0 = exp(myft2.p2);
myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
phi_list = unique(dataTable(:,1));

CSS=(50/19)^3;

% set up phiJ
phiJ = @(sigma) interpConstantX(1,sigma,paramsVector,alpha,D0,phi_list);

% set up cmap for stress
stress_list = unique(dataTable(:,2));
minLogSig = log(min(stress_list)*0.99);
maxLogSig = log(max(stress_list)*1.01);
cmap = winter(256);
colorSig = @(sigma) cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);

% set up data storage
eta = [];
phiJ_phi = [];

% set up plots
fig_phiJ = figure;
ax_phiJ = axes('Parent', fig_phiJ,'YScale','log','XScale','log');
ax_phiJ.XLabel.String = '\phi_J-\phi';
ax_phiJ.YLabel.String = '\eta (Pa s)';
hold(ax_phiJ,'on');

fig_phi0 = figure;
ax_phi0 = axes('Parent', fig_phi0,'YScale','log','XScale','log');
ax_phi0.XLabel.String = '\phi_0-\phi';
ax_phi0.YLabel.String = '\eta (Pa s)';
hold(ax_phi0,'on');

fig_phiJval = figure;
ax_phiJval = axes('Parent', fig_phiJval);
ax_phiJval.XLabel.String = '\phi_J-\phi';
ax_phiJval.YLabel.String = '\phi_0-\phi_J';
hold(ax_phiJval,'on');


cmap = winter(256);

L={};
%for kk=10
for kk = 1:length(stress_list)
    sigma = stress_list(kk);
    
    
    L{end+1}=num2str(sigma);
    my_eta = [];
    my_delta_eta = [];
    my_phi = [];

    
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
  
    myColor = colorSig(sigma);
    plot(ax_phiJ,phiJ(sigma)-my_phi,my_eta,'-o','Color',myColor)
    plot(ax_phi0,phi0-my_phi,my_eta,'-o','Color',myColor)
    plot(ax_phiJval,phiJ(sigma)-my_phi,phi0-phiJ(sigma),'-o','Color',myColor)

    eta = [eta, my_eta];
    phiJ_phi = [phiJ_phi, phiJ(sigma)-my_phi];
end
%legend(ax_phiJ,L);
%legend(ax_phi0,L);
%legend(ax_phiJval,L);

colormap(ax_phiJ,cmap);
dphi = linspace(0.1,0.4);
plot(ax_phiJ,dphi,CSS*dphi.^(-2),'r-')
dphi = linspace(0.01,0.07);
plot(ax_phiJ,dphi,CSS*dphi.^(-1),'r-')


%yline(ax_phiJval,phi0);
%yline(ax_phiJval,phimu);
