function params_out = unlogsome(params_in,varargin)

params_out = params_in;

% the extra inputs are indices for params that should be un-logged
for ii=1:length(varargin)
    paramNum = varargin{ii};
    params_out(paramNum) = exp(params_in(paramNum));
end

end