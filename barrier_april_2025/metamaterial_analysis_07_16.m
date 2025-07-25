load('metamaterial_data_07_16.mat')

CSS = (50/19)^3;
CSR = 1/(50/19);
CSV = CSS/CSR;

%% parallel plate
figure; hold on; prettyplot;
etaVsT(pp_mm_07_16.d2_11hz,CSV)
etaVsT(pp_mm_07_16.d2_50v,CSV)
title('parallel plate, d=2mm')

figure; hold on; prettyplot;
etaVsT(pp_mm_07_16.d09_11hz,CSV)
etaVsT(timeshift(pp_mm_07_16.d09_50v,20),CSV)
title('parallel plate, d=0.9mm')

figure; hold on; prettyplot;
etaVsT(pp_mm_07_16.d04_11hz,CSV)
etaVsT(timeshift(pp_mm_07_16.d04_50v,0),CSV)
title('parallel plate, d=0.4mm')

figure; hold on; prettyplot;
etaVsT(pp_mm_07_16.d022_11hz,CSV)
etaVsT(timeshift(pp_mm_07_16.d022_50v,5),CSV)
title('parallel plate, d=0.22mm')

%% barrier plate
figure; hold on; prettyplot;
etaVsT(barrier_mm_07_16.h2_11hz,CSV)
etaVsT(timeshift(barrier_mm_07_16.h2_50v,-13),CSV)
title('barrier plate, h=2mm (h/d=0.69)')

figure; hold on; prettyplot;
etaVsT(barrier_mm_07_16.h09_11hz,CSV)
etaVsT(timeshift(barrier_mm_07_16.h09_50v,0),CSV)
title('barrier plate, h=0.9mm (h/d=0.51)')

figure; hold on; prettyplot;
etaVsT(barrier_mm_07_16.h04_11hz,CSV)
etaVsT(timeshift(barrier_mm_07_16.h04_50v,0),CSV)
title('barrier plate, h=0.4mm (h/d=0.31)')

figure; hold on; prettyplot;
etaVsT(barrier_mm_07_16.h022_11hz,CSV)
etaVsT(timeshift(barrier_mm_07_16.h022_50v,-3),CSV)
title('barrier plate, h=0.22mm (h/d=0.20)')