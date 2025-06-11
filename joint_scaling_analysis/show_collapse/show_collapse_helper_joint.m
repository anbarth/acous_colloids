function show_collapse_helper_joint(option,stressTable,paramsVector,modelHandle,varargin)
% option:
% 0 = F vs x
% 1 = F vs xc-x
% 2 = J vs 1/x-1/xc
% 3 = actual cardy (requires alpha)

numMaterials = length(unique(stressTable(:,6)));
mat_plotting_range = 1:numMaterials;
colorBy = 2; % 2 for phi, 4 for stress
showLines = false;
showInterpolatingFunction = false;
showErrorBars = false;
alpha = -1;

for ii=1:2:length(varargin)
    if isa(varargin{ii},'char')
        fieldName = varargin{ii};
        if strcmp(fieldName,'MaterialRange')
            mat_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'ColorBy')
            colorBy = varargin{ii+1};
        elseif strcmp(fieldName,'ShowLines')
            showLines = varargin{ii+1};
        elseif strcmp(fieldName,'ShowInterpolatingFunction')
            showInterpolatingFunction = varargin{ii+1};
        elseif strcmp(fieldName,'ShowErrorBars')
            showErrorBars = varargin{ii+1};
        elseif strcmp(fieldName,'Alpha')
            alpha = varargin{ii+1};
        end
    end
end



%%%%%%%%%%%%%%%%%% make the figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');

if option==0
    ax_collapse.XLabel.String = "x";
    ax_collapse.YLabel.String = "F/F_0";
    %xlim([1e-5 1.5])
elseif option==1
    ax_collapse.XLabel.String = "x_c-x";
    ax_collapse.YLabel.String = "F/F_0";
elseif option==2
    ax_collapse.XLabel.String = "1/x-1/x_c";
    ax_collapse.YLabel.String = "x^2*F/F_0";
    xlim([1e-3 1e5])
elseif option==3
    ax_collapse.XLabel.String = "x^{-1/\alpha}-x_c^{-1/\alpha}";
    ax_collapse.YLabel.String = "\eta(B_\alpha(\phi)f(\sigma))^{2/\alpha}/F_0";
    %xlim([1e-3 1e5])
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all,F_hat_all,~,~,~] = modelHandle(stressTable, paramsVector);

% fill in material row if it doesnt exist
if size(stressTable,2)==5
    stressTable = [stressTable, 1*ones(size(stressTable,1),1)];
end

% plot each material
for mm = mat_plotting_range

    if mm==1
        myMarker = 's';
    elseif mm==2
        myMarker = 'd';
    elseif mm==3
        myMarker = 'o';
    end
    if showLines && colorBy < 3
       myMarker = strcat(myMarker,'-');
   end

    myMaterialData = stressTable(:,6)==mm;
    phi_list = unique(stressTable(myMaterialData,1));
    vol_frac_plotting_range = length(phi_list):-1:1;

    if colorBy == 2 % volume fraction
        if mm==1
            %cmap = flipud(viridis(256)); 
            cmap = jet(256);
        elseif mm==2
            cmap = flipud(silica(256));
        elseif mm==3
            %cmap = jet(256);
            cmap = viridis(256);
        end
    elseif colorBy == 4 % stress
        cmap = winter(256);
    else % other
        cmap = plasma(256);
    end

    colormap(ax_collapse,cmap);
    minPhi = min(phi_list);
    maxPhi = max(phi_list);

    for ii = vol_frac_plotting_range

        phi = phi_list(ii);

        myData = stressTable(:,1)==phi & stressTable(:,6)==mm;
        x = x_all(myData);
        F = F_all(myData);
        delta_F = delta_F_all(myData);


        if colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end        

        % sort in order of ascending x
        [x,sortIdx] = sort(x,'ascend');
        F = F(sortIdx);
        delta_F = delta_F(sortIdx);
    
        x_axis_var = 0;
        y_axis_var = 0;
        y_axis_delta = 0;
        if option==0
            x_axis_var = x;
            y_axis_var = F;
            y_axis_delta = delta_F;
        elseif option==1
            x_axis_var = 1-x;
            y_axis_var = F;
            y_axis_delta = delta_F;
        elseif option==2
            x_axis_var = 1./x-1;
            y_axis_var = x.^2.*F;
            y_axis_delta = 0;
        elseif option==3
            x_axis_var = x.^(-1/alpha)-1;
            y_axis_var = x.^(2/alpha).*F;
            y_axis_delta = 0;
        end
        
        

        if colorBy <= 3
           if showErrorBars
               errorbar(ax_collapse,x_axis_var,y_axis_var,y_axis_delta,myMarker,'Color',myColor,'LineWidth',1);
           else
               plot(ax_collapse,x_axis_var,y_axis_var,myMarker,'Color',myColor,'LineWidth',1);
           end
        else
            scatter(ax_collapse,x_axis_var,y_axis_var,[],myColor,'filled',myMarker);
        end



    end


c1 = colorbar(ax_collapse);
if colorBy == 2
    
    clim(ax_collapse,[minPhi maxPhi]);
    %c1.Ticks = phi_list;
    %c1.Ticks = round(phi_list*100)/100;

end


end

if showInterpolatingFunction
    [x_all,sortIdx] = sort(x_all,'ascend');
    F_hat_all = F_hat_all(sortIdx);
    if option==0
        plot(ax_collapse,x_all,F_hat_all,'-r','LineWidth',1)
    elseif option==1
        plot(ax_collapse,1-x_all,F_hat_all,'-r','LineWidth',1)
    elseif option==2
        plot(ax_collapse,1./x_all-1,x_all.^2.*F_hat_all,'-r','LineWidth',1)
    elseif option==3
        plot(ax_collapse,x_all.^(-1/alpha)-1,x_all.^(2/alpha).*F_hat_all/10,'-r','LineWidth',1)
    end
end

end