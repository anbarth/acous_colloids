read_chris_data_04_25;
dataTable = chris_table_04_25;
dataTable = dataTable(dataTable(:,1)>0.54,:);

f=@(sigma,sigmastar) exp(-(sigmastar./sigma));
%f=@(sigma,sigmastar) 1-exp(-(sigma./sigmastar));
showPlot = false;
[eta0,sigmastar,phimu,phi0] = ness_wyart_cates(dataTable,f,showPlot);
%[eta0,sigmastar,phimu,phi0] = ness_wyart_cates_fix_phi0_phimu(chris_table_04_25,f,0.646,0.602,showPlot);


%return
%myModelHandle = @modelWyartCates;
%y = [eta0,sigmastar,phimu,phi0];
%show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',2,'VolFracMarkers',[])

myModelHandle = @modelLogisticCExp0V;
% eta0 phi0 delta A width sigma* alpha L k phi*
y = [eta0 phi0 -2.5 eta0 0.5 sigmastar 1 2 0 0];
show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',2,'VolFracMarkers',[],'ShowInterpolatingFunction',false)
