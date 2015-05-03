% function[NumberOfParam, Param, ByteLen, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = Parser(MetaFileName)
% Parser of Meta-file

clear all
clc

MetaFileName = ('tu_envisat.rmp');
FileFullName = ['D:\TUM\Applied Computer Science\practice\envisat_raw/', MetaFileName];

% try
    FileID = fopen(FileFullName, 'r');

    DataTypes = { '1', 'int8'
                  '2', 'int16'
                  '4', 'int32'
                 '+1', 'uint8'
                 '+2', 'uint16'
                 '+4', 'uint32'};
    NumberOfDataTypes =  size(DataTypes,1);     

    if (isempty(FileID) ~=1)
        Header = fgets(FileID);
        Str = strsplit(Header);
        NumberOfParameters = str2double(Str{2});
        LenghtOfMessage = str2double(Str{3});
    else
        disp('ERROR: File is empty')
    end

    Parameter = zeros(NumberOfParameters);
    Bytes = cell(NumberOfParameters,1);
    LegthOfByte = zeros(NumberOfParameters,1); % for check-sum
    DataType = cell(NumberOfParameters,1);
    Desimal = zeros(NumberOfParameters,1);
    Unit = cell(NumberOfParameters,1);
    ShortCut = cell(NumberOfParameters,1);
    DescriptionOfParameter = cell(NumberOfParameters,1);

    for i = 1:NumberOfParameters
        line = fgets(FileID);
        Str = strsplit(line);
        Parameter(i) = str2double(Str{1}); % Number of Parameter
        Bytes(i) = Str(2); % Bytes designation
        LegthOfByte(i) = str2double(Bytes(i));

        for j=1:NumberOfDataTypes     
            if (strcmp(Bytes{i}, DataTypes(j,1)) == 1)
                DataType(i) = DataTypes(j,2); % Type of Data
            end
        end            
        [DesimalStr, Unit] = strtok(Str(3),'.'); % Separate Decimal and Unit
        Desimal(i) = str2double(DesimalStr); % Desimal
        Unit(i) = strtok(Unit,'.');  % Unit
        ShortCut(i) = strtok(Str(4),'.'); % Name of ShortCut
        DescriptionOfParameter(i) = Str(5);
        
    end

    CheckSum = sum(LegthOfByte);
    if (CheckSum ~= LenghtOfMessage)
        disp('Check sum is Wrong')
    end
    
    fclose(FileID);
