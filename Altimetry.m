
% Apllied Computer Science
% Satellite Altimetry
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

DataPool = SetGlobalVariables;

tic;
% Read data from all satellite files and merge the data
% [AllRecordsEnvsat] = ParseSatData('Envisat');
[AllRecords] = ParseSatData('Jason-1');
ParsingTime= toc;
disp(['Parsing time: ', num2str(ParsingTime/60), ' min']);
%% Filter Data
tic;
% SatFilter(SatelliteName,iflags,oflags, STD_treshold, SWH_treshold, SSH_mssh_treshold)
[AllRecFiltered] = SatFilter('Jason-1', '00000000','11111111', 0.2, 7.0, 2.0);
filteredTime = toc;
disp(['Filtering time: ', num2str(filteredTime/60), ' min']);

%% Parse and Filter 
tic;
[AllRecords, AllRecFiltered] = ParseAndFilterSatData('Jason-1', '00000000','00000110', 0.2, 7.0, 2.0);
ParseAndFiltertime = toc;


%% load Parsed Data and Filtered/Computed data
AllRecords = struct2array(load([DataPool,'\Jason-1\Data\Jason-1_110.mat']));
AllRecFiltered = struct2array(load(['\Jason-1\DataFiltered\Jason-1_110_filtered.mat']));

%% Statistics
figStat = Statistics(AllRecFiltered);

%% Plot Ground tracks
range = [1:2000];
figure(1)
hold on;
% Set background image
BackgroundImage = imread([DataPool,'\Results\map.jpg']);
imagesc([180 360+180], [-90 90], flipdim(BackgroundImage,1)); % Right half
imagesc([-180 180], [-90 90], flipdim(BackgroundImage,1));    % Left half
set(gca,'ydir','normal');
plot (AllRecords(range,3)',    AllRecords(range,2)',    '.g', 'Markersize', 1);
plot (AllRecFiltered(range,3)',AllRecFiltered(range,2)','.r', 'Markersize', 1);
title('Jason-1 GroundTrack / cycle #110')
legend('Satellite Track','AOI = Oceans')
% Set limits for the axis
set(gca,'XLim', [0 360]);
set(gca,'YLim', [-90 90]);
hold off;

%%
figure(3)
subplot(2,1,1)
hold on
plot(AllRecFiltered(range,2),'b')
plot(AllRecords(range,2),'r')
subplot(2,1,2)
plot(AllRecFiltered(range,3),'b')
plot(AllRecords(range,3),'r')
hold off

%%  Scatter map
figure(2)
scatter(AllRecFiltered(:,3)', AllRecFiltered(:,2)',[],AllRecFiltered(:,21)','filled');
set(gca,'XLim', [0 360]);
set(gca,'YLim', [-90 90]);

%%  Scatter map CUT
range = 1:10000;
figMap = figure(2);
scatter(AllRecFiltered(range,3)', AllRecFiltered(range,2)',[],AllRecFiltered(range,21)','filled');
set(gca,'XLim', [0 360]);
set(gca,'YLim', [-90 90]);
print(figMap,'-dpng',[DataPool,'\Results\ScatterMap1.png']);



%% Plot of Statistics for cycle FILTERED
xlimits = [0 size(AllRecFiltered,1)];
figure(3)
subplot(3,2,1); hold on
plot(AllRecFiltered(:,6),'b');
plot(sort(AllRecFiltered(:,6),'descend'),'r');
legend('stdalt','stdalt sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; subplot(3,2,2); hold on
plot(AllRecFiltered(:,21),'b');
plot(sort(AllRecFiltered(:,21)),'r');
legend('SSH','SSH sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; subplot(3,2,3); hold on
plot(AllRecFiltered(:,7),'b');
plot(sort(AllRecFiltered(:,7),'descend'),'r');
legend('swh','swh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; subplot(3,2,4); hold on
plot(AllRecFiltered(:,22),'b')
plot(sort(AllRecFiltered(:,22)),'r');
legend('SSH-mssh','SSH-mssh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; subplot(3,2,5); hold on
plot(AllRecFiltered(:,20),'b')
plot(sort(AllRecFiltered(:,20)),'r');
legend('SumOfCorrections','SumOfCorrections sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; subplot(3,2,6); hold on
plot(AllRecFiltered(:,23),'b')
plot(sort(AllRecFiltered(:,23)),'r');
legend('SSH-geoh','SSH-geoh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off;


%% Plot of Statistics for cycle FILTERED
xlimits = [0 size(AllRecFiltered,1)];
figure(3)
subplot(3,8,1:3); hold on
plot(AllRecFiltered(:,6),'b');
plot(sort(AllRecords(:,6),'descend'),'r')
legend('stdalt','stdalt sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [0 0.25]);
hold off

subplot(3,8,4)
pd1 = fitdist(AllRecords(:,6),'Rayleigh');
x_pdf1 = [0:0.01:1];
y1 = pdf(pd1,x_pdf1);
plot(y1,x_pdf1,'LineWidth',2)
set(gca,'YLim', [0 0.25]);

subplot(3,8,5:7); hold on
plot(AllRecFiltered(:,21),'b');
plot(sort(AllRecFiltered(:,21),'descend'),'r');
legend('SSH','SSH sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [-100 100]);
hold off; 

subplot(3,8,8)
pd2 = fitdist(AllRecFiltered(:,21),'Normal');
x_pdf2 = [-100:1:100];
y2 = pdf(pd2,x_pdf2);
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [-100 100]);

subplot(3,8,9:11); hold on
plot(AllRecFiltered(:,7),'b');
plot(sort(AllRecFiltered(:,7),'descend'),'r');
legend('swh','swh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [0 10]);
hold off; 

subplot(3,8,12)
pd2 = fitdist(AllRecFiltered(:,7),'Rayleigh');
x_pdf2 = [0:0.1:10];
y2 = pdf(pd2,x_pdf2);
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [0 10]);

subplot(3,8,13:15); hold on
plot(AllRecFiltered(:,22),'b')
plot(sort(AllRecFiltered(:,22),'descend'),'r');
legend('SSH-mssh','SSH-mssh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
set(gca,'YLim', [-1.5 1.5]);
hold off; 

subplot(3,8,16)
pd2 = fitdist(AllRecFiltered(:,22),'Normal');
x_pdf2 = [-2:0.1:2];
y2 = pdf(pd2,x_pdf2);
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [-1.5 1.5]);

subplot(3,8,17:19); hold on
plot(AllRecFiltered(:,20),'b')
plot(sort(AllRecFiltered(:,20),'descend'),'r');
legend('SumOfCorrections','SumOfCorrections sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off; 

subplot(3,8,20)
pd2 = fitdist(AllRecFiltered(:,20),'Normal');
x_pdf2 = [-5:0.1:-1];
y2 = pdf(pd2,x_pdf2);
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [-3.5 -1.5]);

subplot(3,8,21:23); hold on
plot(AllRecFiltered(:,23),'b')
plot(sort(AllRecFiltered(:,23),'descend'),'r');
legend('SSH-geoh','SSH-geoh sorted');
ylabel('[m]');
set(gca,'XLim', xlimits);
hold off;

subplot(3,8,24)
pd2 = fitdist(AllRecFiltered(:,23),'Normal');
x_pdf2 = [-2:0.1:3];
y2 = pdf(pd2,x_pdf2);
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [-2 3]);


%%
subplot(1,3,1:2); 
hold on
plot(AllRecFiltered(:,21),'b');
subplot(1,3,3)
hist(AllRecFiltered(:,21),20)

%% Plot of Statistics for cycle AllRecords
std_sorted = sort(AllRecords(:,6),'descend');
pd1 = fitdist(AllRecords(:,6),'Rayleigh')
x_pdf1 = [0:0.01:1];
y1 = pdf(pd1,x_pdf1);

swh_sorted = sort(AllRecords(:,7),'descend');
pd2 = fitdist(AllRecords(:,7),'Rayleigh')
x_pdf2 = [0:0.01:100];
y2 = pdf(pd2,x_pdf2);


figure(3)
subplot(2,3,1:2); 
hold on
plot(AllRecords(:,6),'b');
plot(std_sorted,'r');
legend('stdalt','stdalt sorted');
ylabel('[m]');
set(gca,'YLim', [-0.5 4]);
set(gca,'XLim', [0 size(AllRecords,1)]);
hold off;
subplot(2,3,3); 
hold on
plot(y1,x_pdf,'LineWidth',2)
set(gca,'YLim', [-0.5 4]);

subplot(2,3,4:5); 
hold on
plot(AllRecords(:,7),'b');
plot(swh_sorted,'r');
legend('swh','swh sorted');
ylabel('[m]');
set(gca,'YLim', [-0.5 100]);
set(gca,'XLim', [0 size(AllRecords,1)]);
hold off;
subplot(2,3,6); 
hold on
plot(y2,x_pdf2,'LineWidth',2)
set(gca,'YLim', [-0.5 100]);

%% close 
figure
hold on
plot(AllRecFiltered(:,1),'.b')
plot(AllRecords(:,1),'.r')


%%


[f,x]=hist(std,100);%# create histogram from a normal distribution.
g=1/sqrt(2*pi)*exp(-0.5*x.^2);%# pdf of the normal distribution

%#METHOD 1: DIVIDE BY SUM
figure(1)
subplot(1,2,1)
bar(x,f/sum(f));hold on

%#METHOD 2: DIVIDE BY AREA
subplot(1,2,2)
bar(x,f/trapz(x,f));hold on


% bar(hist(std,100) ./ sum(hist(std,100)))

% plot(AllRecFiltered(:,2),AllRecFiltered(:,3),'.b')
% plot(AllRecordsJason1(:,2),AllRecordsJason1(:,3),'.r')
% xlimits = [0 1000 ]; set(gca,'XLim', xlimits);
hold off

