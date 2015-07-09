% Make Error plots
% by Sokolov Alexandr 

clear all; close all; clc

DataPool = SetGlobalVariables;

ListOfErrorMaps = ls ([DataPool,'Jason-1\Errormaps\*.mat'])
NumberOfCycles = size(ListOfErrorMaps,1)

LandWaterMask = importdata([DataPool,'landOceanMask\lwmask25.mat']);
% LandWaterMask(LandWaterMask == 1) = NaN;
% LandWaterMask(LandWaterMask == 0) = 10;

% Resize matrix
LandWaterMaskReduced = nan(180,360);
for row = 1:size(LandWaterMaskReduced,1) 
    for col = 1:size(LandWaterMaskReduced,2)
        rowRange = row*4;
        colRange = col*4;
        LandWaterMaskReduced(row,col) = mean(mean(LandWaterMask(rowRange-3:rowRange,colRange-3:colRange)));
        
    end
end


%
LandWaterMaskReduced(LandWaterMaskReduced >= 0.5) = NaN;
LandWaterMaskReduced(LandWaterMaskReduced < 0.5) = 10;

% figure(1)
% pcolor(flipud(LandWaterMaskReduced))
% shading flat
% set(gcf, 'renderer', 'zbuffer');
%     
    
    
for index = 1:1 % NumberOfCycles
    Cycle = ListOfErrorMaps(index,end-6:end-4);
    ErrorsData = importdata([DataPool,'Jason-1\errormaps\cross_point_',num2str(Cycle),'.mat']);
    Error = ErrorsData(:,5);
    ErrorLimit = 2;
    Error(Error > ErrorLimit) = ErrorLimit;
    Error(Error < -ErrorLimit) = -ErrorLimit;
    
    
    F = scatteredInterpolant(ErrorsData(:,1),ErrorsData(:,2),Error,'natural','nearest');

    [xq,yq] = meshgrid(0:0.25:360,-67:0.25:67);
    vq = F(xq,yq);

    figure(2)
    hold on;
    pcolor(xq,yq+91,vq);
%     plot3(ErrorsData(:,1),ErrorsData(:,2),ErrorsData(:,5),'+');
    pcolor(flipud(LandWaterMaskReduced))
    h = colorbar;
    shading flat
    set(gcf, 'renderer', 'zbuffer');
    set(gca, 'color', 'w');
    h = colorbar;
    caxis([-ErrorLimit ErrorLimit])
    xlim([0 360])
    ylim([20 160])
    hold off;
    

   

% plot error maps
% 
% fig = figure(2)
% set(gcf,'PaperPositionMode','auto')
% set(fig, 'Position', [0 0 1900 1000])
% subplot(2,1,1)
% pcolor(MapInitial)
% shading flat
% set(gcf, 'renderer', 'zbuffer');
% h = colorbar('peer',gca); 
% caxis([-5 5])
% ylim([20 160])
% xlabel(h,'Erorr, m');
% title(['Error on crossing points, Cycle ',num2str(Cycle)])
% 
% subplot(2,1,2)
% pcolor(MapApprox)
% shading flat
% set(gcf, 'renderer', 'zbuffer');
% h = colorbar('peer',gca); 
% caxis([-5 5])
% ylim([20 160])
% xlabel(h,'Erorr, m');
% title(['Error on crossing points, mean smothing, ',num2str(iterations),' interations, Cycle ',num2str(Cycle)])
% print(fig, '-dpng',[DataPool,'Results\Errormaps\Error_Map_',num2str(Cycle),'.png']);

end