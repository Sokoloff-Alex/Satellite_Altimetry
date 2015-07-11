% Make ArtificialDataSetCheck

clear all; close all; clc

try
cd UnitTests 
catch
end
run ..\SetGlobalVariables
DataPool = ans;
clear ans;


Cycle = 110;
CycleRecords = struct2array(load([DataPool,'Jason-1\Data\jason-1_',num2str(Cycle),'.mat']));
CycleRecFiltered_IN = struct2array(load([DataPool,'Jason-1\DataFiltered\jason-1_',num2str(Cycle),'_filtered.mat']));

NewSSH = 1;
NewSSHAnomaly = 2;
NewMDT = 3;

CycleRecFiltered_IN(:,21) = NewSSH;
CycleRecFiltered_IN(:,22) = NewSSHAnomaly;
CycleRecFiltered_IN(:,23) = NewMDT;

ArtificialDataSet = CycleRecFiltered_IN;

DataPool  = [DataPool ,'Test\']
SatelliteName = 'Jason-1';

Cycle = '000';
mkdir([DataPool,'\',SatelliteName,'\DataFiltered\'])
mkdir([DataPool,'\',SatelliteName,'\Products']);
mkdir([DataPool,'\',SatelliteName,'\Prosecced']);
mkdir([DataPool,'\','\Results\MapsFinal\']);
ArtificialDataSetPath = [DataPool,'\',SatelliteName,'\DataFiltered\',SatelliteName,'_',num2str(Cycle),'_filtered.mat'];
save(ArtificialDataSetPath,'ArtificialDataSet');
Data = struct2array(load([DataPool,'\Jason-1\DataFiltered\Jason-1_',num2str(Cycle),'_filtered.mat'])); 
disp('Artificial DataSet prepared')
%% Interpolation
% cd ../
try
    longSize = 1;
    latSize  = 1;  
    factor = 1.6;
    textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
        
    [Grid,CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Data,longSize, latSize, factor, [21 22 23]); 
catch
    disp('Error in InterpolationFast')
end
cd UnitTests
%%

[SSHMap, SSHAnomalyMap, MDTMap] = Test_meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);
disp('Check meanGrig function')

SSHMap_mean = nanmean(nanmean(SSHMap));
SSHAnomalyMap_mean = nanmean(nanmean(SSHAnomalyMap));
MDTMap_mean = nanmean(nanmean(MDTMap));

if SSHMap_mean ~= NewSSH || SSHAnomalyMap_mean ~= NewSSHAnomaly || MDTMap_mean ~= NewMDT
    disp('Error: InterpolationFast and meanGrid intorduce bias');
else
    disp('InterpolationFast and meanGrid passes test with Artificial dataset');
end

%% to do:

[SSHWeight] = Test_WeightedGrid(1, CounterMatrix, DistanceMatrix, Cycle, textLegend);     

disp('Check WeightedGrid function')

SSHMap_mean = nanmean(nanmean(SSHMap));
SSHAnomalyMap_mean = nanmean(nanmean(SSHAnomalyMap));
MDTMap_mean = nanmean(nanmean(MDTMap));

if SSHMap_mean ~= NewSSH || SSHAnomalyMap_mean ~= NewSSHAnomaly || MDTMap_mean ~= NewMDT
    disp('Error: InterpolationFast and WeightedGrid intorduce bias');
else
    disp('InterpolationFast and meanGrid passes test with Artificial dataset');
end


