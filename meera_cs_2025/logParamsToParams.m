function paramsVector = logParamsToParams(logParamsVector,varargin)

paramsVector = exp(logParamsVector);

% the extra inputs are indices for negative params
for ii=1:length(varargin)
    paramNum = varargin{ii};
    paramsVector(paramNum) = -1*paramsVector(paramNum);
end
end