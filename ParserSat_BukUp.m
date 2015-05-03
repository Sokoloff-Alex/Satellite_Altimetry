% function[Records] = ParseRMP(SatelliteName)
% Parse Satellite files
% Apllied Computer Science
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

clear all
clc


MetaFileName = ('tu_envisat.rmp')
[NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter] = Parser(MetaFileName);

FileName = ['D:\TUM\Applied Computer Science\practice\envisat_raw/033_0022tu_envisat.00']
FileID = fopen(FileName,'r');
Records = zeros(2650,NumberOfParameters); % Dummy matrix

counter = 1;
state = isempty(FileID);
    
while (state ~=1)   
    for index = 1:NumberOfParameters        
        state = feof(FileID);
        if state ~= 1
            bytes = fread(FileID,1,DataType{index});
            if isempty(bytes) ~= 1 % In 
              Value = bytes*10^Desimal(index);  
              Records(counter,index) = Value;
            end           
        else
            break
        end
    end
    if state == 1
        break
    end
    counter = counter + 1;
end

state;  
% catch
    fclose(FileID);
% end


% end