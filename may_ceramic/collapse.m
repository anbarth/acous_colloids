my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];

vol_frac_plotting_range = 13:-1:1;
volt_plotting_range = 4;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showMeera = false;

xc=1;
%xc = 0;

%collapse_params; phi_fudge = zeros(1,13);
%load("y_optimal_06_26.mat"); [eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,13); phi_fudge = zeros(1,13); 
%load("y_optimal_simultaneous_fudge_06_26.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13);
%load("y_optimal_post_fudge_06_26.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13);
%load("y_optimal_crossover_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(y_optimal,13); phi_fudge = zeros(1,13); 
%load("y_optimal_crossover_simultaneous_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13);
%load("y_optimal_crossover_post_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13);
%load("y_optimal_crossover_delta2_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(y_optimal,13); phi_fudge = zeros(1,13); 
%load("y_optimal_crossover_delta2_simultaneous_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13);
load("y_optimal_crossover_delta2_post_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13);


f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);


stressTable = may_ceramic_06_25;
phi_list = unique(stressTable(:,1));
minPhi = 0.17;
maxPhi = 0.62;
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = turbo;
if colorBy == 2 || colorBy == 4
    cmap = viridis(256); 
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
ax_collapse.XLim = [10^-2, 2];
%ax1.YLim = [10^(-1.5),100]; %TODO delete
colormap(ax_collapse,cmap);
if xc ~= 0
    xline(ax_collapse,xc);
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
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            %myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);

        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        %xWC = C(ii,jj)*f(sigma,jj) ./ (-1*phi+phi0);
        xWC = C(ii,jj)*f(sigma,jj);
        %xWC = f(sigma,jj)./(phi0-(phi+my_phi_fudge));
        %xWC = C(phi,voltage)*f(sigma,jj) ./ (-1*phi+phi0);
        
        FWC = eta*(phi0-(phi+my_phi_fudge))^2;

        H = eta.*((phi0-(phi+my_phi_fudge))*C(ii,jj).*f(sigma,jj)).^2;
        %H = 0;

        myMarker = my_vol_frac_markers(ii);
        if showLines && colorBy < 3
            % sort in order of ascending x
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
            %disp('y axis is not really F right now')
            %plot(ax_collapse,xWC,log(log(100*FWC)),strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
            
            plot(ax_collapse,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);

            if xc ~= 0
                plot(ax_xc_x,xc-xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
            end

        else
            scatter(ax_collapse,xWC,FWC,[],myColor,'filled',myMarker);
            %disp('y axis is not really F right now')
            %scatter(ax_collapse,xWC,log(log(100*FWC)),[],myColor,'filled',myMarker);
            %scatter(ax_collapse,xWC/meeraMultiplier_X,FWC/meeraMultiplier_Y,[],myColor,'filled','o','MarkerEdgeColor','w');

            if xc ~= 0
                scatter(ax_xc_x,xc-xWC,FWC,[],myColor,'filled',myMarker);
            end

        end
        %errorbar(ax_collapse,xWC,FWC,delta_eta*(phi0-phi)^2,'.','Color',myColor);

        %hold(meeraAx,'on');
        %scatter(meeraAx,xWC,FWC,[],myColor,'filled',myMarker);
        
        if xc ~= 0
            
            scatter(ax_cardy, abs(1/xc-1./xWC),H,[],myColor,'filled',myMarker);
        end

        
        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

c1 = colorbar(ax_collapse);
if colorBy == 1
    caxis(ax_collapse,[0 80]);
    c1.Ticks = [0,5,10,20,40,60,80];
elseif colorBy == 2
    caxis(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list+phi_fudge';
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_collapse,[1.6988,6])
end

if xc ~= 0
    c2 = colorbar(ax_xc_x);
    colorbar(ax_cardy);

    if colorBy == 1
        caxis(ax_xc_x,[0 80]);
        c2.Ticks = [0,5,10,20,40,60,80];
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
    %close(fig_xc_x)
end
%close(fig_collapse)

figure(gcf)