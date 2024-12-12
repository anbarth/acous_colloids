dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

minimalDataTable = zeros(0,size(dataTable,2));
phi_include_indices = [7 9 11 13];
volt_include_list = [10 40 80];
stress_include_indices = [1 3 5 7 9 11 13 15 17];
for kk = 1:size(dataTable,1)
    myRow = dataTable(kk,:);
    % gimme all the acoustics-free data
    if myRow(3)==0
        minimalDataTable(end+1,:)=myRow;
    end
end
%minimalDataTable = dataTable;



y_init = y_red_handpicked;
%show_F_vs_x(dataTable,reducedParamsToFullParams(y_init,phi_list))
%show_F_vs_xc_x(minimalDataTable,reducedParamsToFullParams(y_init,phi_list))
%return

costfxn = @(yReduced) sum(getResidualsReduced(minimalDataTable,yReduced,phi_list,volt_list).^2);
opts = optimoptions('fmincon','MaxFunctionEvaluations',3e5);
lower_bounds = -Inf*ones(1,14);
lower_bounds(6:7)=0; % sigmastar voltage dependence
lower_bounds(11)=0; % q0 voltage dependence
lower_bounds(13)=0; % q1 voltage dependece
upper_bounds = -1*lower_bounds;
%lower_bounds(8)=y_init(8); % fix sigmastar
%upper_bound(8)=y_init(8); % fix sigmastar

[y_red_optimal,fval,exitflag,output,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);