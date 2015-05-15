% Apllied Computer Science
% Satellite Altimetry
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

tic;
% Read data from all satellite files and merge the data
% [AllRecordsEnvsat] = ParseSatData('Envisat');
[AllRecordsJason1] = ParseSatData('Jason-1');
save('Jason-1/AllRecordsJason1.mat','AllRecordsJason1');
ParsingTime= toc
%% Filter Data
tic
% SatFilter(SatelliteName,iflags,oflags, STD_treshold, SWH_treshold, SSH_mssh_treshold)
[AllRecFiltered] = SatFilter('Jason-1', '00000000','00000110', 0.2, 7.0, 2.0);
save('Jason-1\AllRecFiltered_cylce_110.mat','AllRecFiltered');
fclose all;
filteredTime = toc

%% load Parsed Data and Filtered/Computed data
AllRecordsJason1 = struct2array(load('Jason-1\AllRecordsJason1.mat'));
AllRecFiltered = struct2array(load('Jason-1\AllRecFiltered_cylce_110.mat'));

%% Plot Ground tracks
figure(1)
hold on;
% Set background image
BackgroundImage = imread('map.jpg');
imagesc([180 360+180], [-90 90], flipdim(BackgroundImage,1)); % Right half
imagesc([-180 180], [-90 90], flipdim(BackgroundImage,1));    % Left half
set(gca,'ydir','normal');
plot (AllRecordsJason1(:,3)',AllRecordsJason1(:,2)',  '.g', 'Markersize', 1);
plot (AllRecFiltered(:,3)',  AllRecFiltered(:,2)',    '.r', 'Markersize', 1);
title('Jason-1 GroundTrack / cycle #110')
legend('Satellite Track','AOI = Oceans')
% Set limits for the axis
set(gca,'XLim', [0 360]);
set(gca,'YLim', [-90 90]);
hold off;


%% Statistics

std_sort = sort(AllRecFiltered(:,6),'descend');
swh_sort = sort(AllRecFiltered(:,7),'descend');
SumOfCorretions = sort(AllRecFiltered(:,20),'descend');
SSH_sort = sort(AllRecFiltered(:,21),'descend');
SSH_mssh_sort = sort(AllRecFiltered(:,22),'descend');
SSH_geoh_sort = sort(AllRecFiltered(:,23),'descend');

%% Plot of statistics for cycle
xlimim = [0 size(AllRecFiltered,1)];
figure(3)
subplot(3,2,1); hold on
plot(AllRecFiltered(:,6),'b');
plot(std_sort,'r');
legend('stdalt','stdalt sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off; subplot(3,2,2); hold on
plot(AllRecFiltered(:,21),'b');
plot(SSH_sort,'r');
legend('SSH','SSH sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off; subplot(3,2,3); hold on
plot(AllRecFiltered(:,7),'b');
plot(swh_sort,'r');
legend('swh','swh sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off; subplot(3,2,4); hold on
plot(AllRecFiltered(:,22),'b')
plot(SSH_mssh_sort,'r');
legend('SSH-mssh','SSH-mssh sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off; subplot(3,2,5); hold on
plot(AllRecFiltered(:,20),'b')
plot(SumOfCorretions,'r');
legend('SumOfCorrections','SumOfCorrections sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off; subplot(3,2,6); hold on
plot(AllRecFiltered(:,23),'b')
plot(SSH_geoh_sort,'r');
legend('SSH-geoh','SSH-geoh sorted');
ylabel('[m]');
xlimits = [xlimim]; set(gca,'XLim', xlimits);
hold off;

