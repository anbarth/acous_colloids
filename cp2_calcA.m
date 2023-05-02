my_vol_frac_markers = ['>','s','o','d','h'];

fudge = 0;
cp2_collapse_parameters;

colorBy = 3; % 1 for V, 2 for phi, 3 for P


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
ax2.XLabel.String = "P";
ax2.YLabel.String = "A";
colormap(ax2,cmap);

cmap = viridis(256); 
fig3 = figure;
ax3 = axes('Parent', fig3,'XScale','log','YScale','log');
ax3.XLabel.String = "x";
ax3.YLabel.String = "F";
%ax3.XLim = [10^(-3),10^1.5]; %TODO delete
colormap(ax3,cmap);
if xc ~= 0
    xline(ax3,xc);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = cp_data_01_18;
phi_list = [44,48,50,54];
volt_list = [0,5,10,20,40,60,80,100];
x_all = zeros(0,1);
F_all = zeros(0,1);
P_all = zeros(0,1);
A_all = zeros(0,1);


for ii = 1
    phi = phi_list(ii)/100;
    myMarker = my_vol_frac_markers(ii);

    % first, plot 0V stuff
    myData_0V = stressTable(stressTable(:,1)==phi & stressTable(:,2)==0,:);
    sigma_0V = myData_0V(:,3)*CSS;
    eta_0V = CSV/1000*myData_0V(:,4);
    %x_0V = C(ii)*f(sigma_0V) ./ (-1*phi+phi0);
    my_f_mod_0V = f_mod(ii,1:length(sigma_0V))';

    % fudge phi
    phi_fudge = phi_fudge_factors(phi_fudge_factors(:,1)==phi,2);
    disp(phi_fudge)

    F_0V = eta_0V*(phi0-phi_fudge)^2;
    x_0V = C(ii)*f(sigma_0V).*my_f_mod_0V ./ (-1*phi_fudge+phi0);
    hold(ax1,'on');
    plot(ax1,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));

    hold(ax3,'on');
    plot(ax3,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));


    % now look at everything else!
    myData = stressTable(stressTable(:,1)==phi,:);
    sigma_rheo = myData(:,3);
    sigma = sigma_rheo*CSS;
    eta = CSV/1000*myData(:,4);
    voltage = myData(:,2);
    x = C(ii)*f(sigma) ./ (-1*phi_fudge+phi0);
    % TODO logistically hard to get my_f_mod now -- might be easiest to
    % just loop over all the voltages?
    %my_f_mod = f_mod(ii,1:length(sigma))';
    %x = C(ii)*f(sigma).*my_f_mod ./ (-1*phi+phi0);
    
    F = eta*(phi0-phi_fudge)^2;

    % calculate nondimensionalized power
    % TODO i dont like this
    P = zeros(size(x));
    for kk = 1:length(x)
        my_eta_0V = eta_0V(sigma_0V==sigma(kk));
        my_gamma_dot_0V = sigma(kk)/my_eta_0V;
        P(kk) = voltage(kk)^2/sigma(kk)/my_gamma_dot_0V;
    end

    % now find the shift for each point by interpolating onto 0V curve
    A = zeros(size(x));
    for jj=1:length(x)
        myX = x(jj);
        myF = F(jj);
        myX_target = myInterpolate(myF,x_0V,F_0V);
        A(jj) = myX_target/myX;
        if(isnan(A(jj)))
            A(jj)=1;
        end
    end

    x_new = A.*x;

    if colorBy == 1
        myColor = cmap(round(1+255*voltage/100),:);
    elseif colorBy == 2
        myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
    elseif colorBy == 3
        myColor = log(P);
    end
    

    
    hold(ax1,'on');
    scatter(ax1,x_new,F,[],myColor,'filled',myMarker);

    hold(ax3,'on');
    scatter(ax3,x,F,[],myColor,'filled',myMarker);

    
    hold(ax2,'on');
    myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
    scatter(ax2,P,A,[],myColor);
    
    x_all(end+1:end+length(x)) = x;
    F_all(end+1:end+length(F)) = F;
    P_all(end+1:end+length(P)) = P;
    A_all(end+1:end+length(A)) = A;
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

% lets find a fit for A!
% trim out nan values to prepare myself
keep_me = ~isnan(F_all);
x_all = x_all(keep_me);
F_all = F_all(keep_me);
P_all = P_all(keep_me);
A_all = A_all(keep_me);

% we also need to trim out anything with P=0 so that we can work with logP
% i'm also not interested in all the points with A=1
P_all_old = P_all;
A_all_old = A_all;
keep_me_too = P_all~=0 & 1-abs(A_all)>0.001;
P_all = P_all(keep_me_too);
A_all = A_all(keep_me_too);

% maybe A is some quadratic of log(P)?
%logP_all = log10(P_all);
%myFit = polyfit(logP_all,A_all,2);
%P_fake = logspace(-4,4); 
%logP_fake = log10(P_fake); % i'm aware this is silly but it helps my brain ok
%A_fake = myFit(1)*logP_fake.^2 + myFit(2)*logP_fake + myFit(3);

% maybe a sigmoid of log(P)? aka 1/1+kP?
fitfxn = @(k) 1 ./ (1+k(1)*P_all.^k(2));
%costfxn = @(k) sum(( (fitfxn(k)-A_all)./A_all ).^2); % gives too much weight to points with small A
costfxn = @(k) sum(( (fitfxn(k)-A_all) ).^2); 
myK = fmincon(costfxn,[10^(-2),1],[-1,0;0,0],[0,0]);
P_fake = logspace(-4,6); 
A_fake = 1 ./ (1+myK(1)*P_fake.^myK(2));

hold(ax2,'on');
plot(ax2,P_fake,A_fake,'r')

disp(myK)
