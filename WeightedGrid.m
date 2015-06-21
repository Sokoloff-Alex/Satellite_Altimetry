function[SSH_weighted] = WeightedGrid(power, CounterMatrix, DistanceMatrix, ValuesMatrix, Cycle, textLegend)
% make map of SSH using mean values on grid with uniform weighting for Fast Post-Processing
% save map and surface plots
% by Alexandr Sokolov, 2015


SSH_weighted = zeros(size(DistanceMatrix,1),size(DistanceMatrix,2));

for row = 1:size(CounterMatrix,1)
   for column = 1:size(CounterMatrix,2)
       DistanceVector = DistanceMatrix(row,column,:);
       DistanceVector( all(~DistanceVector,1) ) = []; % Remove zeros
       DistanceVector = DistanceVector(:).^power;
       ValuesVector = ValuesMatrix(row,column,:);
       ValuesVector( all(~ValuesVector,1) ) = []; % Remove zeros
       
       ValuesVector = ValuesVector(:);
       WeightVector = 1./DistanceVector;    
       GridPointSum = sum(WeightVector);
       WeightVector = WeightVector./GridPointSum; % normalized weights
       check_sum = sum(WeightVector);
       value = sum(WeightVector.*ValuesVector);
       if value == 0
            value =NaN;
       end
       
       SSH_weighted(row,column) = value;
%            Average(row,column) = sum([ValuesMatrix(row,column,:)]) / CounterMatrix(row,column);             
   end    
end

% SSH_weighted(iszero(SSH_weighted))=NaN

save(['Jason-1\Results\SSH_',num2str(Cycle),'.mat'], 'SSH_weighted');

mkdir(['Results\',num2str(Cycle)])
FigGrid = figure(1);
pcolor(flipud(CounterMatrix));
legend(textLegend);
print(FigGrid,'-dpng',['Results\',num2str(Cycle),'\GriddingMap_',num2str(Cycle),'.png']);
print(FigGrid,'-dpng',['Results\Maps\GriddingMap_',num2str(Cycle),'.png']);

% FigGrid_Surf = figure(2);
% meshz(flipud(CounterMatrix));
% legend(textLegend);
% print(FigGrid_Surf,'-dpng',['Results\',num2str(Cycle),'\GriddingMapSurf_',num2str(Cycle),'.png']);
% print(FigGrid_Surf,'-dpng',['Results\Maps\GriddingMapSurf_',num2str(Cycle),'.png']);
% close figure 2

Fig_SSH_Map = figure(3);
pcolor(flipud(SSH_weighted));
legend(textLegend);
print(Fig_SSH_Map, '-dpng',['Results\',num2str(Cycle),'\SSH_Map_',num2str(Cycle),'.png']);
print(Fig_SSH_Map, '-dpng',['Results\Maps\SSH_Map_',num2str(Cycle),'.png']);

% Fig_SSH_Surf = figure(4)
% surf(flipud(SSH_weighted));
% legend(textLegend);
% print(Fig_SSH_Surf, '-dpng',['Results\',num2str(Cycle),'\SSH_Surf_',num2str(Cycle),'.png']);
% print(Fig_SSH_Surf, '-dpng',['Results\Maps\SSH_Surf_',num2str(Cycle),'.png']);
% close figure 4

end

