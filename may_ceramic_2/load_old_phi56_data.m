% version 2: just load in data from may 2024 and draw a cubic spline through it
CSS = (50/19)^3;
load("../may_ceramic_2/data/phi56_05_31.mat")
sweepData2 = getStressSweep(phi56_05_31.sweep1,t_avg,2,false);
sweepData1 = getStressSweep(phi56_05_31.low_sweep1,t_avg,2,false);
gap = Inf;
phi56_ref_table1 = [gap*ones(size(sweepData1,1),1), sweepData1, ones(size(sweepData1,1),1)];
phi56_ref_table2 = [gap*ones(size(sweepData2,1),1), sweepData2, ones(size(sweepData2,1),1)];
phi56_ref_table = [phi56_ref_table1;phi56_ref_table2];
phi56_ref_table(:,2) = CSS*phi56_ref_table(:,2);

sweepData = [sweepData1;sweepData2];
sweepData(:,1) = sweepData(:,1)*CSS;

% draw a spline for stress(rate)
pp = spline(sweepData(:,2),sweepData(:,1));
pp = fnxtr(pp);
%pp = flattenEnds(pp);
phi56_ref_stress = @(rate) ppval(pp,rate);


