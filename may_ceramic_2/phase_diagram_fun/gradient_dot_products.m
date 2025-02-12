data_table = may_ceramic_09_17;

load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

%play_with_CV_2_10_28;
%myModelHandle = @modelHandpickedAll; paramsVector = y_handpicked_10_28;

[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);
phi0=paramsVector(2);

volt_list = [0 5 10 20 40 60 80];
lowVoltNum=1;
highVoltNum=7;
V_low = volt_list(lowVoltNum);
V_high = volt_list(highVoltNum);

phiRange = linspace(0.2,0.64,200);
sigmaRange = logspace(-3,3,200);

myXfunLow = @(p) smoothFunctionX(p(1),p(2),V_low,paramsVector);
myXfunHigh = @(p) smoothFunctionX(p(1),p(2),V_high,paramsVector);

dotProduct = zeros(length(phiRange),length(sigmaRange));

N = length(phiRange)*length(sigmaRange);
phi_L = zeros(N,1);
sigma_L = zeros(N,1);
dotProduct_L = zeros(N,1);
c=1;
for ii=1:length(phiRange)
    for jj=1:length(sigmaRange)
        
        phi = phiRange(ii);
        sigma = sigmaRange(jj);
        gradXlow = myGradient(myXfunLow,[phi,sigma]);
        gradXhigh = myGradient(myXfunHigh,[phi,sigma]);
        
        %if ii==149 && (jj==119 || jj==120)
        %    disp([gradXlow gradXhigh])
        %end

        % take the gradient wrt log(sigma) instead
        gradXlow(2) = sigma*gradXlow(2);
        gradXhigh(2) = sigma*gradXhigh(2);

        % make the gradients unit vectors
        gradXlow = gradXlow / norm(gradXlow);
        gradXhigh = gradXhigh / norm(gradXhigh);

        dotProduct(ii,jj) = gradXlow(1)*gradXhigh(1)+gradXlow(2)*gradXhigh(2);

        phi_L(c)=phi;
        sigma_L(c)=sigma;
        dotProduct_L(c)=dotProduct(ii,jj);
        c = c+1;
    end
end
%figure;
%heatmap(phiRange,sigmaRange,dotProduct)

figure; hold on;
cmap = plasma(256); colormap(cmap);
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')
scatter(phi_L,sigma_L,10,dotProduct_L,'filled','s')
colorbar;

for x =  [10.^(-4:-1) 0.2 0.4 0.6 0.8 1 1-[0.046 0.1 0.15 0.22 0.32 0.46]]
%for x = 10.^(-1:0.1:0) 
   [myPhi1,mySigma1] = smoothFunctionsConstantX(x,lowVoltNum,paramsVector);
   plot(myPhi1,mySigma1,'k-','LineWidth',1.5)
   [myPhi2,mySigma2] = smoothFunctionsConstantX(x,highVoltNum,paramsVector);
   plot(myPhi2,mySigma2,'r-','LineWidth',1.5)
end

%xlim([min(phiRange) max(phiRange)])
%ylim([min(sigmaRange) max(sigmaRange)])
xlim([0.4 0.65])
ylim([1e-2 10^(2.5)])
%xlim([0.4 0.65])
%ylim([10^(1) 10^(1.25)])