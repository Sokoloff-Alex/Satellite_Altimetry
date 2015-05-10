% Apllied Computer Science
% Satellite Altimetry
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

clear all
clc

tic;
% Read data from all satellite files and merge the data
% [AllRecordsEnvsat] = ParseSatData('Envisat');
[AllRecordsJason1] = ParseSatData('Jason-1');
ParsingTime= toc
%%
tic
SatFilter('Jason-1',0,0);
fclose all;
filteredTime = toc;

%%
CurrentDir = cd;
figure(2);
hold on;
% Set background image
BackgroundImageFilePath = [CurrentDir,'\','map.jpg'];
BackgroundImage = imread(BackgroundImageFilePath);
imagesc([-180 180], [-90 90], flipdim(BackgroundImage,1));
set(gca,'ydir','normal');
% Plot data
% plot (AllRecordsEnvsat(:,3)-180',AllRecordsEnvsat(:,2)', '.r', 'LineWidth', 2);
plot (AllRecordsJason1(:,3)-180' ,AllRecordsJason1(:,2)',  '.g', 'Markersize', 1);
plot (tujason1(:,3)-180' ,tujason1(:,2)',  '.r', 'Markersize', 1);

title('Jason-1 GroundTrack / cycle #110')
% Set limits for the axis
xlimits = [-180 180];
set(gca,'XLim', xlimits);
ylimits = [-90 90];
set(gca,'YLim', ylimits);
hold off;

