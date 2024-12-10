dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7013;
sigmastar = 0.4589*ones(1,numV);
phi_fudge = zeros(size(phi_list))';

% not important here
eta0 = 0.0270; delta = -1; A = 0.04; width = 1;

% pick some alpha and construct D(phi) accordingly

% general alignment
%alpha = 1; C_0V_1 = 1/11.2*[0.2 0.3 0.6 0.7 1 1 1.6 1.8 1.6 1.65 1.4 1.17 1]'; C_0V = C_0V_1;
%alpha = 0.5; C_0V_05 = 1/3.4*[0.01 0.1 0.4 0.5 0.6 0.7 1.1 1.2 1.1 1.2 1.15 1.07 1]'; C_0V = C_0V_05;
alpha = 0.1; C_0V_01 = 1/1.3*[0.1 0.15 0.2 0.35 0.47 0.5 0.75 0.8 0.85 0.96 0.95 0.97 1]'; C_0V = C_0V_01;
%C_0V = [1 1 1 1 1 1 1 1 1 1 1 1 1]';
D = zeros(numPhi,numV);
D_0V = C_0V.*(phi0-phi_list).^-alpha;
D(:,1) = D_0V;

y_alpha = zipParams(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);

show_cardy(dataTable,y_alpha,'alpha',alpha,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
%show_F_vs_x(dataTable,y_alpha,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',false)

return

%figure;
%hold on;
%plot(phi_list,C_0V_1,'-o','LineWidth',1)
%plot(phi_list,C_0V_05,'-o','LineWidth',1)
%plot(phi_list,C_0V_01,'-o','LineWidth',1)
%xlabel('\phi')
%ylabel('C_\alpha')
%legend('\alpha=1','\alpha=0.5','\alpha=0.1')

figure;
hold on;
plot(phi_list,C_0V_1.*(phi0-phi_list).^-1,'-o','LineWidth',1)
plot(phi_list,C_0V_05.*(phi0-phi_list).^-0.5,'-o','LineWidth',1)
plot(phi_list,C_0V_01.*(phi0-phi_list).^-0.1,'-o','LineWidth',1)
[eta0, phi0, delta, A, width, sigmastar, D_handpicked, phi_fudge] = unzipParams(y_handpicked_10_07,13);
plot(phi_list,D_handpicked(:,1),'-o','LineWidth',1)
xlabel('\phi')
ylabel('D')
legend('\alpha=1','\alpha=0.5','\alpha=0.1','handpicked based on F vs x')


