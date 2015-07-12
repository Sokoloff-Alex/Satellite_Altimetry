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
% MapType = ['SSHAnomalyMap*.mat'];
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
% [GlobalTrendSlope_Weighted] = HarmomicAnalysis(GlobalTrendWeighted, timeVectorAll, MapType(1:end-8));
[GlobalTrendSlopeSmoothed_Weighted] = HarmomicAnalysis(GlalTrendSmWeighted3, timeVectorSmoothed, MapType(1:end-8));

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
fftAnalysis(timeVectorAll,      GlobalTrendWeighted,   0, 0.2)
% fftAnalysis(timeVectorSmoothed, GlobalTrendSmWeighted, 0, 0.2)

%%

GlobalTrendSmWeighted_2 = nansum(nansum(TrendMap.*(cosd(lat)'*ones(1,size(TrendMap,2))))) / (dim - sum(sum(isnan(TrendMap))));
GlobalTrendSmWeighted_2 = GlobalTrendSmWeighted_2 * 1000 * (Year/CyclePeriod) % units change [m/cycle] -> [mm/year]

%%

GlobalTrendSm_3 = nansum(nansum(TrendMapScaledFiltered)) / (dim - sum(sum(isnan(TrendMapScaledFiltered))))
GlobalTrendSmWeighted_3 = nansum(nansum(TrendMapScaledFiltered.*(cosd(lat)'*ones(1,size(TrendMapScaledFiltered,2))))) / (dim - sum(sum(isnan(TrendMapScaledFiltered))))

%% ok
makeIceMask(TrendMap)

% %%  Estimation of Trend FAST
% tic
% for row = 1:size(Map,1)
%     for column = 1:size(Map,2)
%         valuesAll = Matrix(row,column,:);
%         valuesAll = valuesAll(:);
% %         if sum(isnan(valuesAll)) < (size(valuesAll,1)) % Number of NaN's
%         NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100;
%         if NaNPercent <= NanPercentThreshold  % Number of NaN's
%             values = zeros(size(valuesAll,1),1);
%             timeVector = zeros(size(valuesAll,1),1);
%             counter = 0;
%             for index = 1:size(valuesAll);            
%                 if ~isnan(valuesAll(index)) 
%                     counter = counter + 1;
%                     values(counter,1) = valuesAll(index);
%                     timeVector(counter,1) = timeVectorAll(index);                    
%                 end
%             end
%             values = values(1:counter);
%             timeVector = timeVector(1:counter);
%             
%             %  === general trend === 
%             trend = (sum((timeVector - mean(timeVector)).*(values - mean(values))))/(sum((timeVector - mean(timeVector)).^2));
%             b = mean(values) - trend * mean(timeVector);
%             TrendMap(row,column) = trend;
%             %  ==============
%            
%             t0 = timeVector(1);
%             % General Trend 2
%             A = [ones(size(timeVector,1),1), (timeVector-t0)];
%             c = (A'*A)^-1*A'*values;
%             error = A*c-values;
%             M = size(timeVector,1);
%             N = 2;
%             variance1 = (error'*error)/(M-N);
% %           y = c(1)+c(2)*(timeVector-t0);
% 
%             % Annual trend
%             T1 = Year/CyclePeriod;
%             A2 = [ones(size(timeVector,1),1), (timeVector-t0), sin(2*pi/T1*(timeVector-t0)), cos(2*pi/T1*(timeVector-t0))];
%             c2 = (A2'*A2)^-1*A2'*values;
%             error2 = A2*c2-values;
%             variance2 = (error2'*error2)/(M-N);
% %           y2 = c2(1)+c2(2)*(timeVector-t0) + c2(3)*sin(2*pi/T1*(timeVector-t0)) + c2(4)*cos(2*pi/T1*(timeVector-t0));
% 
%             % semi-Annual
%             T2 = Year/CyclePeriod*0.5;
%             A3 = [ones(size(timeVector,1),1), (timeVector-t0), sin(2*pi/T1*(timeVector-t0)), cos(2*pi/T1*(timeVector-t0)), sin(2*pi/T2*(timeVector-t0)), cos(2*pi/T2*(timeVector-t0))];
%             c3= (A3'*A3)^-1*A3'*values;
%             error3 = A3*c3-values;
%             variance3 = (error3'*error3)/(M-N);
% %           y3 = c3(1)+c3(2)*(timeVector-t0) + c3(3)*sin(2*pi/T1*(timeVector-t0)) + c3(4)*cos(2*pi/T1*(timeVector-t0)) + c3(5)*sin(2*pi/T2*(timeVector-t0)) + c3(6)*cos(2*pi/T2*(timeVector-t0));
%     
%             [coeff] = HarmomicAnalysis(timeVector,values,'no');
% 
%             TrendMatrix(row,column,1:6) = c3;
%         else
%             TrendMap(row,column) = NaN;
%         end 
%     end
% end
% 
% timeEstimation = toc;
% disp(['Estimation time: ', num2str(timeEstimation), ' sec']);


%% filter
TrendMapScaledFiltered = TrendMap;
for row = 1:size(TrendMap,1)
    for column = 1:size(TrendMap,2)
        if abs(TrendMapScaledFiltered(row,column)) > 0.003%  filterThresold
            TrendMapScaledFiltered(row,column) = NaN;
        end    
    end
end

close all
figure(1)
subplot(1,2,1)
surf(flipud(TrendMap))
subplot(1,2,2)
surf(flipud(TrendMapScaledFiltered))


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
