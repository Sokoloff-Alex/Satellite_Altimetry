function[Records] = FastParsingSatData(FilePathName, NumberOfParameters, Parameter, LegthOfByte, DataType, Desimal, Unit, ShortCut, DescriptionOfParameter, MessageLenght)
% Fast Parse Satellite files using Memmory Map of file
% and using structure from RMP file
% by Sokolov Alexandr, ESPACE, TUM

%% MEMMAPFILE 
% tic
memmap = memmapfile(FilePathName);
AllRecordsLine = memmap.Data;
depth = length(AllRecordsLine)/MessageLenght;
Records = zeros(depth,NumberOfParameters); % min 3500, Dummy matrix, % Nodal period: 6 745.72 seconds (or 1h52')
ByteNo = 1;

    for counter = 1:depth
       for index = 1:NumberOfParameters
            Bytes = [];
            Bytes = AllRecordsLine(ByteNo:(ByteNo - 1 + LegthOfByte(index)));
            intValue = typecast(Bytes, DataType{index});
            Value = intValue*10^Desimal(index);  
            Records(counter,index) = Value;
            ByteNo  = ByteNo + LegthOfByte(index);
       end
    end
% FastParsingSatDataTime = toc

end


