function total_cost = bhattaCostFunction(dataTable, paramsVector, modelHandle)

phi_list = unique(dataTable(:,1));
vol_frac_range = 1:length(phi_list);
volt_list = [0 5 10 20 40 60 80];
volt_range = 1;
makePlot = false;

[x_all,F_all,delta_F_all,~,~,~,~] = modelHandle(dataTable, paramsVector);

curves = {};
for pp = vol_frac_range
    for qq = volt_range
        voltage = volt_list(qq);
        phi = phi_list(pp);

        myData = dataTable(:,1)==phi & dataTable(:,3)==voltage;
        x = x_all(myData);
        F = F_all(myData);
        delta_F = delta_F_all(myData);

        curves{end+1} = [x,F,delta_F];
    end
end

%disp(size(curves))

Nover = 0;
total_cost = 0;
for pp=1:length(curves)
    curve_p = curves{pp};
    x_p = curve_p(:,1);
    F_p = curve_p(:,2);
    %delta_F_p = curve_p(:,3);
    [x_p,sortIdx] = sort(x_p);
    F_p = F_p(sortIdx);
    %delta_F_p = delta_F_p(sortIdx);
    interpolating_curve_p = @(x) myInterpolateX(x,x_p,F_p);

    for qq=1:length(curves)
        if pp==qq; continue; end
        
        curve_q = curves{qq};
        x_q = curve_q(:,1);
        F_q = curve_q(:,2);
        delta_F_q = curve_q(:,3);

        for ii=1:length(x_q)
            interpolated_F = interpolating_curve_p(x_q(ii));
            % returns nan for non-overlapping points
            if isnan(interpolated_F); continue; end
            cost = abs(F_q(ii)-interpolated_F)/delta_F_q(ii);
            %disp(cost)
            total_cost = total_cost+cost;
            Nover = Nover+1;
        end

        if pp==10 && qq==12 && makePlot
            figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
            plot(x_p,F_p,'k-o');
            plot(x_q,F_q,'ro');
            for ii=1:length(x_q)
                interpolated_F = interpolating_curve_p(x_q(ii));
                % returns nan for non-overlapping points
                if isnan(interpolated_F); continue; end
                plot(x_q(ii),interpolated_F,'bo');
            end
        end

    end
end

total_cost = total_cost/Nover;

end
