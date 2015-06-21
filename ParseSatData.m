function[AllRecords] = ParseSatData(SatelliteName)
% Read data from all satellite files and merge the data
% Alexandr Sokolov

% ===== Find folder with RAW data =========================================
SatelliteName = 'Jason-1';
disp(['Satellite Name: ', SatelliteName]);
SatelliteRawDataFolder = ls ([SatelliteName,'\*raw']);
SatelliteRawDataPath = [SatelliteName,'\',SatelliteRawDataFolder];

% ===== Parse RMP file for description ====================================
[NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = ParseRMP(SatelliteName);

% ===== Find Satellite data in Cycles folders =============================
ListOfCycles = ls (SatelliteRawDataPath);
ListOfCycles = ListOfCycles(3:end,:);
NumberOfCycles = size(ListOfCycles,1);
folderName = [SatelliteName,'\',SatelliteName,'_ASCII'];
mkdir (folderName)

% ===== Iterate over cycles ===============================================
for CycleIteration = 1:NumberOfCycles
Cycle = ListOfCycles(CycleIteration,:);
ListOfFiles = ls ([SatelliteRawDataPath,'\',Cycle]);
ListOfFiles = ListOfFiles(3:end,:); % List of data files
disp(['Starting parsing Cycle: ', Cycle]);
folderName = [SatelliteName,'\',SatelliteName,'_ASCII\',Cycle];
mkdir (folderName)

% ===== Parce data files ==================================================
AllRecords = zeros(1000000,19);
LastIndex = 0;
TotalLength = 0;
    for FileIteration = 1:size(ListOfFiles,1)
        FileName = ListOfFiles(FileIteration,:);
        FilePathName = [SatelliteRawDataPath,'\',Cycle,'\',FileName];
%         Records =  ParseSAT(FilePathName, NumberOfParameters, DataType, Desimal);    
        Records =  ParseJason_1(FilePathName);    
        
        LengthNew = size(Records,1);
        AllRecords((LastIndex+1):(LastIndex+LengthNew),:) = Records; % combine into cycle
        LastIndex = LastIndex + LengthNew;
        TotalLength = TotalLength + LengthNew;

        % ===== Save as a table in binary and ASCII =======================
        ASCIIFileName = [folderName,'\',FileName,'_ASCII.txt'];
        FileID = fopen(ASCIIFileName, 'w'); % Open the binary file for writing with file ID

        % ===== Write Header into ASCII file ======+++=====================
        fprintf(FileID, '%12s %14s\r\n', ' Satellite:   ', SatelliteName);
        fprintf(FileID, '%18s %24s\r\n \r\n', ' Date of parsing: ', datestr(now,'dd-mmmm-yyyy, HH:MM:SS'));
        
        % ===== Add ShortCuts and Units ===================================
        StrFormat = ['%16s\t', repmat('%15s\t',1,4),repmat('%10s\t',1,14),'\r\n'];

        fprintf(FileID, StrFormat, ShortCut{1:end,:}); % write ShortCuts 
        fprintf(FileID, StrFormat, Unit{1:end});       % write Units

        %  Add separation line after header
        for i = 1:250; 
            fprintf(FileID, '%1s', '='); 
        end;
        fprintf(FileID, '\r\n');

        % ======== Write data into file in table form =====================
        DataFormat = ['%16.5f\t%15.6f\t%15.6f\t%15.3f\t%15.3f\t',repmat('%10.3f\t',1,10),'%10.0f\t%10.0f\t%10.3f\t%10.3f\t\r\n'];
        
        % ===== WriteData =================================================
        for row = 1:size(Records,1)
            fprintf(FileID, DataFormat, Records(row,:));
        end        
        fclose(FileID);
        disp([FileName,' >> ',FileName,'_ASCII.txt']); 
    end
    AllRecords = AllRecords(1:TotalLength,:);
%     AllRecords( all(~AllRecords,2), : ) = []; %Remove zero rows
    CycleFileName = ['Jason-1\',SatelliteName,'_',num2str(Cycle),'.mat'];
    save(CycleFileName,'AllRecords');
end
    disp('Parsing of all cycles is finished');
end