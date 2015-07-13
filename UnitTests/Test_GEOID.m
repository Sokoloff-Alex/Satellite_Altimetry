% Test_GEOID 
% Compare intrpolated Geoid (EGM2008) 
% with Geoid from files (from arbitrary cycle)
%
% by Sokolov Alexandr, 2015

clear all; close all; clc;

cd(['D:\TUM\Semester 2\Projects in Earth Oriented Space Science and Technology\Project\Project\Satellite_Altimetry\UnitTests']);

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

% GeoidModel = struct2array(load([GeoidModelPath,'geoid']));     % full model
GeoidModel = struct2array(load([GeoidModelPath,'geoid_cut'])); % reduced by +- 66 deg
clear GeoidModelPath;
range = 1: size(GeoidModel,1);
Data = [zeros(length(range),1) GeoidModel(range,2) GeoidModel(range,1) GeoidModel(range,3)];
disp('Geoid Data Prepared')

%%

Cycle = 999;
tic;
cd ..
longSize = 1;
latSize  = 1;  
factor = 0.8;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
disp('Start Iterpolating Geoid_Model_2008')
[Grid,CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Data,longSize, latSize, factor, [4 4 4]); 
save([DataPool,'Test\Jason-1\Processed\CounterMatrix_',num2str(Cycle),'.mat'],'CounterMatrix');
save([DataPool,'Test\Jason-1\Processed\DistanceMatrix_',num2str(Cycle),'.mat'],'DistanceMatrix');
save([DataPool,'Test\Jason-1\Processed\SSHMatrix_',num2str(Cycle),'.mat'],'SSHMatrix');

timeOut = toc
disp('Interpolation finished')
cd UnitTests
%%


disp('Start making intermolation map');

[SSHMap, SSHAnomalyMap, MDTMap] = Test_meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);

disp('Done')





