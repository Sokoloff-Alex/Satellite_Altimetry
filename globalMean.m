function[GlobalTrendSmWeighted] = globalMean(Matrix)
% and globalmean values for each cycle and strore into vector


LatGrid = (size(Matrix,1)-1)/2;
LatSize= (size(Matrix,1)) / (LatGrid*2+1);
lat = [-LatGrid:LatSize:LatGrid];

GlobalTrendSmWeighted = zeros(size(Matrix,3),1);
dim = size(Matrix,1)*size(Matrix,2);

    for index = 1:size(Matrix,3)
        Map = Matrix(:,:,index);
        GlobalTrendSmWeighted(index) = nansum(nansum(Map.*(cosd(lat)'*ones(1,size(Map,2))))) / (dim - sum(sum(isnan(Map))));
    end

end