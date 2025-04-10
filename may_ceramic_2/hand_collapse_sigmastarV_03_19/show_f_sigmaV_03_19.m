correctStressUnits = true;
CSS=1;
if correctStressUnits
    CSS=(50/19)^3;
end

%optimize_sigmastarV_03_19;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;

sigmastar = CSS*y_pointwise(6:12);

figure; hold on;
ax1 = gca; ax1.XScale = 'log';
xlabel("Shear stress \sigma (Pa)")
ylabel("f(\sigma)")


sigma = logspace(-2,4);
f = @(sigma,sigmastarV) exp(-sigmastarV./sigma);

cmap = plasma(256);
myColor = @(V) cmap(round(1+255*V/80),:);
for jj=1:length(my_volt_list)
    colorV = myColor(my_volt_list(jj));
    sigmastarV = sigmastar(jj);
    plot(sigma,f(sigma,sigmastarV),'-','Color',colorV,'LineWidth',1.5);
    prettyPlot;
end

myfig = gcf;
myfig.Position=[603,135,319,249];
    