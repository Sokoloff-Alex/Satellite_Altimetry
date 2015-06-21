function[NumberOfParameters, ParameterNumber, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter, MessageLenght] = ParseRMP(SatelliteName)
% Parser of RMP Meta-file Description of Parameter for Satellite data-files
% by Sokolov Alexandr
% input the Satellite name and Meta-file name (*.RMP file) 
% output is the total NumberOfParameters as scalar
%  and other param-s as vectors: Parameter, LegthOfByte, DataType, Desimal, 
% Unit, ShortCut, DescriptionOfParameter

% ===== Find RMP file =====================================================
SatelliteName = 'Jason-1';

RMP_FileName = ls ([SatelliteName,'\*.rmp']); % finde RMP file 
RMP_FilePathName = [SatelliteName,'\',RMP_FileName]; % dipslay files in console

disp(['RMP_FilePathName: ',RMP_FilePathName])

RMP_FileID = fopen(RMP_FilePathName, 'r');

DataTypesLookUpTable = { '1', 'int8'
              '2', 'int16'
              '4', 'int32'
             '+1', 'uint8'
             '+2', 'uint16'
             '+4', 'uint32'};
NumberOfDataTypes =  size(DataTypesLookUpTable,1);     

% read header 
if (isempty(RMP_FileID) ~=1)
    Header = fgets(RMP_FileID);
    Str = strsplit(Header);
    NumberOfParameters = str2double(Str{2});
    LenghtOfMessage = str2double(Str{3});
else
    disp('ERROR: File is empty');
end

%   Dummies
ParameterNumber = zeros(NumberOfParameters,1);
Bytes = cell(NumberOfParameters,1);
LegthOfByte = zeros(NumberOfParameters,1); % for check-sum
DataType = cell(NumberOfParameters,1);
Desimal = zeros(NumberOfParameters,1);
Unit = cell(NumberOfParameters,1);
ShortCut = cell(NumberOfParameters,1);
DescriptionOfParameter = cell(NumberOfParameters,1);

%Parse by line the whole file
for i = 1:NumberOfParameters
    line = fgets(RMP_FileID);
    Str = strsplit(line);
    ParameterNumber(i) = str2double(Str{1}); % Number of Parameter
    Bytes(i) = Str(2); % Byte designation
    LegthOfByte(i) = str2double(Bytes(i));

    for j=1:NumberOfDataTypes     
        if (strcmp(Bytes{i}, DataTypesLookUpTable(j,1)) == 1)
            DataType(i) = DataTypesLookUpTable(j,2); % Type of Data
        end
    end            
    [DesimalStr, UnitStr] = strtok(Str(3),'.'); % Separate Decimal and Unit
    Desimal(i) = str2double(DesimalStr); % Desimal
    UnitStr = UnitStr{1}(2:end); % Unit
    Unit(i) = {UnitStr};
    ShortCut(i) = strtok(Str(4),'.'); % Name of ShortCut
    DescriptionOfParameter(i) = Str(5); % Description Of Parameter
end

MessageLenght = sum(LegthOfByte);
if (MessageLenght ~= LenghtOfMessage)
    disp('Check sum is Wrong')
end

% RMP_Matrix = [Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter]
fclose(RMP_FileID);
    
clear i
clear j
clear UnitStr
clear DesimalStr
clear NumberOfDataTypes
clear line
clear RMP_FileID
clear Str
clear LenghtOfMessage
clear RMP_FilePathName
clear ans

% disp(['Parsing of ',RMP_FilePathName,' finished'])
end
