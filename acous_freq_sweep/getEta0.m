function eta0 = getEta0(rheoStruct)

t = getTime(rheoStruct);
eta = getViscosity(rheoStruct);
t0 = rheoStruct.t_markers(1);
eta0 = eta(t0==t);

end