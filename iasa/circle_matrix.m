function myMat = circle_matrix(Nx,Ny,R)

myMat = zeros(Nx,Ny);
for ii=1:Nx
    for jj=1:Ny
        if (ii-(Nx+1)/2)^2 + (jj-(Ny+1)/2)^2 < R^2
            myMat(ii,jj)=1;
        end
    end
end


end