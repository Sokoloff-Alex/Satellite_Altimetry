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
SSHMaps = ['\SSHMap*.mat'];
SSHAnomalyMaps = ['\SSHAnomalyMap*.mat'];
MDTMaps = ['\MDTMap*.mat'];
ListOfCycles = ls ([SatelliteDataMapsPath,SSHAnomalyMaps]);
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
%%
figure
pcolor(flipud(Matrix(:,:,1)))
shading flat
set(gcf, 'renderer', 'zbuffer');
h = colorbar;
caxis([-0.5 0.5 ])
xlabel(h,'SSH Anomaly, [m]');

%% Animation

figure(1); hold on
for index = 1:NumberOfCycles-6
%     subplot(2,1,1)
    pcolor(flipud(MatrixSmoothed(:,:,index)))
    shading flat
    set(gcf, 'renderer', 'zbuffer')
    h = colorbar;
    caxis([-0.5 0.5])
    xlabel(h,'SSH Anomaly, [m]');
    title(index+NumberOfCycles(1))
    
%     subplot(2,1,2)
%     pcolor(flipud(MatrixSmoothed(:,:,index))) 
%     shading flat
%     set(gcf, 'renderer', 'zbuffer');
%     h = colorbar;
%     caxis([-0.7 0.9])
%     xlabel(h,'SSH Anomaly, [m]');
%     title('Smoothing, 60 days')
    pause(0.1);     
end


%% Animation 2

for index = 1:NumberOfCycles %NumberOfCycles
    pcolor(flipud(Matrix(:,:,index)))
    shading flat
    set(gcf, 'renderer', 'zbuffer');
    h = colorbar;
    caxis([-0.8 0.8])
    title(index+NumberOfCycles(1))
    % Store the frame
    pause(0.1)
    M(index)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end

movie2avi(M,[DataPool,'\Results/Animations/WaveMovie.avi'],'compression', 'none');
%% Animation 3

fig = figure(1)
set(gcf,'PaperPositionMode','auto')
set(fig, 'Position', [0 0 1900 1000])
filename = [DataPool,'\Results/Animations/SSH_Anomaly_Smoothed.gif]';
set(gcf, 'renderer', 'zbuffer');

for index = 1:NumberOfCycles-6 
    pcolor(flipud(MatrixSmoothed(:,:,index)))
    h = colorbar;
    shading flat
    caxis([-0.8 0.8])
    xlabel(h,'SSH Anomaly, [m]');
    title(['SSH Anomaly Map, smoothed, cycle ',num2str(index+NumberOfCycles(1)),', no weighting'])
    pause(0.1)
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if index == 1;
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
      imwrite(imind,cm,filename,'gif','WriteMode','append');
end
end
