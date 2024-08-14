my_vol_frac_markers = ["o","square","<","hexagram","^","pentagram","v","d",">"];

vol_frac_plotting_range = 1:8;
volt_plotting_range = 1:8;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
showMeera = false;


%xc=1;
xc = 1;

%collapse_params;
load("y_optimal_08_13.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,8);
f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);


stressTable = pranav_data_table;
phi_list = unique(stressTable(:,1));
minPhi = 0.42;
maxPhi = 0.56;
volt_list = [0,5,10,20,40,60,80,100];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = turbo;
if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');
ax_collapse.XLabel.String = "x";
ax_collapse.YLabel.String = "F";
if showMeera
    scatter(ax_collapse,meeraX*meeraMultiplier_X,meeraY*meeraMultiplier_Y,[],[0.5 0.5 0.5]);
end
ax_collapse.XLim = [10^-3, 2];
colormap(ax_collapse,cmap);
if xc ~= 0
    xline(ax_collapse,xc,Layer="bottom");
end


if xc ~= 0
    fig_xc_x = figure;
    ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
    hold(ax_xc_x,'on');
    ax_xc_x.XLabel.String = "x_c-x";
    ax_xc_x.YLabel.String = "F";
    colormap(ax_xc_x,cmap);
    

    fig_cardy = figure;
    ax_cardy = axes('Parent', fig_cardy,'XScale','log','YScale','log');
    hold(ax_cardy,'on');
    ax_cardy.XLabel.String = "1/x-1/x_c";
    ax_cardy.YLabel.String = "H";
    ax_cardy.Title.String = strcat("x_c = ",num2str(xc));
    ax_xc_x.Title.String = strcat("x_c = ",num2str(xc));
    colormap(ax_cardy,cmap);
    if showMeera
        scatter(ax_cardy,meeraHX,meeraHY*0.2,[],[0.7 0.7 0.7]);
    end
    
    %ax_cardy.XLim = [1e-3 1e4];
    %ax_cardy.YLim = [1e-9 1e2];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);
        my_phi_fudge = phi_fudge(ii);
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
        sigma = myData(:,2);
        eta = myData(:,4);
        delta_eta = myData(:,5);

        if colorBy == 1
            myColor = cmap(round(1+255*voltage/100),:);
        elseif colorBy == 2
            %myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        
        xWC = C(ii,jj)*f(sigma,jj);
        FWC = eta*(phi0-(phi+my_phi_fudge))^2;

        H = FWC .* xWC.^2;
        %H = 0;

        myMarker = my_vol_frac_markers(ii);
        if showLines && colorBy < 3
            % sort in order of ascending x
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
            H = H(sortIdx);
           
            plot(ax_collapse,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);

            if xc ~= 0
                plot(ax_xc_x,xc-xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
            end

        else
            scatter(ax_collapse,xWC,FWC,[],myColor,'filled',myMarker);
           
            if xc ~= 0
                scatter(ax_xc_x,xc-xWC,FWC,[],myColor,'filled',myMarker);
            end

        end

        
        if xc ~= 0
            scatter(ax_cardy, 1./xWC-1/xc,H,[],myColor,'filled',myMarker);
        end

        
        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end


% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

if showInterpolatingFunction
    % min value of X=1-x: 1-max(x)
    % max value of X=1-x: 1-min(x)
    % x=1-X
    x_fake = 1-logspace(log10(min(1-x_all)),log10(max(1-x_all)),1000);
    if fxnType == 1
        Fhat = eta0*(1-x_fake).^delta;
        Hhat = Fhat.*x_fake.^2;
    elseif fxnType == 2
        xi = 1./x_fake-1;
        logintersection = log(A/eta0)/(-delta-2);
        mediator = cosh(width*(log(xi)-logintersection));
        Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
        Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));
        Fhat = 1./x_fake.^2 .* Hhat;
    end

    plot(ax_collapse,x_fake,Fhat,'-k','LineWidth',1)
    plot(ax_xc_x,1-x_fake,Fhat,'-k','LineWidth',1)
    plot(ax_cardy,1./x_fake-1,Hhat,'-k','LineWidth',1)
end

c1 = colorbar(ax_collapse);
if colorBy == 1
    caxis(ax_collapse,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
elseif colorBy == 2
    caxis(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list+phi_fudge';
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_collapse,[1.6988,6])
end

if xc ~= 0
    c2 = colorbar(ax_xc_x);
    %c3 = colorbar(ax_cardy);

    if colorBy == 1
        caxis(ax_xc_x,[0 100]);
        c2.Ticks = [0,5,10,20,40,60,80,100];
    elseif colorBy == 2
        caxis(ax_xc_x,[minPhi maxPhi]);
        c2.Ticks = phi_list+phi_fudge';
    elseif colorBy == 4
        % TODO what are these numbers? lol
        caxis(ax_xc_x,[1.6988,6])
    end

end

if xc ~=0
    %close(fig_cardy)
    close(fig_xc_x)
end
close(fig_collapse)

figure(gcf)

%return
% eta0 = 0.0298;
% delta = -1;
% A = 0.3;
% width = 2;


%x_fake = logspace(log10(min(x_all)),log10(max(x_all)),10000);
%xi = 1./x_fake-1/xc;
xi = logspace(-3,3,1000);

%logintersection = log(A/eta0)/(-delta-2);
%c = 1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0);
%mediator = cosh(width*(log(xi)-logintersection));
%Hhat = exp(c) * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

xi0 = (A/eta0)^(1/(-2-delta));
mediator = 2*cosh(width*log(xi/xi0));
Hhat = sqrt(A*eta0) * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));


if delta==-2
    Hhat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

plot(ax_cardy,xi,xi.^(delta)*A,'LineWidth',1)
plot(ax_cardy,xi,xi.^(-2)*eta0,'LineWidth',1)
plot(ax_cardy,xi,Hhat,'r-','LineWidth',2);
%plot(ax_cardy,xi,mediator,'k-','LineWidth',1)
%xline(exp(logintersection))
xline(xi0);
ylim([1e-7 10])
xlim([1e-3 1e3])


%x_fake = 1./(xi+1);
%Fhat = Hhat.*(xi+1).^2;
%plot(ax_collapse,x_fake,Fhat,'r-','LineWidth',2);
%plot(ax_xc_x,1-x_fake,Fhat,'r-','LineWidth',2);