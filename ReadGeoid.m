% read geoid grid

FileID = fopen('..\..\EGM2008Geoid\egm2008_15x15.grid','r');

LatSize = length(-90:0.25:90);
LonSize = length(0:0.25:360);
GEOID_Matrix = zeros(LatSize, LonSize);

fclose(FileID);