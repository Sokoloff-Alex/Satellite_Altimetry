% Geoid verification

clear all
clc
close all
cd ..
DataPool = SetGlobalVariables;
DataPool = [DataPool,'Test\'];
cd UnitTests\

GeoidModel_1 = struct2array(load([DataPool,'Jason-1\Products\GEOID_Map_110.mat'])); % from file
GeoidModel_2 = struct2array(load([DataPool,'Jason-1\Products\GEOID2008Map_999.mat'])); % from file

diff = GeoidModel_1 - GeoidModel_2;
%%
Cycle = 110;
FigGEOIDiff = figure(1);
set(gcf,'PaperPositionMode','auto')
set(FigGEOIDiff, 'Position', [0 0 1900 1000])
pcolor(flipud(diff))
% legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([-105 85])
xlabel(h,'[m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')    
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['Geoid difference map, cycle ',num2str(Cycle),', mean weighting'])
print(FigGEOIDiff , '-dpng',[DataPool,'Results\MapsFinal\GeoidDifferences',num2str(Cycle),'.png']);


