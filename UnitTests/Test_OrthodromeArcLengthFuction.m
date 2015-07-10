%% ckeck fastest angular distance function
clear all

addpath /UnitTests

Point1 = [35 45];
Point2 = [35 135];

tic
[D1] = distance(Point1, Point2);
t1 = toc; tic
[B1] = azimuth(Point1, Point2);
t2 = toc
disp(['D1: ', num2str(D1),'; B1: ', num2str(B1),'; ,t1 = ', num2str(t1),'; t2 = ', num2str(t2)]);
tic;
[D2 B2] = OrthodromeArcLength(Point1, Point2);
t3 = toc;
disp(['D2: ', num2str(D2),'; B2: ', num2str(B2),'; ,t3 = ', num2str(t3)]);
tic;

if (D1 == D2 && B2 == B2)
   disp('ok') 
end

rmpath /UnitTests
