function[SSHMap, SSHAnomalyMap, MDTMap] = meanGrid(CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix, Cycle, textLegend)
% make map of SSH using mean values on grid with uniform weighting for Fast Post-Processing
% save map and surface plots
% by Alexandr Sokolov, 2015

DataPool = SetGlobalVariables;


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

% prepate ErrorMap

ErrorsData = importdata([DataPool,'Jason-1\errormaps\cross_point_',num2str(Cycle),'.mat']);
Error = ErrorsData(:,5);
ErrorLimit = 2;
Error(Error > ErrorLimit) = ErrorLimit;
Error(Error < -ErrorLimit) = -ErrorLimit;
 Error  = abs(Error);

F = scatteredInterpolant(ErrorsData(:,1),ErrorsData(:,2),Error,'natural','nearest');

[xq,yq] = meshgrid(0:0.5:360,-67:0.5:67);
vq = F(xq,yq);

% save results (exept ErrorMap)

save([DataPool,'Jason-1\Products\SSHMap_',num2str(Cycle),'.mat'], 'SSHMap');
save([DataPool,'Jason-1\Products\SSHAnomalyMap_',num2str(Cycle),'.mat'], 'SSHAnomalyMap');
save([DataPool,'Jason-1\Products\MDTMap_',num2str(Cycle),'.mat'], 'MDTMap');

% plot Maps
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
title(['SSH map, cycle ',num2str(Cycle),', mean weighting'])
print(Fig_SSH_Map, '-dpng',[DataPool,'Results\MapsFinal\SSH_Map_',num2str(Cycle),'.png']);

Fig_SSHAnomaly_Map = figure(3);
set(gcf,'PaperPositionMode','auto')
set(Fig_SSHAnomaly_Map, 'Position', [0 0 1900 1000])
pcolor(flipud(SSHAnomalyMap));
% legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
caxis([-0.8 0.8])
xlabel(h,'SSH Anomaly, [m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]') 
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['SSH Anomaly map, cycle ',num2str(Cycle),', mean weighting'])
print(Fig_SSHAnomaly_Map, '-dpng',[DataPool,'Results\MapsFinal\SSH_Anomaly_Map_',num2str(Cycle),'.png']);

Fig_MDT_Map = figure(4);
set(gcf,'PaperPositionMode','auto')
set(Fig_MDT_Map, 'Position', [0 0 1900 1000])
pcolor(flipud(MDTMap));
% legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
caxis([-2 2.5])
xlabel(h,'SMDT, [m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]') 
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['MDT map, cycle ',num2str(Cycle),', mean weighting'])
print(Fig_MDT_Map, '-dpng',[DataPool,'Results\MapsFinal\MDT_',num2str(Cycle),'.png']);


LandWaterMask = importdata([DataPool,'landOceanMask\lwmask_1x1.mat']);

  
%%
    figErrorMap = figure(6);
    set(gcf,'PaperPositionMode','auto')
    set(figErrorMap, 'Position', [0 0 1900 1000])
    hold on
    set(gcf, 'renderer', 'zbuffer');    
    pc1 = pcolor(xq,yq+91,vq);
    shading flat
    h = colorbar;
    xlabel(h,'Error, [m]')  
    pc2 = pcolor(flipud(LandWaterMask));
    shading flat
    hAllAxes = findobj(gcf,'type','axes');
    ax1 = hAllAxes(1);
    ax2 = hAllAxes(2);  
    colormap(ax1, 'jet')
%     colormap(ax2, 'gray')
    set(ax2,'Color','w');
    caxis([0 ErrorLimit])
    xlim([0 360])
    ylim([24 156])
    ax = gca;
    xlabel('Latitude, [deg]')
    set(ax,'XTick',     [0:30:360])
    ylabel('Longitude, [deg]')    
    set(ax,'YTick',     [  0     24    50    70   90  110  130  156  180])
    set(ax,'YTickLabel',{'-90','-66','-40','-20','0', '20','40','66','90'})
    title(['Cross-track error analysis, Cycle ',num2str(Cycle)])
    print(figErrorMap, '-dpng',[DataPool,'Results\Errormaps\Error_Map_',num2str(Cycle),'.png']);
    hold off;
      
%%%%

figCombination = figure(5);
set(gcf,'PaperPositionMode','auto')
set(figCombination, 'Position', [0 0 1900 1000])

subplot(2,4,1:2)
pcolor(flipud(SSHMap));
% % legend(textLegend);
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
title(['SSH map, cycle ',num2str(Cycle),', mean weighting'])

subplot(2,4,3:4)
pcolor(flipud(SSHAnomalyMap));
% % legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
caxis([-0.8 0.8])
xlabel(h,'SSH Anomaly, [m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')  
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['SSH Anomaly map, cycle ',num2str(Cycle),', mean weighting'])

subplot(2,4,5:6)
pcolor(flipud(MDTMap));
% % legend(textLegend);
shading flat
set(gcf, 'renderer', 'zbuffer');
% set(gcf,'Visible','off') 
h = colorbar;
caxis([-2 2.5])
xlabel(h,'SMDT, [m]');
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')  
ylim([4 141-4])
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
title(['MDT map, cycle ',num2str(Cycle),', mean weighting'])

subplot(2,4,7:8)
    hold on
    set(gcf, 'renderer', 'zbuffer');    
    pc1 = pcolor(xq,yq+91,vq);
    shading flat
    h = colorbar;
    xlabel(h,'Error, [m]')  
    pc2 = pcolor(flipud(LandWaterMask));
    shading flat
    hAllAxes = findobj(gcf,'type','axes');
    ax1 = hAllAxes(1);
    ax2 = hAllAxes(2);  
    colormap(ax1, 'jet')
%     colormap(ax2, 'gray')
    set(ax2,'Color','w');
    caxis([0 ErrorLimit])
    xlim([0 360])
    ylim([24 156])
    ax = gca;
    xlabel('Latitude, [deg]')
    set(ax,'XTick',     [0:30:360])
    ylabel('Longitude, [deg]')    
    set(ax,'YTick',     [  0     24    50    70   90  110  130  156  180])
    set(ax,'YTickLabel',{'-90','-66','-40','-20','0', '20','40','66','90'})
    title(['Cross-track error analysis, Cycle ',num2str(Cycle)])
    hold off;

% subplot(2,4,7:8)
% pcolor(flipud(CounterMatrix));
% % legend(textLegend);
% shading flat
% set(gcf, 'renderer', 'zbuffer');
% % set(gcf,'Visible','off') 
% h = colorbar('peer',gca);
% caxis([0 350])
% xlabel(h,'# of Points')
% ax = gca;
% xlabel('Longitude, [deg]')
% set(ax,'XTick',     [0:30:360])
% ylabel('Latitude, [deg]')  
% ylim([4 141-4])
% set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
% set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
%  title(['measurement points distribution into grid cells, cycle ',num2str(Cycle)])

print(figCombination,'-dpng',[DataPool,'Results\Maps\figCombiMap_',num2str(Cycle),'.png']);


end

