function params_out = logsome(params_in,varargin)

params_out = params_in;

% the extra inputs are indices for params that should be logged
for ii=1:length(varargin)
    paramNum = varargin{ii};
    params_out(paramNum) = log(params_in(paramNum));
end

end