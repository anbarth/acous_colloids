%optimize_sigmastarV_03_19;
y = y_fmincon;
myModelHandle = @modelHandpickedSigmastarV_CSV;
sigmastar = y(6:12);
sigmastar_noV = sigmastar(1)*ones(size(sigmastar));
y_noV = y;
y_noV(6:12) = sigmastar_noV;

dataTable = may_ceramic_09_17;
GammaDot = zeros(size(dataTable,1),1);

d33 = 3e-10;
f = 1.15e6;
gap = 0.211*1e-3;


for kk=1:size(dataTable,1)
    % read data row
    V = dataTable(kk,3);
    sigma = dataTable(kk,2);
    eta = dataTable(kk,4);

    % calculate Gamma dot
    gammaDotAcous = V*d33/gap*f;
    gammaDotShear = sigma./eta;
    GammaDot(kk)=gammaDotAcous/gammaDotShear;
end

dataTable = [dataTable,GammaDot];

show_F_vs_x(dataTable,y_noV,myModelHandle,'ColorBy',5)
xlim([1e-5 1.5])