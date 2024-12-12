rheoStruct = phi44_03_19.sig003;
gap = getGap(rheoStruct);
t = getTime(rheoStruct);
changePts = findchangepts(gap,'MaxNumChanges',2);
t_on = t(changePts(1));
t_off = t(changePts(2));

etaVsT(rheoStruct);
xline(t_on);
xline(t_off);