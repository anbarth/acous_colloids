function show_cardy(stressTable, paramsVector, varargin)

my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];

vol_frac_plotting_range = 13:-1:1;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showMeera = false;
showInterpolatingFunction = false;

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
        end
    end
end

xc=1;

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13); fxnType = 2;

f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);

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
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        x = C(ii,jj)*f(sigma,jj);
        F = eta*(phi0-(phi+my_phi_fudge))^2;
        H = F .* x.^2;


        myMarker = my_vol_frac_markers(ii);

        scatter(ax_cardy, 1./x-1/xc,H,[],myColor,'filled',myMarker);
        
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
    end

    plot(ax_cardy,1./x_fake-1,Hhat,'-r','LineWidth',2)
end



end