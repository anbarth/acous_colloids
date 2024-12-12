%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;

play_with_CV_2_10_28; y_handpicked = y_handpicked_10_28;
[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParams(y_handpicked,13);

stressTable = may_ceramic_09_17;
phi_list = unique(stressTable(:,1));
phi_list_fudged = phi_list+phi_fudge';
volt_list = [0,5,10,20,40,60,80];


ft1 = fittype('1/((q0*x)^alpha+(q1*x)^(alpha+beta))');
%ft1 = fittype('1/( q0*x^alpha*(1+(q1*x)^beta) )');
opts = fitoptions(ft1);
opts.StartPoint = [-0.003,8,12,3];
%opts.Lower = [-0.003,0,0,0];
%opts.Upper = [-0.003,Inf,Inf,Inf];
phiFake = linspace(0.15,0.65);
Qform = @(dphi,alpha,b,q0,q1) ((q0*dphi).^alpha+(q1*dphi).^(alpha+b));
%Qform = @(dphi,alpha,b,q0,q1) q0*dphi.^alpha .* (1+(q1*dphi).^b);

Dfit = zeros(size(D));
alphaFit = zeros(7,1);
bFit = zeros(7,1);
q0Fit = zeros(7,1);
q1Fit = zeros(7,1);
q0_err = zeros(7,2);
q1_err = zeros(7,2);

figure; hold on; ylabel('D'); xlabel('\phi');
ax1=gca;ax1.XScale='log';ax1.YScale='log';
cmap = plasma(256); colormap(cmap);
cbar = colorbar; clim([0 80]); cbar.Ticks = [0,5,10,20,40,60,80];

include_volt_indices = [1 4 6 7];

for jj=1:size(D,2)

    %if ~ismember(jj,include_volt_indices); continue; end
    %if jj>1; continue; end

    myD = D(:,jj);
    voltage = volt_list(jj);
    myPhi = phi_list_fudged(myD~=0);
    myD = myD(myD~=0);

    dPhi = phi0-myPhi;

    myColor = cmap(round(1+255*voltage/80),:);
    plot(dPhi,1./myD,'o','Color',myColor,'LineWidth',1);
    myFit1 = fit(dPhi,myD,ft1,opts);

    %plot(myFit1,dPhi,myD)
    %[0.1,5,12,3];
    plot(phi0-phiFake,Qform(phi0-phiFake,myFit1.alpha,myFit1.beta,myFit1.q0,myFit1.q1),'Color',myColor,'LineWidth',1)
    %plot(phi0-phiFake,Qform(phi0-phiFake,myFit1.alpha,myFit1.beta,myFit1.q0,0),'Color',myColor,'LineWidth',1,'LineStyle','--')
    %plot(linspace(0.2,0.5),Qform(linspace(0.2,0.5),myFit1.alpha,myFit1.b,0,myFit1.q1),'Color',myColor,'LineWidth',1,'LineStyle','--')
    
    %plot(phi0-phiFake,Qform(phi0-phiFake,0.14,9,1.5,3.5),'Color',myColor,'LineWidth',1)
    %plot(phi0-phiFake,Qform(phi0-phiFake,0.14,9,1.5,7),'Color',myColor,'LineWidth',1)
    

    Dfit(:,jj) = Qform(phi0-phi_list_fudged,myFit1.alpha,myFit1.beta,myFit1.q0,myFit1.q1);
    alphaFit(jj) = myFit1.alpha;
    bFit(jj) = myFit1.beta;
    q0Fit(jj) = myFit1.q0;
    q1Fit(jj) = myFit1.q1;

    ci = confint(myFit1);
    q0_err(jj,1:2) = (ci(:,3)-myFit1.q0)';
    q1_err(jj,1:2) = (ci(:,4)-myFit1.q1)';

    if jj==1
        %disp(myFit1)
        opts = fitoptions(ft1);
        opts.StartPoint = [myFit1.alpha,myFit1.beta,myFit1.q0,myFit1.q1];
        opts.Lower = [myFit1.alpha,myFit1.beta,0,0];
        opts.Upper = [myFit1.alpha,myFit1.beta,Inf,Inf];
        myFit0V=myFit1;
    end
end
%return

figure; hold on;
%plot(volt_list,q0Fit,'-ok','LineWidth',1)
errorbar(volt_list,q0Fit,q0_err(:,1),q0_err(:,2),'-ok','LineWidth',1)
xlabel('V')
ylabel('q0')
pq0 = polyfit(volt_list,q0Fit,1);
q0FitFit = pq0(1)*volt_list+pq0(2);
plot(volt_list,q0FitFit,'-r','LineWidth',1)

figure; hold on;
%plot(volt_list,q1Fit,'-ok','LineWidth',1)
errorbar(volt_list,q1Fit,q1_err(:,1),q1_err(:,2),'-ok','LineWidth',1)
xlabel('V')
ylabel('q1')
pq1 = polyfit(volt_list,q1Fit,1);
q1FitFit = pq1(1)*volt_list+pq1(2);
plot(volt_list,q1FitFit,'-r','LineWidth',1)

y_red_handpicked = zipReducedParams(0.03,0.7,-1.2,0.03,1,pSigmastar,myFit1.alpha,myFit1.beta,pq0,pq1);
y_red_handpicked = fitToInterpolatingFxnReduced(stressTable,y_red_handpicked);