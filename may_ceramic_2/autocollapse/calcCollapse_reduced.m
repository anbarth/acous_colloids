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
    % choose only select acoustics data
    elseif ismember(myRow(1),phi_list(phi_include_indices))
        if ismember(myRow(3),volt_include_list)
            if ismember(myRow(2),stress_list(stress_include_indices))
                minimalDataTable(end+1,:)=myRow;
            end
        end
    end
end
minimalDataTable = dataTable;

% eta0_init = A_init = eta_solvent*phi0^2 ~ 0.02
[eta0_init,sigmastar_init,phimu_init,phi0_init]  = wyart_cates(may_ceramic_09_17,false);
y_init = zipReducedParams(eta0_init,phi0_init,-1,eta0_init,0.5,[0,0,sigmastar_init],0.15,10,[0,10],[0,3]);
y_init = shift_xmax_to_val(dataTable,y_init,0.999);

%y_init = y_red_handpicked;

%show_F_vs_xc_x(dataTable,reducedParamsToFullParams(y_init,phi_list),'ShowInterpolatingFunction',true)
%show_F_vs_xc_x(minimalDataTable,reducedParamsToFullParams(y_init,phi_list))
%return

costfxn = @(yReduced) sum(getResidualsReduced(minimalDataTable,yReduced,phi_list,volt_list).^2);
opts = optimoptions('fmincon','MaxFunctionEvaluations',3e5);
lower_bounds = -Inf*ones(1,14);
upper_bounds = Inf*ones(1,14);

[y_red_optimal,fval,exitflag,output,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);
%[yReduced_optimal,fval,exitflag,output,grad,hessian] = fminunc(costfxn,y_init,opts);

show_F_vs_x(dataTable,reducedParamsToFullParams(y_red_optimal),'ShowInterpolatingFunction',true)

costfxn_alldata = @(yReduced) sum(getResidualsReduced(dataTable,yReduced,phi_list,volt_list).^2);
disp(costfxn_alldata(y_red_optimal))