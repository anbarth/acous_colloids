function [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCon(yRestricted,constraints)

y = mergeParamsAndConstraints(yRestricted,constraints);
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y,length(phi_list));

end