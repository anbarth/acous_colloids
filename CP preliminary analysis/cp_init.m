CSS = (50/19)^3;
CSR = 19/50;
CSV = CSS/CSR;

vol_frac_markers = ['^','>','s','o','d','p','h','v'];

addpath(genpath('SiO2_DPG_CP\'))
addpath(genpath('..\plot_helpers\'))
addpath(genpath('..\rheo_data_helpers\'))
load('cp_data_01_18.mat');
load('cp_low_phi.mat');