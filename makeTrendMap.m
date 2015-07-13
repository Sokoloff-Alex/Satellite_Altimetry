function[TrendMap, TrendMapScaled] = makeTrendMap(Matrix, timeVectorAll, NanPercentThreshold, MapType)
% Estimation of TrendMap from stack of cycle's solutions 
% 
% Input :    Matrix                 - stack of individual cycles;
%            timeVector             - timeVector;  
%            NanPercentThreshold    - Maximum Percent of NaN values;
%             
% Output:    TrendMap               - 1D Matrix in [m/cycle] units
%            TrendMapScaled         - 1D Matrix in [mm/year] units and filtered by
%                                     Limit of Sea Level Rise = 250 mm/year to delete outliers
% 
% by Alexandr Sokolov, 2015

Year = 365.25; % days
CyclePeriod = 9.9156; % days

DataPool = SetGlobalVariables;

tic
for row = 1:size(Matrix,1)
    for column = 1:size(Matrix,2)
        valuesAll = Matrix(row,column,:);
        valuesAll = valuesAll(:);
        alert = max(isnan(valuesAll));
        NaNPercent = sum(isnan(valuesAll))/(size(valuesAll,1))*100;
        if NaNPercent == NanPercentThreshold % Number of NaN's
            values = zeros(size(valuesAll,1),1);
            timeVector = zeros(size(valuesAll,1),1);
            counter = 0;
            for index = 1:size(valuesAll);            
                if ~isnan(valuesAll(index)) 
                    counter = counter + 1;
                    values(counter,1) = valuesAll(index);
                    timeVector(counter,1) = timeVectorAll(index);                    
                end
            end
            values = values(1:counter);
            timeVector = timeVector(1:counter);
            [coeff] = HarmomicAnalysis(values,timeVector,'no');
            TrendMatrix(row,column,1:12) = coeff;
            TrendMap(row,column) = coeff(2);
        else
            TrendMap(row,column) = NaN;
        end 
    end
end

timeEstimation = toc;
disp(['Estimation time: ', num2str(timeEstimation), ' sec']);
    
    
% filter and plot results
TrendMapScaled = TrendMap * 1000 * (Year/CyclePeriod); % units change
TrendMapScaledFiltered = TrendMapScaled;
Limit = 250;
for row = 1:size(TrendMap,1)
    for column = 1:size(TrendMap,2)
        if abs(TrendMapScaledFiltered(row,column)) > Limit%  filterThresold
            if TrendMapScaledFiltered(row,column) > 0
                TrendMapScaledFiltered(row,column) = Limit;
            else
                TrendMapScaledFiltered(row,column) = -Limit;
            end   
        end
    end
end

% % plot maps
% fig1 = figure(1);
% set(gcf,'PaperPositionMode','auto')
% set(fig1, 'Position', [0 0 1900 1000])
% subplot(2,1,1)
% pcolor(flipud(TrendMapScaled))
% title(['Regional chages of ',MapType(1:end-8)])
% shading flat
% set(gcf, 'renderer', 'zbuffer');
% h = colorbar
% xlabel(h, '[mm/year]');
% ax = gca;
% xlabel('Longitude, [deg]')
% set(ax,'XTick',     [0:30:360])
% ylabel('Latitude, [deg]')    
% set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
% set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
% ylim([4 141-4])
% subplot(2,1,2)
% pcolor(flipud(TrendMapScaledFiltered))
% shading flat
% set(gcf, 'renderer', 'zbuffer');
% h = colorbar
% xlabel(h, '[mm/year]');
% ax = gca;
% xlabel('Longitude, [deg]')
% set(ax,'XTick',     [0:30:360])
% ylabel('Latitude, [deg]')    
% set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
% set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
% ylim([4 141-4])
% caxis([-100 100])
% title(['Regional chages of ',MapType(1:end-8),', rescaled']);
% print(fig1,'-dpng',[DataPool,'Results\Trends\Maps\DoublePlots\',MapType(1:end-8),'_change.png']);

% 
figTrend = figure(2);
set(gcf,'PaperPositionMode','auto')
set(figTrend, 'Position', [0 0 1900 1000])
pcolor(flipud(TrendMapScaledFiltered))
shading flat
set(gcf, 'renderer', 'zbuffer');
colorbar
h = colorbar;
xlabel(h,[MapType(1:end-8),' change, [mm/year]']);
title(['Regional chages of ',MapType(1:end-8)])
caxis([-100 100])
ax = gca;
xlabel('Longitude, [deg]')
set(ax,'XTick',     [0:30:360])
ylabel('Latitude, [deg]')    
set(ax,'YTick',     [  1     4    30    50   70    90   110  141-4   141 ])
set(ax,'YTickLabel',{'70','-66','-40','-20' ,'0', '20', '40', '66',  '70'})
ylim([4 141-4])
print(figTrend,'-dpng',[DataPool,'Results\Trends\Maps\',MapType(1:end-8),'_change.png']);

end
