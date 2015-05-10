function[] = SatFilter(SatelliteName,iflags,oflags)
% Filter of satellite data using instrumental and orbital flags
% by Alexandr Sokolov

disp(['Filtering: ', SatelliteName,' by ',num2str(iflags),' and ', num2str(oflags)]);

% find ASCII folder
SatelliteASCIIDataFolder = ls ([SatelliteName,'\*ASCII']);
SatelliteASCIIDataPath = [SatelliteName,'\',SatelliteASCIIDataFolder];

% find cycles
ls (SatelliteASCIIDataPath);
ListOfCycles = ls (SatelliteASCIIDataPath);
ListOfCycles = ListOfCycles(3:end,:);
NumberOfCycles = size(ListOfCycles,1);
FilteredFolder = [SatelliteName,'\',SatelliteName,'_ASCII_filtered'];
mkdir (FilteredFolder);

    for CycleIteration = 1:NumberOfCycles
        Cycle = ListOfCycles(CycleIteration,:);
        ListOfFiles = ls ([SatelliteASCIIDataPath,'\',Cycle]);
        ListOfFiles = ListOfFiles(3:end,:); % List of data files

        disp(['Starting filtering Cycle: ', Cycle]);
        FilteredCycleFolder = [FilteredFolder,'\',Cycle];
        mkdir (FilteredCycleFolder)
        AllRecFiltered = [];

        for FileIteration = 1:size(ListOfFiles,1)      
            File_A_Name = ListOfFiles(FileIteration,:);
            File_A_Path = [SatelliteASCIIDataPath,'\',Cycle,'\',File_A_Name];
            File_B_Path = [FilteredFolder,'\',Cycle,'\',File_A_Name,'_fil.txt'];

            % filter Satellite Data file
            FilterSatFile(File_A_Path, File_B_Path,iflags,oflags);
    %         AllRecFiltered = [AllRecFiltered;Records];
        disp([File_A_Name,' >> ',File_A_Name,'fil.txt']);
        end
    end
    disp('Filtering finished')
end