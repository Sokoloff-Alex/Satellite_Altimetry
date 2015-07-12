function[MatrixFiltered] = maskFilter(Matrix, Mask)
% filter Matrix by using Mask

    if size(Matrix,1) == size(Mask,1) || size(Matrix,2) == size(Mask,2)
    MatrixFiltered = Matrix;
        for index = 1:size(Matrix,3)
            MatrixFiltered(:,:,index) = Matrix(:,:,index).*Mask;
        end
    else
       disp('Matrix and Mask have different size'); 
    end
end