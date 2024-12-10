% run these individually with showPlots set to true to check that the
% automated part is working correctly

% for 52%, we have to exclude the lower stresses bc i didnt do motor adjustment
%phi52_rows = getAllDataTableRows(phi52_03_18,phi52_03_18.low_sweep_30min,0.5205,false);
phi20_rows = getStressSweepDataTableRows(phi20_04_15.stress_sweep_30min,0.1997,[]);
phi30_rows = getStressSweepDataTableRows(phi30_04_15.stress_sweep_init,0.2993,[]);
phi44_rows = getAllDataTableRows(phi44_03_19,phi44_03_19.low_sweep_init,0.4398,false);
phi48_rows = getAllDataTableRows(phi48_03_25,phi48_03_25.low_sweep_init,0.4800,false);
phi52_rows = getAcousDataTableRows(phi52_03_18, false);
phi52_rows(:,1) = 0.5205*ones(size(phi52_rows(:,1)));
phi54_rows = getAllDataTableRows(phi54_04_17,phi54_04_17.low_sweep_init,0.5404,false);
phi56_rows = getAllDataTableRows(phi56_03_28,phi56_03_28.low_sweep_init_2,0.5597,false);
phi58_rows = getAllDataTableRows(phi58_04_18,phi58_04_18.low_sweep_init,0.5809,false);
phi59_rows = getAllDataTableRows(phi59_03_20,phi59_03_20.low_sweep_init,0.5907,false);
phi59p5_rows = getAllDataTableRows(phi59p5_04_16,phi59p5_04_16.low_sweep_init,0.5956,false);


% exclude higher stresses where stress sweep begins to bend down
phi44_rows = phi44_rows(phi44_rows(:,2)~=10 & phi44_rows(:,2)~=20,:);
phi48_rows = phi48_rows(phi48_rows(:,2)~=20,:);
phi52_rows = phi52_rows(phi52_rows(:,2)~=50,:);
phi56_rows = phi56_rows(phi56_rows(:,2)~=100,:);
phi59_rows = phi59_rows(phi59_rows(:,2)~=200,:);

% exclude lower stresses where there's big shear thinning
% (i used some discretion here)
%phi30_rows = phi30_rows(phi30_rows(:,2)>=0.01,:);
%phi48_rows = phi48_rows(phi48_rows(:,2)>=0.01,:);
%phi54_rows = phi54_rows(phi54_rows(:,2)>=0.03,:);
%phi56_rows = phi56_rows(phi56_rows(:,2)>=0.003,:);
%phi59_rows = phi59_rows(phi59_rows(:,2)>=0.01,:);
%phi59p5_rows = phi59p5_rows(phi59p5_rows(:,2)>=0.01,:);


clear dataTable
dataTable = [phi20_rows; phi30_rows; phi44_rows; phi48_rows; phi52_rows; phi54_rows; phi56_rows; phi59_rows; phi59p5_rows];