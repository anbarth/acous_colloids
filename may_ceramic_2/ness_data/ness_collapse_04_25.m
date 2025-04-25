read_chris_data_04_25;

f=@(sigma,sigmastar) exp(-(sigmastar./sigma));
[eta0,sigmastar,phimu,phi0] = ness_wyart_cates(chris_table_04_25,f,showPlot);