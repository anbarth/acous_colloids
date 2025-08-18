load('phi61_meta_06_21.mat')

figure; hold on; prettyplot
etaVsT(timeshift(phi61_meta_06_21.h2_conts,-30))
etaVsT(timeshift(phi61_meta_06_21.h2_200hz,-10))
etaVsT(timeshift(phi61_meta_06_21.h2_10hz,-35))
etaVsT(timeshift(phi61_meta_06_21.h2_05hz,0))
legend('continuous','200 Hz','10 Hz','0.5 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=2mm, h/d=0.69')

figure; hold on; prettyplot
etaVsT(timeshift(phi61_meta_06_21.h06_conts,0))
etaVsT(timeshift(phi61_meta_06_21.h06_200hz,20))
etaVsT(timeshift(phi61_meta_06_21.h06_10hz,30))
etaVsT(timeshift(phi61_meta_06_21.h06_05hz,50))
legend('continuous','200 Hz','10 Hz','0.5 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=0.6mm, h/d=0.41')

figure; hold on; prettyplot
etaVsT(timeshift(phi61_meta_06_21.h022_conts,0))
etaVsT(timeshift(phi61_meta_06_21.h022_200hz,20))
etaVsT(timeshift(phi61_meta_06_21.h022_10hz,30))
etaVsT(timeshift(phi61_meta_06_21.h022_05hz,50))
legend('continuous','200 Hz','10 Hz','0.5 Hz')
ylabel('\eta_{eff} (Pa s)')
title('h=0.22mm, h/d=0.20')