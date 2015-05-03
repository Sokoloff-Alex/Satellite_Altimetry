function[AllRecords] = readSat(SatelliteName)
% Read data from all satellite files and merge the data

% SatelliteName = ('envisat')
cd 'D:\TUM\Semester 1\Applied Computer Science\Satellite_Altimetry'
currentDir = cd;
SatFolder = [SatelliteName,'_raw']
cd (SatFolder)

% Find RMP file
RMPFileName = ['*',SatelliteName,'*','.rmp'];
MetaFileName = ls (RMPFileName) % RMP file name
MetaFileFullName = [currentDir,'\',MetaFileName]

% Find Satellite data files
name = ['*',SatelliteName,'*','.00'];
files = ls (name) % List of data files
cd (currentDir)

% Parse RMP file for description
[NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = ParseRMP(SatelliteName, MetaFileName);

% Parce data files
AllRecords = [];
    for i = 1:size(files,1)
        FileName = files(i,:)
        Records = ParseSAT(SatelliteName, FileName, NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter);    
        AllRecords = [AllRecords;Records] ;   
        
        % Save as a table in binary and ASCII
        
        ASCIIFileName = [SatelliteName,'_raw\',FileName,'ASCII.txt']
        FileID = fopen(ASCIIFileName, 'w'); % Open the binary file for writing with file ID

%         for row = 1:size(Records,1)
%             for value = 1:NumberOfParameters
%             fprintf(FileID, '%f', Records(row,value),'\t'); % Write floating point value
%             end
%             fprintf(FileID,'%f','\r\n');
%               save ('-ascii', '-double', '033_0022tu_envisat.00.txt', AllRecords(row,value));
%         end
%         fclose(FileID);
    end
    disp('Data reading is finished');
end