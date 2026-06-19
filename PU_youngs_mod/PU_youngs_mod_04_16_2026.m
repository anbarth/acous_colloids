samples = {big_bones.sample_1,big_bones.sample_2,big_bones.sample_3,...
    big_bones.sample_4,...
    small_bones.sample_1,...
    ... small_bones.sample_2,... % this one didn't break
    small_bones.sample_3,small_bones.sample_4,...
    small_bones.sample_5};

%% plot samples individually
E = zeros(size(samples));
for ii = 1:length(samples)
    figure; hold on; title(ii)
    sample = samples{ii};
    stress = sample.data(:,2)/(sample.dims(1)*sample.dims(2)*1e-6);
    strain = sample.data(:,3)/sample.dims(3);
    plot(strain,stress,'o')
    ylabel('stress (Pa)')
    xlabel('strain (1)')
    cutoff_strain = 5e-3;
    %lower_cutoff_strain=0.3e-3;
    lower_cutoff_strain=0;
    p = polyfit(strain(strain<cutoff_strain & strain>lower_cutoff_strain), stress(strain<cutoff_strain & strain>lower_cutoff_strain),1);
    plot(strain,p(1)*strain+p(2));
    % stress = p(1)*strain + p(2)
    E(ii) = p(1);
end

E_avg = mean(E);
E_err = std(E)/sqrt(length(E));
disp([E_avg E_err])

%% plot all together
figure; hold on; prettyplot;
ylabel('stress (Pa)')
xlabel('strain (1)')
for ii = 1:length(samples)
    sample = samples{ii};
    stress = sample.data(:,2)/(sample.dims(1)*sample.dims(2)*1e-6);
    strain = sample.data(:,3)/sample.dims(3);
    plot(strain,stress,'-')
end