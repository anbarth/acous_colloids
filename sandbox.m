%V = [5,10,20,40,60,80,100];
% V = [100];
% rheoData = phi48_08_29.sig90_100V;
% stress = 90;
% 
% for ii = 1:length(V)
%     myV = V(ii);
%     clean_data_09_03 = fillDataTable(clean_data_09_03,acousticTimeTable,rheoData,0.48,myV,stress);
% end

fn=fieldnames(phi48_08_29);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi48_08_29.(fn{i});
    myRheoData.phi = 0.48;
    phi48_08_29.(fn{i}) = myRheoData;
end