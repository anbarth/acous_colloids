load("optimized_params_03_17.mat")
build_restricted_data_table_03_17;

makePlot = false;
plotUsingCSS = true;
CSS = 19;

dataTable = restricted_data_table;
y = y_fmincon;
myModelHandle = @modelHandpickedAllExp;

[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(y,13); 
confInts = get_conf_ints(dataTable,y,myModelHandle);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err] = unzipParamsHandpickedAll(confInts,13); 

volt_list = [0 5 10 20 40 60 80];

includeIndices = sigmastar~=0;
volt_list = volt_list(includeIndices);
sigmastar = sigmastar(includeIndices);
sigmastar_err = sigmastar_err(includeIndices);

myQuadFit = polyfit(volt_list,sigmastar,2);

if makePlot
    figure; hold on;
    xlabel('Acoustic voltage V')
    ylabel('\sigma^* (Pa)')
    %errorbar(volt_list,CSS*sigmastar,CSS*sigmastar_err,'ko','MarkerFaceColor','k')
    plot(volt_list,CSS*sigmastar,'ko','MarkerFaceColor','k')
    V = linspace(0,80);
    plot(V,CSS*polyval(myQuadFit,V),'r-')
end