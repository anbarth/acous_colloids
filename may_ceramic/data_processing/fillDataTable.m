% run these individually with showPlots set to true to check that the
% automated part is working correctly

rows20 = getStressSweepDataTableRows(phi20_sample1_05_28.sweep2,0.1999,[]); 
rows25 = getStressSweepDataTableRows(phi25_sample1_05_31.sweep1,0.2503,[]);
rows30 = getStressSweepDataTableRows(phi30_sample1_05_28.sweep3,0.2997,[]);
rows35 = getStressSweepDataTableRows(phi35_sample1_05_31.sweep3,0.3500,[]);
rows40 = getStressSweepDataTableRows(phi40_sample3_05_31.sweep1,0.4009,[]);
rows44 = getAcousDataTableRows(phi44_05_29,false);
rows46 = getAcousDataTableRows(phi46_06_19,false);
rows48 = getAcousDataTableRows(phi48_05_31,false);
rows52 = getAcousDataTableRows(phi52_05_29,false);
rows54 = getAcousDataTableRows(phi54_06_01,false);
rows56 = getAcousDataTableRows(phi56_05_31,false);
rows59 = getAcousDataTableRows(phi59_05_30,false);
rows61 = getAcousDataTableRows(phi61_06_20,false);

% exclude higher stresses where stress sweep begins to bend down
% phi44_rows = phi44_rows(phi44_rows(:,2)~=10 & phi44_rows(:,2)~=20,:);
% phi48_rows = phi48_rows(phi48_rows(:,2)~=20,:);
% phi52_rows = phi52_rows(phi52_rows(:,2)~=50,:);
% phi56_rows = phi56_rows(phi56_rows(:,2)~=100,:);
% phi59_rows = phi59_rows(phi59_rows(:,2)~=200,:);

% exclude lower stresses where there's big shear thinning
% (i used some discretion here)
% phi30_rows = phi30_rows(phi30_rows(:,2)>=0.01,:);
% phi48_rows = phi48_rows(phi48_rows(:,2)>=0.01,:);
% phi54_rows = phi54_rows(phi54_rows(:,2)>=0.03,:);
% phi56_rows = phi56_rows(phi56_rows(:,2)>=0.003,:);
% phi59_rows = phi59_rows(phi59_rows(:,2)>=0.01,:);
% phi59p5_rows = phi59p5_rows(phi59p5_rows(:,2)>=0.01,:);


clear dataTable
dataTable = [rows20; rows25; rows30; rows35;...
    rows40; rows44; rows46; rows48; rows52;...
    rows54; rows56; rows59; rows61];