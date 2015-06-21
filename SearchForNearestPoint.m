function[IndexLat, IndexLong, Lat_deg, Long_deg] =  SearchForNearestPoint(LatGrid, LongGrid, Point)
% Searches indexes for nearest ?eference ?oint on Grid 
% given by LatGrid and LongGrid vectors 
% for arbitrarz given Point(Lat, Long)  
% by Alexandr Sokolov

% Search in Latitude

minLatVector = abs(LatGrid' - ones(size(LatGrid))'*Point(1));
[MinLatValue, IndexLat] = min(minLatVector);
Lat_deg = LatGrid(IndexLat);

% Search in Latitude
minLongVector = abs(LongGrid' - ones(size(LongGrid))'*Point(2));
[MinLongValue, IndexLong] = min(minLongVector);
Long_deg = LongGrid(IndexLong);

end
