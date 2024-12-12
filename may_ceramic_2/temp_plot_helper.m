my_y_red = y_red_half_phi_half_V_half_sig;
my_y = reducedParamsToFullParams(my_y_red);
show_F_vs_x(may_ceramic_09_17,my_y)
show_F_vs_xc_x(may_ceramic_09_17,my_y)

% 48%
show_F_vs_xc_x(may_ceramic_09_17,my_y,'ShowLines',true,'ShowErrorBars',true,'PhiRange',8)
% 59%
show_F_vs_xc_x(may_ceramic_09_17,my_y,'ShowLines',true,'ShowErrorBars',true,'PhiRange',12)

disp(sum(getResidualsReduced(dataTable,my_y_red,phi_list,volt_list).^2))