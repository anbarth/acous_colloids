% import data and params
data_table = may_ceramic_09_17;
%smoothen_C_acous_free_03_19;
alpha = -myft2.p1;
D0 = exp(myft2.p2);

myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
phi0=paramsVector(2);
sigmastar = paramsVector(6);
D = paramsVector(7:end);
phi_list = unique(data_table(:,1));

myAlpha=alpha;
%D0 = D(end)*(phi0-phi_list(end))^myAlpha;

figure; hold on; prettyplot;
xlabel('\phi'); ylabel('D')
plot(phi_list,D,'bo','LineWidth',1)
D_fake = linspace(min(D),1.5);
phi_fake=zeros(size(D_fake));
for ii=1:length(phi_fake)
    phi_fake(ii)=invD(D_fake(ii),D,phi_list,phi0,D0,myAlpha);
end
plot(phi_fake,D_fake,'b-','LineWidth',1);

figure; hold on; prettyplot;
xlabel('\phi'); ylabel('B')
myAlpha=1;
plot(phi_list,D'.*(phi0-phi_list).^myAlpha,'bo','LineWidth',1)
plot(phi_fake,D_fake.*(phi0-phi_fake).^myAlpha,'b-','LineWidth',1);