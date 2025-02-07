function grad = myGradient(funHandle,evalPt)

grad = zeros(size(evalPt));
%epsilon = eps;
epsilon = max(funHandle(evalPt)*0.0001,eps);
for ii=1:length(evalPt)
    ptPlus = evalPt;
    ptPlus(ii) = ptPlus(ii)+epsilon;
    ptMinus = evalPt;
    ptMinus(ii) = ptMinus(ii)-epsilon;
    grad(ii) = (funHandle(ptPlus)-funHandle(ptMinus))/(2*epsilon);
end

end