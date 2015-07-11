%% Trend Estimation Analysis on Time series
%  by Alexanr Sokolov
clear all, close all, clc
tic

DataPool = SetGlobalVariables;

NanPercentThreshold = 50;
filterThresold = 0.01;
Year = 365.25; % days
CyclePeriod = 9.9156; % days

tic;
disp('Estimating Global Trend');
SatelliteDataMapsPath = [DataPool,'\Jason-1\Products'];
% DataMap = ['\SSHMap*.mat'];
DataMap = ['\SSHAnomalyMap*.mat'];
% DataMap = ['\MDTMap*.mat'];
ListOfCycles = ls ([SatelliteDataMapsPath,DataMap]);
ListOfCycles = ListOfCycles(1:end,:)
NumberOfCycles = size(ListOfCycles,1)

Map = struct2array(load([SatelliteDataMapsPath,'\',ListOfCycles(1,:)]));


lat = -70:2:70;
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
    Matrix(:,:,index) = Map;
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
end


%% Animation

figure(1); hold on
for index = 1:2 %NumberOfCycles-6
    pcolor(flipud(MatrixSmoothed(:,:,index)))
    shading flat
    set(gcf, 'renderer', 'zbuffer')
    h = colorbar;
    caxis([-105 85]) % for SSH
%     caxis([-0.5 0.5]) % for SSHAmomaly
%     caxis([-2 2]) % for MDT
    xlabel(h,'SSH , [m]');
    title(index+NumberOfCycles(1))
    ax = gca;
    xlabel('Longitude, [deg]')
    set(ax,'XTick',     [0:30:360])
    ylabel('Latitude, [deg]')    
    set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
    set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
    xlim([0 360])
    ylim([4 141-4])
end



%% Animation 

fig = figure(1);
set(gcf,'PaperPositionMode','auto')
set(fig, 'Position', [0 0 1900 1000])
filename1 = [DataPool,'\Results/Animations/slow/SSH_Anomaly_Map_smoothed_2fps.gif'];
filename2 = [DataPool,'\Results/Animations/SSH_Anomaly_Map_smoothed.gif'];
filename3 = [DataPool,'\Results/Animations/Fast/SSH_Anomaly_Map_smoothed_25fps.gif'];
set(gcf, 'renderer', 'zbuffer');

for index = 1:NumberOfCycles
    pcolor(flipud(MatrixSmoothed(:,:,index)))
    h = colorbar;
    shading flat
%     caxis([-105 85])  % for SSH
    caxis([-0.8 0.8]) % for SSHAmomaly
%     caxis([-2 2])     % for MDT
    xlabel(h,'[m]');
    title(['SSH Anomaly Map, smoothed, cycle ',num2str(index+NumberOfCycles(1)),', no weighting'])
    ax = gca;
    xlabel('Longitude, [deg]')
    set(ax,'XTick',  [0:30:360])
    ylabel('Latitude, [deg]')    
    set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
    set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
    xlim([0 360])
    ylim([4 141-4])
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if index == 1;
      imwrite(imind,cm,filename1,'gif', 'DelayTime',1/2, 'Loopcount', inf);
      imwrite(imind,cm,filename2,'gif', 'DelayTime',1/10,'Loopcount', inf);
      imwrite(imind,cm,filename3,'gif', 'DelayTime',1/25,'Loopcount', inf);
    else
      imwrite(imind,cm,filename1,'gif', 'DelayTime',1/2,  'WriteMode', 'append');
      imwrite(imind,cm,filename2,'gif', 'DelayTime',1/10, 'WriteMode', 'append');
      imwrite(imind,cm,filename3,'gif', 'DelayTime',1/25, 'WriteMode', 'append');
    end
end


