function [minP, maxP] = get_P_range(dataTable)
    minP = Inf;
    maxP = 0;

    for kk = 1:size(dataTable,1)
        phi = dataTable(kk,1);
        sigma = dataTable(kk,2);
        voltage = dataTable(kk,3);
        if voltage == 0
            continue
        end
        P = getP(phi,sigma,voltage,dataTable);
        if P < minP
            minP = P;
        end
        if P > maxP
            maxP = P;
        end
    end

end