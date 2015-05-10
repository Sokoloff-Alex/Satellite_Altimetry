function[Records] = ParseRMP(FilePathName, NumberOfParameters, DataType, Desimal)
% Parse Satellite files using info from RMP file
% Apllied Computer Science 
% 20.01.2015
% by Sokolov Alexandr, ESPACE, TUM

% Files to process
% CurrentDir = cd;
% FilePathName = [FilePathName]; 
FileID = fopen(FilePathName,'r');
Records = zeros(3000,NumberOfParameters); % Dummy matrix

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
Records( all(~Records,2), : ) = []; %Remove zero rows
end

