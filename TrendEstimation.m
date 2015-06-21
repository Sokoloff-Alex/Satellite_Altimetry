function[TrendMap] = TrendEstimation(NanPercentThreshold ,filterThresold)
%%  by Alexanr Sokolov

tic;
disp('Estimating Global Trend');
SatelliteDataMapsPath = ['Jason-1\Results'];
ListOfCycles = ls (SatelliteDataMapsPath);
ListOfCycles = ListOfCycles(3:end-4,:)
NumberOfCycles = size(ListOfCycles,1)

Map1 = struct2array(load([SatelliteDataMapsPath,'\',ListOfCycles(1,:)]));
size(Map1);

% load single 3D array
Matrix = zeros(size(Map1,1),size(Map1,2),NumberOfCycles);
TrendMap = zeros(size(Map1,1),size(Map1,2));
timeVectorAll = zeros(NumberOfCycles,1);

for index = 1:NumberOfCycles
    FileName = [SatelliteDataMapsPath,'\',ListOfCycles(index,:)];
    Matrix(:,:,index) = struct2array(load(FileName));
    timeVectorAll(index) = str2double(ListOfCycles(index,5:7));
    timeVectorAll = timeVectorAll';
end

%  Estimation of Trend FAST
for row = 1:size(Map1,1)
    for column = 1:size(Map1,2)
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
            trend = (sum((timeVector - mean(timeVector)).*(values - mean(values))))/(sum((timeVector - mean(timeVector)).^2));
            TrendMap(row,column) = trend;
        else
            TrendMap(row,column) = NaN;
        end 
    end
end

% filter
TrendMap2 = TrendMap;
for row = 1:size(TrendMap,1)
    for column = 1:size(TrendMap,2)
        if abs(TrendMap2(row,column)) > filterThresold
            TrendMap2(row,column) = NaN;
        end    
    end
end
    
%
close all
figure(1)
subplot(2,2,1)
surf(flipud(TrendMap))
subplot(2,2,2)
surf(flipud(TrendMap2))

% figure(2)
subplot(2,2,3)
pcolor(flipud(TrendMap))
subplot(2,2,4)
pcolor(flipud(TrendMap2))

%% Plot samples

% valuesAll = Matrix(30,100,:);
% valuesAll = valuesAll(:);
% NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100; % NaN's percent
% if NaNPercent <= NanPercentThreshold  % Number of NaN's
%     values = zeros(size(valuesAll,1),1);
%     timeVector = zeros(size(valuesAll,1),1);
%     counter = 0;
%     for index = 1:size(valuesAll);            
%         if ~isnan(valuesAll(index)) 
%             counter = counter + 1;
%             values(counter,1) = valuesAll(index);
%             timeVector(counter,1) = timeVectorAll(index);                    
%         end
%     end
%     values = values(1:counter);
%     timeVector = timeVector(1:counter);
%     trend = (sum((timeVector - mean(timeVector)).*(values - mean(values))))/(sum((timeVector - mean(timeVector)).^2));
%     b = mean(values) - trend * mean(timeVector);
% end 
% 
% figure(2)
% hold on
% plot(timeVector,values,'.-b')
% plot(timeVector,timeVector*trend + b,'r')
% legend('data','trend')
% xlabel('Cycle')
% ylabel('value, [m]')

end



