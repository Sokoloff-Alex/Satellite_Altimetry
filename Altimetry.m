% Apllied Computer Science
% Satellite Altimetry
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

% clear all
% clc

% Read data from all satellite files and merge the data
[AllRecordsEnvsat] = readSat('envisat');
[AllRecordsJason] = readSat('jason');

%%
figure(1)
hold on
plot(AllRecordsEnvsat(:,3),AllRecordsEnvsat(:,2),'.b')
plot(AllRecordsJason(:,3),AllRecordsJason(:,2),'.r')
hold off


%%
CurrentDir = cd;
figure(2);
hold on;
% Set background image
BackgroundImageFilePath = [CurrentDir,'\','1200px-Equirectangular_projection_SW.jpg'];
BackgroundImage = imread(BackgroundImageFilePath);
imagesc([-180 180], [-90 90], flipdim(BackgroundImage,1));
set(gca,'ydir','normal');
% Plot data
plot (AllRecordsEnvsat(:,3)-180',AllRecordsEnvsat(:,2)', '.r', 'LineWidth', 2);
plot (AllRecordsJason(:,3)-180' ,AllRecordsJason(:,2)',  '.g', 'LineWidth', 2);
% Set limits for the axis
xlimits = [-180 180];
set(gca,'XLim', xlimits);
ylimits = [-90 90];
set(gca,'YLim', ylimits);
hold off;

