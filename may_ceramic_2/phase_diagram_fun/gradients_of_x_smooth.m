%%% i wanted to make a heatmap of gradients but that doesnt work bc the
%%% gradient is a vector and not a scalar :(
%%% but i could pick some value of x and plot the gradient along some
%%% (phi,sigma) along that contour

data_table = may_ceramic_09_17;


figure; hold on;
ax1=gca;
%ax1.YScale='log';
xlabel('\phi')
ylabel('log \sigma')

load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

%play_with_CV_2_10_28;
%myModelHandle = @modelHandpickedAll; paramsVector = y_handpicked_10_28;

[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);
phi0=paramsVector(2);


lowVoltNum=1;
highVoltNum=7;
V_low = volt_list(lowVoltNum);
V_high = volt_list(highVoltNum);

phiRange = linspace(0.2,0.64,100);
sigmaRange = logspace(-3,3,100);

myXfunLow = @(p) smoothFunctionX(p(1),p(2),V_low,paramsVector);
myXfunHigh = @(p) smoothFunctionX(p(1),p(2),V_high,paramsVector);

for x =  [10.^(-4:0) 1-[0.046 0.1 0.15 0.22 0.32 0.46]]
   [myPhi1,mySigma1] = smoothFunctionsConstantX(x,lowVoltNum,paramsVector);
   [myPhi2,mySigma2] = smoothFunctionsConstantX(x,highVoltNum,paramsVector);
   plot(myPhi1,log(mySigma1),'k-','LineWidth',1.5)
   plot(myPhi2,log(mySigma2),'r-','LineWidth',1.5)
   %for kk = [1 5 20 100:500:length(myPhi1)]
   baseNum=2;
   for kk = baseNum.^(0:(log(length(myPhi1))/log(baseNum)))
        phi = myPhi1(kk);
        sigma = mySigma1(kk);
     
        gradXLow = myGradient(myXfunLow,[phi,sigma]);
        gradXHigh = myGradient(myXfunHigh,[phi,sigma]);
        
        % take the gradient wrt log(sigma) instead
        gradXLow(2) = sigma*gradXLow(2);
        gradXHigh(2) = sigma*gradXHigh(2);

        % normalize gradient vectors
        gradXLow = 10*gradXLow / norm(gradXLow);
        gradXHigh = 10*gradXHigh / norm(gradXHigh);

        quiver(phi,log(sigma),gradXLow(1),gradXLow(2),0.005,'Color',[0 0 0],'LineWidth',3)
        quiver(phi,log(sigma),gradXHigh(1),gradXHigh(2),0.005,'Color',[1 0 0],'LineWidth',3)
   end
end

xlim([0.2 0.8])
ylim([1 1.6])
%xlim([0.4 0.65])
%ylim([-2 (2.5)])