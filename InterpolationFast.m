function[Grid, CounterMatrix, DistanceMatrix, SSHMatrix, SSHAnomalyMatrix, MDTMatrix] = InterpolationFast(Cycle,longSize, latSize, factor)
% interpolate measurements using Grid 
% and generate interpolated map
% by Alexandr Sokolov


%% load Parsed Data and Filtered/Computed data

Data = struct2array(load([DataPool,'\Jason-1\DataFiltered\Jason-1_',num2str(Cycle),'_filtered.mat']));

%% make Grid
% [Grid] = makeGrid(longSize,latSize)
[Grid,LatGrid,LongGrid] = makeGrid(longSize, latSize, factor);

%% Processing
% indexing of RefPoints in nearest 
% neighbouhood of MasterRefPoint
% ======= 
% |9 2 3|
% |8 1 4|
% |7 6 5|
% =======

tic;
% MeanDepth = size(Data,1)/(length(LatGrid)*length(LongGrid))
CounterMatrix  = zeros(size(Grid,1),size(Grid,2));        
SSHMatrix   = zeros(size(Grid,1),size(Grid,2),300);  % for 10x10 grid usually <1000 points in single RefPoint 
SSHAnomalyMatrix  = zeros(size(Grid,1),size(Grid,2),300);  % for 10x10 grid usually <1000 points in single RefPoint 
MDTMatrix   = zeros(size(Grid,1),size(Grid,2),300);  % for 10x10 grid usually <1000 points in single RefPoint 
DistanceMatrix = zeros(size(Grid,1),size(Grid,2),300);  
% CoordMatrix    = zeros(size(Grid,1),size(Grid,2),1200,2);     
Distance = 100*ones(9,1);  % make huge, to overwrite with real distances and look for minimum                                  

iStart = 1;
iEnd = size(Data,1);
InitialPoint = [Data(iStart,2),Data(iStart,3)];
[iLat, iLong] =  SearchForNearestPoint(LatGrid, LongGrid, InitialPoint);
MasterRefPoint = Grid(iLat,iLong,:); % todo: make ato initialization
% disp(['initial Master RefPoint, iLat: ',num2str(iLat),', iLong: ',
% num2str(iLong)]);
disp(['Starting interpolation of Cycle: ',num2str(Cycle)]);
% disp(['initial Master RefPoint, Lat: ',num2str(MasterRefPoint(1)),', Long: ', num2str(MasterRefPoint(2)), '; Rmin = ',num2str(MasterRefPoint(3))])
       
    for index = iStart:iEnd  % iterate first 100 points
    Point = [Data(index,2),Data(index,3)];
    Distance(1) = OrthodromeArcLength(Point, [MasterRefPoint(1),MasterRefPoint(2)]);
        if Distance(1) < MasterRefPoint(3) % point # 1 , center
            CounterMatrix(iLat,iLong) = CounterMatrix(iLat,iLong) + 1;
            SSHMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Data(index,21);
            SSHAnomalyMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Data(index,22);
            MDTMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Data(index,23);
            DistanceMatrix(iLat,iLong,CounterMatrix(iLat,iLong)) = Distance(1);
%             CoordMatrix(iLat,iLong,CounterMatrix(iLat,iLong),:) = Point;
            %  === check 8 neighbours from 12'clock, clockwise ============
            % 2. North
            cLat  = iLat - 1; 
            cLong = iLong;
            if cLat ~= 0
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(2) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(2) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(2);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
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
                Distance(3) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(3) < CurrentRefPoint(3)                
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(3);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
                end
            end
            % 4. East
            cLat  = iLat;
            cLong = iLong + 1;
            if cLong > length(LongGrid)
                cLong = 1; % back to first column, 360 -> 0
            end
            CurrentRefPoint = Grid(cLat,cLong,:);
            Distance(4) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
            if Distance(4) < CurrentRefPoint(3)
                CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                SSHMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(4);
%                 CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
            end            
            % 5. South-East
            cLat  = iLat  + 1; 
            cLong = iLong + 1;
            if cLat <= length(LatGrid)
                if cLong > length(LongGrid)
                   cLong = 1; % back to first column, 360 -> 0; 
                end
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(5) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(5) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(5);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
                end
            end
            
            % 6. South
            cLat  = iLat + 1;
            cLong = iLong;
            if cLat <= length(LatGrid)
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(6) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(6) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(6);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
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
                Distance(7) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(7) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(7);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
                end
            end
            % 8. West
            cLat  = iLat;
            cLong = iLong - 1;
            if cLong == 0
                cLong = length(LongGrid); % back to last column, 0 -> 350(360) 
            end
            CurrentRefPoint = Grid(cLat,cLong,:);
            Distance(8) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
            if Distance(8) < CurrentRefPoint(3)
                CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                SSHMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(8);
%                 CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
            end
            
            % 9. North-West
            cLat  = iLat  - 1;
            cLong = iLong - 1;
            if cLat ~= 0
                if cLong == 0
                    cLong = length(LongGrid); % back to last column, 0 -> 350(360) 
                end
                CurrentRefPoint = Grid(cLat,cLong,:);
                Distance(9) = OrthodromeArcLength(Point, [CurrentRefPoint(1),CurrentRefPoint(2)]);
                if Distance(9) < CurrentRefPoint(3)
                    CounterMatrix( cLat,cLong) = CounterMatrix(cLat,cLong) + 1;
                    SSHMatrix(  cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,21);
                    SSHAnomalyMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,22);
                    MDTMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Data(index,23);
                    DistanceMatrix(cLat,cLong,CounterMatrix(cLat,cLong)) = Distance(9);
%                     CoordMatrix(cLat,cLong,CounterMatrix(cLat,cLong),:) = Point;
                end
            end
            
            % ===== Check new best MasterRefPoint
            [M,I] = min(Distance(:));
%             disp(['Min distance to Master RefPoint, index:',num2str(I)])
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
%                             disp([num2str(index),' ;  Jump in switch, 360 -> 0 ged'])
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
%                            disp([num2str(index),'; Jump in switch, 0 -> 360 ged'])
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
%             disp([num2str(index),'; Process Point  : Lat: ', num2str(Point(1)),' , Long: ',num2str(Point(2))]);
%             disp([num2str(index),'; MasterPoint OLD: Lat: ', num2str(MasterRefPoint(1)),'      , Long: ',num2str(MasterRefPoint(2))]);
%             disp(['Previous: iLat: ',num2str(iLat),'; iLong: ',num2str(iLong)]);
            [iLat, iLong] =  SearchForNearestPoint(LatGrid, LongGrid, Point);
            MasterRefPoint = Grid(iLat,iLong,:); % reinitialize Master RefPoint
%             disp([num2str(index),'; MasterPoint NEW: Lat: ', num2str(MasterRefPoint(1)),' ; Long: ',num2str(MasterRefPoint(2))]);
            index = index - 1; % roll back index
        end   
    end

% Cut zeros
maxCount = max(max(CounterMatrix));
DistanceMatrix = DistanceMatrix(:,:,1:maxCount);
SSHMatrix = SSHMatrix(:,:,1:maxCount);
SSHAnomalyMatrix = SSHAnomalyMatrix(:,:,1:maxCount);
MDTMatrix = MDTMatrix(:,:,1:maxCount);
% CoordMatrix    = CoordMatrix(:,:,1:maxCount,:);

% Save Results
save([DataPool,'Jason-1\Processed\CounterMatrix_',num2str(Cycle),'.mat'],'CounterMatrix');
save([DataPool,'Jason-1\Processed\DistanceMatrix_',num2str(Cycle),'.mat'],'DistanceMatrix');
save([DataPool,'Jason-1\Processed\SSHMatrix_',num2str(Cycle),'.mat'],'SSHMatrix');
save([DataPool,'Jason-1\Processed\SSHAnomalyMatrix_',num2str(Cycle),'.mat'],'SSHAnomalyMatrix');
save([DataPool,'Jason-1\Processed\MDTMatrix_',num2str(Cycle),'.mat'],'MDTMatrix');
% save([DataPool,'Jason-1\Processed\CoordMatrix_',num2str(Cycle),'.mat'],'CoordMatrix');
timeInterp = toc;
disp(['Processing time :', num2str(timeInterp/60),' min']);

end
