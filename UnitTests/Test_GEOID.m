% Test_GEOID 
% Compare intrpolated Geoid (EGM2008) 
% with Geoid from files (from arbitrary cycle)
%
% by Sokolov Alexandr, 2015

clear all; close all; clc;

try 
    cd Satellite_Altimetry\UnitTests\
catch
end


try
    cd ..
    DataPool = SetGlobalVariables;
    cd UnitTests
catch
    DataPool = SetGlobalVariables;
end

GeoidModelPath = [DataPool,'EGM2008Geoid\']
GeoidModel = struct2array(load([GeoidModelPath,'geoid']));
clear GeoidModelPath;
lim = 5000;
Data = [zeros(lim,1) GeoidModel(1:lim,2) GeoidModel(1:lim,1) GeoidModel(1:lim,3)];
disp('Geoid Data Prepared')

%%

cd ..
longSize = 1;
latSize  = 1;  
factor = 1.6;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
disp('Start Iterposating Geoid_Model_2008')
[Grid,CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Data,longSize, latSize, factor, [4 4 4]); 
disp('Interpolation finished')
%%

Cycle = 999;
disp('Start making intermolation map');

[SSHMap, SSHAnomalyMap, MDTMap] = meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);

disp('Done')





