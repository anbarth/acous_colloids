%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 

stressTable = may_ceramic_09_14;
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];



ft1 = fittype('1/(1+((p-x)/a)^b)');
opts = fitoptions(ft1);
opts.StartPoint = [0.3,6,phi0];
opts.Lower = [0 -Inf phi0];
opts.Upper = [1 Inf phi0];
phiFake = linspace(0.15,0.75);

Cfit = zeros(size(C));
aFit = zeros(7,1);
bFit = zeros(7,1);

for jj=1:size(C,2)

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


    myC = C(:,jj);
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);

    %if voltage ~= 0
    %   continue
    %end

    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myColor = cmap(round(1+255*voltage/80),:);
    plot(myPhi,myC,'o','Color',myColor,'LineWidth',1.5);
    myFit1 = fit(myPhi,myC,ft1,opts);
    %plot(phiFake,exp(-0.1./phiFake),'Color',myColor,'LineWidth',1)
    %plot(phiFake,1./(1+(2.5*phiFake).^-12),'Color',myColor,'LineWidth',1)
    plot(phiFake,1./(1+(1/myFit1.a*(phi0-phiFake)).^myFit1.b),'Color',myColor,'LineWidth',1)


    myPhi = phi_list+phi_fudge';
    Cfit(:,jj) = 1./(1+(1/myFit1.a*(phi0-myPhi)).^myFit1.b);

    aFit(jj) = myFit1.a;
    bFit(jj) = myFit1.b;
end

%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%y_optimal = zipParamsCrossoverFudge(eta0, phi0, delta, A, width, sigmastarFit, Cfit, phi_fudge);

figure; hold on;
plot(volt_list,aFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('a')

figure; hold on;
plot(volt_list,bFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('b')

