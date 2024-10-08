function show_cardy(stressTable, paramsVector, varargin)



my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];

vol_frac_plotting_range = 13:-1:1;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showMeera = false;
showInterpolatingFunction = false;
showErrorBars = false;
alpha = 1;


for ii=1:2:length(varargin)
    if isa(varargin{ii},'char')
        fieldName = varargin{ii};
        if strcmp(fieldName,'PhiRange')
            vol_frac_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'VoltRange')
            volt_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'ColorBy')
            colorBy = varargin{ii+1};
        elseif strcmp(fieldName,'ShowInterpolatingFunction')
            showInterpolatingFunction = varargin{ii+1};
        elseif strcmp(fieldName,'ShowErrorBars')
            showErrorBars = varargin{ii+1};
        elseif strcmp(fieldName,'alpha')
            alpha = varargin{ii+1};
        end
    end
end

xc=1;
alpha_interpolate = alpha;
%alpha_interpolate = 1;

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13); fxnType = 2;


phi_list = unique(stressTable(:,1));
minPhi = 0.17;
maxPhi = 0.62;
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_cardy = figure;
ax_cardy = axes('Parent', fig_cardy,'XScale','log','YScale','log');
hold(ax_cardy,'on');
ax_cardy.XLabel.String = "1/x-1/x_c";
ax_cardy.YLabel.String = "H";
colormap(ax_cardy,cmap);
if showMeera
    scatter(ax_cardy,meeraHX,meeraHY*0.2,[],[0.7 0.7 0.7]);
end
ax_cardy.XLim = [10^-2, 10^4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all] = calc_x_F(stressTable,paramsVector);
P_all = getP(stressTable);
minP = min(P_all(P_all~=0));
%maxP = max(P_all);
maxP = 10^5;

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);
        my_phi_fudge = phi_fudge(ii);

        myData = stressTable(:,1)==phi & stressTable(:,3)==voltage;
        x = x_all(myData);
        F = F_all(myData);
        delta_F = delta_F_all(myData);
        H = F .* x.^(2/alpha);
        delta_H = delta_F .* x.^(2/alpha);
        x_axis_variable = x.^(-1/alpha)-xc^(-1/alpha);
        P = P_all(myData);


        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            P_color = P;
            P_color(P_color==0) = minP;
            P_color(P_color>maxP) = maxP;
            myColor = cmap(round(1+255*(log(P_color)-log(minP))/(log(maxP)-log(minP))),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        myMarker = my_vol_frac_markers(ii);

        if showErrorBars
            errorbar(ax_cardy,x_axis_variable,H,delta_H,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
        else
            scatter(ax_cardy, x_axis_variable,H,[],myColor,'filled',myMarker);
        end
        

    end
end




if showInterpolatingFunction
    % min value of X=1-x: 1-max(x)
    % max value of X=1-x: 1-min(x)
    % x=1-X
    x_fake = 1-logspace(log10(min(1-x_all)),log10(max(1-x_all)),1000);
    if fxnType == 1
        % deprecated bad naughty code
        Fhat = eta0*(1-x_fake).^delta;
        Hhat = Fhat.*x_fake.^2;
    elseif fxnType == 2
        xi = x_fake.^(-1/alpha_interpolate)-1;
        logintersection = log(A/eta0)/(-delta-2);
        mediator = cosh(width*(log(xi)-logintersection));
        Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
        Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));
    end

    plot(ax_cardy,x_fake.^(-1/alpha_interpolate)-1,Hhat,'-r','LineWidth',2)
end



end