%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;
play_with_CV_2_10_28; y_optimal = y_handpicked_10_28;
[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParams(y_optimal,13);

stressTable = may_ceramic_09_17;
phi_list = unique(stressTable(:,1));
phi_list_fudged = phi_list+phi_fudge';
volt_list = [0,5,10,20,40,60,80];

alpha = 0.1;

ft1 = fittype('c/(1+((p-x)/a)^b)');
opts = fitoptions(ft1);
myB = 6.7046;
opts.StartPoint = [0.2693,myB,0.8,phi0];
opts.Lower = [0 myB -Inf phi0];
opts.Upper = [1 myB Inf phi0];
%opts.Lower = [0 -Inf -Inf phi0];
%opts.Upper = [1 Inf Inf phi0];
%opts.Lower = [0.2693 -Inf -Inf phi0];
%opts.Upper = [0.2693 Inf Inf phi0];
phiFake = linspace(0.15,phi0);

Dsigmoidal = zeros(size(D));
aFit = zeros(7,1);
bFit = zeros(7,1);
cFit = zeros(7,1);

figure; hold on; ylabel('C'); xlabel('\phi');
cmap = plasma(256); colormap(cmap);
cbar = colorbar; clim([0 80]); cbar.Ticks = [0,5,10,20,40,60,80];


for jj=1:size(D,2)

    myC = D(:,jj) .* (phi0-phi_list_fudged).^alpha;
    voltage = volt_list(jj);

   % if voltage ~= 0
   %    continue
   % end


    myPhi = phi_list_fudged(myC ~= 0);
    myC = myC(myC~=0);


    myColor = cmap(round(1+255*voltage/80),:);
    plot(phi0-myPhi,myC,'o','Color',myColor,'LineWidth',1.5);
    myFit1 = fit(myPhi,myC,ft1,opts);

    plot(phi0-phiFake,myFit1.c ./ (1+(1/myFit1.a*(phi0-phiFake)).^myFit1.b),'Color',myColor,'LineWidth',1)
    %plot(phi0-phiFake,0.8./(1+((phi0-phiFake)/0.26).^6),'Color',myColor,'LineWidth',1)


    Dsigmoidal(:,jj) = myFit1.c ./(1+(1/myFit1.a*(phi0-phi_list_fudged)).^myFit1.b) ./ (phi0-phi_list_fudged).^alpha;

    aFit(jj) = myFit1.a;
    bFit(jj) = myFit1.b;
    cFit(jj) = myFit1.c;
end
%return

figure; hold on;
plot(volt_list,aFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('a')
pa = polyfit(volt_list,aFit,1);
aFitFit = pa(1)*volt_list+pa(2);
plot(volt_list,aFitFit,'-r','LineWidth',1)

figure; hold on;
plot(volt_list,bFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('b')

figure; hold on;
plot(volt_list,cFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('c')
pc = polyfit(volt_list,cFit,1);
cFitFit = pc(1)*volt_list+pc(2);
plot(volt_list,cFitFit,'-r','LineWidth',1)

Dsigmoidal_minimal = zeros(size(D));
for jj=1:length(volt_list)
     Dsigmoidal_minimal(:,jj) = cFitFit(jj) ./(1+(1/aFitFit(jj)*(phi0-phi_list_fudged)).^myB) ./ (phi0-phi_list_fudged).^alpha;
end

y_sig = zipParams(eta0, phi0, delta, A, width, sigmastar, Dsigmoidal, phi_fudge);
y_sig_min = zipParams(eta0, phi0, delta, A, width, sigmastar, Dsigmoidal_minimal, phi_fudge);
%show_F_vs_x(stressTable,y_optimal,'ColorBy',2,'VoltRange',1,'ShowLines',true,'ShowErrorBars',true)
%show_F_vs_x(stressTable,y_new,'ColorBy',2,'VoltRange',1,'ShowLines',true,'ShowErrorBars',true)

phiNum = 9; show_F_vs_xc_x(stressTable,y_optimal,'ColorBy',1,'PhiRange',phiNum,'ShowLines',true,'ShowErrorBars',true); title('handpicked'); show_F_vs_xc_x(stressTable,y_sig_min,'ColorBy',1,'PhiRange',phiNum,'ShowLines',true,'ShowErrorBars',true); title('5-parameter sigmoid fit')


figure; hold on; ylabel('C'); xlabel('\phi');
cmap = plasma(256); colormap(cmap);
cbar = colorbar; clim([0 80]); cbar.Ticks = [0,5,10,20,40,60,80];

for jj=1:size(D,2)
    
    voltage = volt_list(jj);
    myC = D(:,jj).*(phi0-phi_list_fudged).^alpha;
    myCsig_min = Dsigmoidal_minimal(:,jj).*(phi0-phi_list_fudged).^alpha;
    

    myPhi = phi_list_fudged(myC ~= 0);
    myCsig_min = myCsig_min(myC~=0);
    myC = myC(myC~=0);
    

    myColor = cmap(round(1+255*voltage/80),:);

    plot(phi0-myPhi,myC,'o','Color',myColor,'LineWidth',1.5);
    plot(phi0-myPhi,myCsig_min,'Color',myColor,'LineWidth',1)
end
%%
figure; hold on; ylabel('C'); xlabel('V');
cmap = viridis(256); colormap(cmap);
cbar = colorbar;minPhi = min(phi_list);maxPhi = max(phi_list);clim([minPhi maxPhi]);cbar.Ticks = phi_list;

for ii=1:size(D,1)
    phi = phi_list_fudged(ii);
    myC = D(ii,:)*(phi0-phi)^alpha;
    myCsig_min = Dsigmoidal_minimal(ii,:)*(phi0-phi)^alpha;
    
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

    myVolt = volt_list(myC ~= 0);
    myCsig_min = myCsig_min(myC~=0);
    myC = myC(myC ~= 0);

    plot(myVolt,myC,'o','Color',myColor,'LineWidth',1);
    plot(myVolt,myCsig_min,'-','Color',myColor,'LineWidth',1);
end


