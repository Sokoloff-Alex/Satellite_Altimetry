function[AllRecFiltered] = FastSatFilter(SatelliteName,iflags,oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% Filter of satellite data using instrumental and orbital flags
% by Alexandr Sokolov

DataPool = SetGlobalVariables;

disp(['Filtering Sat data: ', SatelliteName]);
disp(['allowed iflags:     ', iflags]);
disp(['allowed oflags:     ', oflags]);
disp(['Std threshold:      ', num2str(STD_threshold)]);
disp(['SWH threshold:      ', num2str(SWH_threshold)]);
disp(['abs(SSH - mssh) thr:', num2str(SSH_mssh_threshold)]);


% find ASCII folder
% SatelliteName = 'Jason-1';
SatelliteASCIIDataFolder = ls ([SatelliteName,'\*ASCII']);
SatelliteASCIIDataPath = [DataPool,SatelliteName,'\',SatelliteASCIIDataFolder];

% find cycles
% ls (SatelliteASCIIDataPath);
ListOfCycles = ls (SatelliteASCIIDataPath);
ListOfCycles = ListOfCycles(3:end,:);
NumberOfCycles = size(ListOfCycles,1);
FilteredFolder = [DataPool, SatelliteName,'\',SatelliteName,'_ASCII_filtered'];
mkdir (FilteredFolder);
AllRecFiltered = zeros(1000000,23);
LastIndex = 0;
    for CycleIteration = 1:NumberOfCycles
        Cycle = ListOfCycles(CycleIteration,:);
        ListOfFiles = ls ([DataPool,SatelliteASCIIDataPath,'\',Cycle]);
        ListOfFiles = ListOfFiles(3:end,:); % List of data files

        disp(['Starting filtering Cycle: ', Cycle]);
        FilteredCycleFolder = [FilteredFolder,'\',Cycle];
        mkdir (FilteredCycleFolder)
%         AllRecFiltered = [];

        for FileIteration = 1:size(ListOfFiles,1)      
            File_A_Name = ListOfFiles(FileIteration,:);
            File_A_Path = [SatelliteASCIIDataPath,'\',Cycle,'\',File_A_Name];
            File_B_Path = [FilteredFolder,'\',Cycle,'\',File_A_Name,'_fil.txt'];

            % filter Satellite Data file
            [Records] = FilterSatFile(File_A_Path, File_B_Path, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold);
            LengthNew = size(Records,1);
            AllRecFiltered((LastIndex+1):(LastIndex+LengthNew),:) = Records;
            LastIndex = LastIndex + LengthNew;
        disp([File_A_Name,' >> ',File_A_Name,'fil.txt']);
        end
        CycleFileName = [DataPool,'Jason-1\',SatelliteName,'_',num2str(Cycle),'_filtered','.mat'];
%         save(CycleFileName,'AllRecFiltered');
    end
    AllRecFiltered( all(~AllRecFiltered,2), : ) = []; %Remove zero rows
    disp('Filtering finished')
end