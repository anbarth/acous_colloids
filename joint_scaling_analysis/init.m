addpath(genpath('..\plot_helpers\'))
addpath(genpath('..\rheo_data_helpers\'))
addpath(genpath('..\joint_scaling_analysis\'))

load('meera_si_table.mat')
load('y_si.mat') % generated from meeras og collapse

load('meera_cs_table.mat')
load('y_cs.mat') % generated from meeras og collapse

load('may_ceramic_09_17.mat')
load('anna_ceramic_y_handpicked_03_19.mat') % generated from play_with_C_03_19 
% NOTE for all 3 of these parameter vectors, A has been set to 1 bc I am
% now using F/F0 instead of F in the model files in this folder

compile_joint_table;
