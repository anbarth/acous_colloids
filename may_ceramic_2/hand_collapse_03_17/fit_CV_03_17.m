load("optimized_params_03_17.mat")
build_restricted_data_table_03_17;
dataTable = restricted_data_table;
volt_list = [0 5 10 20 40 60 80];
phi_list = unique(dataTable(:,1));

makeAlphaPlot = false;
makeIndividualCVPlots = false;
makeJointCVPlot = false;

y = y_fmincon;
myModelHandle = @modelHandpickedAllExp;

[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(y,13); 
confInts = get_conf_ints(dataTable,y,myModelHandle);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err] = unzipParamsHandpickedAll(confInts',13); 

% first step is to extract alpha
D0V = D(:,1);
D0V_err = D_err(:,1);
dphi = phi0-phi_list;

alphaFitRegion = 10:13;
linearfit = fittype('poly1');

myAlphaFit = fit(log(dphi(alphaFitRegion)),log(D(alphaFitRegion))',linearfit);
alpha = myAlphaFit.p1;

if makeAlphaPlot
    figure; hold on; makeAxesLogLog;
    errorbar(dphi,D0V,D0V_err,'ko','MarkerFaceColor','k');
    plot(dphi(alphaFitRegion),exp(myAlphaFit.p2)*dphi(alphaFitRegion).^myAlphaFit.p1,'b')
end


%includeIndices = sigmastar~=0;

% fill in C(phi, V)
C = zeros(size(D));
C_err = D_err;
for jj=1:size(D,2)
    C(:,jj) = D(:,jj).*dphi.^alpha;
end

% behold CV
% doesnt it look like a logistic with a shifting inflection pt?
if makeJointCVPlot
    figure; hold on;
    cmap = plasma(256);
    ylabel('C'); xlabel('\phi');
    %xlim([0.4 0.65])

    for jj=1:size(C,2)
        myC = C(:,jj); myC_err = C_err(:,jj);
        myPhi = phi_list;
        voltage = volt_list(jj);
    
        myPhi = myPhi(myC~=0); myC_err = myC_err(myC~=0); myC = myC(myC~=0);
    
        myColor = cmap(round(1+255*voltage/80),:);
        errorbar(myPhi,myC,myC_err,'o-','Color',myColor,'LineWidth',0.75,'MarkerFaceColor',myColor);
    end
end


% convert 2d arrays into vectors for fitting
phi_mat = repmat(phi_list,7);
volt_mat = repmat(volt_list,13);
C_vec = C(C~=0);
C_vec_err = C_err(C~=0);
phi_vec = phi_mat(C~=0);
volt_vec = volt_mat(C~=0);

logistic = @(L,k,x0,x1,x,V) L./(1+exp(-k*(x-x0-x1*V)));
logisticFit = fittype(logistic,independent=["x" "V"]);
cFit = fit([phi_vec,volt_vec],C_vec,logisticFit,'StartPoint',[0.95, 25, 0.4, 0],'Weights',1./C_vec_err);
%cFit = fit([phi_vec,volt_vec],C_vec,logisticFit,'StartPoint',[0.95, 25, 0.4, 0]);


if makeIndividualCVPlots
    for jj=1:size(C,2)
        myC = C(:,jj);
        myC_err = C_err(:,jj);
        myPhi = phi_list;
        voltage = volt_list(jj);
    
        myPhi = myPhi(myC~=0);
        myC_err = myC_err(myC~=0);
        myC = myC(myC~=0);
    
        if isempty(myC)
            continue
        end
    
        figure; hold on;
        cmap = plasma(256);
        ylabel('C'); xlabel('\phi'); title(voltage)
        %xlim([0.4 0.65])
    
        myColor = cmap(round(1+255*voltage/80),:);
        errorbar(myPhi,myC,myC_err,'o','Color',myColor,'LineWidth',0.75,'MarkerFaceColor',myColor);
        phiFake = linspace(0.19,0.62);
        plot(phiFake,logistic(cFit.L,cFit.k,cFit.x0,cFit.x1,phiFake,voltage),'Color',myColor,'LineWidth',1.5)
    end
end

