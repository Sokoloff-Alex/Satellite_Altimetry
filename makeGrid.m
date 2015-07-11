function[Grid,LatGrid,LongGrid] = makeGrid(longSize,latSize, factor)
% make grid with AOI for each point
% by Alexandr Sokolov

DataPool = SetGlobalVariables;

LatGrid = 90:-latSize:-90;
LongGrid = 0:longSize:360;
Arc_deg = zeros(size(LatGrid,2),1);


if rem(length(LatGrid),2) == 0 % check odd and even
    for index = 1:1:(length(LatGrid)/2)    % even
%         disp('LatGrid is even');
        Arc_deg(index) = distance(LatGrid(index),0,LatGrid(index+1),longSize)/2 * factor;
        Arc_deg(end-index) = Arc_deg(index);
    end 
else
%     disp('LatGrid is odd');
    for index = 1:1:(length(LatGrid)-1)/2  % odd
        Arc_deg(index) = distance(LatGrid(index),0,LatGrid(index+1),longSize)/2* factor;
        Arc_deg(length(LatGrid) - index + 1) = Arc_deg(index);
    end
        Arc_deg(index+1) = distance(LatGrid(index),0,LatGrid(index+1),longSize)/2 * factor;
end
Arc_deg;
    
Grid = ones(size(LatGrid,2),size(LongGrid,2),3);
Grid(:,:,1) = LatGrid' * ones(size(LongGrid,2),1)';
Grid(:,:,2) = ones(size(LatGrid,2),1) * LongGrid ;
Grid(:,:,3) = Arc_deg * ones(size(LongGrid,2),1)';



% Rmin = zeros(size(LatGrid,2),1);
%     for row = 1:1:size(LatGrid,2)
%        ArcLength = 2*pi*Re*(longSize*cosd(LatGrid(row))/360); % lenght of arcs on the given parallel 
%        Rmin(row) = 0.8*ArcLength/1000;  % , [km] min radius of AOI for given latitude
%        %        Rmin(row) = (sqrt(2)/2)*ArcLength/1000;  % , [km] min radius of AOI for given latitude
%     end
%        Rmin = Rmin'; % in column more intuitive
% 
% Grid = ones(size(LatGrid,2),size(LongGrid,2),3);
% Grid(:,:,1) = LatGrid' * ones(size(LongGrid,2),1)';
% Grid(:,:,2) = ones(size(LatGrid,2),1) * LongGrid ;
% Grid(:,:,3) = Rmin' * ones(size(LongGrid,2),1)';

clear row
clear ArcLength

%%
% 
% figure(1)
% hold on;
% BackgroundImage = imread([[DataPool,'Results\map.jpg']);
% imagesc([180 360+180], [-90 90], flipdim(BackgroundImage,1)); % Right half
% imagesc([-180 180], [-90 90], flipdim(BackgroundImage,1));    % Left half
% set(gca,'ydir','normal');
% % plot (AllRecords(:,3)',    AllRecords(:,2)',    '.g', 'Markersize', 1);
% % plot (AllRecFiltered(:,3)',AllRecFiltered(:,2)','.r', 'Markersize', 1);
% plot(Grid(:,:,1),Grid(:,:,2),'or', 'Markersize',40)
% title('Jason-1 GroundTrack / cycle #110')
% legend('Satellite Track','AOI = Oceans')
% set(gca,'XLim', [0 360]);
% set(gca,'YLim', [-90 90]);
% hold off;
% 
% 
% 
% %% Scatter
% close all
% figure(2)
% scatter(Grid(:,1,1),Grid(:,1,2),Grid(:,1,3)/250)
% % scatter(Grid(:,:,1),Grid(:,:,2),Grid(:,:,3))
% set(gca,'XLim', [0 360]);
% set(gca,'YLim', [-90 90]);

end