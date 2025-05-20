%dataTable = may_ceramic_09_17;
%dataTable = dataTable(dataTable(:,3)==0,:);
%optimize_C_jardy_03_19;

myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;


paramNum = 6;

jacobian = numeric_jacobian(dataTable,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals via hessian
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
hessian_ci = sqrt(variances)*tinv(0.975,dof);

myParamOptimal = paramsVector(paramNum);
myHessianCI = hessian_ci(paramNum);
disp([myParamOptimal myHessianCI])

%return
myParamsAlt = paramsVector;
myParamsAlt(paramNum) = paramsVector(paramNum)+hessian_ci(paramNum);



%deltaParam = 0.05;
%paramRange = myParamOptimal+deltaParam;

SSR = @(y) sum(get_residuals(dataTable, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);

deltaSSRequals5 = @(paramValue) SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,paramValue)-resnorm0-5;
deltaSSRequals5_loggily = @(logParamValue) SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,exp(logParamValue))-resnorm0-5;

myTanh = @(x) 1/2*(tanh(x)+1);
myArcTanh = @(x) atanh(2*x-1);
deltaSSRequals5_arctanh = @(arctanhParamValue) SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,myTanh(arctanhParamValue))-resnorm0-5;

% need special case for: A right (0.05), h right (6), sigmastar left (0.02)
% D: must use tanh-y version
% 7  D(1) -- no left bound
% 8  D(2) -- no left bound
% 9  D(3) -- no left bound
% 10 D(4) -- no left bound
% 11 D(5) -- no left bound, right 0.99
% 12 D(6) -- left sends many warnings but is fine, comes out around 0.25. right 0.99
% 13 D(7) -- left is fine, right 0.99
% i think left=hessian_ci and right=0.99 will work for all of them from
% here up. eehhh no it eventually stops working, at least for the last 2
% entries... at some point there's no upper bound besides 1 lol
deltaParam = myHessianCI;
%ci_left = fzero(deltaSSRequals5,myParamOptimal-deltaParam);
ci_right = fzero(deltaSSRequals5,myParamOptimal+deltaParam);

ci_left = fzero(deltaSSRequals5,0.02);
%ci_right = fzero(deltaSSRequals5,0.95);

% arctanhOptimalParam = myArcTanh(myParamOptimal);
% arctanh_ci_left = fzero(deltaSSRequals5_arctanh,myArcTanh(myParamOptimal-deltaParam));
% %arctanh_ci_right = fzero(deltaSSRequals5_arctanh,myArcTanh(myParamOptimal+deltaParam));
% arctanh_ci_right = fzero(deltaSSRequals5_arctanh,myArcTanh(0.9999));
% ci_left = myTanh(arctanh_ci_left);
% ci_right = myTanh(arctanh_ci_right);

% for things with no left bound, convince yourself by looking at this:
%deltaSSRequals5_loggily(-200)

%return
first=true;
paramRange = linspace(ci_left,ci_right,7);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    
    myResnorm = SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,myParam);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;

    %if myParam==myParamOptimal || first || ii==length(paramRange)
    %   show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); xlim([1e-2 1.5])
      % show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ShowLines',true,'VoltRange',paramNum-5); xlim([1e-2 1.5])
    %   title(myParam-myParamOptimal)
    %end

    first=false;
end

%%
figure;
hold on;
plot(paramRange,resnorm,'-o','LineWidth',1)
%plot(epsilon,resnorm,'-o','LineWidth',1)

ylabel('\Delta SSR')
xlabel('parameter')
%xline(-myHessianCI); xline(myHessianCI)
xline(ci_left); xline(ci_right);


% figure;
% hold on;
% plot(epsilon,hessian_resnorm,'-o','LineWidth',1)
% ylabel('\Delta SSR from Hessian')
% xlabel('\Delta parameter')
%xline(-myHessianCI)
%xline(myHessianCI)

%end
