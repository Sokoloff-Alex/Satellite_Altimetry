function[Average] = meanGrid(CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend)
% make map of SSH using mean values on grid with uniform weighting for Fast Post-Processing
% save map and surface plots
% by Alexandr Sokolov, 2015


Average = zeros(size(DistanceMatrix,1),size(DistanceMatrix,2));

for row = 1:size(CounterMatrix,1)
   for column = 1:1:size(CounterMatrix,2)
       Average(row,column) = sum([ValuesMatrix(row,column,:)]) / CounterMatrix(row,column);             
   end    
end

save(['Jason-1\Results\SSH_',num2str(Cycle),'.mat'], 'Average');

mkdir(['Results\',num2str(Cycle)])

FigGrid1 = figure(1);
pcolor(flipud(CounterMatrix));
legend(textLegend);
print(FigGrid1,'-dpng',['Results\',num2str(Cycle),'\GriddingMap_',num2str(Cycle),'.png']);
print(FigGrid1,'-dpng',['Results\Maps\GriddingMap_',num2str(Cycle),'.png']);

% FigGrid_Surf = figure(2);
% meshz(flipud(CounterMatrix));
% legend(textLegend);
% print(FigGrid_Surf,'-dpng',['Results\',num2str(Cycle),'\GriddingMapSurf_',num2str(Cycle),'.png']);
% print(FigGrid_Surf,'-dpng',['Results\Maps\GriddingMapSurf_',num2str(Cycle),'.png']);
% close figure 2
 
Fig_SSH_Map = figure(2);
pcolor(flipud(Average));
legend(textLegend);
print(Fig_SSH_Map, '-dpng',['Results\',num2str(Cycle),'\SSH_Map_',num2str(Cycle),'.png']);
print(Fig_SSH_Map, '-dpng',['Results\Maps\SSH_Map_',num2str(Cycle),'.png']);

% Fig_SSH_Surf = figure(4)
% surf(flipud(Average));
% legend(textLegend);
% print(Fig_SSH_Surf, '-dpng',['Results\',num2str(Cycle),'\SSH_Surf_',num2str(Cycle),'.png']);
% print(Fig_SSH_Surf, '-dpng',['Results\Maps\SSH_Surf_',num2str(Cycle),'.png']);
% close figure 4

end

