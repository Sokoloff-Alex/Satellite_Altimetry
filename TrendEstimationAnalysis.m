% function[TrendMap] = TrendEstimationAnalysis(NanPercentThreshold ,filterThresold)
%% Trend Estimation Analysis on Time series
%  by Alexanr Sokolov
clear all, close all, clc
tic

NanPercentThreshold = 50;
filterThresold = 0.01;
Year = 365.25; % days
CyclePeriod = 9.9156; % days

tic;
disp('Estimating Global Trend');
SatelliteDataMapsPath = ['Jason-1\Results'];
ListOfCycles = ls (SatelliteDataMapsPath);
ListOfCycles = ListOfCycles(3:end-4,:)
NumberOfCycles = size(ListOfCycles,1)

Map = struct2array(load([SatelliteDataMapsPath,'\',ListOfCycles(1,:)]));


lat = -70:2:70;
% load single 3D array
Matrix = zeros(size(Map,1),size(Map,2),NumberOfCycles);
TrendMap = zeros(size(Map,1),size(Map,2));
TrendMatrix = NaN(size(Map,1),size(Map,2),17);
timeVectorAll = zeros(NumberOfCycles,1);
GlobalTrend = zeros(NumberOfCycles,1);
GlobalTrendWeighted = zeros(NumberOfCycles,1);
dim = size(TrendMap,1)*size(TrendMap,2);


for index = 1:NumberOfCycles
    FileName = [SatelliteDataMapsPath,'\',ListOfCycles(index,:)];
    Map = struct2array(load(FileName));
%     Map = index /1000 *ones(size(Map1,1),size(Map1,2));
    Matrix(:,:,index) = Map;
    timeVectorAll(index) = str2double(ListOfCycles(index,5:7));
    timeVectorAll = timeVectorAll';
    GlobalTrend(index) = nansum(nansum(Map)) / (dim - sum(sum(isnan(Map))));
    GlobalTrendWeighted(index) = nansum(nansum(Map.*(cosd(lat)'*ones(1,size(Map,2))))) / (dim - sum(sum(isnan(Map))));
    
end

% smothing
SmothingSize = 7; %   7 cycles within 60 days
MatrixSmoothed = zeros(size(Matrix,1),size(Matrix,2),(size(Matrix,3)-SmothingSize+1)); % smoothing of 60 days
GlobalTrendSm = zeros((size(Matrix,3)-SmothingSize+1),1);
GlobalTrendSmWeighted = zeros((size(Matrix,3)-SmothingSize+1),1);

for index = 1:((size(Matrix,3)-SmothingSize)+1)
    MatrixWindow = Matrix(:,:,index:(index+SmothingSize-1)); 
    MapSmoothed = nanmean(MatrixWindow,3);
    MatrixSmoothed(:,:,index) = MapSmoothed;
    GlobalTrendSm(index) = nansum(nansum(MapSmoothed)) / (dim - sum(sum(isnan(MapSmoothed))));
    GlobalTrendSmWeighted(index) = nansum(nansum(MapSmoothed.*(cosd(lat)'*ones(1,size(MapSmoothed,2))))) / (dim - sum(sum(isnan(MapSmoothed))));
end
timeVectorSmoothed = timeVectorAll(4:end-3);

%% Global Trend
[GlobalTrendSlopeSmoothed_Weighted] = HarmomicAnalysis(timeVectorSmoothed, GlobalTrendSmWeighted,'Global');

%% FFT ok
% fftAnalysis(x,                y,         fmin, fmax)
fftAnalysis(timeVectorAll,      GlobalTrend,           0, 0.2)
fftAnalysis(timeVectorSmoothed, GlobalTrendSm,         0, 0.2)
fftAnalysis(timeVectorAll,      GlobalTrendWeighted,   0, 0.2)
fftAnalysis(timeVectorSmoothed, GlobalTrendSmWeighted, 0, 0.2)

%%  Estimation of Trend FAST
tic
for row = 1:size(Map,1)
    for column = 1:size(Map,2)
        valuesAll = MatrixSmoothed(row,column,:);
        valuesAll = valuesAll(:);
        alert = max(isnan(valuesAll));
        NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100;
        if NaNPercent == 0 % Number of NaN's
            values = zeros(size(valuesAll,1),1);
            timeVector = zeros(size(valuesAll,1),1);
            counter = 0;
            for index = 1:size(valuesAll);            
                if ~isnan(valuesAll(index)) 
                    counter = counter + 1;
                    values(counter,1) = valuesAll(index);
                    timeVector(counter,1) = timeVectorAll(index);                    
                end
            end
            values = values(1:counter);
            timeVector = timeVector(1:counter);
            [coeff] = HarmomicAnalysis(timeVector,values,'no');
            TrendMatrix(row,column,:) = coeff;
        else
            TrendMap(row,column) = NaN;
        end 
    end
end

timeEstimation = toc;
disp(['Estimation time: ', num2str(timeEstimation), ' sec']);


%%  Estimation of Trend FAST
tic
for row = 1:size(Map,1)
    for column = 1:size(Map,2)
        valuesAll = Matrix(row,column,:);
        valuesAll = valuesAll(:);
%         if sum(isnan(valuesAll)) < (size(valuesAll,1)) % Number of NaN's
        NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100;
        if NaNPercent <= NanPercentThreshold  % Number of NaN's
            values = zeros(size(valuesAll,1),1);
            timeVector = zeros(size(valuesAll,1),1);
            counter = 0;
            for index = 1:size(valuesAll);            
                if ~isnan(valuesAll(index)) 
                    counter = counter + 1;
                    values(counter,1) = valuesAll(index);
                    timeVector(counter,1) = timeVectorAll(index);                    
                end
            end
            values = values(1:counter);
            timeVector = timeVector(1:counter);
            
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
            [coeff] = HarmomicAnalysis(timeVector,values,'no');

            TrendMatrix(row,column,:) = coeff;
        else
            TrendMap(row,column) = NaN;
        end 
    end
end

timeEstimation = toc;
disp(['Estimation time: ', num2str(timeEstimation), ' sec']);


%% filter
TrendMap3 = TrendMap;
for row = 1:size(TrendMap,1)
    for column = 1:size(TrendMap,2)
        if abs(TrendMap3(row,column)) > 0.003%  filterThresold
            TrendMap3(row,column) = NaN;
        end    
    end
end

close all
figure(1)
subplot(1,2,1)
surf(flipud(TrendMap))
subplot(1,2,2)
surf(flipud(TrendMap3))


%% Plot arbitrary samples
close all; clc

% 60 days smoothing
valuesAll = Matrix(20,125,:);
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
    HarmomicAnalysis(timeVector, values);
end 