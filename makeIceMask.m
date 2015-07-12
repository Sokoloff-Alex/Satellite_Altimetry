function[IceMask, IceMaskGrid] = makeIceMask(TrendMap)
% Make Ise mask from Trend map
% fill with NaN all non-water regions (terrain and ICE),
% and set vater regions = 1;
% return simple IceMask as simple 1D maprix
% and IceMaskGrid as 3D Matrix of IceMask with Lat and Long coordinates.

% Alexandr Sokolov, 2015

DataPool = SetGlobalVariables;


IceMask = TrendMap;
IceMask(~isnan(IceMask)) = 1;
IceMask(isnan(IceMask)) = 0;
IceMask(IceMask == 0) = NaN;

LatGridIceMask = (size(IceMask,1)-1)/2;
LatSizeIceMask = (size(IceMask,1)) / (LatGridIceMask*2+1);
LongSizeIceMask = 360 / (size(IceMask,2)-1);

%
IceMaskGrid = ones(size(IceMask,1),size(IceMask,2),3);
IceMaskGrid(:,:,1) = ones(size(IceMask,1),1) * [0:LongSizeIceMask:360] ;
IceMaskGrid(:,:,2) = [-LatGridIceMask:LatSizeIceMask:LatGridIceMask]' * ones(size(IceMask,2),1)';
IceMaskGrid(:,:,3) = flipud(IceMask);


LandWaterMask = importdata([DataPool,'landOceanMask\lwmask25.mat']);
LandWaterMask = importdata([DataPool,'landOceanMask\lwmask_1x1.mat']);
LandWaterMask(LandWaterMask == 1) = NaN;
LandWaterMask(LandWaterMask == 0) = 4;


LatSize  = 180 / (size(LandWaterMask,1) - 1);
LongSize = 360 / (size(LandWaterMask,2) - 1);

LW_MaskGrid = ones(size(LandWaterMask,1),size(LandWaterMask,2),3);
LW_MaskGrid(:,:,1) = ones(size(LandWaterMask,1),1) * [0:LongSize:360] ;
LW_MaskGrid(:,:,2) = [-90:LatSize:90]' * ones(size(LandWaterMask,2),1)';
LW_MaskGrid(:,:,3) = flipud(LandWaterMask);

save([DataPool,'Jason-1\Additional\IceMask.mat'],'IceMask');
save([DataPool,'Jason-1\Additional\IceMaskGrid.mat'],'IceMaskGrid');
save([DataPool,'Jason-1\Additional\LandWaterMaskGrid.mat'],'LW_MaskGrid');

%
close all
figure(3)
hold on
% pcolor(LW_MaskGrid(:,:,1), LW_MaskGrid(:,:,2), LW_MaskGrid(:,:,3))
pcolor(IceMaskGrid(:,:,1), IceMaskGrid(:,:,2), IceMaskGrid(:,:,3)) 

shading flat
set(gcf, 'renderer', 'zbuffer');
legend('Land-Water Mask', 'IceMask')
xlim([0 360])
ylim([-70 70])
h = colorbar('peer',gca); 
% caxis([0 5])

end