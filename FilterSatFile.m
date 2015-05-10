function[] = FilterSatFile(File_A_Path,File_B_Path,iflags,oflags)
% filter Satellite Data file
% by Alexandr Sokolov

File_A_ID = fopen(File_A_Path, 'r');
File_B_ID = fopen(File_B_Path, 'w');

% ===== Add header ========================================================
fprintf(File_B_ID, fgetl(File_A_ID));
fprintf(File_B_ID, '\r\n');
fprintf(File_B_ID, '%18s %22s\r\n', ' Date of filtering: ', datestr(now,'dd-mmmm-yyyy, HH:MM:SS'));
fprintf(File_B_ID, '%16s\t %56s \r\n', 'Original file: ', File_A_Path);
fprintf(File_B_ID, '%18s\t%10s and %10s \r\n', ' Filters configuration: ', num2str(iflags), num2str(oflags)); 
fgetl(File_A_ID); % Skip Date of parsing
for i = 1:4
    fprintf(File_B_ID, fgetl(File_A_ID)); % Ept. line / SC / Units / sep-line
    fprintf(File_B_ID, '\r\n');
end

% ===== Filter all line records ===============================================
state = feof(File_A_ID);

while state ~= 1
    DataLine = fgetl(File_A_ID);
    Str = strsplit(DataLine);
    ifl = str2double(Str{17});
    ofl = str2double(Str{18});
    if ifl == iflags && ofl == iflags
        fprintf(File_B_ID, DataLine);
        fprintf(File_B_ID, '\r\n');
    end
    state = feof(File_A_ID);
end
fclose(File_A_ID);
fclose(File_B_ID);
end