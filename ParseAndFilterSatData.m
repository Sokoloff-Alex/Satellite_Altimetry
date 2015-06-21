function[AllRecords, AllRecFiltered] = ParseAndFilterSatData(SatelliteName, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold)
% Read data from all satellite files and merge the data
% Alexandr Sokolov


% ===== Find folder with RAW data =========================================
% SatelliteName = 'Jason-1';
disp(['Satellite Name:     ', SatelliteName]);
disp(['allowed iflags:     ', iflags]);
disp(['allowed oflags:     ', oflags]);
disp(['Std limit:          ', num2str(STD_threshold)]);
disp(['SWH threshold:      ', num2str(SWH_threshold)]);
disp(['abs(SSH - mssh) thr:', num2str(SSH_mssh_threshold)]);

SatelliteRawDataFolder = ls ([SatelliteName,'\*raw']);
SatelliteRawDataPath = [SatelliteName,'\',SatelliteRawDataFolder];

iflags = bin2dec(iflags);
oflags = bin2dec(oflags);

% ===== Parse RMP file for description ====================================
[NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = ParseRMP(SatelliteName);

% ===== Find Satellite data in Cycles folders =============================
ListOfCycles = ls (SatelliteRawDataPath);
ListOfCycles = ListOfCycles(3:end,:);
NumberOfCycles = size(ListOfCycles,1);
folderName = [SatelliteName,'\',SatelliteName,'_ASCII'];
mkdir (folderName)
FilteredFolder = [SatelliteName,'\',SatelliteName,'_ASCII_filtered'];
mkdir (FilteredFolder);
AllRecFiltered = zeros(1000000,23);
LastIndex = 0;

% ===== Iterate over cycles ===============================================
for CycleIteration = 1:NumberOfCycles
Cycle = ListOfCycles(CycleIteration,:);
ListOfFiles = ls ([SatelliteRawDataPath,'\',Cycle]);
ListOfFiles = ListOfFiles(3:end,:); % List of data files
disp(['Starting parsing Cycle: ', Cycle]);
folderName = [SatelliteName,'\',SatelliteName,'_ASCII\',Cycle];
mkdir (folderName)
% FilteredCycleFolder = [FilteredFolder,'\',Cycle];
% mkdir (FilteredCycleFolder)

% ===== Parce data files ==================================================
AllRecords = [];
RecordsFiltered = zeros(5000,23);

    for FileIteration = 1:size(ListOfFiles,1)
        FileName = ListOfFiles(FileIteration,:);
        FilePathName = [SatelliteRawDataPath,'\',Cycle,'\',FileName];
        Records =  ParseSAT(FilePathName, NumberOfParameters, DataType, Desimal);    
        AllRecords = [AllRecords;Records];    %#ok<AGROW>

        % ===== Save as a table in binary and ASCII =======================
        ASCIIFileName = [folderName,'\',FileName,'_ASCII.txt'];
        FileID = fopen(ASCIIFileName, 'w'); % Open the binary file for writing with file ID

        % ===== Write Header into ASCII file ======+++=====================
        fprintf(FileID, '%12s %14s\r\n', ' Satellite:   ', SatelliteName);
        fprintf(FileID, '%18s %24s\r\n \r\n', ' Date of parsing: ', datestr(now,'dd-mmmm-yyyy, HH:MM:SS'));
        
        StrFormat = ['%16s\t', repmat('%15s\t',1,4),repmat('%10s\t',1,14),'\r\n'];
        fprintf(FileID, StrFormat, ShortCut{1:end,:}); % write ShortCuts 
        fprintf(FileID, StrFormat, Unit{1:end});       % write Units

        for i = 1:250; 
            fprintf(FileID, '%1s', '='); %  Add separation line after header
        end;
        fprintf(FileID, '\r\n');

        % ======== Write data into file in table form =====================
        DataFormat = ['%16.5f\t%15.6f\t%15.6f\t%15.3f\t%15.3f\t',repmat('%10.3f\t',1,10),'%10.0f\t%10.0f\t%10.3f\t%10.3f\t\r\n'];
        
        % ===== WriteData =================================================
        counter = 0;
        for row = 1:size(Records,1)
            DataLine = Records(row,:);
            fprintf(FileID, DataFormat, DataLine);
            
            % ===== Select/filter data ====================================
            DataLineFiltered = DataLineFilter(DataLine, iflags, oflags, STD_threshold, SWH_threshold, SSH_mssh_threshold);
            if isempty (DataLineFiltered) ~= 0;
                counter = counter + 1
                RecordsFiltered(counter,:) = DataLineFiltered(1,:);
            end
        end        
        fclose(FileID);
        disp([FileName,' >> ',FileName,'_ASCII.txt']); 
        % ====== Combile Filtered data from single cycle ======================
        RecordsFiltered( all(~RecordsFiltered,2), : ) = []; %Remove zero rows
        LengthNew = size(RecordsFiltered,1);
        AllRecFiltered((LastIndex+1):(LastIndex+LengthNew),:) = RecordsFiltered; % combine into cycle
        LastIndex = LastIndex + LengthNew;
    end
    AllRecFiltered( all(~AllRecFiltered,2), : ) = []; %Remove zero rows
    disp(['Cycle ',Cycle,' is finished'])
end
    disp('Parsing and filtering of ALL Cycles is finished');
    
end