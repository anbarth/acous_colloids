function eta_list = averageEtaBetweenTimeMarkers(rheoStruct)

t_markers = rheoStruct.t_markers;

eta_list = -1*ones(length(t_markers)-1,1);
for i=1:length(t_markers)-1
    tStart = t_markers(i)+0.5;
    tEnd = t_markers(i+1);
    eta_list(i) = averageEtaInterval(rheoStruct,tStart,tEnd);
end

end