% function[CounterMatrix, ValuesMartix, DistanceMatrix] = Interpolation
% interpolate measurements using Grid 
% and generate interpolated map
% by Alexandr Sokolov

clear all


%% load Parsed Data and Filtered/Computed data
% Data = struct2array(load('Jason-1\Jason-1_110.mat'));
Data = struct2array(load('Jason-1\Jason-1_110_filtered.mat'));
iValue = 21; % value of interest 16 = SSH

%% make Grid
% [Grid] = makeGrid(longSize,latSize)
[Grid,LatGrid,LongGrid] = makeGrid(5, 5, 1);

%% Processing
% indexing of RefPoints in nearest 
% neighbouhood of MasterRefPoint
% ======= 
% |9 2 3|
% |8 1 4|
% |7 6 5|
% =======

tic;
MeanDepth = size(Data,1)/(length(LatGrid)*length(LongGrid));
CounterMatrix  = zeros(size(Grid,1),size(Grid,2));        
ValuesMatrix   = zeros(size(Grid,1),size(Grid,2),15000);  % for 10x10 grid usually <1000 points in single RefPoint 
DistanceMatrix = zeros(size(Grid,1),size(Grid,2),15000);     
Distance = 100*ones(9,1);  % make huge, to overwrite with real distances and look for minimum                                  

iStart = 1;
iEnd = 1000; % size(Data,1);
InitialPoint = [Data(iStart,2),Data(iStart,3)];
[iLat, iLong] =  SearchForNearestPoint(LatGrid, LongGrid, InitialPoint);
MasterRefPoint = Grid(iLat,iLong,:); % todo: make ato initialization
% disp(['initial Master RefPoint, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
disp('starting interpolation');
disp(['initial Master RefPoint, Lat: ',num2str(MasterRefPoint(1)),', Long: ', num2str(MasterRefPoint(2)), '; Rmin = ',num2str(MasterRefPoint(3))])
       
    for index = iStart:iEnd  % iterate first 100 points
    Point = [Data(index,2),Data(index,3)];
    Distance(1) = distance(Point, [MasterRefPoint(1),MasterRefPoint(2)]);
    newDistance = Distance(1);
%     Distance(1) = Re*sqrt((Point(1)-MasterRefPoint(1))^2 + (cosd((Point(1)+MasterRefPoint(1))/2)*(Point(2)-MasterRefPoint(2)) )^2) / 360;
        if Distance(1) < MasterRefPoint(3) % point # 1 , center
            CounterMatrix(iLat,iLong) = CounterMatrix(iLat,iLong) + 1;
            ValuesMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Data(index,iValue);
            DistanceMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Distance(1);
            %  === check 8 neighbours from 12'clock, clockwise ============
            % 2. North
            cLat  = iLat - 1; 
            cLong = iLong;
            if cLat ~= 0
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(2) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%               Distance(2) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
                if Distance(2) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(2);
                end
            end          
            % 3. North-East
            cLat  = iLat  - 1;
            cLong = iLong + 1;
            if cLat ~= 0
                if cLong > length(LongGrid)
                   cLong = 1; % back to first column, 360 -> 0; 
                end 
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(3) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%                 Distance(3) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;                
                if Distance(3) < CurrentRefPoint(3)                
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(3);
                end
            end
            % 4. East
            cLat  = iLat;
            cLong = iLong + 1;
            if cLong > length(LongGrid)
                cLong = 1; % back to first column, 360 -> 0
%                 disp(['Iter:, ',num2str(index),'Jump in neighbour pixel 4:  360 -> 0 ged'])
%                 disp(['iLong: ',num2str(iLong), '; cLong: ',num2str(cLong)]);
            end
            CurrentRefPoint = Grid(cLat,cLong,:);
            Distance(4) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%             Distance(4) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
            if Distance(4) < CurrentRefPoint(3)
                CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(4);
            end            
            % 5. South-East
            cLat  = iLat  + 1; 
            cLong = iLong + 1;
            if cLat <= length(LatGrid)
                if cLong > length(LongGrid)
                   cLong = 1; % back to first column, 360 -> 0; 
                end
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(5) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%                 Distance(5) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
                if Distance(5) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(5);
                end
            end
            
            % 6. South
            cLat  = iLat + 1;
            cLong = iLong;
            if cLat <= length(LatGrid)
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(6) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%                 Distance(6) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
                if Distance(6) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(6);
                end
            end
            % 7. South-West
            cLat  = iLat  + 1;
            cLong = iLong - 1;
            if cLat <= length(LatGrid)
                if cLong == 0
                   cLong = length(LongGrid); % back to last column, 0 -> 360; 
                end
                CurrentRefPoint = Grid(cLat,iLong,:);
                Distance(7) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%                 Distance(7) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
                if Distance(7) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(7);
                end
            end
            % 8. West
            cLat  = iLat;
            cLong = iLong - 1;
            if cLong == 0
                cLong = length(LongGrid); % back to last column, 0 -> 350(360) 
            end
            CurrentRefPoint = Grid(cLat,cLong,:);
            Distance(8) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%             Distance(8) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
            if Distance(8) < CurrentRefPoint(3)
                CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(8);
            end
            
            % 9. North-West
            cLat  = iLat  - 1;
            cLong = iLong - 1;
            if cLat ~= 0
                if cLong == 0
                    cLong = length(LongGrid); % back to last column, 0 -> 350(360) 
                end
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(9) = distance(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
%                 Distance(9) = Re*sqrt((Point(1)-CurrentRefPoint(1))^2 + (cosd((Point(1)+CurrentRefPoint(1))/2)*(Point(2)-CurrentRefPoint(2)) )^2) / 360;
                if Distance(9) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    ValuesMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,iValue);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(9);
                end
            end
            
            % ===== Check new best MasterRefPoint
            [M,I] = min(Distance(:));
%             disp(['Min distance to Master RefPoint, index:',num2str(I)])
            Distance;
            Distance(I);
            Distance = 100*ones(9,1); % clean vector for new iteration
            
            if I  ~= 1 %  if I == 1 => MasterRefPoint remains
%                     disp(['Iteration: ', num2str(index), '; I = ', num2str(I)])
               switch I
                    case 2
                        iLat =  iLat  - 1;
%                         disp(['go North, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 3
                        iLat  = iLat  - 1;
                        iLong = iLong + 1;
                        if iLong > length(LongGrid)
                            iLong = 1;
                        end
%                         disp(['go Nort-East, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 4
                        iLong = iLong + 1;
                        if iLong > length(LongGrid)
                            iLong = 1;
                            disp([num2str(index),'; Jump in switch, 360 -> 0 ged'])
                        end
%                         disp(['go East, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 5
                        iLat  = iLat  + 1;
                        iLong = iLong + 1;
                        if iLong > length(LongGrid)
                            iLong = 1;
                        end
%                         disp(['go South-East, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 6
                        iLat  = iLat  + 1;
%                         disp(['go South, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 7
                        iLat  = iLat  + 1;
                        iLong = iLong - 1;
                        if iLong == 0
                           iLong = length(LongGrid); 
                        end
%                         disp(['go South-West, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 8
                        iLong = iLong - 1;
                        if iLong == 0
                           iLong = length(LongGrid); 
                           disp([num2str(index),'; Jump in switch, 0 -> 360 ged'])
                        end
%                         disp(['go West, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    case 9
                        iLat  = iLat  - 1;
                        iLong = iLong - 1;
                        if iLong == 0
                           iLong = length(LongGrid); 
                        end
%                         disp(['go North-West, iLat: ',num2str(iLat),', iLong: ', num2str(iLong)])
                    otherwise
%                         disp('central MasterRefPoint remains')
                end
            end 
            MasterRefPoint = Grid(iLat,iLong,:); % reinitialize Master RefPoint
        else
%             disp(['iteration: ',num2str(index),' ERROR: point is not interpolated!']);
            disp([num2str(index),'; Process Point  : Lat: ', num2str(Point(1)),' , Long: ',num2str(Point(2))]);
            disp([num2str(index),'; MasterPoint OLD: Lat: ', num2str(MasterRefPoint(1)),'      , Long: ',num2str(MasterRefPoint(2))]);
%             disp(['Previous: iLat: ',num2str(iLat),'; iLong: ',num2str(iLong)]);
            [iLat, iLong] =  SearchForNearestPoint(LatGrid, LongGrid, Point);
            MasterRefPoint = Grid(iLat,iLong,:); % reinitialize Master RefPoint
%             disp(['Updated:  iLat: ',num2str(iLat),'; iLong: ',num2str(iLong)]);
            disp([num2str(index),'; MasterPoint NEW: Lat: ', num2str(MasterRefPoint(1)),'      , Long: ',num2str(MasterRefPoint(2))]);
        end   
    end
    
    %% plots of distribution of points into Grid
    ProcessingTime = toc
    figure(1)
    subplot(1,2,1)
    pcolor(flipud(CounterMatrix))
    subplot(1,2,2)
    surf(flipud(CounterMatrix))
    
    
%% Save Results
save('Jason-1\CounterMatrix.mat','CounterMatrix');
save('Jason-1\DistanceMatrix.mat','DistanceMatrix');
save('Jason-1\ValuesMatrix.mat','ValuesMatrix');
    
