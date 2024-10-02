dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_09_04.mat")
y_init = y_handpicked_xcShifted_09_04;



% constraints
% C = 0 for phi=20%...40%; V > 0 (no data)
% C = 0 for phi=56%, V>=60 (no data)
% phi_fudge = 0
C_con = NaN(numPhi,numV);
C_con(1:5,2:end) = 0;
C_con(11,6:7) = 0;
phi_fudge_con = 0*ones(1,numPhi);
% interpolating fxn parameters
% treated as "constraints" insofar as the outermost cost function will not
% vary them explicitly, but they WILL be varied under the hood by
% fitToInterpolatingFxn
% these values need to be reasonable initial guesses
eta0_init = 0.02;
delta_init = -1;
A_init = 0.02;
width_init = 0.5;
%  [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] 
constraints = zipParams(eta0_init,NaN,delta_init,A_init,width_init,NaN(1,numV),C_con,phi_fudge_con);

y_init_restricted = removeConstraintsFromParamVec(y_init,constraints);


costfxncon = @(yRestricted) sum(fitToInterpolatingFxnThenGetResidualsCon(dataTable,yRestricted,constraints).^2);



opts = optimoptions('fminunc','Display','iter');
[y_optimal_restricted,fval,exitflag,output,grad,hessian] = fminunc(costfxncon,y_init_restricted,opts);
%opts = optimset('MaxIter',1e6,'MaxFunEvals',1e6,'Display','iter');
%y_optimal_restricted = fminsearch(costfxncon,y_init_restricted,opts);

y_optimal = mergeParamsAndConstraints(y_optimal_restricted,constraints);
%awkward, but i need to go back at the end and fill in interpolating fxn parameters
disp(costfxncon(y_optimal))
y_optimal = fitToInterpolatingFxn(dataTable,y_optimal);
disp(sum(getResiduals(dataTable,y_optimal).^2));

%show_F_vs_x(dataTable,y_optimal_lsq,'ShowInterpolatingFunction',true); title('lsq 1')
%show_F_vs_x(dataTable,y_optimal_fmin,'ShowInterpolatingFunction',true); title('fmin 1')

% disp(costfxn(y_optimal_lsq))
% disp(costfxn(y_optimal_fmin))

