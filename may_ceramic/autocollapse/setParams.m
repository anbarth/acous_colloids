function y_out = setParams(y_in, numPhi, varargin)

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_in,numPhi);
for ii=1:2:length(varargin)
    if isa(varargin{ii},'char')
        fieldName = varargin{ii};
        if strcmp(fieldName,'eta0')
            eta0 = varargin{ii+1};
        elseif strcmp(fieldName,'phi0')
            phi0 = varargin{ii+1};
        elseif strcmp(fieldName,'delta')
            delta = varargin{ii+1};
        elseif strcmp(fieldName,'A')
            A = varargin{ii+1};
        elseif strcmp(fieldName,'width')
            width = varargin{ii+1};
        elseif strcmp(fieldName,'sigmastar')
            sigmastar = varargin{ii+1};
        elseif strcmp(fieldName,'C')
            C = varargin{ii+1};
        elseif strcmp(fieldName,'phi_fudge')
            phi_fudge = varargin{ii+1};
        end
    end
end
y_out = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

end