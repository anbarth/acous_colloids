function show_collapse_helper(option,stressTable,paramsVector,modelHandle,varargin)
% option:
% 0 = F vs x
% 1 = F vs xc-x
% 2 = jardy
% 3 = eta*g^2/alpha

my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">"];

phi_list = unique(stressTable(:,1));
%phi_list = [0.1999 0.2503 0.2997 0.3500 0.4009 0.4396 0.4604 0.4811 0.5193 0.5398 0.5607 0.5898 0.6101]';
vol_frac_plotting_range = length(phi_list):-1:1;
volt_plotting_range = 1:7;
highlight_stress = 0;
colorBy = 1; % 1 for V, 2 for phi, 3 for E0, 4 for stress, 5 for pressure (chris simulations)
showLines = false;
showMeera = false;
showInterpolatingFunction = false;
showErrorBars = false;
alpha=-1;

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
        elseif strcmp(fieldName,'HighlightStress')
            highlight_stress = varargin{ii+1};
        elseif strcmp(fieldName,'VolFracMarkers')
            my_vol_frac_markers = varargin{ii+1};
        elseif strcmp(fieldName,'Alpha')
            alpha = varargin{ii+1};
        end
    end
end

if option==3 && alpha==-1
    disp('Cannot make this plot without alpha')
    return
end

minPhi = min(phi_list);
maxPhi = max(phi_list);
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%% make the figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4 || colorBy == 5
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');
if option == 0
    ax_collapse.XLabel.String = "x";
    ax_collapse.YLabel.String = "F";
elseif option==1
    ax_collapse.XLabel.String = "x_x-c";
    ax_collapse.YLabel.String = "F";
elseif option==2
    ax_collapse.XLabel.String = "1/x-1/x_c";
    ax_collapse.YLabel.String = "H";
elseif option==3
    ax_collapse.XLabel.String = "1/x^{1/\alpha}-1/x_c^{1/\alpha}";
    ax_collapse.YLabel.String = "\eta (B(\phi)f(\sigma))^{2/\alpha}";
end

if showMeera
    meeraMultiplier_X = 1/13.8;
    meeraMultiplier_Y = 3;
    [meeraX,meeraY]=stealMeerasData();
    scatter(ax_collapse,meeraX*meeraMultiplier_X,meeraY*meeraMultiplier_Y,[],[0.5 0.5 0.5]);
end
%ax_collapse.XLim = [10^-3, 1.5];
%ax_collapse.XLim = [10^-8, 1.5];
%ax_collapse.YLim = [0.4,110];
colormap(ax_collapse,cmap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all,F_hat_all,eta_all,~,~] = modelHandle(stressTable, paramsVector);

if colorBy==3
    logMinE0 = log(acoustic_energy_density(5));
    logMaxE0 = log(acoustic_energy_density(80));
end

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);

        myData = stressTable(:,1)==phi & stressTable(:,3)==voltage;
        x = x_all(myData);
        F = F_all(myData);
        eta = eta_all(myData);
        delta_F = delta_F_all(myData);


        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3  
            E0 = acoustic_energy_density(voltage);
            if E0==0
                myColor = [0 0 0];
            else
                myColor = cmap(round(1+255*(log(E0)-logMinE0)/( logMaxE0-logMinE0 )),:);
            end
        elseif colorBy == 4
            myColor = log(sigma);
        elseif colorBy == 5
            myColor = log(stressTable(myData,6));
        end        

        % sort in order of ascending x
        [x,sortIdx] = sort(x,'ascend');
        F = F(sortIdx);
        eta = eta(sortIdx);
        delta_F = delta_F(sortIdx);
    
        x_axis_var = 0;
        if option==0
            x_axis_var = x;
        elseif option==1
            x_axis_var = 1-x;
        elseif option==2
            x_axis_var = 1./x-1;
        elseif option==3
            x_axis_var = x.^(-1/alpha)-1;
        end

        y_axis_var=0;
        delta_y_axis_var=0;
        if option==0 || option==1
            y_axis_var=F;
            delta_y_axis_var=delta_F;
        elseif option==2
            y_axis_var=F.*x.^2;
            delta_y_axis_var=0;
        elseif option==3
            %dphi = sqrt(F./eta);
            %g=x.*(dphi).^alpha;
            %y_axis_var=eta.*g.^2;
            y_axis_var=F.*x.^(2/alpha);
            delta_y_axis_var=0;
        end
        
        if ~isempty(my_vol_frac_markers)
            myMarker = my_vol_frac_markers(ii);
        else
            myMarker = 'o';
        end
        if colorBy <= 3
           if showLines
               myMarker = strcat(myMarker,'-');
           end
           if showErrorBars
               errorbar(ax_collapse,x_axis_var,y_axis_var,delta_y_axis_var,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           else
                plot(ax_collapse,x_axis_var,y_axis_var,myMarker,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
           end
        else
            scatter(ax_collapse,x_axis_var,F,[],myColor,'filled',myMarker);
        end

        if highlight_stress
            myDataHighlight = stressTable(:,1)==phi & stressTable(:,3)==voltage & stressTable(:,2)==highlight_stress;
            xHighlight = x_axis_var(myDataHighlight);
            FHighlight = F_all(myDataHighlight);
            s=scatter(ax_collapse,xHighlight,FHighlight,'red','filled',myMarker);
            uistack(s,'bottom')
        end

    end
end

if highlight_stress
    for ii = vol_frac_plotting_range
        for jj = volt_plotting_range
    
            voltage = volt_list(jj);
            phi = phi_list(ii);
            
    
            myDataHighlight = stressTable(:,1)==phi & stressTable(:,3)==voltage & stressTable(:,2)==highlight_stress;
            xHighlight = x_all(myDataHighlight);
            FHighlight = F_all(myDataHighlight);

            x_axis_var = 0;
            if option==0
                x_axis_var = xHighlight;
            elseif option==1
                x_axis_var = 1-xHighlight;
            end
    
            if ~isempty(my_vol_frac_markers)
                myMarker = my_vol_frac_markers(ii);
            else
                myMarker = 'o';
            end
            
            scatter(ax_collapse,x_axis_var,FHighlight,'red','filled',myMarker);
            
        end
    end
end


if showInterpolatingFunction
    [x_all,sortIdx] = sort(x_all,'ascend');
    F_hat_all = F_hat_all(sortIdx);
    if option==0
        plot(ax_collapse,x_all,F_hat_all,'-r','LineWidth',1.5)
    elseif option==1
        plot(ax_collapse,1-x_all,F_hat_all,'-r','LineWidth',1.5)
    elseif option==2
        plot(ax_collapse,1./x_all-1,F_hat_all.*x_all.^2,'-r','LineWidth',2)
    elseif option==3
        plot(ax_collapse,x_all.^(-1/alpha)-1,F_hat_all.*x_all.^(2/alpha),'-r','LineWidth',2)
    end
end

c1 = colorbar(ax_collapse);
if colorBy == 1
    clim(ax_collapse,[0 80]);
    c1.Ticks = [0,5,10,20,40,60,80];
elseif colorBy == 2
    clim(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list;
    c1.Ticks = round(phi_list*100)/100;
elseif colorBy ==3
    clim(ax_collapse,[log(acoustic_energy_density(5)) log(acoustic_energy_density(80))])
    c1.Ticks = log(acoustic_energy_density([5 10 20 40 60 80]));
    c1.TickLabels = num2cell( round(acoustic_energy_density([5 10 20 40 60 80])*100)/100 );
end


end