cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);


% 44%
figure; hold on;
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

% 52%
figure; hold on;
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

% 59%
figure; hold on;
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
