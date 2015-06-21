function[CycleRecords, CycleRecFiltered_IN, CycleRecFiltered_OUT] = FastPreProcessing(SatelliteName, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% Read data from all satellite files and merge the data
% Alexandr Sokolov

% ===== Find folder with RAW data =========================================
% SatelliteName = 'Jason-1';
disp(['Satellite Name:            ', SatelliteName]);
disp(['allowed iflags:            ', iflags]);
disp(['allowed oflags:            ', oflags]);
disp(['Std threshold:             ', num2str(STD_threshold)]);
disp(['SWH threshold:             ', num2str(SWH_threshold)]);
disp(['abs(SSH - mssh) threshold: ', num2str(SSH_mssh_threshold)]);

SatelliteRawDataFolder = ls ([SatelliteName,'\*raw']);
SatelliteRawDataPath = [SatelliteName,'\',SatelliteRawDataFolder];

% ===== Parse RMP file for description ====================================
[NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter, MessageLenght] = ParseRMP(SatelliteName);

% ===== Find Satellite data in Cycles folders =============================
ListOfCycles = ls (SatelliteRawDataPath);
ListOfCycles = ListOfCycles(3:end,:);
NumberOfCycles = size(ListOfCycles,1);

% ===== Iterate over cycles ===============================================
    for CycleIteration = 1:NumberOfCycles
        tic
        Cycle = ListOfCycles(CycleIteration,:);
        CycleFileName = ['Jason-1\Data\',SatelliteName,'_',num2str(Cycle),'.mat'];
        if exist(CycleFileName, 'file') ~= 2
            disp(['Starting parsing Cycle: ', Cycle]);
            ListOfFiles = ls ([SatelliteRawDataPath,'\',Cycle]);
            ListOfFiles = ListOfFiles(3:end,:); % List of data files

            % ===== Parce data files ======================================
            CycleRecords = zeros(1000000,19);
            LastIndexRaw = 0;

            for FileIteration = 1:size(ListOfFiles,1)
                FileName = ListOfFiles(FileIteration,:);
                FilePathName = [SatelliteRawDataPath,'\',Cycle,'\',FileName];
                FileRecords =  ParseSAT(FilePathName, NumberOfParameters, DataType, Desimal);    
%                 FileRecords =  FastParsingSatData(FilePathName, NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter, MessageLenght);    
                FileRecords( all(~FileRecords,2), : ) = []; %Remove zero rows
                LengthNewRaw = size(FileRecords,1);
                CycleRecords((LastIndexRaw+1):(LastIndexRaw+LengthNewRaw),:) = FileRecords; % combine into cycle
                LastIndexRaw = LastIndexRaw + LengthNewRaw;        
                disp(FileName); 
            end
            CycleRecords( all(~CycleRecords,2), : ) = []; %Remove zero rows
            save(CycleFileName,'CycleRecords');       
            ParsingTime = toc;
            disp(['Parsing Time of Cycle ', Cycle, ' is ', num2str(ParsingTime), ' sec']);
        else
            CycleRecords = struct2array(load(CycleFileName));
            disp(['CycleFileName: ',CycleFileName]);
        end           
        %===== FilterData =============================================
        tic 
        CycleRecFiltered_IN  = zeros(size(CycleRecords,1),23);
        CycleRecFiltered_OUT = zeros(size(CycleRecords,1),23);
        counter_in  = 0;
        counter_out = 0;
        for row = 1:size(CycleRecords,1)
            DataLine = CycleRecords(row,:);
            [DataLineFiltered_IN, DataLineFiltered_OUT] = DataLineSpliter(DataLine, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold);
            if isempty (DataLineFiltered_IN) == 0;
                counter_in = counter_in + 1;
                CycleRecFiltered_IN(counter_in,:) = DataLineFiltered_IN;
            end
            if isempty (DataLineFiltered_OUT) == 0;
                counter_out = counter_out + 1;
                CycleRecFiltered_OUT(counter_out,:) = DataLineFiltered_OUT;
            end
        end
        CycleRecFiltered_IN( all(~CycleRecFiltered_IN, 2),:) = []; %Remove zero rows    
        CycleRecFiltered_OUT(all(~CycleRecFiltered_OUT,2),:) = []; %Remove zero rows
        mkdir([SatelliteName,'\DataFiltered\'])
        CycleFileRecFiltered_IN = ['Jason-1\DataFiltered\',SatelliteName,'_',num2str(Cycle),'_filtered.mat'];
        save(CycleFileRecFiltered_IN,'CycleRecFiltered_IN');   
        filteringTime = toc;
        disp(['Filtering of cycle ',Cycle,' finished: ', num2str(filteringTime), ' sec']);
    end
    disp('Fast Parsing and filtering of ALL Cycles is finished');
end