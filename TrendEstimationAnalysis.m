% function[TrendMap] = TrendEstimationAnalysis(NanPercentThreshold ,filterThresold)
%% Trend Estimation Analysis on Time series
%  by Alexanr Sokolov
clear all, close all, clc
tic

DataPool = SetGlobalVariables;

NanPercentThreshold = 0; % 0% removing ice; 100% keep icy regions
filterThresold = 0.01;
Year = 365.25; % days
CyclePeriod = 9.9156; % days

tic;
disp('Estimating Global Trend');
SatelliteDataMapsPath = [DataPool,'Jason-1\Products']; 
MapType = ['SSHMap*.mat'];
% MapType = ['MDTMap*.mat'];
%  MapType = ['SSHAnomalyMap*.mat'];
ListOfCycles = ls ([SatelliteDataMapsPath,'\',MapType])
NumberOfCycles = size(ListOfCycles,1)

Map = struct2array(load([SatelliteDataMapsPath,'\',ListOfCycles(1,:)]));

lat = -70:1:70;
% load single 3D array
Matrix = zeros(size(Map,1),size(Map,2),NumberOfCycles);
TrendMap = zeros(size(Map,1),size(Map,2));
TrendMatrix = NaN(size(Map,1),size(Map,2),12);
timeVectorAll = zeros(NumberOfCycles,1);
GlobalTrend = zeros(NumberOfCycles,1);
GlobalTrendWeighted = zeros(NumberOfCycles,1);
dim = size(TrendMap,1)*size(TrendMap,2);


for index = 1:NumberOfCycles
    FileName = [SatelliteDataMapsPath,'\',ListOfCycles(index,:)];
    Map = struct2array(load(FileName));
%     Map = index /1000 *ones(size(Map1,1),size(Map1,2));
    Matrix(:,:,index) = Map;
    timeVectorAll(index) = str2double(ListOfCycles(index,end-6:end-4));
    timeVectorAll = timeVectorAll';
    GlobalTrend(index) = nansum(nansum(Map)) / (dim - sum(sum(isnan(Map))));
    GlobalTrendWeighted(index) = nansum(nansum(Map.*(cosd(lat)'*ones(1,size(Map,2))))) / (dim - sum(sum(isnan(Map))));
end

% 60 days smoothing, Compute global mean for each cycle and Estimate trend
[MatrixSmoothed, timeVectorSmoothed] = makeSmooth(Matrix, timeVectorAll,7);
GlalTrendSmWeighted3 = globalMean(MatrixSmoothed);

%%[GlobalTrendSlope_Weighted] = HarmomicAnalysis(GlobalTrendWeighted, timeVectorAll, MapType(1:end-8));

%% Trend from global mean value
[GlobalTrendSlopeSmoothed_Weighted1] = HarmomicAnalysis(GlalTrendSmWeighted3, timeVectorSmoothed, MapType(1:end-8));

%% Make Trend Map                             
[TrendMap, TrendMapScaled] = makeTrendMap(MatrixSmoothed, timeVectorAll, NanPercentThreshold, MapType);

%% Apply Ice Mask
IceMask = makeIceMask(TrendMap);

% apply IseMask to Matrix of DataStack 
[MatrixSmoothed] = maskFilter(MatrixSmoothed, IceMask);

% calc new global mean
GlalTrendSmWeighted4 = globalMean(MatrixSmoothed);

% Global Trend without Icy regions
[GlobalTrendSlopeSmoothed_Weighted] = HarmomicAnalysis(GlalTrendSmWeighted4, timeVectorSmoothed, MapType(1:end-8));

%% FFT ok
% % fftAnalysis(x,                y,                   fmin, fmax)
% fftAnalysis(timeVectorAll,      GlobalTrend,           0, 0.2)
% fftAnalysis(timeVectorSmoothed, GlobalTrendSm,         0, 0.2)
% fftAnalysis(timeVectorAll,      GlobalTrendWeighted,   0, 0.2)
% fftAnalysis(timeVectorSmoothed, GlobalTrendSmWeighted, 0, 0.2)

%% Sum Up TrendMap into scalar => Global Trend

GlobalTrendSmWeighted_2 = nansum(nansum(TrendMap.*(cosd(lat)'*ones(1,size(TrendMap,2))))) / (dim - sum(sum(isnan(TrendMap))));
GlobalTrendSmWeighted_2 = GlobalTrendSmWeighted_2 * 1000 * (Year/CyclePeriod) % units change [m/cycle] -> [mm/year]


%% Plot arbitrary samples
close all; clc

% comvert coordinates [deg] into indexis on gridMapMatrix

Lat = 40;
Long = 200;
CooridatesOfPoint = ['Lat ',num2str(Lat),' , Long ', num2str(Long),];
disp(CooridatesOfPoint)

iLong = round((Long/360)*size(Matrix,2));
iLat = round((Lat+70)/140*size(Matrix,1));


% 60 days smoothing
valuesAll = Matrix(iLat,iLong,:);
valuesAll = valuesAll(:);
NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100; % NaN's percent

SmothingSize = 7; %   7 cycles within 60 days
valuesSmoothed = zeros((size(valuesAll,1)-SmothingSize),1); % smoothing of 60 days

for i = 1:(size(valuesAll,1)-SmothingSize)+1
    window = valuesAll(i:i+SmothingSize-1); 
    valuesSmoothed(i) = nanmean(window);
end

% Calc Trend
if NaNPercent <= NanPercentThreshold  % Number of NaN's
    values = zeros(size(valuesSmoothed,1),1);
    timeVector = zeros(size(valuesSmoothed,1),1);
    counter = 0;
    for index = 1:size(valuesSmoothed);            
        if ~isnan(valuesSmoothed(index)) 
            counter = counter + 1;
            values(counter,1) = valuesSmoothed(index);
            timeVector(counter,1) = timeVectorAll(index);                    
        end
    end
    values = values(1:counter);
    timeVector = timeVector(1:counter);
    HarmomicAnalysis(timeVector, values,CooridatesOfPoint);
end 
