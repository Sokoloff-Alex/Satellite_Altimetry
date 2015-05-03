clear all
clc

FileName = ['D:\TUM\Applied Computer Science\practice\envisat_raw/033_0022tu_envisat - Copy.00'];
FileID = fopen(FileName,'r');

state = isempty(FileID)
b = zeros(137586,1);
index = 1;

tic
counter = 0;
while (state ~=1)
%     fgets(FileID);
    index = index +1;
    b = fread(FileID,1,'uint8');
    state = feof(FileID);
    state2 = feof(FileID);
    counter = counter + 1;
end

timeByte = toc

state
state2
fclose(FileID);