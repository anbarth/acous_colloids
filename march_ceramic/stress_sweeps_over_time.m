cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);


% 44%
figure; hold on;
title('44%');
ax44 = gca;
ax44.XScale = 'log';
ax44.YScale = 'log';
colormap(ax44,cmap)

tmax=180;
getStressSweep(phi44_03_19.low_sweep_init,1,myColor(0,tmax));
getStressSweep(phi44_03_19.low_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi44_03_19.low_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi44_03_19.low_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi44_03_19.low_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi44_03_19.stress_sweep_init,1,myColor(0,tmax));
getStressSweep(phi44_03_19.stress_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi44_03_19.stress_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi44_03_19.stress_sweep_90min,1,myColor(90,tmax));
getStressSweep(phi44_03_19.stress_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi44_03_19.stress_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi44_03_19.stress_sweep_3hr,1,myColor(180,tmax));

% 48%
figure; hold on;
title('48%');
ax48 = gca;
ax48.XScale = 'log';
ax48.YScale = 'log';
colormap(ax48,cmap)

tmax=180;
getStressSweep(phi48_03_25.stress_sweep_init,1,myColor(0,tmax));
getStressSweep(phi48_03_25.stress_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi48_03_25.stress_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi48_03_25.stress_sweep_90min,1,myColor(90,tmax));
getStressSweep(phi48_03_25.stress_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi48_03_25.stress_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi48_03_25.stress_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi48_03_25.low_sweep_init,1,myColor(0,tmax));
getStressSweep(phi48_03_25.low_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi48_03_25.low_sweep_1hr,1,myColor(60,tmax));



% 52%
figure; hold on;
title('52%');
ax52 = gca;
ax52.XScale = 'log';
ax52.YScale = 'log';
colormap(ax52,cmap)

tmax = 180;
getStressSweep(phi52_03_18.low_sweep_init,1,myColor(0,tmax));
getStressSweep(phi52_03_18.low_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi52_03_18.low_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi52_03_18.low_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi52_03_18.low_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi52_03_18.stress_sweep_init,1,myColor(0,tmax));
getStressSweep(phi52_03_18.stress_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi52_03_18.stress_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi52_03_18.stress_sweep_90min,1,myColor(90,tmax));
getStressSweep(phi52_03_18.stress_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi52_03_18.stress_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi52_03_18.stress_sweep_3hr,1,myColor(180,tmax));

% 56%
figure; hold on;
title('56%');
ax56 = gca;
ax56.XScale = 'log';
ax56.YScale = 'log';
colormap(ax56,cmap)

tmax = 270;
getStressSweep(phi56_03_28.stress_sweep_init_2,1,myColor(0,tmax));
getStressSweep(phi56_03_28.stress_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi56_03_28.stress_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi56_03_28.stress_sweep_90min,1,myColor(90,tmax));
getStressSweep(phi56_03_28.stress_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi56_03_28.stress_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi56_03_28.stress_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi56_03_28.stress_sweep_210min,1,myColor(210,tmax));
getStressSweep(phi56_03_28.stress_sweep_4hr,1,myColor(240,tmax));
getStressSweep(phi56_03_28.stress_sweep_270min,1,myColor(270,tmax));
getStressSweep(phi56_03_28.low_sweep_init_2,1,myColor(0,tmax));
getStressSweep(phi56_03_28.low_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi56_03_28.low_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi56_03_28.low_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi56_03_28.low_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi56_03_28.low_sweep_4hr,1,myColor(240,tmax));
getStressSweep(phi56_03_28.low_sweep_270min,1,myColor(270,tmax));



% 59%
figure; hold on;
title('59%');
ax59 = gca;
ax59.XScale = 'log';
ax59.YScale = 'log';
colormap(ax59,cmap)

tmax=240;
getStressSweep(phi59_03_20.stress_sweep_init_2,1,myColor(0,tmax));
getStressSweep(phi59_03_20.stress_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi59_03_20.stress_sweep_1hr,1,myColor(60,tmax));
getStressSweep(phi59_03_20.stress_sweep_90min,1,myColor(90,tmax));
getStressSweep(phi59_03_20.stress_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi59_03_20.stress_sweep_150min,1,myColor(150,tmax));
getStressSweep(phi59_03_20.stress_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi59_03_20.stress_sweep_210min,1,myColor(210,tmax));
getStressSweep(phi59_03_20.stress_sweep_4hr,1,myColor(240,tmax));
getStressSweep(phi59_03_20.low_sweep_init,1,myColor(0,tmax));
getStressSweep(phi59_03_20.low_sweep_30min,1,myColor(30,tmax));
getStressSweep(phi59_03_20.low_sweep_2hr,1,myColor(120,tmax));
getStressSweep(phi59_03_20.low_sweep_3hr,1,myColor(180,tmax));
getStressSweep(phi59_03_20.low_sweep_210min,1,myColor(210,tmax));
getStressSweep(phi59_03_20.low_sweep_4hr,1,myColor(240,tmax));
