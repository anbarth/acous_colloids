my_vol_frac_markers = ['>','s','o','d','h'];


cp2_collapse_parameters;

colorBy = 2; % 1 for V, 2 for phi, 3 for P


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
ax2 = axes('Parent', fig2,'XScale','log');
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
sig_all = zeros(0,1);
f_all = zeros(0,1);


for ii = 1
    phi = phi_list(ii)/100;
    myMarker = my_vol_frac_markers(ii);

    % first, plot 0V stuff
    myData_0V = stressTable(stressTable(:,1)==phi & stressTable(:,2)==0,:);
    sigma_0V = myData_0V(:,3)*CSS;
    eta_0V = CSV/1000*myData_0V(:,4);
    x_0V = C(ii) ./ (-1*phi+phi0);
    F_0V = eta_0V*(phi0-phi)^2;
    hold(ax1,'on');
    plot(ax1,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));

    continue
    % now look at everything else!
    myData = stressTable(stressTable(:,1)==phi,:);
    sigma_rheo = myData(:,3);
    sigma = sigma_rheo*CSS;
    eta = CSV/1000*myData(:,4);
    voltage = myData(:,2);

    % calculate nondimensionalized power
    % TODO i dont like this
    P = zeros(size(x));
    for kk = 1:length(x)
        my_eta_0V = eta_0V(sigma_0V==sigma(kk));
        my_gamma_dot_0V = sigma(kk)/my_eta_0V;
        P(kk) = voltage(kk)^2/sigma(kk)/my_gamma_dot_0V;
    end

    x = C(ii)*A(P) ./ (-1*phi+phi0);
    F = eta*(phi0-phi)^2;

    % now find the shift for each point by interpolating onto 0V curve
    f = zeros(size(x));
    for jj=1:length(x)
        myX = x(jj);
        myF = F(jj);
        myX_target = myInterpolate(myF,x_0V,F_0V);
        f(jj) = myX_target/myX;
        if(isnan(f(jj)))
            f(jj)=1;
        end
    end

    x_new = f.*x;

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
    scatter(ax2,P,A,[],myColor);
    
    x_all(end+1:end+length(x)) = x;
    F_all(end+1:end+length(F)) = F;
    sig_all(end+1:end+length(sigma)) = sigma;
    f_all(end+1:end+length(f)) = f;
end

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
return
% lets find a fit for A!
% trim out nan values to prepare myself
keep_me = ~isnan(F_all);
x_all = x_all(keep_me);
F_all = F_all(keep_me);
sig_all = sig_all(keep_me);
f_all = f_all(keep_me);

% we also need to trim out anything with P=0 so that we can work with logP
% i'm also not interested in all the points with A=1
P_all_old = sig_all;
A_all_old = f_all;
keep_me_too = sig_all~=0 & 1-abs(f_all)>0.001;
sig_all = sig_all(keep_me_too);
f_all = f_all(keep_me_too);

% maybe A is some quadratic of log(P)?
%logP_all = log10(P_all);
%myFit = polyfit(logP_all,A_all,2);
%P_fake = logspace(-4,4); 
%logP_fake = log10(P_fake); % i'm aware this is silly but it helps my brain ok
%A_fake = myFit(1)*logP_fake.^2 + myFit(2)*logP_fake + myFit(3);

% maybe a sigmoid of log(P)? aka 1/1+kP?
fitfxn = @(k) 1 ./ (1+k(1)*sig_all.^k(2));
%costfxn = @(k) sum(( (fitfxn(k)-A_all)./A_all ).^2); % gives too much weight to points with small A
costfxn = @(k) sum(( (fitfxn(k)-f_all) ).^2); 
myK = fmincon(costfxn,[10^(-2),1],[-1,0;0,0],[0,0]);
P_fake = logspace(-4,6); 
A_fake = 1 ./ (1+myK(1)*P_fake.^myK(2));

hold(ax2,'on');
plot(ax2,P_fake,A_fake,'r')

disp(myK)
