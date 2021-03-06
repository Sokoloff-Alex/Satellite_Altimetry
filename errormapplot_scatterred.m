% Make Error plots
% by Sokolov Alexandr 

clear all; close all; clc

DataPool = SetGlobalVariables;

ListOfErrorMaps = ls ([DataPool,'Jason-1\Errormaps\*.mat'])
NumberOfCycles = size(ListOfErrorMaps,1)

LandWaterMask = importdata([DataPool,'landOceanMask\lwmask25.mat']);

% down-samlpe matrix of Land-Ocean Mask
LandWaterMaskReduced = nan(180,360);
for row = 1:size(LandWaterMaskReduced,1) 
    for col = 1:size(LandWaterMaskReduced,2)
        rowRange = row*4;
        colRange = col*4;
        LandWaterMaskReduced(row,col) = mean(mean(LandWaterMask(rowRange-3:rowRange,colRange-3:colRange)));
        
    end
end

LandWaterMaskReduced(LandWaterMaskReduced >= 0.5) = NaN;
LandWaterMaskReduced(LandWaterMaskReduced < 0.5) = -1;
save([DataPool,'landOceanMask\lwmask_1x1','.mat'], 'LandWaterMaskReduced');

LandWaterMaskNew = importdata([DataPool,'landOceanMask\lwmask_1x1.mat']);

LandWaterMaskReduced = [LandWaterMaskReduced(:,end) LandWaterMaskReduced];
%%
    
for index = 35:110 % NumberOfCycles
    tic;
    Cycle = ListOfErrorMaps(index,end-6:end-4);
    ErrorsData = importdata([DataPool,'Jason-1\errormaps\cross_point_',num2str(Cycle),'.mat']);
    Error = ErrorsData(:,5);
    ErrorLimit = 2;
    Error(Error > ErrorLimit) = ErrorLimit;
    Error(Error < -ErrorLimit) = -ErrorLimit;
     Error  = abs(Error);
    
    F = scatteredInterpolant(ErrorsData(:,1),ErrorsData(:,2),Error,'natural','nearest');

    [xq,yq] = meshgrid(0:0.5:360,-67:0.5:67);
    vq = F(xq,yq);

    figErrorMap = figure(2);
    set(gcf,'PaperPositionMode','auto')
    set(figErrorMap, 'Position', [0 0 1900 1000])
    hold on
    set(gcf, 'renderer', 'zbuffer');    
    pc1 = pcolor(xq,yq+91,vq);
    shading flat
    h = colorbar;
    xlabel(h,'Error, [m]')  
    pc2 = pcolor(flipud(LandWaterMaskReduced));
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
    xlabel('Longitude, [deg]')
    set(ax,'XTick',     [0:30:360])
    ylabel('Latitude, [deg]')    
    set(ax,'YTick',     [  0     24    50    70   90  110  130  156  180])
    set(ax,'YTickLabel',{'-90','-66','-40','-20','0', '20','40','66','90'})
    title(['Cross-track error analysis, Cycle ',num2str(Cycle)])
    print(figErrorMap, '-dpng',[DataPool,'Results\Errormaps\Error_Map_',num2str(Cycle),'.png']);
    hold off;
    
    time = toc
      
end 


