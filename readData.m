function[Records] = readData(file)
% read satellite data from file and outtup in matrix form
% by Alexandr Sokolov

FileID = fopen(file, 'r');

line = fgetl(FileID);
state = isempty(line);
% Dummy matrix
Records = zeros(3500,19) % Nodal period: 6 745.72 seconds (or 1h52')
counter = 0;
while state ~= 1
    counter = counter + 1;
    DataLine = fgetl(FileID);
    Str = strsplit(DataLine);
    [Records(counter,:)] = [str2double(Str{3}),str2double(Str{4})];
    state = feof(FileID);
end
Records( all(~Records,2), : ) = []; %Remove zero rows

end