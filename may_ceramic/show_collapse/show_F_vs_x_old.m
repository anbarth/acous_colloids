function show_F_vs_x(stressTable,paramsVector,varargin)

my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];

vol_frac_plotting_range = 13:-1:1;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
showMeera = false;
showInterpolatingFunction = false;
showErrorBars = false;

for ii=1:2:length(varargin)
    if isa(varargin{ii},'char')
        fieldName = varargin{ii};
        if strcmp(fieldName,'PhiRange')
            vol_frac_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'VoltRange')
            volt_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'ColorBy')
            colorBy = varargin{ii+1};
        elseif strcmp(fieldName,'ShowLines')
            showLines = varargin{ii+1};
        elseif strcmp(fieldName,'ShowInterpolatingFunction')
            showInterpolatingFunction = varargin{ii+1};
        elseif strcmp(fieldName,'ShowErrorBars')
            showErrorBars = varargin{ii+1};
        end
    end
end



[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13); fxnType = 2;

f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);
%C =  C.*repmat(linspace(1,0.95,7),13,1);

phi_list = unique(stressTable(:,1));
minPhi = 0.17;
maxPhi = 0.62;
volt_list = [0,5,10,20,40,60,80];
[minP, maxP] = get_P_range(stressTable);
maxP = 10^5;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%ax_collapse.XLim = [10^-7, 2];
colormap(ax_collapse,cmap);

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
        %delta_eta = myData(:,5);
        delta_eta = max(myData(:,5),eta*0.05);
        delta_phi = 0.01;
        P = getP(phi,sigma,voltage,stressTable);

        %mySigmaStar = 0.2812+P*0.00005;
        %mySigmaStar = 0.2812;
        %mySigmaStar = 0.2812+P*0.0001;
        %myF = exp(-mySigmaStar./sigma);
        %x = C(ii,jj)*myF;

        x = C(ii,jj)*f(sigma,jj);
        F = eta*(phi0-(phi+my_phi_fudge))^2;

        delta_F = F .* (eta.^(-2).*delta_eta.^2 + 4/(phi0-(phi+my_phi_fudge))^2*delta_phi^2 ).^(1/2);

        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            %myColor = log(P);
            P_color = P;
            P_color(P_color==0) = minP;
            P_color(P_color>maxP) = maxP;
            myColor = cmap(round(1+255*(log(P_color)-log(minP))/(log(maxP)-log(minP))),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end        

        % sort in order of ascending x
        [x,sortIdx] = sort(x,'ascend');
        F = F(sortIdx);
        myMarker = my_vol_frac_markers(ii);
        if colorBy < 3
           if showLines
               myMarker = strcat(myMarker,'-');
           end
           if showErrorBars
               errorbar(ax_collapse,x,F,delta_F,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           else
                plot(ax_collapse,x,F,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           end
        else
            scatter(ax_collapse,x,F,[],myColor,'filled',myMarker);
        end
            
        if any(F<0)
            disp([ii jj])
        end

        x_all(end+1:end+length(x)) = x;
        F_all(end+1:end+length(F)) = F;
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
    x_fake_higher = 1-logspace(log10(min(1-x_all)),log10(max(1-x_all)),1000);
    x_fake_lower = logspace(log10(min(x_all)),log10(max(x_all)));
    x_fake = [x_fake_lower,x_fake_higher];
    x_fake = sort(x_fake);
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

    plot(ax_collapse,x_fake,Fhat,'-r','LineWidth',2)

end

c1 = colorbar(ax_collapse);
if colorBy == 1
    clim(ax_collapse,[0 80]);
    c1.Ticks = [0,5,10,20,40,60,80];
elseif colorBy == 2
    clim(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list+phi_fudge';
elseif colorBy == 3
    clim(ax_collapse,[minP maxP]);
%elseif colorBy == 4
    %clim(ax_collapse,[1.6988,6]) % ????
end


end