% Make Error plots
% by Sokolov Alexandr 

clear all; close all; clc

DataPool = SetGlobalVariables;

ListOfErrorMaps = ls ([DataPool,'Jason-1\Errormaps\*.mat'])
NumberOfCycles = size(ListOfErrorMaps,1)


for index = 1:1 % NumberOfCycles
    Cycle = ListOfErrorMaps(index,end-6:end-4);
    ErrorsData = importdata([DataPool,'Jason-1\errormaps\cross_point_',num2str(Cycle),'.mat']);
    Error = ErrorsData(:,5);
    ErrorLimit = 2;
    Error(Error > ErrorLimit) = ErrorLimit;
    Error(Error < -ErrorLimit) = -ErrorLimit;
    Error = abs(Error);
    
%     figure(2)
%     scatter(ErrorsData(:,1),ErrorsData(:,2),Error(:,1));

    Map = nan(181, 361);
    MapApprox = nan(size(Map,1),size(Map,2));

    for index = 1:size(ErrorsData,1)
        
       DataLine = ErrorsData(index,:);       
       iLong = round(DataLine(1)) + 1;
       iLat = round(DataLine(2)) + 91; 
       Map(iLat, iLong);
       if isnan(Map(iLat, iLong)) ||  abs(Map(iLat, iLong)) < abs(DataLine(5))
            Map(iLat, iLong) =  Error(index);    
       end
    end

    MapInitial = Map;

    % filling gaps with mean  operation
    for iterations = 1:3
        for iLat = 2:size(Map,1)-1
            for iLong = 2:size(Map,2)-1
                oldValue = Map(iLat, iLong);
                if isnan(oldValue)
                   newValue = nanmean([Map(iLat-1, iLong), Map(iLat+1, iLong), Map(iLat, iLong-1), Map(iLat, iLong+1)]);
    %                newValue = nanmean([
    %                     Map(iLat-1, iLong-1); 
    %                     Map(iLat-1, iLong); 
    %                     Map(iLat-1, iLong+1); 
    %                     Map(iLat,   iLong+1); 
    %                     Map(iLat+1, iLong+1); 
    %                     Map(iLat+1, iLong); 
    %                     Map(iLat+1, iLong-1); 
    %                     Map(iLat, iLong-1) ]);
                   MapApprox(iLat, iLong) = newValue; 
                else
                    MapApprox(iLat, iLong) = Map(iLat, iLong);
                end
            end
        end
    Map = MapApprox;
    end   

% plot error maps

fig = figure(1)
set(gcf,'PaperPositionMode','auto')
set(fig, 'Position', [0 0 1900 1000])
subplot(2,1,1)
pcolor(MapInitial)
shading flat
set(gcf, 'renderer', 'zbuffer');
h = colorbar('peer',gca); 
caxis([0 ErrorLimit])
ylim([20 160])
xlabel(h,'Erorr, m');
title(['Error on crossing points, Cycle ',num2str(Cycle)])

subplot(2,1,2)
pcolor(MapApprox)
shading flat
set(gcf, 'renderer', 'zbuffer');
h = colorbar('peer',gca); 
caxis([0 ErrorLimit])
ylim([20 160])
xlabel(h,'Erorr, m');
title(['Error on crossing points, mean smothing, ',num2str(iterations),' interations, Cycle ',num2str(Cycle)])
print(fig, '-dpng',[DataPool,'Results\Errormaps\Error_Map_',num2str(Cycle),'.png']);

end
