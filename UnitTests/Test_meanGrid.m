function[SSHMap, SSHAnomalyMap, MDTMap] = Test_meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend)
% make map of SSH using mean values on grid with uniform weighting for Fast Post-Processing
% save map and surface plots
% by Alexandr Sokolov, 2015

% difference to meanGrid function in the scale of output
% instead of original scale, used adopted to artificial
% dataset range [0 4] for all

cd ../;
DataPool = SetGlobalVariables;
DataPool = [DataPool,'Test\'];
cd UnitTests;

SSHMap = zeros(size(DistanceMatrix,1),size(DistanceMatrix,2));
SSHAnomalyMap = zeros(size(DistanceMatrix,1),size(DistanceMatrix,2));
MDTMap = zeros(size(DistanceMatrix,1),size(DistanceMatrix,2));


for row = 1:size(CounterMatrix,1)
   for column = 1:1:size(CounterMatrix,2)
       SSHMap(row,column) = sum([SSHMatrix(row,column,:)]) / CounterMatrix(row,column);  
       SSHAnomalyMap(row,column) = sum([SSHAnomalyMatrix(row,column,:)]) / CounterMatrix(row,column);  
       MDTMap(row,column) = sum([MDTMatrix(row,column,:)]) / CounterMatrix(row,column);  
   end    
end


save([DataPool,'Jason-1\Products\SSHMap_',num2str(Cycle),'.mat'], 'SSHMap');
save([DataPool,'Jason-1\Products\SSHAnomalyMap_',num2str(Cycle),'.mat'], 'SSHAnomalyMap');
save([DataPool,'Jason-1\Products\MDTMap_',num2str(Cycle),'.mat'], 'MDTMap');

mkdir([DataPool,'\Results\',num2str(Cycle)])

FigGrid1 = figure(1);
% set(FigGrid1,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'PaperPositionMode','auto')
set(FigGrid1, 'Position', [0 0 1900 1000])
pcolor(flipud(CounterMatrix));
% legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar('peer',gca); 
caxis([0 350])
xlabel(h,'# of Points')
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')    
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
ylim([4 141-4])
title(['measurement points distribution into grid cells, cycle ',num2str(Cycle)])
print(FigGrid1,'-dpng',[DataPool,'Results\MapsFinal\GriddingMap_',num2str(Cycle),'.png']);
 Fig_SSH_Map = figure(2);
set(gcf,'PaperPositionMode','auto')
set(Fig_SSH_Map, 'Position', [0 0 1900 1000])
pcolor(flipud(SSHMap));
% legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
caxis([-105 85])
xlabel(h,'SSH, [m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')    
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['MSSH map, cycle ',num2str(Cycle),', mean weighting'])
print(Fig_SSH_Map, '-dpng',[DataPool,'Results\MapsFinal\MSSH_Map_',num2str(Cycle),'.png']);

Fig_SSHAnomaly_Map = figure(3);
set(gcf,'PaperPositionMode','auto')
set(Fig_SSHAnomaly_Map, 'Position', [0 0 1900 1000])
pcolor(flipud(SSHAnomalyMap));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([0 4])
xlabel(h,'[m]');
title(['GEOID map, cycle ',num2str(Cycle),', no weighting'])
% print(Fig_SSHAnomaly_Map, '-dpng',[DataPool,'Results\',num2str(Cycle),'\SSH_Anomaly_Map_',num2str(Cycle),'.png']);
print(Fig_SSHAnomaly_Map, '-dpng',[DataPool,'Results\MapsFinal\_GEOID_Map_',num2str(Cycle),'.png']);

Fig_MDT_Map = figure(4);
set(gcf,'PaperPositionMode','auto')
set(Fig_MDT_Map, 'Position', [0 0 1900 1000])
pcolor(flipud(MDTMap));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([0 4])
xlabel(h,'[m]');
title(['Corrections map, cycle ',num2str(Cycle),', no weighting'])
% print(Fig_MDT_Map, '-dpng',[DataPool,'Results\',num2str(Cycle),'\MDT_Map_',num2str(Cycle),'.png']);
print(Fig_MDT_Map, '-dpng',[DataPool,'Results\MapsFinal\Corrections_',num2str(Cycle),'.png']);

figCombination = figure(5);
set(gcf,'PaperPositionMode','auto')
set(figCombination, 'Position', [0 0 1900 1000])
subplot(2,4,1:2)
pcolor(flipud(SSHMap));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([0 4])
xlabel(h,'MSSH, [m]');
title(['MSSH map, cycle ',num2str(Cycle),', no weighting'])

subplot(2,4,3:4)
pcolor(flipud(SSHAnomalyMap));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([0 4])
xlabel(h,'[m]');
title(['GEOID map, cycle ',num2str(Cycle),', no weighting'])

subplot(2,4,5:6)
pcolor(flipud(MDTMap));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
% caxis([0 4])
xlabel(h,'[m]');
title(['Corrections map, cycle ',num2str(Cycle),', no weighting'])

subplot(2,4,7:8)
pcolor(flipud(CounterMatrix));
legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar('peer',gca);
caxis([0 350])
xlabel(h,'# of Points')
title(['measurement points distribution into grid cells, cycle ',num2str(Cycle)])
print(figCombination,'-dpng',[DataPool,'Results\MapsFinal\figCombiMap_',num2str(Cycle),'.png']);


end

