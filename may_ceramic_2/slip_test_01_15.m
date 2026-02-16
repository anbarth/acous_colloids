load('slip_test_phi56_01_15.mat')

CSV = (50/19)^3;

%%
figure; hold on;
tests = {slip_test_phi56_01_15.samp1_1mm_sweep,slip_test_phi56_01_15.samp1_08mm_sweep,...
    slip_test_phi56_01_15.samp1_06mm_sweep,slip_test_phi56_01_15.samp1_04mm_sweep,...
    slip_test_phi56_01_15.samp1_02mm_sweep};
for test=tests
    etaVsT(test{1},CSV)
end
legend('1mm','0.8mm','0.6mm','0.4mm','0.2mm')
ylim([4 1e3])

%%
figure; hold on;
tests = {slip_test_phi56_01_15.samp2_1mm_50pa,slip_test_phi56_01_15.samp2_08mm_50pa,...
    slip_test_phi56_01_15.samp2_06mm_50pa,slip_test_phi56_01_15.samp2_04mm_50pa,...
    slip_test_phi56_01_15.samp2_02mm_50pa};
for test=tests
    etaVsT(test{1},CSV)
end
legend('1mm','0.8mm','0.6mm','0.4mm','0.2mm')
xlim([0 10])

%%
% repeat of this test on 1/22 with fresh sandblasting on bottom plate
% and sandpaper taped to top plate
load('slip_test_phi56_01_22.mat')
figure; hold on;
tests = {slip_test_phi56_01_22.d1_sweep,slip_test_phi56_01_22.d08_sweep,...
    slip_test_phi56_01_22.d06_sweep,slip_test_phi56_01_22.d04_sweep,...
    slip_test_phi56_01_22.d02_sweep};
for test=tests
    etaVsT(test{1},CSV)
end
legend('1mm','0.8mm','0.6mm','0.4mm','0.2mm')
ylim([4 1e3])