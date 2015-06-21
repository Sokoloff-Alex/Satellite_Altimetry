function[ArcLength, azim] = OrthodromeArcLength(Point1, Point2)
% Length of Arc on the orthodrome and bearing (initial azimuth) at Point 1
% Indut angles in degrees, output in degrees
% by Alexandr sokolov

lat1  = deg2rad(Point1(1));
lon1 = deg2rad(Point1(2));
lat2  = deg2rad(Point2(1));
lon2 = deg2rad(Point2(2));

ArcLength = acosd(sin(lat1).*sin(lat2) + cos(lat1).*cos(lat2).*cos(lon2-lon1));

azim = atan2d(cos(lat2) .* sin(lon2-lon1),...
           cos(lat1) .* sin(lat2) - sin(lat1) .* cos(lat2) .* cos(lon2-lon1));

% Azimuths are undefined at the poles, so we choose a convention: zero at
% the north pole and pi at the south pole.

azim(lat1 <= -90) = 0;
azim(lat2 >=  90) = 0;
azim(lat2 <= -90) = pi;
azim(lat1 >=  90) = pi;

end