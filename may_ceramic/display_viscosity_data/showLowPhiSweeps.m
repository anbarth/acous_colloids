%% 20%
figure; hold on;
title('20%')
L={};
getStressSweep(phi20_sample1_05_28.sweep1,true);L{end+1}='1, 1';
getStressSweep(phi20_sample1_05_28.sweep2,true);L{end+1}='1, 2';
getStressSweep(phi20_sample1_05_28.sweep3,true);L{end+1}='1, 3';
getStressSweep(phi20_sample1_05_28.sweep4,true);L{end+1}='1, 1';
getStressSweep(phi20_sample1_05_28.sweep5,true);L{end+1}='1, 5';
getStressSweep(phi20_sample1_05_28.sweep6,true);L{end+1}='1, 6';
getStressSweep(phi20_sample2_05_31.sweep1,true);L{end+1}='2, 1';
legend(L)

%% 25%
figure; hold on;
title('25%')
L={};
getStressSweep(phi25_sample1_05_31.sweep1,true);L{end+1}='1, 1';
getStressSweep(phi25_sample1_05_31.sweep2,true);L{end+1}='1, 2';
legend(L)

%% 30%
figure; hold on;
title('30%')
L={};
getStressSweep(phi30_sample1_05_28.sweep1,true);L{end+1}='1, 1';
getStressSweep(phi30_sample1_05_28.sweep2,true);L{end+1}='1, 2';
getStressSweep(phi30_sample1_05_28.sweep3,true);L{end+1}='1, 3';
getStressSweep(phi30_sample1_05_28.sweep4,true);L{end+1}='1, 4';
getStressSweep(phi30_sample2_05_31.sweep1,true);L{end+1}='2, 1';
getStressSweep(phi30_sample2_05_31.sweep2,true);L{end+1}='2, 2';
getStressSweep(phi30_sample3_05_31.sweep1,true);L{end+1}='3, 1';
legend(L)

%% 35%
figure; hold on;
title('35%')
L={};
getStressSweep(phi35_sample1_05_31.sweep1,true);L{end+1}='1, 1';
getStressSweep(phi35_sample1_05_31.sweep2,true);L{end+1}='1, 2';
getStressSweep(phi35_sample1_05_31.sweep3,true);L{end+1}='1, 3';
getStressSweep(phi35_sample1_05_31.sweep4,true);L{end+1}='1, 4';
legend(L)

%% 40%
figure; hold on;
title('40%')
L={};
getStressSweep(phi40_sample1_05_30.sweep1,true);L{end+1}='1, 1';
getStressSweep(phi40_sample1_05_30.sig0003,true);L{end+1}='1, \sigma=0.003';
getStressSweep(phi40_sample1_05_30.sig0005,true);L{end+1}='1, \sigma=0.005';
getStressSweep(phi40_sample1_05_30.sig001,true);L{end+1}='1, \sigma=0.01';
getStressSweep(phi40_sample1_05_30.sig002,true);L{end+1}='1, \sigma=0.02';
getStressSweep(phi40_sample2_05_31.sweep1,true);L{end+1}='2, 1';
getStressSweep(phi40_sample2_05_31.sweep2,true);L{end+1}='2, 2';
getStressSweep(phi40_sample3_05_31.sweep1,true);L{end+1}='3, 1';
getStressSweep(phi40_sample3_05_31.sweep2,true);L{end+1}='3, 2';
getStressSweep(phi40_sample3_05_31.sweep3,true);L{end+1}='3, 3';
getStressSweep(phi40_sample3_05_31.sweep4,true);L{end+1}='3, 4';
legend(L)