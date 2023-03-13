my_vol_frac_markers = ['>','s','o','d','h'];


%phi0 = 0.6231;
%C = [1,1.2,1.1,0.7];

phi0=.5923;
C = [1,1,0.8,0.45];
A = @(P) 1 ./ (1 + 0.0388*P.^0.6752);

sigmastar = 14.0770;
k = 0.9228;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);


colorBy = 3; % 1 for V, 2 for phi, 3 for P

xc = 0;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "x";
ax1.YLabel.String = "F";
%ax1.XLim = [10^(-3),10^1.5]; %TODO delete
colormap(ax1,cmap);
if xc ~= 0
    xline(ax1,xc);
end

fig2 = figure;
ax2 = axes('Parent', fig2,'XScale','log','YScale','log');
%ax2 = axes('Parent', fig2);
ax2.XLabel.String = "\sigma";
ax2.YLabel.String = "f";
colormap(ax2,cmap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = cp_data_01_18;
phi_list = [44,48,50,54];
volt_list = [0,5,10,20,40,60,80,100];
x_all = zeros(0,1);
F_all = zeros(0,1);
f_all = zeros(0,1);
sigma_all = zeros(0,1);


for ii = 1:4
    phi = phi_list(ii)/100;
    myMarker = my_vol_frac_markers(ii);

    % first, plot 0V stuff
    myData_0V = stressTable(stressTable(:,1)==phi & stressTable(:,2)==0,:);
    sigma_0V = myData_0V(:,3)*CSS;
    eta_0V = CSV/1000*myData_0V(:,4);
    x_0V = C(ii)*f(sigma_0V).*A(0) ./ (-1*phi+phi0);
    F_0V = eta_0V*(phi0-phi)^2;
    hold(ax1,'on');
    plot(ax1,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));



    % now look at everything else!
    myData = stressTable(stressTable(:,1)==phi,:);
    sigma_rheo = myData(:,3);
    sigma = sigma_rheo*CSS;
    eta = CSV/1000*myData(:,4);
    voltage = myData(:,2);

    % calculate nondimensionalized power
    % TODO i dont like this
    P = zeros(size(sigma));
    for kk = 1:length(P)
        my_eta_0V = eta_0V(sigma_0V==sigma(kk));
        my_gamma_dot_0V = sigma(kk)/my_eta_0V;
        P(kk) = voltage(kk)^2/sigma(kk)/my_gamma_dot_0V;
    end

    %x = C(ii)*f(sigma).*A(P) ./ (-1*phi+phi0);
    x = C(ii)*A(P) ./ (-1*phi+phi0);
    F = eta*(phi0-phi)^2;

    

    % now find the shift for each point by interpolating onto 0V curve
    newf = zeros(size(x));
    for jj=1:length(x)
        myX = x(jj);
        myF = F(jj);
        myX_target = myInterpolate(myF,x_0V,F_0V);
        newf(jj) = myX_target/myX;
        if(isnan(newf(jj)))
            newf(jj)=1;
        end
    end

    x_new = newf.*x;

    if colorBy == 1
        myColor = cmap(round(1+255*voltage/100),:);
    elseif colorBy == 2
        myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
    elseif colorBy == 3
        myColor = log(P);
    end
    

    
    hold(ax1,'on');
    scatter(ax1,x_new,F,[],myColor,'filled',myMarker);

    
    hold(ax2,'on');
    myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
    scatter(ax2,sigma,newf,[],myColor);
    
    x_all(end+1:end+length(x)) = x;
    F_all(end+1:end+length(F)) = F;
    f_all(end+1:end+length(newf)) = newf;
    sigma_all(end+1:end+length(sigma)) = sigma;
end

% plot old f(sigma)
hold(ax2,"on");
sigma_fake = logspace(-0.4,3);
f_fake = f(sigma_fake);
plot(ax2,sigma_fake,f_fake);

% add colorbars to plots
c1 = colorbar(ax1);
if colorBy == 1
    caxis(ax1,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
    %caxis(ax1,[0 log10(110)-1])
    %c1.Ticks = log10([0,5,10,20,40,60,80,100]+10)-1;
    %c1.TickLabels = {0,5,10,20,40,60,80,100};
elseif colorBy == 2
    caxis(ax1,[.44 .55]);
    c1.Ticks = phi_list/100;
end
c2 = colorbar(ax2);
caxis(ax2,[.44 .55]);
c2.Ticks = phi_list/100;

% lets find a fit for f!
% trim out nan values to prepare myself
keep_me = ~isnan(F_all);
x_all = x_all(keep_me);
F_all = F_all(keep_me);
f_all = f_all(keep_me);
sigma_all = sigma_all(keep_me);

% maybe a stretched exponential?
fitfxn = @(k) exp(-(k(1)./sigma_all).^k(2));
%costfxn = @(k) sum(( (fitfxn(k)-f_all)./f_all ).^2); % gives too much weight to points with small A
costfxn = @(k) sum(( (fitfxn(k)-f_all) ).^2); 
myK = fmincon(costfxn,[17,1],[-1,0;0,0],[0,0]);
sigma_fake = logspace(-0.4,3);
f_fake = exp(-(myK(1)./sigma_fake).^myK(2));

hold(ax2,'on');
plot(ax2,sigma_fake,f_fake,'r')
