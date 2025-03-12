data_table = may_ceramic_09_17;
phi_list = unique(data_table(:,1));
volt_list = [0 5 10 20 40 60 80];

cutoffV = 40;

% load up desired parameters
load("optimized_params_02_11.mat")
paramsVector = y_fminsearch; myModelHandle=@modelHandpickedAllExp;
paramsVector(isnan(paramsVector))=0;

[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(paramsVector,13); 

jacobian = numeric_jacobian(data_table,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err] = unzipParamsHandpickedAll(confInts',13); 

% compute alpha from D(0V)
D0V = D(:,1);
dphi = phi0-phi_list;
l2 = 10:13;

linearfit = fittype('poly1');
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
alpha = -myft2.p1;

C = zeros(size(D));
C_err = D_err;
for jj=1:size(D,2)
    C(:,jj) = D(:,jj).*dphi.^alpha;
end
phi_mat = repmat(phi_list,7);
volt_mat = repmat(volt_list,13);
C_vec = C(C~=0);
C_vec_err = C_err(C~=0);
phi_vec = phi_mat(C~=0);
volt_vec = volt_mat(C~=0);

% fit only to V<40
includeForFit = volt_vec<cutoffV;
C_vec = C_vec(includeForFit);
C_vec_err = C_vec_err(includeForFit);
phi_vec = phi_vec(includeForFit);
volt_vec = volt_vec(includeForFit);


logistic = @(L0,L1,L2,k,x0,x,V) (L0+L1*V+L2*V.^2)./(1+exp(-k*(x-x0)));
logisticFit = fittype(logistic,independent=["x" "V"]);
cFit = fit([phi_vec,volt_vec],C_vec,logisticFit,'StartPoint',[0.95, 0, 0, 25, 0.4],'Weights',1./C_vec_err);
%return



figure; hold on;

cmap = plasma(256);
ylabel('C')
xlabel('\phi')
xlim([0.4 0.65])

for jj=1:size(C,2)

    myC = C(:,jj);
    myPhi = phi_list;
    voltage = volt_list(jj);

    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myColor = cmap(round(1+255*voltage/80),:);
    plot(myPhi,myC,'-o','Color',myColor,'LineWidth',0.75);
    
    plot(phi_list,logistic(cFit.L0,cFit.L1,cFit.L2,cFit.k,cFit.x0,phi_list,voltage),'Color',myColor,'LineWidth',1.5)
end

figure; hold on;

cmap2 = viridis(256);
myColorPhi = @(phi) cmap2(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
ylabel('C')
xlabel('V')

for ii=1:size(C,1)

    myC = C(ii,:);
    myV = volt_list;
    phi = phi_list(ii);

    myV = myV(myC ~= 0);
    myC = myC(myC~=0);

    myColor = myColorPhi(phi);
    plot(myV,myC,'o','Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor);

    plot(myV,logistic(cFit.L0,cFit.L1,cFit.L2,cFit.k,cFit.x0,phi,myV),'Color',myColor,'LineWidth',1.5)
end
return
% now fit sigma* params
includeForFit = volt_list < cutoffV;
figure; hold on; xlabel('V'); ylabel('\sigma^*');
errorbar(volt_list,sigmastar,sigmastar_err,'ko');
quad = polyfit(volt_list(includeForFit),sigmastar(includeForFit),2);
plot(volt_list,polyval(quad,volt_list),'r-')

% eta0 = y(1);
% phi0 = y(2);
% delta = y(3);
% A = y(4);
% width = y(5);
% sigmastarParams = y(6:8);
% alpha = y(7);
% L = y(8);
% k = y(9);
% x0 = y(10);
% x1 = y(11);
y_logistic = [eta0,phi0,delta,A,width,quad,alpha,cFit.L,cFit.k,cFit.x0,cFit.x1];

show_F_vs_x(data_table,y_logistic,@modelLogisticCV)