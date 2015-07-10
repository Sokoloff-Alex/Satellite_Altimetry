% Make ArtificialDataSetCheck

clear all; close all; clc

DataPool = SetGlobalVariables;
addpath /UnitTests

Cycle = 110;
CycleRecords = struct2array(load([DataPool,'\Jason-1\Data\jason-1_',num2str(Cycle),'.mat']));
CycleRecFiltered_IN = struct2array(load([DataPool,'Jason-1\DataFiltered\jason-1_',num2str(Cycle),'_filtered.mat']));

CycleRecFiltered_IN(:,21) = 1;
CycleRecFiltered_IN(:,22) = 2;
CycleRecFiltered_IN(:,23) = 3;

ArtificialDataSet = CycleRecFiltered_IN;

global DataPool;
DataPool = SetGlobalVariables;
DataPool  = [DataPool ,'Test']
SatelliteName = 'Jason-1';

Cycle = '000';
mkdir([DataPool,'\',SatelliteName,'\DataFiltered\'])
ArtificialDataSetPath = [DataPool,'\',SatelliteName,'\DataFiltered\',SatelliteName,'_',num2str(Cycle),'_filtered.mat'];
save(ArtificialDataSetPath,'ArtificialDataSet');

longSize = 1;
latSize  = 1;  
factor = 1.6;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
%% Interpolation

[Grid,CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Cycle,longSize, latSize, factor); 

%%

addpath /UnitTests
DataPool = SetGlobalVariables;
DataPool  = [DataPool ,'Test']
Test_meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);

%%
addpath /UnitTests
Test_WeightedGrid(1, CounterMatrix, DistanceMatrix, Cycle, textLegend);     

TimeInterpolation = toc;



rmpath /UnitTests