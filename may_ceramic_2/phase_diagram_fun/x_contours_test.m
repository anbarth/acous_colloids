data_table = may_ceramic_09_17;

figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')


load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

%play_with_CV_2_10_28;
%myModelHandle = @modelHandpickedAll; paramsVector = y_handpicked_10_28;

%paramsVector(21) = 0.2; % for phi=50%, was 0.83

[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);

phi0=paramsVector(2);



cmap = plasma(256);
colormap(cmap)



voltNum=1;


% plot gradient of x
myXfun = @(p) smoothFunctionX(p(1),p(2),volt_to_plot,paramsVector);

x_all = [];
phi_all = [];
sigma_all = [];
grad_x_all = zeros(0,2);

for kk=1:size(data_table,1)
    V = data_table(kk,3);
    if V ~= volt_to_plot
        continue
    end
    phi = data_table(kk,1);
    sigma = data_table(kk,2);
    

    phi_all(end+1)=phi;
    sigma_all(end+1)=sigma;
    x_all(end+1)=myXfun([phi,sigma]);
    grad_x_all(end+1,:) = myGradient(myXfun,[phi,sigma]);
    
end

scatter(phi_all,sigma_all,[],x_all,'filled');
quiver(phi_all',sigma_all',grad_x_all(:,1),grad_x_all(:,2),0.005,'Color',[0 0 0],'LineWidth',3)


xlim([0.1 0.7])
ylim([1e-3 1e3])