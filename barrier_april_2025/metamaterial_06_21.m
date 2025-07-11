load('phi61_meta_06_21.mat')

figure; hold on; prettyplot
rateVsT(phi61_meta_06_21.h2_conts)
rateVsT(phi61_meta_06_21.h2_05hz)
rateVsT(phi61_meta_06_21.h2_10hz)
rateVsT(phi61_meta_06_21.h2_200hz)
legend('continuous','0.5 Hz','10 Hz','200 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=2mm, h/d=0.69')

figure; hold on; prettyplot
rateVsT(phi61_meta_06_21.h06_conts)
rateVsT(phi61_meta_06_21.h06_05hz)
rateVsT(phi61_meta_06_21.h06_10hz)
rateVsT(phi61_meta_06_21.h06_200hz)
legend('continuous','0.5 Hz','10 Hz','200 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=0.6mm, h/d=0.41')

figure; hold on; prettyplot
rateVsT(phi61_meta_06_21.h022_conts)
rateVsT(phi61_meta_06_21.h022_05hz)
rateVsT(phi61_meta_06_21.h022_10hz)
rateVsT(phi61_meta_06_21.h022_200hz)
legend('continuous','0.5 Hz','10 Hz','200 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=0.22mm, h/d=0.20')