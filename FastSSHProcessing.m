%% Parse and Filter 
clear all; close all; clc

DataPool = SetGlobalVariables;

%% Parsing and filtering
tic;                                                                      %  allowed flags: iflags    oflags    std  swh abs(ssh-mssh)
[CycleRecords, CycleRecFiltered_IN, CycleRecFiltered_OUT] = FastPreProcessing('Jason-1', '00000000','00000110', 0.2, 12.0, 2.0);
FastParseAndFiltertime = toc;
disp(['Fast PreProcessing time: ', num2str(FastParseAndFiltertime/60), ' min']);

%% Interpolation
close all; clear all; clc; tic;
longSize = 1;
latSize  = 1;  
factor = 1.6;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];
for Cycle = 205:220
    [Grid,CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Cycle,longSize, latSize, factor); 
%     meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);
%     WeightedGrid(1, CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend);     
end
TimeInterpolation = toc;

%%
close all
meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);


%%
longSize = 1;
latSize  = 1;  
factor = 1.6;
textLegend = ['Grid ',num2str(longSize), 'x',num2str(latSize),', factor ', num2str(factor)];

for Cycle = 110
    CounterMatrix = struct2array(load([DataPool,'\Jason-1\Processed\CounterMatrix_',num2str(Cycle),'.mat']));
    SSHMatrix = struct2array(load([DataPool,'\Jason-1\Processed\SSHMatrix_',num2str(Cycle),'.mat']));
    SSHAnomalyMatrix = struct2array(load([DataPool,'\Jason-1\Processed\SSHAnomalyMatrix_',num2str(Cycle),'.mat']));
    MDTMatrix = struct2array(load([DataPool,'\Jason-1\Processed\MDTMatrix_',num2str(Cycle),'.mat']));
    DistanceMatrix = struct2array(load([DataPool,'\Jason-1\Processed\DistanceMatrix_',num2str(Cycle),'.mat']));
    % CoordMatrix = struct2array(load([DataPool,'\Jason-1\Processed\CoordMatrix_',num2str(Cycle),'.mat']));
    meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend);
end

%%
Average1 = meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, Cycle, textLegend);

%%
Average2 = WeightedGrid(1, CounterMatrix, DistanceMatrix, SSHMatrix, Cycle, textLegend);     
Average3 = WeightedGrid(2, CounterMatrix, DistanceMatrix, SSHMatrix, Cycle, textLegend);     

%%
% diff = Average3-Average2;
figure
pcolor(flipud(Average1))
title('differenc b/w quadratic and mean weighting')
shading flat
% set(gcf, 'renderer', 'zbuffer');
h = colorbar;
xlabel(h,'SSH, [m]');

%% Trend Estimation
clear all; close all; clc
%          TrendEstimation(max%ofNaN, FilterTreshold)
TrendMap = TrendEstimation(50,0.01);

%% Load
Cycle = 110;
CounterMatrix = struct2array(load([DataPool,'\Jason-1\Processed\CounterMatrix_',num2str(Cycle),'.mat']));
SSHMatrix = struct2array(load([DataPool,'\Jason-1\Processed\ValuesMatrix_',num2str(Cycle),'.mat']));
DistanceMatrix = struct2array(load([DataPool,'\Jason-1\Processed\DistanceMatrix_',num2str(Cycle),'.mat']));
% CoordMatrix = struct2array(load([DataPool,'\Jason-1\Processed\CoordMatrix_',num2str(Cycle),'.mat']));

%% difference in weighting
close all
textLegend = ['Grid 2x2, factor 1.6'];
Average1 = meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, Cycle, textLegend);
Average2 = WeightedGrid(1, CounterMatrix, DistanceMatrix, SSHMatrix, Cycle, textLegend);
AveDiff = Average2 - Average1;
figure(1)
pcolor(flipud(AveDiff))

%% Load
Cycle = 110;
CycleRecords = struct2array(load([DataPool,'Jason-1\Data\jason-1_',num2str(Cycle),'.mat']));
CycleRecFiltered_IN = struct2array(load([DataPool,'Jason-1\DataFiltered\jason-1_',num2str(Cycle),'_filtered.mat']));

%% Plot Ground tracks
figure(1)
hold on;
BackgroundImage = imread([DataPool,'Results\map.jpg']);
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
