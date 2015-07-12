function[MatrixSmoothed, timeVectorSmoothed] = makeSmooth(Matrix, timeVectorAll,SmoothingWindow)
% smothing of stack between cycles within SmoothingWindow


LatGrid = (size(Matrix,1)-1)/2;
LatSize= (size(Matrix,1)) / (LatGrid*2+1);
lat = [-LatGrid:LatSize:LatGrid];

dim = size(Matrix,1)*size(Matrix,2);

% SmoothingWindow = 7; %   7 cycles within 60 days
MatrixSmoothed = zeros(size(Matrix,1),size(Matrix,2),(size(Matrix,3)-SmoothingWindow+1)); % smoothing of 60 days

for index = 1:((size(Matrix,3)-SmoothingWindow)+1)
    MatrixWindow = Matrix(:,:,index:(index+SmoothingWindow-1)); 
    MapSmoothed = nanmean(MatrixWindow,3);
    MatrixSmoothed(:,:,index) = MapSmoothed;
end
timeVectorSmoothed = timeVectorAll(4:end-3);

end