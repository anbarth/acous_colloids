rheoStruct = phi59p5_04_16.sig003_100V_40V;
gap = getGap(rheoStruct);
t = getTime(rheoStruct);
changePts = findchangepts(gap,'MaxNumChanges',2);
t_on = t(changePts(1));
t_off = t(changePts(2));

etaVsT(rheoStruct);
xline(t_on);
xline(t_off);