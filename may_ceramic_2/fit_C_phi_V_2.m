%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;
y_optimal = y_handpicked_10_07;
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

stressTable = may_ceramic_09_17;
phi_list = unique(stressTable(:,1));
phi_list_fudged = phi_list+phi_fudge';
volt_list = [0,5,10,20,40,60,80];

alpha=0;

ft1 = fittype('exp(B*(p-x)^a)');
opts = fitoptions(ft1);
opts.StartPoint = [-50,3,phi0];
opts.Lower = [-Inf -Inf phi0];
opts.Upper = [Inf Inf phi0];
phiFake = linspace(0.15,0.75);

Cfit = zeros(size(C));
aFit = zeros(7,1);
bFit = zeros(7,1);

for jj=1:size(C,2)

    myC = C(:,jj);
    voltage = volt_list(jj);

     if voltage ~= 0
        continue
     end

figure;
hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
ylabel('C')
xlabel('\phi')







    myPhi = phi_list_fudged(myC ~= 0);
    myC = myC(myC~=0);
    myC = myC .* (phi0-myPhi).^alpha;

    myColor = cmap(round(1+255*voltage/80),:);
    plot(phi0-myPhi,log(myC),'o','Color',myColor,'LineWidth',1.5);
    myFit1 = fit(myPhi,myC,ft1,opts);
    a = myFit1.a;
    B = myFit1.B;
    myCfit = exp(B*(phi0-phi_list_fudged).^a);
    plot(phi0-phi_list_fudged,log(myCfit),'Color',myColor);

    

    Cfit(:,jj) = myCfit;
    aFit(jj) = a;
    bFit(jj) = B;
end
return

%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%y_optimal = zipParamsCrossoverFudge(eta0, phi0, delta, A, width, sigmastarFit, Cfit, phi_fudge);

figure; hold on;
plot(volt_list,aFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('a')

figure; hold on;
plot(volt_list,bFit,'-ok','LineWidth',1)
xlabel('V')
ylabel('B')

