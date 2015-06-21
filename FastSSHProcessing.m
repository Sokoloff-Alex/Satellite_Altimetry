%% Parse and Filter 
clear all; close all; clc

%% Parsing and filtering
tic;                                                                      %  allowed flags: iflags    oflags    std  swh abs(ssh-mssh)
[CycleRecords, CycleRecFiltered_IN, CycleRecFiltered_OUT] = FastPreProcessing('Jason-1', '00000000','00000110', 0.2, 12.0, 2.0);
FastParseAndFiltertime = toc;
disp(['Fast PreProcessing time: ', num2str(FastParseAndFiltertime/60), ' min']);

%% Interpolation
close all; clear all; clc; tic;
longSize = 2;
latSize  = 2;  
factor = 1.6;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
for Cycle = 112
    [Grid,CounterMatrix, DistanceMatrix, ValuesMatrix] = InterpolationFast(Cycle,longSize, latSize, factor); 
    Average = meanGrid(CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);
%     Average = WeightedGrid(2, CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);     
end
TimeInterpolation = toc;

%%
Average1 = meanGrid(CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);

%%
Average2 = WeightedGrid(2, CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);     


%% Trend Estimation
clear all; close all; clc
%          TrendEstimation(max%ofNaN, FilterTreshold)
TrendMap = TrendEstimation(50,0.01);

%% Load
Cycle = 112;
CounterMatrix = struct2array(load(['Jason-1\Processed\CounterMatrix_',num2str(Cycle),'.mat']));
ValuesMatrix = struct2array(load(['Jason-1\Processed\ValuesMatrix_',num2str(Cycle),'.mat']));
DistanceMatrix = struct2array(load(['Jason-1\Processed\DistanceMatrix_',num2str(Cycle),'.mat']));
% CoordMatrix = struct2array(load(['Jason-1\Processed\CoordMatrix_',num2str(Cycle),'.mat']));

%% difference in weighting
close all
textLegend = ['Grid 2x2, factor 1.6'];
Average1 = meanGrid(CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);
Average2 = WeightedGrid(1, CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);
AveDiff = Average2 - Average1;
figure(1)
pcolor(flipud(AveDiff))

%% Load
Cycle = 110;
CycleRecords = struct2array(load(['Jason-1\Data\jason-1_',num2str(Cycle),'.mat']));
CycleRecFiltered_IN = struct2array(load(['Jason-1\DataFiltered\jason-1_',num2str(Cycle),'_filtered.mat']));

%% Plot Ground tracks
figure(1)
hold on;
BackgroundImage = imread('Results\map.jpg');
imagesc([180 360+180], [-90 90], flipdim(BackgroundImage,1)); % Right half
imagesc([-180 180],    [-90 90], flipdim(BackgroundImage,1)); % Left half
set(gca,'ydir','normal');
plot (CycleRecords(:,3)',        CycleRecords(:,2)',        '.g', 'Markersize', 1);
plot (CycleRecFiltered_IN(:,3)' ,CycleRecFiltered_IN(:,2)', '.b', 'Markersize', 1);
% plot (CycleRecFiltered_OUT(:,3)',CycleRecFiltered_OUT(:,2)','.r', 'Markersize', 1);
title('Jason-1 GroundTrack / cycle #110')
legend('green Satellite Track','blue - ocean','red - filtered out');
set(gca,'XLim', [0  360]);
set(gca,'YLim', [-90 90]);
hold off;
